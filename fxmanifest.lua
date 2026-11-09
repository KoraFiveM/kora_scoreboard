fx_version 'cerulean'
game 'gta5'
lua54 'yes'
-- Keep the legacy resource name resolvable for exports['qbscoreboard'] callers.
provide 'qbscoreboard'
author 'Kakarot'
description 'Server scoreboard and police-gated activity status, built on the kora_lib AppShell'
version '2.0.0'

dependency 'kora_lib'
dependency 'kora_core'

shared_script {
    '@kora_lib/init.lua',
    'shared/config.lua'
}
client_script 'client/**.lua'
server_script 'server/**.lua'

-- kora_qa: Gherkin test scenarios (converted legacy tests), see [kora]/kora_qa/README.md
qa_feature 'tests/*.feature'
