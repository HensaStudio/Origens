local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")

local radioChannel = 0
local radioNames = {}
local radioObject = nil
local radioAnimVars = {}

function deleteRadioObject()
	local Ped = PlayerPedId()

	if radioAnimVars[1] and radioAnimVars[2] then
		StopAnimTask(Ped, radioAnimVars[1], radioAnimVars[2], 8.0)
	end

	ClearPedSecondaryTask(Ped)

	radioAnimVars[3] = false

	if DoesEntityExist(radioObject) then
		DeleteEntity(radioObject)

		TriggerServerEvent(
			"DeleteObject",
			NetworkGetNetworkIdFromEntity(radioObject)
		)

		radioObject = nil
	end
end

function createRadioObject(Dict, Anim, Prop, Flag, Hands, Height, Pos1, Pos2, Pos3, Pos4, Pos5)
	local Ped = PlayerPedId()

	deleteRadioObject()

	if Anim ~= "" then
		if LoadAnim(Dict) then
			TaskPlayAnim(Ped, Dict, Anim, 8.0, 8.0, -1, Flag, 1, 0, 0, 0)
		end

		radioAnimVars = { Dict, Anim, true, Flag }
	end

	if not IsPedInAnyVehicle(Ped) then
		local Coords = GetEntityCoords(Ped)
		local Networked = vRPS.CreateObject(Prop, Coords.x, Coords.y, Coords.z)

		if not Networked then
			return
		end

		local Entity = LoadNetwork(Networked)

		while not DoesEntityExist(Entity) do
			Wait(100)
		end

		radioObject = Entity

		SetEntityLodDist(radioObject, 0xFFFF)

		if Height then
			AttachEntityToEntity(radioObject, Ped, GetPedBoneIndex(Ped,Hands), Height, Pos1, Pos2, Pos3, Pos4, Pos5, true, true, false, true, 1, true)
		else
			AttachEntityToEntity(radioObject, Ped, GetPedBoneIndex(Ped,Hands), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 2, true)
		end
	end
end

function destroyRadio()
	local Ped = PlayerPedId()

	if radioAnimVars[1] and radioAnimVars[2] then
		StopAnimTask(Ped, radioAnimVars[1], radioAnimVars[2], 8.0)
	end

	ClearPedSecondaryTask(Ped)

	radioAnimVars[3] = false

	if DoesEntityExist(radioObject) then
		DeleteEntity(radioObject)

		TriggerServerEvent("DeleteObject", NetworkGetNetworkIdFromEntity(radioObject))

		radioObject = nil
	end
end

function isRadioEnabled()
	return radioEnabled and LocalPlayer.state.disableRadio == 0
end

function syncRadioData(radioTable,localPlyRadioName)
	radioData = radioTable

	local isEnabled = isRadioEnabled()

	if isEnabled then
		handleRadioAndCallInit()
	end

	radioNames[playerServerId] = localPlyRadioName
end

RegisterNetEvent("pma-voice:syncRadioData",syncRadioData)

function setTalkingOnRadio(plySource,enabled)
	radioData[plySource] = enabled

	if not isRadioEnabled() then
		return
	end

	local enabled = enabled or callData[plySource]
	toggleVoice(plySource,enabled,"radio")
end

RegisterNetEvent("pma-voice:setTalkingOnRadio",setTalkingOnRadio)

function addPlayerToRadio(plySource,plyRadioName)
	radioData[plySource] = false
	radioNames[plySource] = plyRadioName

	if radioPressed then
		addVoiceTargets(radioData,callData)
	end
end

RegisterNetEvent("pma-voice:addPlayerToRadio",addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		for tgt,_ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt,false,"radio")
			end
		end

		radioNames = {}
		radioData = {}

		addVoiceTargets(callData)
	else
		toggleVoice(plySource,false,"radio")

		if radioPressed then
			addVoiceTargets(radioData,callData)
		end

		radioData[plySource] = nil
		radioNames[plySource] = nil
	end
end

RegisterNetEvent("pma-voice:removePlayerFromRadio",removePlayerFromRadio)

RegisterNetEvent("pma-voice:radioChangeRejected",function()
	radioChannel = 0
end)

