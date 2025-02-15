local PARTS = {"RawConstants", "Utilly", "QuestManager", "SpawnRegionLoader", "TweenController", "AttackController", "CombatController"} 
local CDN_HOST = "https://raw.githubusercontent.com/Bocchi-World/Bocchi_BF/refs/heads/main/"

ScriptStorage = {
    IsInitalized = false, 
    PlayerData = {}, 
    
    Connections = {
        LocalPlayer = {}
    }
} 

for _, Part in PARTS do 
    ScriptStorage[Part] = loadstring(game:HttpGet(CDN_HOST .. Part .. ".lua"))() 
    print("[ Debug ] Try to include", Part)
end 

Players = game.Players 
LocalPlayer = Players.LocalPlayer 
Character = LocalPlayer.Character 

Humanoid = Character:WaitForChild("Humanoid") 
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") 

Services = {} 
Remotes = {} 

setmetatable(Services, {__index = function(_, Index) 
    return game:GetService(Index)
end
}); 

setmetatable(Remotes, {__index = function(_, Index) 
        return Services.ReplicatedStorage.Remotes[Index]
    end 
})

function AwaitUntilPlayerLoaded(Player, Timeout) 
    repeat wait() until Player.Character 
    
    Player.Character:WaitForChild("Humanoid") 
    repeat wait() until Player.Character.Humanoid.Health > 0
end 

function RefreshPlayerData (Player) 
    for _, ChildInstance in Player.Data:GetChildren() do 
        pcall(function() 
            ScriptStorage.PlayerData[ChildInstance.Name] = ChildInstance.Value 
        end)
    end 
end 

function RegisterLocalPlayerEventsConnection() 
    
    for _, Connection in ScriptStorage.Connections.LocalPlayer do 
        pcall(function() 
            Connection:Disconnect() 
        end) 
    end 
    
    AwaitUntilPlayerLoaded(LocalPlayer) 
    
    pcall(function() 
        for _, ChildInstance in LocalPlayer.Data do 
            if not ChildInstance:IsA("Folder") then 
                ScriptStorage.Connections.LocalPlayer[ChildInstance.Name] = ChildInstance:GetPropertyChangedSignal("Value"):Connect(RefreshPlayerData)
            end 
        end 
    end)
    
    LocalPlayer:SetAttribute("IsAvailable", true)
    
    ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function() 
        local Health = LocalPlayer.Character.Humanoid.Health 
        
        LocalPlayer:SetAttribute("IsAvailable", Health > 10)
        ScriptStorage.LocalPlayerHealth = Health
    end)
    
end 

RegisterLocalPlayerEventsConnection(LocalPlayer) 

Players.PlayerAdded:Connect(function(Player) 
    if tostring(Player) == tostring(LocalPlayer) then 
        RegisterLocalPlayerEventsConnection(Player) 
    end 
end) 
