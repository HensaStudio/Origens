-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Range = false
local Accuracy = 800.0
local ConfigTimer = 15000
local ActiveAlarm = false
local ExplosionCooldown = 300
local ActiveExplosions = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYINACCURACY
-----------------------------------------------------------------------------------------------------------------------------------------
local function ApplyInaccuracy(TargetCoords)
	local Offset = math.random(-Accuracy, Accuracy) / 100
	local XOffset = Offset
	local YOffset = Offset
	local ZOffset = Offset
	return vec3(TargetCoords["x"] + XOffset, TargetCoords["y"] + YOffset, TargetCoords["z"] + ZOffset)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local WaitTime = 2000 

		local Ped = PlayerPedId()
		local PedCoords = GetEntityCoords(Ped)

		local CurrentLocate = nil
		local MinDistance = 999999.0

		if AIR_DEFENSE_LOCATIONS then
			for _, loc in ipairs(AIR_DEFENSE_LOCATIONS) do
				local Distance = #(PedCoords - loc.Coords)
				if Distance < loc.Radius then
					if Distance < MinDistance then
						MinDistance = Distance
						CurrentLocate = loc
					end
				end
			end
		end

		local HeightAboveGround = GetEntityHeightAboveGround(Ped)
		local IsFlyingVehicle = IsPedInFlyingVehicle(Ped)
		local IsAuthorized = LocalPlayer["state"]["Paramedic"] or LocalPlayer["state"]["Police"]
		local PlayerIsDead = IsEntityDead(Ped)

		if CurrentLocate and HeightAboveGround > 5.0 and IsFlyingVehicle and not IsAuthorized then
			local Distance = MinDistance
			local Locate = CurrentLocate.Coords
			local Radius = CurrentLocate.Radius

			if not Range then
				Range = true
				ActiveAlarm = false
				ActiveExplosions = false
			end

			if not ActiveAlarm then
				TriggerEvent("sounds:playSound", "warningSky", "warning", 1.0)
				TriggerEvent("Notify", "Atenção", "Você entrou em uma <b>Área com Defesa Aérea</b>. Sua aeronave será abatida em breve. Saia imediatamente — você tem <b>15 segundos</b>..", "amarelo", ConfigTimer)
				ActiveAlarm = true

				Wait(ConfigTimer)

				ActiveExplosions = true
			end

			if ActiveExplosions then
				local ExplosionTimer = GetGameTimer()
				while ActiveExplosions and GetEntityHealth(Ped) > 100 do
					local CurrentTime = GetGameTimer()
					if CurrentTime - ExplosionTimer >= ExplosionCooldown then
						local TargetCoords = ApplyInaccuracy(PedCoords)
						AddExplosion(TargetCoords.x, TargetCoords.y, TargetCoords.z, 18, 2.0, true, false, 1.0)
						ExplosionTimer = CurrentTime
					end

					PedCoords = GetEntityCoords(Ped)
					Distance = #(PedCoords - Locate)
					if Distance >= Radius then
						ActiveExplosions = false
					end

					Wait(ExplosionCooldown)
				end
			end

			WaitTime = 500 
		else
			if Range then
				Range = false
				ActiveAlarm = false
				ActiveExplosions = false
			end

			if PlayerIsDead then
				Range = false
				ActiveAlarm = false
				ActiveExplosions = false
				WaitTime = 1000
			end
		end

		Wait(WaitTime)
	end
end)