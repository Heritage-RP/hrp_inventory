-- Fork checks (PRODUCTION-SERVER#476, #520): UI theme from the `hrp_ui_theme` convar and the resource declaring it.
-- Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/theme_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local Theme = dofile('modules/theme/shared.lua')

check('the convar is hrp_ui_theme', Theme.CONVAR == 'hrp_ui_theme')
check('the fxmanifest key is hrp_ui_theme', Theme.METADATA == 'hrp_ui_theme')
check('the default is neutral', Theme.DEFAULT == 'neutral')
check('any well-formed name is a theme name', Theme.name('dusk') == 'dusk' and Theme.name('my-theme2') == 'my-theme2')
check('case and spaces do not matter', Theme.name('  DuSk ') == 'dusk')
check('a malformed name is none', Theme.name('2dark') == nil and Theme.name('a b') == nil and Theme.name('') == nil)
check('a non-string is none', Theme.name(nil) == nil and Theme.name(1) == nil)
check('a stylesheet names its theme', Theme.fileName('themes/dusk.css') == 'dusk' and Theme.fileName('Dusk.CSS') == 'dusk')
check('another file names none', Theme.fileName('themes/dusk.scss') == nil and Theme.fileName('themes/my theme.css') == nil)

local declared = Theme.declarations({
    { resource = 'a', file = 'themes/dusk.css' },
    { resource = 'b', file = 'dusk.css' },
    { resource = 'b', file = 'themes/neutral.css' },
    { resource = 'b', file = '/themes/dawn.css' },
    { resource = 'b', file = 'readme.md' },
})
check('the first declaration of a name wins', declared.dusk == 'nui://a/themes/dusk.css')
check('a leading slash is dropped', declared.dawn == 'nui://b/themes/dawn.css')
check('neutral stays the upstream look', declared.neutral == nil)

local resolved = Theme.resolve(' Dusk ', declared)
check('a declared theme comes with its stylesheet', resolved.theme == 'dusk' and resolved.stylesheet == 'nui://a/themes/dusk.css')
check('an undeclared theme is neutral', Theme.resolve('dusk', {}).theme == 'neutral' and Theme.resolve('dusk', {}).stylesheet == nil)
check('unset (empty) is neutral', Theme.resolve('', declared).theme == 'neutral')
check('neutral is neutral', Theme.resolve('neutral', declared).theme == 'neutral')

-- the started resources' declarations, read through the natives
do
    local resources = { 'ox_inventory', 'stopped-theme', 'my-config' }
    local metadata = { ['stopped-theme'] = { 'dawn.css' }, ['my-config'] = { 'themes/dusk.css' } }
    _G.GetNumResources = function() return #resources end
    _G.GetResourceByFindIndex = function(i) return resources[i + 1] end
    _G.GetResourceState = function(name) return name == 'stopped-theme' and 'stopped' or 'started' end
    _G.GetNumResourceMetadata = function(name, key) return key == 'hrp_ui_theme' and #(metadata[name] or {}) or 0 end
    _G.GetResourceMetadata = function(name, _, i) return metadata[name][i + 1] end
    _G.GetConvar = function(name, default) return name == 'hrp_ui_theme' and 'dusk' or default end
    local scanned = Theme.declared()
    check('only started resources declare', scanned.dusk == 'nui://my-config/themes/dusk.css' and scanned.dawn == nil)
    local current = Theme.current()
    check('the convar resolves against them', current.theme == 'dusk' and current.stylesheet == 'nui://my-config/themes/dusk.css')
end

-- client.lua hands the theme to the page at init and when the convar changes
do
    local f = assert(io.open('client.lua', 'r'))
    local client = f:read('a')
    f:close()
    check('init sends the current theme', client:find('theme = Theme.current%(%)') ~= nil)
    check('a convar change sends setTheme',
        client:find("AddConvarChangeListener%(Theme.CONVAR, function%(%)%s+SendNUIMessage%({ action = 'setTheme', data = Theme.current%(%) }") ~= nil)
end

-- the page styles the themed look from tokens, and names no theme
do
    local f = assert(io.open('web/src/index.scss', 'r'))
    local scss = f:read('a')
    f:close()
    check("index.scss scopes the themed look under any theme but neutral", scss:find(":root:not([data-theme='neutral'])", 1, true) ~= nil)
    check('index.scss draws the themed look with --hrp-* tokens', scss:find('var(--hrp-accent)', 1, true) ~= nil)
    for _, file in ipairs({ 'web/src/index.scss', 'web/src/theme.ts', 'modules/theme/shared.lua' }) do
        local g = assert(io.open(file, 'r'))
        local text = g:read('a')
        g:close()
        local named = false
        for name in text:gmatch("data%-theme='([%w%-]+)'") do
            if name ~= 'neutral' then named = true end
        end
        check(file .. ' names no theme but neutral', not named)
    end
end

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
io.write('all passed\n')