function setRadioChannel(channel)
	radioEnabled = true

	type_check({ channel,"number" })

	TriggerServerEvent("pma-voice:setPlayerRadio",channel)

	radioChannel = tonumber(channel)

	sendUIMessage({
		radioChannel = channel,
		radioEnabled = radioEnabled
	})
end

exports("setRadioChannel",setRadioChannel)
exports("SetRadioChannel",setRadioChannel)

exports("removePlayerFromRadio",function()
	radioEnabled = false
	setRadioChannel(0)
end)

exports("addPlayerToRadio",function(_radio)
	local radio = tonumber(_radio)

	if radio then
		setRadioChannel(radio)
	end
end)

RegisterCommand("+radiotalk",function()
	local Ped = PlayerPedId()

	if IsPedSwimming(Ped)
	or GetEntityHealth(Ped) <= 100
	or LocalPlayer["state"]["Handcuff"]
	or IsPlayerFreeAiming(PlayerId())
	or not isRadioEnabled() then
		return
	end

	if not radioPressed then
		if radioChannel > 0 then
			addVoiceTargets(radioData,callData)

			TriggerServerEvent("pma-voice:setTalkingOnRadio",true)

			radioPressed = true

			playMicClicks(true)

			createRadioObject("ultra@walkie_talkie", "walkie_talkie", "prop_cs_hand_radio", 50, 18905, 0.14, 0.03, 0.03, -105.877, -10.9432, -33.7212)

			CreateThread(function()
				TriggerEvent("pma-voice:radioActive",true)

				LocalPlayer.state:set("radioActive",true,true)

				local checkFailed = false

				while radioPressed do
					local Ped = PlayerPedId()

					if radioChannel <= 0
					or GetEntityHealth(Ped) <= 100
					or not isRadioEnabled()
					or IsPedRagdoll(Ped)
					or IsPedFalling(Ped)
					or IsPedBeingStunned(Ped)
					or IsPedInAnyVehicle(Ped) then
						checkFailed = true
						break
					end

					if radioAnimVars[3]
					and not IsEntityPlayingAnim(Ped, radioAnimVars[1], radioAnimVars[2], 3) then
						TaskPlayAnim(Ped, radioAnimVars[1], radioAnimVars[2], 8.0, 8.0, -1, radioAnimVars[4], 1, 0, 0, 0)
					end

					SetControlNormal(0,249,1.0)
					SetControlNormal(1,249,1.0)
					SetControlNormal(2,249,1.0)

					DisableControlAction(0,24,true)
					DisableControlAction(0,25,true)
					DisableControlAction(0,257,true)
					DisableControlAction(0,140,true)
					DisableControlAction(0,142,true)

					Wait(0)
				end

				if checkFailed then
					ExecuteCommand("-radiotalk")
				end
			end)
		end
	end
end,false)

RegisterCommand("-radiotalk",function()
	if radioChannel > 0 and radioPressed then
		radioPressed = false

		MumbleClearVoiceTargetPlayers(voiceTarget)

		addVoiceTargets(callData)

		TriggerEvent("pma-voice:radioActive",false)

		LocalPlayer.state:set("radioActive",false,true)

		playMicClicks(false)

		destroyRadio()

		TriggerServerEvent("pma-voice:setTalkingOnRadio",false)
	end
end,false)

RegisterKeyMapping("+radiotalk", "Dialogar no rádio.", "keyboard", "CAPITAL")

function syncRadio(_radioChannel)
	radioChannel = tonumber(_radioChannel) or 0
end

RegisterNetEvent("pma-voice:clSetPlayerRadio",syncRadio)

function handleRadioEnabledChanged(wasRadioEnabled)
	if wasRadioEnabled then
		syncRadioData(radioData,"")
	else
		removePlayerFromRadio(playerServerId)
	end
end

local function addRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0

	curVal = curVal | bit

	LocalPlayer.state:set("disableRadio",curVal,true)
end

exports("addRadioDisableBit",addRadioDisableBit)

local function removeRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0

	curVal = curVal & (~bit)

	LocalPlayer.state:set("disableRadio",curVal,true)
end

exports("removeRadioDisableBit",removeRadioDisableBit)

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then
		return
	end

	destroyRadio()
end)