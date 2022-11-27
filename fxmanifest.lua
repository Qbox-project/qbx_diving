fx_version 'cerulean'
game 'gta5'

description 'QB-Diving'
version '1.1.0'

shared_script {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

server_script 'server/main.lua'

client_script 'client/main.lua'

lua54 'yes'