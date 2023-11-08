fx_version 'cerulean'
game 'gta5'

description 'qbx_diving'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

server_scripts {
    'server/*',
}

client_scripts {
    'client/*'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
