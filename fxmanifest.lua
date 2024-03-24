fx_version 'cerulean'
game 'gta5'

lua54 'yes'
description 'Blips made by Visualz Development'
author 'Visualz Blips https://visualz.dk'
version '1.0.0'

client_script 'client/**/*'

server_script 'server/**/*'

shared_scripts {
  '@es_extended/imports.lua',
  'config.lua',
}

escrow_ignore {
  'config.lua',
  'server/exports.lua'
}
