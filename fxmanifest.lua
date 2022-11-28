fx_version 'cerulean'
game 'gta5'

shared_script {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

server_script 'server/main.lua'

client_script 'client/main.lua'

lua54 'yes'