-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("doors",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
local Doors = {
	-- Pharmacy South
	["1"] = { Coords = vec3(376.302673,-825.570740,29.442997), Hash = -2037125726, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["2"] = { Coords = vec3(372.869781,-826.490784,29.421286), Hash = -2051450263, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },

	-- Hospital
	["3"] = { Coords = vec3(313.480072,-595.458313,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["4"] = { Coords = vec3(309.133728,-597.751465,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["5"] = { Coords = vec3(340.781830,-581.821472,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["6"] = { Coords = vec3(339.004974,-586.703369,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["7"] = { Coords = vec3(349.313751,-586.325989,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "8" },
	["8"] = { Coords = vec3(348.433319,-588.744995,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "7" },
	["9"] = { Coords = vec3(307.118195,-569.568970,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["10"] = { Coords = vec3(303.959625,-572.557922,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["11"] = { Coords = vec3(312.005127,-571.341187,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "12" },
	["12"] = { Coords = vec3(314.424103,-572.221558,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "11" },
	["13"] = { Coords = vec3(317.842560,-573.465881,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "14" },
	["14"] = { Coords = vec3(320.261536,-574.346313,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "13" },
	["15"] = { Coords = vec3(323.237549,-575.429443,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "16" },
	["16"] = { Coords = vec3(325.656525,-576.309937,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "15" },
	["17"] = { Coords = vec3(326.549896,-578.040649,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "18" },
	["18"] = { Coords = vec3(325.669464,-580.459595,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "17" },
	["19"] = { Coords = vec3(326.654999,-590.106628,43.433910), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "20" },
	["20"] = { Coords = vec3(324.236023,-589.226196,43.433910), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "19" },
	["21"] = { Coords = vec3(328.701080,-587.311890,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["22"] = { Coords = vec3(328.976166,-586.597534,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["23"] = { Coords = vec3(336.162842,-580.140320,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["24"] = { Coords = vec3(346.773926,-584.002441,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["25"] = { Coords = vec3(352.199677,-594.147766,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["26"] = { Coords = vec3(346.885498,-593.599976,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["27"] = { Coords = vec3(350.834076,-597.899719,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["28"] = { Coords = vec3(345.519928,-597.351929,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["29"] = { Coords = vec3(356.125183,-583.362488,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["30"] = { Coords = vec3(357.490784,-579.610535,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["31"] = { Coords = vec3(360.503387,-588.999512,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["32"] = { Coords = vec3(358.726532,-593.881409,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["33"] = { Coords = vec3(345.789795,-592.722717,28.947092), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "34" },
	["34"] = { Coords = vec3(346.669006,-590.302673,28.947092), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "33" },
	["35"] = { Coords = vec3(348.981842,-583.949768,28.947092), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "36" },
	["36"] = { Coords = vec3(349.860748,-581.530457,28.947092), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "35" },
	["37"] = { Coords = vec3(339.326599,-587.634521,28.947092), Hash = -1700911976, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "38" },
	["38"] = { Coords = vec3(338.446655,-590.052979,28.947092), Hash = -434783486, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic", Other = "37" },
	["39"] = { Coords = vec3(337.279846,-564.426147,29.801291), Hash = -820650556, Disabled = false, Lock = true, Distance = 2.0, Permission = "Paramedic" },
	["40"] = { Coords = vec3(330.140442,-561.817810,29.846949), Hash = -820650556, Disabled = false, Lock = true, Distance = 2.0, Permission = "Paramedic" },
	["41"] = { Coords = vec3(336.866486,-592.578796,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["42"] = { Coords = vec3(303.908691,-596.578003,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["43"] = { Coords = vec3(298.954803,-594.774963,43.433910), Hash = 854291622, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },

	-- Mecânica
	["44"] = { Coords = vec3(948.528870,-965.351929,39.643547), Hash = 1289778077, Disabled = false, Lock = true, Distance = 1.75, Permission = "Mechanic" },
	["45"] = { Coords = vec3(955.358276,-972.445190,39.647919), Hash = -626684119, Disabled = false, Lock = true, Distance = 1.75, Permission = "Mechanic" },

	-- LSPD
	["46"] = { Coords = vec3(431.411926,-1000.786194,26.760252), Hash = 2130672747, Disabled = false, Lock = true, Distance = 2.0, Permission = "LSPD" },
	["47"] = { Coords = vec3(452.300507,-1000.784058,26.750164), Hash = 2130672747, Disabled = false, Lock = true, Distance = 2.0, Permission = "LSPD" },
	["48"] = { Coords = vec3(443.061768,-998.746216,30.815304), Hash = -1547307588, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "49" },
	["49"] = { Coords = vec3(440.739197,-998.746216,30.815304), Hash = -1547307588, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "48" },
	["50"] = { Coords = vec3(455.886169,-972.254272,30.815308), Hash = -1547307588, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "51" },
	["51"] = { Coords = vec3(458.208740,-972.254272,30.815308), Hash = -1547307588, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "50" },
	["52"] = { Coords = vec3(489.05,-1020.19,28.21), Hash = -1603817716, Disabled = false, Lock = true, Distance = 2.0, Permission = "LSPD" },
	["53"] = { Coords = vec3(469.774261,-1014.406006,26.483816), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["54"] = { Coords = vec3(467.368622,-1014.406006,26.483816), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["55"] = { Coords = vec3(440.520081,-977.601074,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["56"] = { Coords = vec3(440.520081,-986.233459,30.823193), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["57"] = { Coords = vec3(464.308563,-984.528442,43.771240), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["58"] = { Coords = vec3(438.197083,-993.911255,30.823193), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "59" },
	["59"] = { Coords = vec3(438.197083,-996.316650,30.823193), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "58" },
	["60"] = { Coords = vec3(445.406708,-984.201416,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["61"] = { Coords = vec3(458.654327,-976.886414,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["62"] = { Coords = vec3(458.654327,-990.649780,30.823193), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["63"] = { Coords = vec3(452.266266,-995.525391,30.823193), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["64"] = { Coords = vec3(458.089417,-995.524658,30.823193), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["65"] = { Coords = vec3(469.440613,-985.031311,30.823193), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "66" },
	["66"] = { Coords = vec3(469.440613,-987.437683,30.823193), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "65" },
	["67"] = { Coords = vec3(472.977692,-989.824707,30.823193), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "68" },
	["68"] = { Coords = vec3(475.383698,-989.824707,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "67" },
	["69"] = { Coords = vec3(472.978088,-984.372192,30.823193), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "70" },
	["70"] = { Coords = vec3(475.383698,-984.372192,30.823193), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "69" },
	["71"] = { Coords = vec3(479.753387,-986.215088,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "72" },
	["72"] = { Coords = vec3(479.753387,-988.620361,30.823193), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "71" },
	["73"] = { Coords = vec3(476.751160,-999.630676,30.823193), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["74"] = { Coords = vec3(479.750732,-999.629028,30.789167), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["75"] = { Coords = vec3(487.437836,-1000.189270,30.786972), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["76"] = { Coords = vec3(488.018433,-1002.901978,30.786972), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "77" },
	["77"] = { Coords = vec3(485.613342,-1002.901978,30.786972), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "76" },
	["78"] = { Coords = vec3(459.945404,-990.705322,35.103981), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["79"] = { Coords = vec3(459.945404,-981.074158,35.103981), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["80"] = { Coords = vec3(448.984558,-995.526367,35.103764), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["81"] = { Coords = vec3(448.986816,-990.200745,35.103764), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["82"] = { Coords = vec3(448.986816,-981.578491,35.103764), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["83"] = { Coords = vec3(464.159058,-974.665588,26.370705), Hash = 1830360419, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["84"] = { Coords = vec3(464.156555,-997.509277,26.370705), Hash = 1830360419, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["85"] = { Coords = vec3(471.375305,-985.031921,26.405483), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "86" },
	["86"] = { Coords = vec3(471.375305,-987.437378,26.405483), Hash = -96679321, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "85" },
	["87"] = { Coords = vec3(479.062408,-985.032349,26.405483), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["88"] = { Coords = vec3(475.832336,-990.483948,26.405483), Hash = -692649124, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["89"] = { Coords = vec3(478.289154,-997.910095,26.405483), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["90"] = { Coords = vec3(482.669434,-983.986816,26.405483), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["91"] = { Coords = vec3(482.670135,-987.579163,26.405483), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["92"] = { Coords = vec3(482.669922,-992.299133,26.405483), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["93"] = { Coords = vec3(482.670258,-995.728516,26.405483), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["94"] = { Coords = vec3(479.663757,-997.909973,26.406504), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "95" },
	["95"] = { Coords = vec3(482.068573,-997.909973,26.406504), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "94" },
	["96"] = { Coords = vec3(479.059967,-1003.172974,26.406504), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["97"] = { Coords = vec3(481.008362,-1004.117981,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["98"] = { Coords = vec3(484.176422,-1007.734375,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["99"] = { Coords = vec3(486.913116,-1012.188660,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["100"] = { Coords = vec3(483.912720,-1012.188660,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["101"] = { Coords = vec3(480.912811,-1012.188660,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["102"] = { Coords = vec3(477.912598,-1012.188660,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["103"] = { Coords = vec3(476.615692,-1008.875427,26.480055), Hash = -53345114, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["104"] = { Coords = vec3(475.953857,-1006.937805,26.406385), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["105"] = { Coords = vec3(475.953857,-1010.819336,26.406385), Hash = -1406685646, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD" },
	["106"] = { Coords = vec3(471.375824,-1010.197876,26.405483), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "107" },
	["107"] = { Coords = vec3(471.367859,-1007.793396,26.405483), Hash = 149284793, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "106" },
	["108"] = { Coords = vec3(467.522217,-1000.543701,26.405483), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "109" },
	["109"] = { Coords = vec3(469.927368,-1000.543701,26.405483), Hash = -288803980, Disabled = false, Lock = true, Distance = 1.75, Permission = "LSPD", Other = "108" },
	["110"] = { Coords = vec3(459.541321,-1019.699036,29.127647), Hash = -190780785, Disabled = false, Lock = true, Distance = 2.0, Permission = "LSPD" },
	["111"] = { Coords = vec3(459.526306,-1014.645996,29.223188), Hash = -190780785, Disabled = false, Lock = true, Distance = 2.0, Permission = "LSPD" },

	-- PRPD
	["112"] = { Coords = vec3(383.407928, 798.291077, 187.611816), Hash = 517369125, Disabled = false, Lock = true, Distance = 1.75, Permission = "PRPD" },
	["113"] = { Coords = vec3(381.662781, 796.828674, 187.611725), Hash = 517369125, Disabled = false, Lock = true, Distance = 1.75, Permission = "PRPD" },
	["114"] = { Coords = vec3(378.172577, 796.828430, 187.612305), Hash = 517369125, Disabled = false, Lock = true, Distance = 1.75, Permission = "PRPD" },
	["115"] = { Coords = vec3(380.217438, 792.788269, 190.641434), Hash = -117185009, Disabled = false, Lock = true, Distance = 1.75, Permission = "PRPD" },
	["116"] = { Coords = vec3(384.381195, 796.092773, 190.639633), Hash = -117185009, Disabled = false, Lock = true, Distance = 1.75, Permission = "PRPD" },

	-- Lester
	["117"] = { Coords = vec3(1273.815552,-1720.696899,54.921429), Hash = 1145337974, Disabled = false, Lock = true, Distance = 1.75, Item = "lockpick" },

	-- BurgerShot
	["118"] = { Coords = vec3(-1183.372681,-885.564392,13.903462), Hash = 1724308471, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot", Other = "119" },
	["119"] = { Coords = vec3(-1184.716431,-883.575623,13.903462), Hash = -571782594, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot", Other = "118" },
	["120"] = { Coords = vec3(-1196.787964,-883.689453,13.903462), Hash = 1724308471, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot", Other = "121" },
	["121"] = { Coords = vec3(-1198.776733,-885.033264,13.903462), Hash = -571782594, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot", Other = "120" },
	["122"] = { Coords = vec3(-1199.886475,-903.025818,13.904463), Hash = 1009568243, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["123"] = { Coords = vec3(-1176.609253,-895.575745,13.904463), Hash = 1009568243, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["124"] = { Coords = vec3(-1185.497070,-894.589783,13.902462), Hash = 1618088565, Disabled = false, Lock = true, Distance = 1, Permission = "BurgerShot" },
	["125"] = { Coords = vec3(-1185.813110,-895.478638,13.902462), Hash = 1618088565, Disabled = false, Lock = true, Distance = 1, Permission = "BurgerShot" },
	["126"] = { Coords = vec3(-1182.503174,-899.558228,13.902462), Hash = 547885802, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["127"] = { Coords = vec3(-1183.267578,-897.056335,13.902462), Hash = 846116471, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["128"] = { Coords = vec3(-1191.714722,-902.760681,13.902462), Hash = 547885802, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["129"] = { Coords = vec3(-1200.195312,-901.234253,13.902463), Hash = 846116471, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },
	["130"] = { Coords = vec3(-1193.738159,-900.077454,13.949343), Hash = 1309514423, Disabled = false, Lock = true, Distance = 1.75, Permission = "BurgerShot" },

	-- Pharmacy North
	["131"] = { Coords = vec3(1639.435547,4871.321777,42.250587), Hash = -624865139, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },
	["132"] = { Coords = vec3(1647.360229,4871.281738,42.635082), Hash = -1893735662, Disabled = false, Lock = true, Distance = 1.75, Permission = "Paramedic" },

	-- Impound
	["133"] = { Coords = vec3(-187.061401,-1162.348633,23.821239), Hash = -952356348, Disabled = false, Lock = true, Distance = 1.75, Permission = "Mechanic" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Number)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Doors[Number] and Doors[Number].Permission and not vRP.HasGroup(Passport,Doors[Number].Permission) then
		TriggerClientEvent("Notify",source,"Aviso","Você não tem permissão para usar esta porta.","vermelho",5000)
		return false
	end

	if Doors[Number] and Doors[Number].Item then
		local Item = Doors[Number].Item
		local Amount = Doors[Number].Amount or 1
		local ItemData = vRP.InventoryItemAmount(Passport,Item)
		local HasAmount = ItemData[1] or 0
		if HasAmount < Amount then
			TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>"..ItemName(Item).."</b> para usar esta porta.","amarelo",5000)
			return false
		end

		if Doors[Number].Consume then
			vRP.RemoveItem(Passport,Item,Amount,true)
			TriggerClientEvent("Notify",source,"Sucesso","Você usou <b>"..Amount.."x "..ItemName(Item).."</b>.","verde",5000)
		end
	end

	Doors[Number].Lock = not Doors[Number].Lock

	local Other = Doors[Number].Other
	if Other and Doors[Other] then
		Doors[Other].Lock = not Doors[Other].Lock
	end

	TriggerClientEvent("doors:Sync",-1,Number,Doors[Number].Lock,Other)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debugdoors",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		TriggerClientEvent("doors:Connect",source,Doors)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("doors:Connect",source,Doors)
end)