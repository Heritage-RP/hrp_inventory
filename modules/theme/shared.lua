-- UI theme (fork patch, Heritage-RP/PRODUCTION-SERVER#476). Pure Lua (no natives): client.lua reads the replicated
-- convar and hands the theme to the page (`init`, then `setTheme` when the convar changes); web/src/index.scss styles
-- both. Tested by tests/lua/theme_spec.lua.
--
-- `neutral` (default) is the upstream look; `heritage` is the green terminal look. A server picks it with
-- `setr hrp_ui_theme heritage` — the convar every UI of the server reads.

local Theme = {}

Theme.CONVAR = 'hrp_ui_theme'
Theme.DEFAULT = 'neutral'
Theme.NAMES = { neutral = true, heritage = true }

---The theme a convar value names (case-insensitive, trimmed), the default for anything else.
---@param value any
---@return 'neutral' | 'heritage'
function Theme.resolve(value)
    if type(value) ~= 'string' then return Theme.DEFAULT end

    local name = value:match('^%s*(.-)%s*$'):lower()

    return Theme.NAMES[name] and name or Theme.DEFAULT
end

return Theme
