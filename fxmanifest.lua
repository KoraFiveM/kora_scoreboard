fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Server scoreboard and police-gated activity status, built on the qblib AppShell'
version '2.0.0'

dependency 'qblib'

shared_script {
    '@qblib/init.lua',
    'config.lua'
}
client_script 'client/**.lua'
server_script 'server/**.lua'