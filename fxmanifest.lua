fx_version 'cerulean'
game 'gta5'

description 'qbx_diving'
repository 'https://github.com/Qbox-project/qbx_diving'
version '1.1.1'

shared_script {
    '@ox_lib/init.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

server_scripts {
    'server/*',
}

client_scripts {
    'client/*'
}

files {
    'config/client.lua',
    'config/shared.lua',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
