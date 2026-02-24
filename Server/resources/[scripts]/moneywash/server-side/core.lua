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
Tunnel.bindInterface("moneywash",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local MoneyWash = {}
local MachineLimits = {
  moneywash = 250000,
  moneywashplus = 500000,
  moneywashalpha = 1000000,
  moneywashomega = 5000000
}
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
  while true do
    local Changed = false
    local Now = os.time()
    local Today = os.date("%Y-%m-%d")

    for Index,Data in pairs(MoneyWash) do
      if Data and Data.Timer and Data.Timer > Now and Data.Money and Data.Money > 0 then
        local Ratio = 0.9

        if Data.DailyLimit and Data.DailyLimit > 0 then
          if not Data.DailyDay or Data.DailyDay ~= Today then
            Data.DailyDay = Today
            Data.DailyUsed = 0
            Changed = true
          end
        end

        if Data.DirtyCapacity and Data.CleanCapacity and Data.DirtyCapacity > 0 and Data.CleanCapacity > 0 then
          Ratio = Data.CleanCapacity / Data.DirtyCapacity
        end

        local MaxClean = math.huge
        if Data.CleanCapacity and Data.CleanCapacity > 0 then
          MaxClean = math.max(Data.CleanCapacity - (Data.Washed or 0),0)
        end

        if MaxClean > 0 then
          local ConvertDirty = Data.Money
          local ConvertClean = math.floor(ConvertDirty * Ratio)

          if ConvertClean > MaxClean and Ratio > 0 then
            ConvertClean = MaxClean
            ConvertDirty = math.ceil(ConvertClean / Ratio)
          end

          local Limit = Data.DailyLimit or 0
          if Limit > 0 then
            local Remaining = math.max(Limit - (Data.DailyUsed or 0),0)
            if Remaining <= 0 then
              ConvertDirty = 0
              ConvertClean = 0
            else
              if ConvertClean > Remaining then
                ConvertClean = Remaining
                if Ratio > 0 then
                  ConvertDirty = math.ceil(ConvertClean / Ratio)
                end
              end
            end
          end

          if ConvertDirty > 0 and ConvertClean > 0 then
            Data.Money = Data.Money - ConvertDirty
            Data.Washed = (Data.Washed or 0) + ConvertClean
            Data.DailyUsed = (Data.DailyUsed or 0) + ConvertClean
            Changed = true
          end
        end
      end
    end

    if Changed then
      vRP.SetSrvData("MoneyWash",MoneyWash,true)
    end

    Wait(60000)
  end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINITMACHINES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local Consult = vRP.GetSrvData("MoneyWash",true)
    for k,v in pairs(Consult) do
        MoneyWash[k] = {
          Route = v.Route,
          Coords = v.Coords,
          Hash = v.Hash,
          Item = v.Item,
          Money = v.Money,
          Washed = v.Washed,
          Timer = v.Timer,
          DirtyCapacity = v.DirtyCapacity,
          CleanCapacity = v.CleanCapacity,
          DirtyItem = v.DirtyItem,
          CleanItem = v.CleanItem,
          Password = v.Password,
          DailyLimit = v.DailyLimit,
          DailyUsed = v.DailyUsed,
          DailyDay = v.DailyDay
        }
    end

    TriggerClientEvent("moneywash:Table", -1, MoneyWash)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WASH
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wash",function(Passport, Full, Hash, Coords, Bucket, DirtyCapacity, CleanCapacity, DirtyItem, CleanItem)
  repeat
    Selected = GenerateString("DDLLDDLL")
  until Selected and not MoneyWash[Selected]
  local DailyLimit = MachineLimits[Full] or 0
  MoneyWash[Selected] = {
    Route = Bucket,
    Coords = Coords,
    Hash = Hash,
    Item = Full,
    Money = 0,
    Washed = 0,
    Timer = 0,
    DirtyCapacity = DirtyCapacity,
    CleanCapacity = CleanCapacity,
    DirtyItem = DirtyItem,
    CleanItem = CleanItem,
    Password = false,
    DailyLimit = DailyLimit,
    DailyUsed = 0,
    DailyDay = os.date("%Y-%m-%d")
  }
  vRP.SetSrvData("MoneyWash",MoneyWash,true)
  TriggerClientEvent("moneywash:New", -1, Selected, MoneyWash[Selected])
  TriggerClientEvent("Notify",vRP.Source(Passport),"Sucesso","Você posicionou a máquina de lavagem de dinheiro.","verde",5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:StoreObjects")
AddEventHandler("moneywash:StoreObjects",function(Selected)
  local source = source
  local Passport = vRP.Passport(source)
  if not MoneyWash[Selected] or not Passport then return end

  local Data = MoneyWash[Selected]
  local DirtyItem = Data.DirtyItem or "wetdollar"
  local CleanItem = Data.CleanItem or "dollar"

  if not Data.Password or Data.Password == false or Data.Password == "" then
    local Keyboard = vKEYBOARD.Primary(source,"Defina a senha da máquina para guardar")
    if not Keyboard then
      return
    end

    local Pass = tostring(Keyboard[1] or "")
    Pass = Pass:gsub("%s+","")

    if Pass == "" or #Pass < 4 or #Pass > 12 then
      TriggerClientEvent("Notify",source,"Atenção","A senha deve ter entre 4 e 12 caracteres.","amarelo",5000)
      return
    end

    Data.Password = Pass
    vRP.SetSrvData("MoneyWash",MoneyWash,true)
  else
    local Keyboard = vKEYBOARD.Primary(source,"Informe a senha da máquina para guardar")
    if not Keyboard then
      return
    end

    local Pass = tostring(Keyboard[1] or "")
    Pass = Pass:gsub("%s+","")

    if Pass ~= Data.Password then
      TriggerClientEvent("Notify",source,"Atenção","Senha incorreta.","vermelho",5000)
      return
    end
  end

  if Data.Money and Data.Money > 0 then
    vRP.GenerateItem(Passport,DirtyItem,Data.Money,true)
  end

  if Data.Washed and Data.Washed > 0 then
    vRP.GenerateItem(Passport,CleanItem,Data.Washed,true)
  end

  vRP.GenerateItem(Passport,Data.Item,1,true)
  MoneyWash[Selected] = nil
  vRP.SetSrvData("MoneyWash",MoneyWash,true)
  TriggerClientEvent("moneywash:Remove",-1,Selected)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Add")
AddEventHandler("moneywash:Add",function(Selected)
  local Source = source
  local Passport = vRP.Passport(Source)
  if not MoneyWash[Selected] or not Passport then return end

  local DirtyItem = MoneyWash[Selected]["DirtyItem"] or "wetdollar"
  local Keyboard = vKEYBOARD.Primary(Source,"Quatidade:")
  if Keyboard then
    local Quantity = tonumber(Keyboard[1])

    if not Quantity or Quantity <= 0 then
      TriggerClientEvent("Notify",Source,"Atenção","Quantidade inválida.","amarelo",5000)
      return
    end

    if MoneyWash[Selected]["DirtyCapacity"] and MoneyWash[Selected]["DirtyCapacity"] > 0 then
      local Free = MoneyWash[Selected]["DirtyCapacity"] - (MoneyWash[Selected]["Money"] or 0)
      if Free <= 0 then
        TriggerClientEvent("Notify",Source,"Atenção","O compartimento primário está cheio.","amarelo",5000)
        return
      end

      if Quantity > Free then
        Quantity = Free
      end
    end

    if vRP.TakeItem(Passport,DirtyItem,Quantity,true) then
      MoneyWash[Selected]["Money"] = (MoneyWash[Selected]["Money"] or 0) + Quantity

      vRP.SetSrvData("MoneyWash",MoneyWash,true)

      TriggerClientEvent("dynamic:Close",Source)
    else
      TriggerClientEvent("Notify",Source,"Atenção","Você não possui dólar molhado suficiente.","vermelho",5000)
    end
  end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Money")
AddEventHandler("moneywash:Money",function(Selected)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not MoneyWash[Selected] or not Passport then return end

    local DirtyItem = MoneyWash[Selected]["DirtyItem"] or "wetdollar"

    local Keyboard = vKEYBOARD.Primary(Source,"Quatidade:")
    if Keyboard then
        local Quantity = tonumber(Keyboard[1])

        if not Quantity or Quantity <= 0 then
          TriggerClientEvent("Notify",Source,"Atenção","Quantidade inválida.","amarelo",5000)
          return
        end

        if MoneyWash[Selected]["Money"] < Quantity then
          TriggerClientEvent("Notify",Source,"Atenção","Quantidade maior que o saldo do compartimento primário.","amarelo",5000)
          return
        end

        MoneyWash[Selected]["Money"] -= Quantity

        vRP.SetSrvData("MoneyWash",MoneyWash,true)
        vRP.GenerateItem(Passport,DirtyItem,Quantity,true)

        TriggerClientEvent("dynamic:Close",Source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:WASHED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Washed")
AddEventHandler("moneywash:Washed",function(Selected)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not MoneyWash[Selected] or not Passport then return end

    local CleanItem = MoneyWash[Selected]["CleanItem"] or "dollar"

    local Keyboard = vKEYBOARD.Primary(Source,"Quatidade:")
    if Keyboard then
        local Quantity = tonumber(Keyboard[1])

        if not Quantity or Quantity <= 0 then
          TriggerClientEvent("Notify",Source,"Atenção","Quantidade inválida.","amarelo",5000)
          return
        end

        if MoneyWash[Selected]["Washed"] < Quantity then
          TriggerClientEvent("Notify",Source,"Atenção","Quantidade maior que o saldo do compartimento secundário.","amarelo",5000)
          return
        end

        MoneyWash[Selected]["Washed"] -= Quantity

        vRP.SetSrvData("MoneyWash",MoneyWash,true)
        vRP.GenerateItem(Passport,CleanItem,Quantity,true)

        TriggerClientEvent("dynamic:Close",Source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:BATTERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Battery")
AddEventHandler("moneywash:Battery",function(Selected)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not MoneyWash[Selected] or not Passport then return end

    if vRP.TakeItem(Passport, "washbattery", 1, true) then
      MoneyWash[Selected]["Timer"] = os.time() + 86400

      vRP.SetSrvData("MoneyWash",MoneyWash,true)

      TriggerClientEvent("dynamic:Close",Source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Information(Selected)
  local source = source
  local Passport = vRP.Passport(source)
  if not MoneyWash[Selected] or not Passport then return end
  local Data = MoneyWash[Selected]

  if not Data.Password or Data.Password == false or Data.Password == "" then
    local Keyboard = vKEYBOARD.Primary(source,"Defina uma senha para a máquina")
    if not Keyboard then
      return
    end

    local Password = tostring(Keyboard[1] or "")
    Password = Password:gsub("%s+","")

    if Password == "" or #Password < 4 or #Password > 12 then
      TriggerClientEvent("Notify",source,"Atenção","A senha deve ter entre 4 e 12 caracteres.","amarelo",5000)
      return
    end

    Data.Password = Password
    vRP.SetSrvData("MoneyWash",MoneyWash,true)

    TriggerClientEvent("Notify",source,"Sucesso","Senha definida com sucesso.","verde",5000)
  else
    local Keyboard = vKEYBOARD.Primary(source,"Informe a senha da máquina")
    if not Keyboard then
      return
    end

    local Password = tostring(Keyboard[1] or "")
    Password = Password:gsub("%s+","")

    if Password ~= Data.Password then
      TriggerClientEvent("Notify",source,"Atenção","Senha incorreta.","vermelho",5000)
      return
    end
  end

  return Data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OSTIME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OsTime()
  return os.time()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, Source)
  TriggerClientEvent("moneywash:Table", Source, MoneyWash)
end)
