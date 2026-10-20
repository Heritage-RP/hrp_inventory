fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
name 'ox_inventory'
author 'Overextended'
version '2.45.0'
repository 'https://github.com/communityox/ox_inventory'
description 'Slot-based inventory with item metadata support'

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'ox_lib',
}

shared_script '@ox_lib/init.lua'

ox_libs {
    'locale',
    'table',
    'math',
}

server_scripts {
    '@hrp-metrics/lib/log.lua', -- HrpLog: structured logs (Heritage-RP/PRODUCTION-SERVER docs/dev/logs.md)
    '@oxmysql/lib/MySQL.lua',
    'init.lua'
}

client_script 'init.lua'

ui_page 'web/build/index.html'

files {
    'client.lua',
    'server.lua',
    'locales/*.json',
    'web/build/index.html',
    'web/build/assets/*.js',
    'web/build/assets/*.css',
    'web/images/*.png',
    'web/images/c-icons/*.png',
    'modules/**/shared.lua',
    'modules/items/declared.lua', -- items declared by other resources (PRODUCTION-SERVER#464)
    'modules/**/client.lua',
    'modules/bridge/**/client.lua',
    'data/*.lua',
}
