fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Server scoreboard and police-gated activity status, built on the kora_lib AppShell'
version '0.2.0'

dependency 'kora_lib'
dependency 'kora_core'

shared_script {
    '@kora_lib/init.lua',
    'shared/config.lua'
}
client_script 'client/**.lua'
-- Optional FFT hooks: returns immediately unless fft_kora_hooks is true.
client_script 'fft_hooks.lua'
server_script 'server/**.lua'

-- kora_qa: Gherkin test scenarios (converted legacy tests), see [kora]/kora_qa/README.md
qa_feature 'tests/*.feature'
