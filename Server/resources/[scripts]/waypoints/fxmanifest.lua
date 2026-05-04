fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

shared_scripts {
	"shared-side/*",
	"@vrp/lib/Utils.lua",
	"@vrp/config/Global.lua"
}

files {
	"web-side/*"
}

exports {
	"AddWaypoint",
	"RemoveWaypoint",
	"UpdateWaypoint",
	"GetWaypointForCoord",
	"ClearWaypoints"
}