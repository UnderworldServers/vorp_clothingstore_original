fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '1.0'

author 'Bobert/UnderworldServers'
description 'Refactored vorp_clothingstore into lua'

client_scripts { 
    'client/client.lua',
    'client/functions.lua'
}

server_scripts { 
    'server/server.lua',
}

shared_scripts {
    'config.lua',
    'shared/*.lua',
    'languages/*.lua',
}

files {
    'images/*'
}

dependencies { 
    'vorp_core',
    'vorp_character'
}
