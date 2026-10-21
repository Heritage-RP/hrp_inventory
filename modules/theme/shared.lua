-- UI theme (fork patch, Heritage-RP/PRODUCTION-SERVER#476, #520). client.lua reads the replicated convar, finds the
-- started resource that declares that theme (`hrp_ui_theme '<path>/<name>.css'` in its fxmanifest, the theme is the
-- file's name) and hands both to the page (`init`, then `setTheme` when the convar changes); web/src/theme.ts loads the
-- stylesheet and web/src/index.scss styles the page from its `--hrp-*` tokens. Tested by tests/lua/theme_spec.lua.
--
-- `neutral` (default) is the upstream look; any declared theme gets the themed look, coloured by its tokens. A server
-- picks it with `setr hrp_ui_theme <name>` — the convar every UI of the server reads.

local Theme = {}

Theme.CONVAR = 'hrp_ui_theme'
Theme.METADATA = 'hrp_ui_theme'
Theme.DEFAULT = 'neutral'

---The theme name a value holds (lower case letters, digits and dashes, starting with a letter; case-insensitive,
---trimmed), nil for anything else.
---@param value any
---@return string?
function Theme.name(value)
    if type(value) ~= 'string' then return nil end

    local name = value:match('^%s*(.-)%s*$'):lower()

    return name:match('^[a-z][a-z0-9%-]*$') and name or nil
end

---The theme a declared stylesheet defines: its file name without `.css`, nil when it names none.
---@param file string
---@return string?
function Theme.fileName(file)
    local base = type(file) == 'string' and file:match('([^/]+)%.[cC][sS][sS]%s*$')

    return base and Theme.name(base) or nil
end

---The declared themes by name (`{ [name] = 'nui://<resource>/<file>' }`), from `{ resource, file }` entries in resource
---order: the first declaration of a name wins, `neutral` stays the upstream look.
---@param entries { resource: string, file: string }[]
---@return table<string, string>
function Theme.declarations(entries)
    local themes = {}

    for i = 1, #entries do
        local entry = entries[i]
        local name = Theme.fileName(entry.file)

        if name and name ~= Theme.DEFAULT and not themes[name] then
            themes[name] = ('nui://%s/%s'):format(entry.resource, (entry.file:gsub('^/+', '')))
        end
    end

    return themes
end

---The `hrp_ui_theme` entries of the started resources (natives: client or server).
---@return table<string, string>
function Theme.declared()
    local entries = {}

    for index = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(index)
        local state = resource and GetResourceState(resource)

        if state == 'started' or state == 'starting' then
            for entry = 0, GetNumResourceMetadata(resource, Theme.METADATA) - 1 do
                local file = GetResourceMetadata(resource, Theme.METADATA, entry)

                if file then entries[#entries + 1] = { resource = resource, file = file } end
            end
        end
    end

    return Theme.declarations(entries)
end

---What the page gets for a convar value: the theme and its stylesheet, the default (no stylesheet) when the value is
---not a theme name or no started resource declares it.
---@param value any
---@param declared table<string, string>
---@return { theme: string, stylesheet: string? }
function Theme.resolve(value, declared)
    local name = Theme.name(value)
    local stylesheet = name and declared[name]

    if not stylesheet then return { theme = Theme.DEFAULT } end

    return { theme = name, stylesheet = stylesheet }
end

---The page's theme now (convar and declarations read at each call: a theme resource may start later).
---@return { theme: string, stylesheet: string? }
function Theme.current()
    return Theme.resolve(GetConvar(Theme.CONVAR, Theme.DEFAULT), Theme.declared())
end

return Theme
