fx_version "bodacious"
game "gta5"
lua54 "yes"

creative_network "extended"

version "1.0.5"

client_scripts {
	"lib/Utils.lua",
	"config/Native.lua",

	"client/base.lua",
	"client/gui.lua",
	"client/objects.lua",
	"client/playanim.lua",
	"client/player.lua",
	"client/vehicles.lua"
}

server_scripts {
	"lib/Utils.lua",

	"modules/vrp.lua",
	"modules/base.lua",
	"modules/banned.lua",
	"modules/daily.lua",
	"modules/drugs.lua",
	"modules/groups.lua",
	"modules/identity.lua",
	"modules/inventory.lua",
	"modules/permissions.lua",
	"modules/money.lua",
	"modules/player.lua",
	"modules/prepare.lua",
	"modules/battlepass.lua",
	"modules/vehicles.lua",
	"modules/playing.lua",
	"modules/version.lua"
}

files {
	"lib/*",
	"config/*",
	"config/**/*",
	"config/**/**/*"
}

shared_scripts {
	"config/Item.lua",
	"config/Vehicle.lua",
	"config/Global.lua",
	"config/Drops.lua"
}