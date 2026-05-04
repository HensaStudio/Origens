fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'LS Smell - Particle-based smell visualization system'
version '1.0.0'

shared_scripts {
    'helper.lua',
    'config.lua'
}

client_scripts {
    'client/editables/*',
    'client/trail_manager.lua',
    'client/create_particles.lua',
    'client/sync_manager.lua',
    'client/item_detector.lua',
    'client/prop_detector.lua',
    'client/scenario_detector.lua',
    'client/writhe_detector.lua',
    'client/smell_mode.lua'
}

server_scripts {
    '@vrp/lib/Utils.lua',
    'server/server.lua'
}

exports {
    'AddItemTrail',
    'AddPropTrail',
    'AddEventTrail',
    'AddScenarioTrail',
    'AddAnimationTrail',
    'RemoveActiveAnimation',
    'ClearAllTrails'
}

escrow_ignore {
    'client/editables/*'
}