if Config.inventory == 'vrp' then
    function IsPlayerCarryingItem(item_name)
        local state = LocalPlayer.state.SmellyItems
        return state and state[item_name] or false
    end
end
