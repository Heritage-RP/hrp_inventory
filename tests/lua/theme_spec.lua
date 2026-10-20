-- Fork checks (PRODUCTION-SERVER#476): UI theme from the `hrp_ui_theme` convar. Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/theme_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local Theme = dofile('modules/theme/shared.lua')

check('the convar is hrp_ui_theme', Theme.CONVAR == 'hrp_ui_theme')
check('the default is neutral', Theme.DEFAULT == 'neutral')
check('heritage names the heritage theme', Theme.resolve('heritage') == 'heritage')
check('neutral names the neutral theme', Theme.resolve('neutral') == 'neutral')
check('case and spaces do not matter', Theme.resolve('  HeRiTaGe ') == 'heritage')
check('unset (empty) is neutral', Theme.resolve('') == 'neutral')
check('an unknown name is neutral', Theme.resolve('pipboy') == 'neutral')
check('a non-string is neutral', Theme.resolve(nil) == 'neutral' and Theme.resolve(1) == 'neutral')

-- client.lua hands the theme to the page at init and when the convar changes
do
    local f = assert(io.open('client.lua', 'r'))
    local client = f:read('a')
    f:close()
    check('init sends the resolved convar',
        client:find("theme = Theme.resolve%(GetConvar%(Theme.CONVAR, Theme.DEFAULT%)%)") ~= nil)
    check('a convar change sends setTheme',
        client:find("AddConvarChangeListener%(Theme.CONVAR, function%(%)%s+SendNUIMessage%({ action = 'setTheme'") ~= nil)
end

-- the page styles both themes from data-theme, and no lore word names them
do
    local f = assert(io.open('web/src/index.scss', 'r'))
    local scss = f:read('a')
    f:close()
    check("index.scss scopes the heritage look under data-theme='heritage'", scss:find(":root[data-theme='heritage']", 1, true) ~= nil)
    check('index.scss names no pip-boy', not scss:lower():find('pip%-?boy'))
end

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
io.write('all passed\n')
