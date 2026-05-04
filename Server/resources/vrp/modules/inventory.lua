-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Entitys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVECHARGES
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.RemoveCharges(Passport,Item)
	local Consult = vRP.ConsultItem(Passport,Item)

	if not (Consult and Consult.Item and Consult.Slot and Consult.Amount > 0) then
		return false
	end

	if not vRP.TakeItem(Passport,Consult.Item,1,false,Consult.Slot) then
		return false
	end

	if ItemLoads(Consult.Item) then
		local Slotable = Consult.Slot
		local Name = SplitOne(Consult.Item)
		local Charger = SplitTwo(Consult.Item) - 1

		if Consult.Amount > 1 then
			Slotable = false
		end

		if Charger >= 1 then
			vRP.GiveItem(Passport,Name.."-"..Charger,1,false,Slotable)
		else
			local Empty = ItemEmpty(Consult.Item)
			if Empty and ItemExist(Empty) then
				vRP.GenerateItem(Passport,Empty,1,false,Slotable)
			end
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTITEM
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.ConsultItem(Passport,Item,Amount)
	local Passport = parseInt(Passport)
	local Amount = parseInt(Amount,true)
	local ItemAmount,ItemName,ItemSlot = table.unpack(vRP.InventoryItemAmount(Passport,Item))

	if ItemAmount >= Amount and not vRP.CheckDamaged(ItemName) then
		return { Amount = ItemAmount, Item = ItemName, Slot = ItemSlot }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPRESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasPrescription(Passport,Medicament)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)
	for Slot,v in pairs(Inventory) do
		local Split = splitString(v.item,"-")
		if Split[1] == "prescription" and Split[3] == Medicament and Split[4] == tostring(Passport) then
			return { Slot = Slot, Item = v.item }
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASVEHICLEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.HasVehicleKey(Plate)
	local source = source
	local Passport = vRP.Passport(source)
	local Inventory = vRP.Inventory(Passport)
	local Plate = Plate:gsub("%s+","")

	for Slot,v in pairs(Inventory) do
		local Split = splitString(v.item,"-")
		if Split[1] == "vehiclekey" and Split[2]:gsub("%s+","") == Plate then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTHASVEHICLEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PassportHasVehicleKey(Passport,Plate)
	local Inventory = vRP.Inventory(Passport)
	local Plate = Plate:gsub("%s+","")

	for Slot,v in pairs(Inventory) do
		local Split = splitString(v.item,"-")
		if Split[1] == "vehiclekey" and Split[2]:gsub("%s+","") == Plate then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.GetWeight(Passport,Ignore)
	local Weight = 0
	local Passport = parseInt(Passport)
	local Datatable = vRP.Datatable(Passport)

	if Datatable then
		Datatable.Weight = Datatable.Weight or MinimumWeight
		Weight = Datatable.Weight

		if not Ignore then
			for Index,v in pairs(Groups) do
				if v and v.Backpack then
					local Permission = vRP.HasService(Passport,Index)
					if Permission and v.Backpack[Permission] then
						Weight = Weight + v.Backpack[Permission]
					end
				end
			end

			local Slotable = vRP.CheckSlotable(Passport,"104")
			if Slotable then
				Weight = Weight + ItemBackpack(Slotable)
			end
		end
	end

	return Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.CheckWeight(Passport,Item,Amount)
	return ((vRP.InventoryWeight(Passport) + (ItemWeight(Item) * (Amount or 1))) <= vRP.GetWeight(Passport)) and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.UpgradeWeight(Passport,Amount,Mode)
	local Passport = parseInt(Passport)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		Datatable.Weight = Datatable.Weight or MinimumWeight

		if Mode == "+" then
			Datatable.Weight = Datatable.Weight + Amount
		else
			Datatable.Weight = math.max(Datatable.Weight - Amount,MinimumWeight)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSLOTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CheckSlotable(Passport,Slot)
	local Slot = tostring(Slot)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)
	if Inventory and Inventory[Slot] and Inventory[Slot].item and ItemExist(Inventory[Slot].item) and Inventory[Slot].item and Inventory[Slot].amount >= 1 and not vRP.CheckDamaged(Inventory[Slot].item) then
		return Inventory[Slot].item
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPSLOT	
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRP.SwapSlot(Passport,Slot,Target)
	local Slot = tostring(Slot)
	local Target = tostring(Target)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	if Inventory[Slot] and Inventory[Target] then
		Inventory[Slot],Inventory[Target] = Inventory[Target],Inventory[Slot]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryWeight(Passport)
	local Weight = 0
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	for _,v in pairs(Inventory) do
		if ItemExist(v.item) then
			Weight = Weight + ItemWeight(v.item) * v.amount
		end
	end

	return Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESMELLYITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateSmellyItems(Passport)
	local source = vRP.Source(Passport)
	if source then
		local Inventory = vRP.Inventory(Passport)

		local SmellyItems = {}
		for _,v in pairs(Inventory) do
			if ItemSmell(v.item) then
				SmellyItems[v.item] = true
			end
		end

		Player(source).state:set("SmellyItems",SmellyItems,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDAMAGED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CheckDamaged(Item)
	local splitTime = SplitTwo(Item)
	local durability = ItemDurability(Item)

	if durability and splitTime then
		local maxTime = 3600 * durability
		local elapsedTime = os.time() - splitTime
		local remainingPercentage = (maxTime - elapsedTime) / maxTime

		if remainingPercentage <= 0.01 then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ChestWeight(Data)
	local Weight = 0

	for _,v in pairs(Data) do
		if ItemExist(v.item) then
			Weight = Weight + ItemWeight(v.item) * v.amount
		end
	end

	return Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryItemAmount(Passport,Item)
	local ItemSplit = SplitOne(Item)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	for Slot,v in pairs(Inventory) do
		if ItemSplit == SplitOne(v.item) then
			return { v.amount,v.item,Slot }
		end
	end

	return { 0,"" }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InventoryFull(Passport,Item)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	for _,v in pairs(Inventory) do
		if v.item == Item then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ItemAmount(Passport,Item)
	local Amount = 0
	local ItemSplit = SplitOne(Item)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	for _,v in pairs(Inventory) do
		if SplitOne(v.item) == ItemSplit then
			Amount = Amount + v.amount
		end
	end

	return Amount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCHESTAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ItemChestAmount(Data,Item,Save)
	local Amount = 0
	local ItemSplit = SplitOne(Item)
	local Consult = vRP.GetSrvData(Data,Save)

	for _,v in pairs(Consult) do
		if SplitOne(v.item) == ItemSplit then
			Amount = Amount + v.amount
		end
	end

	return Amount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveItem(Passport,Item,Amount,Notify,Slot)
	local Amount = parseInt(Amount)
	if Amount <= 0 then
		return false
	end

	local Animation = ItemAnim(Item)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)
	local Inventory = vRP.Inventory(Passport)

	local function AddItemToInventory(slot)
		if type(slot) ~= "string" then
			slot = tostring(slot)
		end

		if not Inventory[slot] or Inventory[slot].item == Item then
			Inventory[slot] = { item = Item, amount = (Inventory[slot] and Inventory[slot].amount or 0) + Amount }
		end

		if ItemTypeCheck(Item,"Armamento") and vRP.ConsultItem(Passport,Item) then
			TriggerClientEvent("inventory:CreateWeapon",source,Item)
		end

		if Animation then
			vRPC.PersistentBlock(source,Item,Animation)
		end

		if Notify and ItemExist(Item) then
			TriggerClientEvent("inventory:NotifyItem",source,{ Item,Amount })
		end
	end

	if not Slot then
		for Number = 0,100 do
			local SlotIndex = tostring(Number)
			if not Inventory[SlotIndex] or (Inventory[SlotIndex] and Inventory[SlotIndex].item == Item) then
				AddItemToInventory(SlotIndex)
				break
			end
		end
	else
		AddItemToInventory(Slot)
	end

	vRP.UpdateSmellyItems(Passport)

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateItem(Passport,Item,Amount,Notify,Slot)
	local Amount = parseInt(Amount)
	if Amount <= 0 then
		return false
	end

	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)
	local Inventory = vRP.Inventory(Passport)
	local Item = vRP.SortNameItem(Passport,Item)
	local Animation = ItemAnim(Item)

	local function AddItemToInventory(slot)
		if not Inventory[slot] then
			Inventory[slot] = { item = Item, amount = Amount }

			if ItemTypeCheck(Item,"Armamento") and vRP.ConsultItem(Passport,Item) then
				TriggerClientEvent("inventory:CreateWeapon",source,Item)
			end
		elseif Inventory[slot] and Inventory[slot].item == Item then
			Inventory[slot].amount = Inventory[slot].amount + Amount
		end
	end

	if not Slot then
		for Number = 0,100 do
			local SlotIndex = tostring(Number)
			if not Inventory[SlotIndex] or (Inventory[SlotIndex] and Inventory[SlotIndex].item == Item) then
				AddItemToInventory(SlotIndex)
				break
			end
		end
	else
		Slot = tostring(Slot)
		AddItemToInventory(Slot)
	end

	if Animation then
		vRPC.PersistentBlock(source,Item,Animation)
	end

	if Notify and ItemExist(Item) then
		TriggerClientEvent("inventory:NotifyItem",source,{ Item,Amount })
	end

	vRP.UpdateSmellyItems(Passport)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.MaxItens(Passport,Item,Amount)
	local Item = Item
	if not ItemExist(Item) then
		return false
	end

	local Passport = parseInt(Passport)
	local Amount = parseInt(Amount,true)
	local MaxAmount = ItemMaxAmount(Item)
	if not MaxAmount or (vRP.ItemAmount(Passport,Item) + Amount) <= MaxAmount then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.MaxChest(Data,Item,Amount,Save)
	local Item = Item
	if not ItemExist(Item) then
		return false
	end

	local Data = Data
	local Amount = parseInt(Amount)
	local MaxAmount = ItemMaxAmount(Item)
	if not MaxAmount or (vRP.ItemChestAmount(Data,Item,Save) + Amount) <= MaxAmount then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.TakeItem(Passport,Item,Amount,Notify,Slot)
	local Item = Item
	local Returned = false
	local Animation = ItemAnim(Item)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)
	local Amount = parseInt(Amount,true)
	local Inventory = vRP.Inventory(Passport)

	if source then
		if not Slot then
			for Index,v in pairs(Inventory) do
				if Inventory[Index].item == Item and Inventory[Index].amount >= Amount then
					Inventory[Index].amount = Inventory[Index].amount - Amount

					if Inventory[Index].amount <= 0 then
						if Animation and not vRP.ConsultItem(Passport,Item) then
							vRPC.PersistentNone(source,Item)
						end

						if ItemTypeCheck(Item,"Armamento") or ItemTypeCheck(Item,"Arremesso") then
							TriggerClientEvent("inventory:verifyWeapon",source,Item)
						end

						if Index == "104" then
							local Skinshop = ItemSkinshop(Item)
							if Skinshop then
								TriggerClientEvent("skinshop:BackpackRemove",source)
							end
						end

						local Execute = ItemExecute(Item)
						if Execute and Execute.Event and Execute.Type and not vRP.ConsultItem(Passport,Item) then
							if Execute.Type == "Client" then
								TriggerClientEvent(Execute.Event,source)
							else
								TriggerEvent(Execute.Event,source,Passport)
							end
						end

						Inventory[Index] = nil
					end

					if Notify and ItemExist(Item) then
						TriggerClientEvent("inventory:NotifyItem",source,{ Item,-Amount })
					end

					vRP.UpdateSmellyItems(Passport)

					Returned = true

					break
				end
			end
		else
			local Slot = tostring(Slot)
			if Inventory[Slot] and Inventory[Slot].item == Item and Inventory[Slot].amount >= Amount then
				Inventory[Slot].amount = Inventory[Slot].amount - Amount

				if Inventory[Slot].amount <= 0 then
					if Animation and not vRP.ConsultItem(Passport,Item) then
						vRPC.PersistentNone(source,Item)
					end

					if ItemTypeCheck(Item,"Armamento") or ItemTypeCheck(Item,"Arremesso") then
						TriggerClientEvent("inventory:verifyWeapon",source,Item)
					end

					if Slot == "104" then
						local Skinshop = ItemSkinshop(Item)
						if Skinshop then
							TriggerClientEvent("skinshop:BackpackRemove",source)
						end
					end

					local Execute = ItemExecute(Item)
					if Execute and Execute.Event and Execute.Type and not vRP.ConsultItem(Passport,Item) then
						if Execute.Type == "Client" then
							TriggerClientEvent(Execute.Event,source)
						else
							TriggerEvent(Execute.Event,source,Passport)
						end
					end

					Inventory[Slot] = nil
				end

				if Notify and ItemExist(Item) then
					TriggerClientEvent("inventory:NotifyItem",source,{ Item,-Amount })
				end

				vRP.UpdateSmellyItems(Passport)

				Returned = true
			end
		end
	end

	return Returned
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANSLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CleanSlot(Passport,Slot)
	local Slot = tostring(Slot)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	if Inventory[Slot] then
		Inventory[Slot] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveItem(Passport,Item,Amount,Notify)
	local Amount = parseInt(Amount)
	if Amount <= 0 then
		return false
	end

	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)
	local Inventory = vRP.Inventory(Passport)

	for Index,v in pairs(Inventory) do
		if Inventory[Index] and Inventory[Index].item == Item and Inventory[Index].amount >= Amount then
			Inventory[Index].amount = Inventory[Index].amount - Amount

			if Inventory[Index].amount <= 0 then
				local Animation = ItemAnim(Item)
				if Animation and not vRP.ConsultItem(Passport,Item) then
					vRPC.PersistentNone(source,Item)
				end

				if ItemTypeCheck(Item,"Armamento") or ItemTypeCheck(Item,"Arremesso") then
					TriggerClientEvent("inventory:verifyWeapon",source,Item)
				end

				if ItemUnique(Item) then
					local Unique = SplitUnique(Item)
					if Unique then
						vRP.RemSrvData(Unique)
					end
				end

				local Execute = ItemExecute(Item)
				if Execute and Execute.Event and Execute.Type and not vRP.ConsultItem(Passport,Item) then
					if Execute.Type == "Client" then
						TriggerClientEvent(Execute.Event,source)
					else
						TriggerEvent(Execute.Event,source,Passport)
					end
				end

				Inventory[Index] = nil
			end

			if Notify and ItemExist(Item) then
				TriggerClientEvent("inventory:NotifyItem",source,{ Item,-Amount })
			end

			vRP.UpdateSmellyItems(Passport)

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetSrvData(Key,Save)
	if not Entitys[Key] then
		local Consult = vRP.SingleQuery("entitydata/GetData",{ Name = Key })

		Entitys[Key] = {
			Data = Consult and Consult.Information and json.decode(Consult.Information) or {},
			Timer = os.time() + 60,
			Save = Save
		}
	end

	return Entitys[Key].Data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetSrvData(Key,Data,Save)
	Entitys[Key] = {
		Data = Data,
		Timer = os.time() + 60,
		Save = Save and true or false
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemSrvData(Key)
	if Entitys[Key] then
		Entitys[Key] = nil
	end

	vRP.Query("entitydata/RemoveData",{ Name = Key })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer",function(Silenced)
	for Index,v in pairs(Entitys) do
		if v.Save then
			vRP.Query("entitydata/SetData",{ Name = Index, Information = json.encode(v.Data) })
		else
			if Silenced and SplitOne(Index,":") == "Trash" then
				for _,v in pairs(v.Data) do
					if v.item and ItemUnique(v.item) then
						local Unique = SplitUnique(v.item)
						if Unique then
							vRP.RemSrvData(Unique)
						end
					end
				end
			end
		end
	end

	for Passport in pairs(Sources) do
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
		end
	end

	if not Silenced then
		print("O resource ^2vRP^7 salvou os dados.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTICK
-----------------------------------------------------------------------------------------------------------------------------------------
local function ThreadTick()
	local Remove = {}
	local CurrentTime = os.time()

	for Data,v in pairs(Entitys) do
		if CurrentTime >= v.Timer and v.Save then
			local DataSave = v.Data

			if type(DataSave) ~= "string" then
				DataSave = json.encode(DataSave)
			end

			vRP.Query("entitydata/SetData",{ Name = Data, Information = DataSave })

			table.insert(Remove,Data)
		end
	end

	for _,Data in ipairs(Remove) do
		Entitys[Data] = nil
	end

	SetTimeout(60000,ThreadTick)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTICK
-----------------------------------------------------------------------------------------------------------------------------------------
ThreadTick()
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.invUpdate(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Amount > 0 then
		local Item = nil
		local Returned = true
		local Slot = tostring(Slot)
		local Target = tostring(Target)
		local Inventory = vRP.Inventory(Passport)

		if Inventory[Slot] then
			Item = Inventory[Slot].item

			if Inventory[Target] then
				if Inventory[Slot] and Inventory[Target] then
					if Item == Inventory[Target].item then
						if Inventory[Slot].amount >= Amount then
							Inventory[Slot].amount = Inventory[Slot].amount - Amount
							Inventory[Target].amount = Inventory[Target].amount + Amount

							if Inventory[Slot].amount <= 0 then
								Inventory[Slot] = nil
							end

							Returned = false
						end
					else
						local Unique = SplitOne(Item)
						local Splice = splitString(Inventory[Target].item)
						local ItemRepair = ItemRepair(Inventory[Target].item)
						local ItemFishing = ItemFishing(Inventory[Target].item)

						if Unique == "gsrkit" and ItemSerial(Splice[1]) then
							if vRP.TakeItem(Passport,Item,1,false,Slot) then
								if Splice[4] then
									TriggerClientEvent("inventory:Notify",source,"Sucesso","Propriedade do passaporte <b>"..Splice[4].."</b>","verde")
								else
									TriggerClientEvent("inventory:Notify",source,"Aviso","Serial não encontrado.","amarelo")
								end
							end
						elseif Unique == "WEAPON_SWITCHBLADE" and not vRP.CheckDamaged(Item) and ItemFishing then
							local Temporary = Inventory[Target].amount
							if vRP.TakeItem(Passport,Inventory[Target].item,Temporary,false,Target) then
								vRP.GenerateItem(Passport,"fishfillet",Temporary * ItemFishing)
							end
						elseif vRP.CheckDamaged(Inventory[Target].item) and ItemRepair and Inventory[Target].amount == 1 and ItemRepair == Unique then
							if ItemTypeCheck(Inventory[Target].item,"Armamento") and parseInt(Splice[3]) <= 0 then
								TriggerClientEvent("inventory:Notify",source,"Aviso","Armamento não pode ser reparado.","amarelo")
							else
								if vRP.TakeItem(Passport,Item,1,false,Slot) then
									local CurrentTime = os.time() - 1
									if ItemTypeCheck(Inventory[Target].item, "Armamento") then
										local Serial = Splice[4] and "-"..(Passport or "")
										Inventory[Target].item = Splice[1].."-"..CurrentTime.."-"..parseInt(Splice[3] - 1)..Serial
									else
										if ItemUnique(Splice[1]) then
											Inventory[Target].item = Splice[1].."-"..CurrentTime.."-"..Splice[3]
										else
											Inventory[Target].item = Splice[1].."-"..CurrentTime
										end
									end
								end
							end
						else
							local Temp = Inventory[Slot]
							Inventory[Slot] = Inventory[Target]
							Inventory[Target] = Temp

							Returned = false
						end
					end
				end
			else
				if Inventory[Slot] and Inventory[Slot].amount >= Amount then
					Inventory[Target] = { item = Item, amount = Amount }
					Inventory[Slot].amount = Inventory[Slot].amount - Amount

					if Inventory[Slot].amount <= 0 then
						Inventory[Slot] = nil
					end

					Returned = false
				end
			end
		end

		if Item and (Returned or Target == "104" or Slot == "104") then
			TriggerClientEvent("inventory:Update",source)

			local Skinshop = ItemSkinshop(Item)
			if Target == "104" and Skinshop then
				TriggerClientEvent("skinshop:Backpack",source,Skinshop)
			elseif Slot == "104" and Skinshop then
				TriggerClientEvent("skinshop:BackpackRemove",source)
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.TakeChest(Passport,Data,Amount,Slot,Target,Save)
	local Returned = true
	local Amount = parseInt(Amount)
	local Passport = parseInt(Passport)

	if Amount <= 0 then
		return Returned
	end

	local Slot = tostring(Slot)
	local Consult = vRP.GetSrvData(Data,Save)

	if not Consult[Slot] then
		return Returned
	end

	local source = vRP.Source(Passport)
	local Item = Consult[Slot].item
	local Animation = ItemAnim(Item)

	if vRP.MaxItens(Passport,Item,Amount) then
		TriggerClientEvent("inventory:Notify",source,"Atenção","Limite atingido.","vermelho")
		return Returned
	end

	if not vRP.CheckWeight(Passport,Item,Amount) then
		return Returned
	end

	local Target = tostring(Target)
	local Inv = vRP.Inventory(Passport)

	if Inv[Target] then
		if Inv[Target].item == Item and Consult[Slot].amount >= Amount then
			exports["discord"]:Embed("Chest","**[REF]:** "..Data.."\n**[MODO]:** Retirou\n**[PASSAPORTE]:** "..Passport.."\n**[ITEM]:** "..Amount.."x "..Item.."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))

			Inv[Target].amount = Inv[Target].amount + Amount
			Consult[Slot].amount = Consult[Slot].amount - Amount

			if Consult[Slot].amount <= 0 then
				Consult[Slot] = nil
			end

			Returned = false
		end
	else
		if Consult[Slot].amount >= Amount then
			exports["discord"]:Embed("Chest","**[REF]:** "..Data.."\n**[MODO]:** Retirou\n**[PASSAPORTE]:** "..Passport.."\n**[ITEM]:** "..Amount.."x "..Item.."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))

			Inv[Target] = { item = Item, amount = Amount }
			Consult[Slot].amount = Consult[Slot].amount - Amount

			if Consult[Slot].amount <= 0 then
				Consult[Slot] = nil
			end
			
			if Animation then
				vRPC.PersistentBlock(source,Item,Animation)
			end

			if ItemTypeCheck(Item,"Armamento") and vRP.ConsultItem(Passport,Item) then
				TriggerClientEvent("inventory:CreateWeapon",source,Item)
			end

			TriggerClientEvent("inventory:Update",source)

			if Target == "104" then
				local Skinshop = ItemSkinshop(Item)
				if Skinshop then
					TriggerClientEvent("skinshop:Backpack",source,Skinshop)
				end
			end

			Returned = false
		end
	end

	return Returned
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANSLOTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CleanSlotChest(Data,Slot,Save)
	local Consult = vRP.GetSrvData(Data,Save)

	if Consult and Consult[Slot] then
		Consult[Slot] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.StoreChest(Passport,Data,Amount,Weight,Slot,Target,Save,Max)
	local Returned = true
	local Amount = parseInt(Amount)
	local Passport = parseInt(Passport)

	if Amount <= 0 then
		return Returned
	end

	local Slot = tostring(Slot)
	local Inv = vRP.Inventory(Passport)

	if Inv[Slot] then
		local Item = Inv[Slot].item
		if not Max or not vRP.MaxChest(Data,Item,Amount,Save) then
			local Target = tostring(Target)
			local source = vRP.Source(Passport)
			local Consult = vRP.GetSrvData(Data,Save)

			if (vRP.ChestWeight(Consult) + (ItemWeight(Item) * Amount)) <= Weight then
				local Animation = ItemAnim(Item)
				if Consult[Target] and Inv[Slot] then
					if Item == Consult[Target].item and Inv[Slot].amount >= Amount then
						exports["discord"]:Embed("Chest","**[REF]:** "..Data.."\n**[MODO]:** Guardou\n**[PASSAPORTE]:** "..Passport.."\n**[ITEM]:** "..Amount.."x "..Item.."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))

						Consult[Target].amount = Consult[Target].amount + Amount
						Inv[Slot].amount = Inv[Slot].amount - Amount

						if Inv[Slot].amount <= 0 then
							Inv[Slot] = nil

							if Slot == "104" then
								TriggerClientEvent("inventory:Update",source)

								local Skinshop = ItemSkinshop(Item)
								if Skinshop then
									TriggerClientEvent("skinshop:BackpackRemove",source)
								end
							end

							if Animation and not vRP.ConsultItem(Passport,Item) then
								vRPC.PersistentNone(source,Item)
							end

							if ItemTypeCheck(Item,"Armamento") or ItemTypeCheck(Item,"Arremesso") then
								TriggerClientEvent("inventory:verifyWeapon",source,Item)
							end

							local Execute = ItemExecute(Item)
							if Execute and Execute.Event and Execute.Type and not vRP.ConsultItem(Passport,Item) then
								if Execute.Type == "Client" then
									TriggerClientEvent(Execute.Event,source)
								else
									TriggerEvent(Execute.Event,source,Passport)
								end
							end
						end

						Returned = false
					end
				else
					if Inv[Slot] and Inv[Slot].amount >= Amount then
						exports["discord"]:Embed("Chest","**[REF]:** "..Data.."\n**[MODO]:** Guardou\n**[PASSAPORTE]:** "..Passport.."\n**[ITEM]:** "..Amount.."x "..Item.."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))

						Consult[Target] = { item = Item, amount = Amount }
						Inv[Slot].amount = Inv[Slot].amount - Amount

						if Inv[Slot].amount <= 0 then
							Inv[Slot] = nil

							if Slot == "104" then
								TriggerClientEvent("inventory:Update",source)

								local Skinshop = ItemSkinshop(Item)
								if Skinshop then
									TriggerClientEvent("skinshop:BackpackRemove",source)
								end
							end

							if Animation and not vRP.ConsultItem(Passport,Item) then
								vRPC.PersistentNone(source,Item)
							end

							if ItemTypeCheck(Item,"Armamento") or ItemTypeCheck(Item,"Arremesso") then
								TriggerClientEvent("inventory:verifyWeapon",source,Item)
							end

							local Execute = ItemExecute(Item)
							if Execute and Execute.Event and Execute.Type and not vRP.ConsultItem(Passport,Item) then
								if Execute.Type == "Client" then
									TriggerClientEvent(Execute.Event,source)
								else
									TriggerEvent(Execute.Event,source,Passport)
								end
							end
						end

						Returned = false
					end
				end
			else
				TriggerClientEvent("inventory:Notify",source,"Atenção","Limite de peso atingido.","vermelho")
			end
		end
	end

	return Returned
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateChest(Passport,Data,Slot,Target,Amount,Save)
	local Returned = true
	local Slot = tostring(Slot)
	local Passport = parseInt(Passport)
	local Amount = parseInt(Amount,true)
	local Consult = vRP.GetSrvData(Data,Save)

	if Consult[Slot] then
		local Target = tostring(Target)
		if Consult[Target] and Consult[Slot].item == Consult[Target].item then
			if Consult[Slot].amount >= Amount then
				Consult[Slot].amount = Consult[Slot].amount - Amount

				if Consult[Slot].amount <= 0 then
					Consult[Slot] = nil
				end

				Consult[Target].amount = Consult[Target].amount + Amount

				Returned = false
			end
		elseif Consult[Target] then
			local Temp = Consult[Slot]
			Consult[Slot] = Consult[Target]
			Consult[Target] = Temp

			Returned = false
		else
			if Consult[Slot].amount >= Amount then
				Consult[Target] = { item = Consult[Slot].item, amount = Amount }
				Consult[Slot].amount = Consult[Slot].amount - Amount

				if Consult[Slot].amount <= 0 then
					Consult[Slot] = nil
				end

				Returned = false
			end
		end
	end

	return Returned
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ArrestItens(Passport)
	local itemsToRemove = {}
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	for _,v in pairs(Inventory) do
		if ItemArrest(v.item) then
			table.insert(itemsToRemove,{ item = v.item, amount = v.amount })
		end
	end

	for _,v in pairs(itemsToRemove) do
		vRP.RemoveItem(Passport,v.item,v.amount,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNTCONTAINER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.MountContainer(Passport,Datatable,Table,Multiplier,Save,Percentage,Dollars)
	local Itens = {}
	local Exists = {}
	local Passport = Passport
	local Multiplier = Multiplier or 1

	if not Percentage or math.random(1000) <= Percentage then
		for Number = 1,Multiplier do
			local Rand = RandPercentage(Table)
			if not Exists[Rand.Item] then
				Exists[Rand.Item] = true

				Itens[tostring(Number)] = {
					item = vRP.SortNameItem(Passport,Rand.Item),
					amount = math.random(Rand.Min,Rand.Max)
				}
			end
		end

		if Dollars then
			local Amount = CountTable(Itens)
			Itens[tostring(Amount + 1)] = {
				item = vRP.SortNameItem(Passport,Dollars.Item),
				amount = parseInt(Dollars.Amount)
			}
		end
	end

	vRP.SetSrvData(Datatable,Itens,Save or false)

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SORTNAMEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SortNameItem(Passport,Item)
	local NameItem = Item
	local Passport = Passport
	local CurrentTime = os.time() - 1

	if ItemUnique(Item) then
		local Hash = vRP.GenerateHash(Item)

		if Boxes[Item] then
			local multiplierMin = Boxes[Item].Multiplier.Min
			local multiplierMax = Boxes[Item].Multiplier.Max
			vRP.MountContainer(Passport,Item..":"..Hash,Boxes[Item].List,math.random(multiplierMin,multiplierMax),true)
		end

		NameItem = Item.."-"..CurrentTime.."-"..Hash
	elseif ItemDurability(Item) then
		if ItemTypeCheck(Item,"Armamento") then
			NameItem = Item.."-"..CurrentTime.."-"..MaxRepair.."-"..Passport
		else
			NameItem = Item.."-"..CurrentTime
		end
	elseif ItemLoads(Item) then
		NameItem = Item.."-"..ItemLoads(Item)
	elseif ItemNamed(Item) then
		NameItem = Item.."-"..Passport
	end

	return NameItem
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("CallPolice",function(Table)
	if Table.Percentage and math.random(1000) < Table.Percentage then
		return false
	end

	local source = Table.Source
	local passport = Table.Passport

	if Table.Wanted then
		TriggerEvent("Wanted",source,passport,Table.Wanted)
	end

	if Table.Marker then
		local marker = type(Table.Marker) == "number" and Table.Marker or false
		exports["markers"]:Enter(source,Table.Title,1,passport,marker)
	end

	if Table.Notify then
		TriggerClientEvent("Notify",source,"Departamento Policial","As autoridades foram acionadas.","policia",5000)
	end

	local service = vRP.NumPermission(Table.Permission)
	local coords = Table.Coords or vRP.GetEntityCoords(source)
	for _,officer in pairs(service) do
		async(function()
			vRPC.PlaySound(officer,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")

			local notification = {
				code = Table.Code or 20,
				title = Table.Title,
				name = Table.Name,
				x = coords.x,
				y = coords.y,
				z = coords.z,
				vehicle = Table.Vehicle,
				color = Table.Color or 44
			}

			TriggerClientEvent("NotifyPush",officer,notification)
		end)
	end
end)