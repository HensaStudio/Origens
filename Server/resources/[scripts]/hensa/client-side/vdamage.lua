-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE
-----------------------------------------------------------------------------------------------------------------------------------------
local Engine = {
	Delta = 0.0,
	Scale = 0.0,
	New = 1000.0,
	Last = 1000.0,
	Current = 1000.0
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BODY
-----------------------------------------------------------------------------------------------------------------------------------------
local Body = {
	Delta = 0.0,
	Scale = 0.0,
	New = 1000.0,
	Last = 1000.0,
	Current = 1000.0
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Last = nil
local Same = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLASS
-----------------------------------------------------------------------------------------------------------------------------------------
local Class = {
	[0] = 2.5,  -- Compactos (mais frágeis)
	[1] = 2.5,  -- Sedans (mais frágeis)
	[2] = 2.5,  -- SUVs (mais frágeis)
	[3] = 2.5,  -- Cupês (mais frágeis)
	[4] = 2.5,  -- Muscle (mais frágeis)
	[5] = 2.5,  -- Sports Classics (mais frágeis)
	[6] = 2.5,  -- Sports (mais frágeis)
	[7] = 2.5,  -- Super (mais frágeis)
	[8] = 2.5,  -- Motocicletas (mais frágeis)
	[9] = 2.5,  -- Off-road (mais frágeis)
	[10] = 2.5, -- Industrial (mais frágeis)
	[11] = 2.5, -- Utility (mais frágeis)
	[12] = 2.5, -- Vans (mais frágeis)
	[13] = 2.5, -- Cycles (mais frágeis)
	[14] = 0.0, -- Boats (sem dano progressivo)
	[15] = 1.5, -- Helicopters (dano moderado)
	[16] = 1.5, -- Planes (dano moderado)
	[17] = 2.5, -- Service (mais frágeis)
	[18] = 2.5, -- Emergency (mais frágeis)
	[19] = 2.5, -- Military (mais frágeis)
	[20] = 2.5, -- Commercial (mais frágeis)
	[21] = 2.5, -- Trains (mais frágeis)
	[22] = 2.5  -- Open Wheel (mais frágeis)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHVEH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local DamageCheckInterval = 250
	local LastDamageCheck = 0

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		local CurrentTime = GetGameTimer()

		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			local ClassId = GetVehicleClass(Vehicle)

			if ClassId ~= 13 and ClassId ~= 14 then
				if GetPedInVehicleSeat(Vehicle,-1) == Ped then
					local Roll = GetEntityRoll(Vehicle)
					if (Roll > 75.0 or Roll < -75.0) and (ClassId ~= 15 and ClassId ~= 16) then
						DisableControlAction(0,59,true)
						DisableControlAction(0,60,true)
					end
				end

				if (CurrentTime - LastDamageCheck) >= DamageCheckInterval then
					if Same then
						local Torque = (Engine.New < 900) and ((Engine.New + 100.0) / 1000) or 1.0
						SetVehicleEngineTorqueMultiplier(Vehicle,Torque)
					end

					Engine.Current = GetVehicleEngineHealth(Vehicle)
					Engine.Current = math.min(Engine.Current,1000.0)
					Engine.Delta = Engine.Last - Engine.Current
					Engine.Scale = Engine.Delta * 1.2 * Class[ClassId + 1]
					Engine.New = Engine.Current

					Body.Current = GetVehicleBodyHealth(Vehicle)
					Body.Current = math.min(Body.Current,1000.0)
					Body.Delta = Body.Last - Body.Current
					Body.Scale = Body.Delta * 1.2 * Class[ClassId + 1]
					Body.New = Body.Current

					if Vehicle ~= Last then
						Same = false
					end

					if Same then
						if Engine.Current < 1000.0 or Body.Current < 1000.0 then
							local Combine = math.max(Engine.Scale,Body.Scale)
							if Combine > (Engine.Current - 100.0) then
								Combine = Combine * 0.7
							end

							if Combine > Engine.Current then
								Combine = Engine.Current - (210.0 / 5)
							end

							Engine.New = Engine.Last - Combine

							if Engine.New > 210.0 and Engine.New < 350.0 then
								Engine.New = Engine.New - (0.038 * 15.0)
							elseif Engine.New < 210.0 then
								Engine.New = Engine.New - (0.1 * 3.0)
							end

							Engine.New = math.max(Engine.New,0.0)
							Body.New = math.max(Body.New,0.0)
						end
					else
						Same = true
					end

					if Body.Current < 100.0 then
						Body.New = 100.0
					end

					if Engine.Current < 100.0 then
						Engine.New = 100.0
					end

					if Engine.New ~= Engine.Current then
						SetVehicleEngineHealth(Vehicle,Engine.New)
					end

					if Body.New ~= Body.Current then
						SetVehicleBodyHealth(Vehicle,Body.New)
					end

					Last = Vehicle
					Engine.Last = Engine.New
					Body.Last = Body.New
					LastDamageCheck = CurrentTime

					if ShakeVehicleCamera then
						local PedsVehicle = GetVehiclePedIsIn(Ped, false)
						if DoesEntityExist(PedsVehicle) then
							local Speed = GetEntitySpeed(PedsVehicle) * VehicleSpeed / 250.0
							local VehicleHealth = GetVehicleBodyHealth(PedsVehicle)

							if LastDamage and VehicleHealth < LastDamage then
								local DamageDiff = LastDamage - VehicleHealth

								if DamageDiff > 5.0 then
									ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", Speed)
									TriggerServerEvent("player:UpgradeStress", 1)
								end
							end

							LastDamage = VehicleHealth
						end
					end
				end

				TimeDistance = DamageCheckInterval
			end
		else
			Same = false
		end

		Wait(TimeDistance)
	end
end)