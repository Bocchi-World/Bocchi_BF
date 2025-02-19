--[[
    @ todo: sửa combatcontroller thêm cả search trong replicatedstorage 
]]

Config = 
{
    Team = "Pirates", 
    Configuration = 
    {
        HopWhenIdle = true, 
        AutoHop = true, 
        AutoHopDelay = 10 * 60
    },
    Items = {
        -- Melees 
        Superhuman = true, 
        GodHuman = true, 
        
        -- Swords 
        Saber = true,
        LegendarySword = true,
        Canvander = true, 
        BuddySword = true, 
        CursedDualKatana = true, 
        
        -- Guns 
        Kabucha = true, 
        SperentBow = true, 
        SoulGuitar = true, 
        
    }, 
    
    Utilly = 
    {
        BlackScreen = true, 
    }, 
    
    Authorize = 
    {
        GrantCode = "", 
        SendData = true, 
        AllowToControl = true,
        HookdataUrl = ""
    },  
}


game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)

local PARTS = {"RawConstants", "Utilly", "QuestManager", "SpawnRegionLoader", "TweenController", "AttackController", "CombatController", "FunctionsHandler", "Hooks"}

loadstring(game:HttpGet"https://github.com/Bocchi-World/Bocchi_BF/blob/main/InstanceDownloader.lua?raw=true")()

local CDN_HOST = "https://raw.githubusercontent.com/Bocchi-World/Bocchi_BF/refs/heads/main/"

local FolderPath = "Bocchi/Blox_Fruit/Assets/"

ScriptStorage = {
    IsInitalized = false, 
    PlayerData = {}, 
    Melees = {}, 
    Enemies = {},
    Connections = {
        LocalPlayer = {}
    }, 
} 


Players = game.Players 
LocalPlayer = Players.LocalPlayer 
Character = LocalPlayer.Character 

Humanoid = Character:WaitForChild("Humanoid") 
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") 

PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) 

Services = {} 

setmetatable(Services, {__index = function(_, Index) 
    return game:GetService(Index)
end
}); 

setmetatable(ScriptStorage.Enemies, {__index = function(_, Index) 
        return Services.Workspace.Enemies:FindFirstChild(Index) or Services.ReplicatedStorage:FindFirstChild(Index)
    end 
})

Remotes = Services.ReplicatedStorage.Remotes

Tasks = {} 




function AwaitUntilPlayerLoaded(Player, Timeout) 
    repeat wait() until Player.Character 
    
    Player.Character:WaitForChild("Humanoid") 
    repeat wait() until Player.Character.Humanoid.Health > 0
end 

function RefreshPlayerData () 
    for _, ChildInstance in LocalPlayer.Data:GetChildren() do 
        pcall(function() 
            ScriptStorage.PlayerData[ChildInstance.Name] = ChildInstance.Value
            print(ChildInstance, ChildInstance.Value)
        end)
    end 
end 

RefreshPlayerData()

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

for _, Part in PARTS do 
    print("[ Debug ] Try to include", Part)
    ScriptStorage[Part] = loadstring(readfile(FolderPath .. Part .. ".lua"))() 
end 

local LogCache = {} 

function RefreshTasksData() 
    for _, TaskName in TasksOrder do 
        local Task = ScriptStorage.FunctionsHandler[TaskName] 
        if not Task and not LogCache[TaskName] then 
            print("[ Debug ] Task", Name, "is not registered yet") 
            LogCache[TaskName] = true 
            
        else 
            local Refresh = Task.Methods.Refresh 
            local Start = Task.Methods.Start 
            local RefreshValue = Refresh:Call() 
            
            if RefreshValue then 
                Start:Call()
            end 
        end 
    end 
end 

ScriptStorage.Hooks.RegisterNotifyListener("level", function() 
    ScriptStorage.QuestManager:RefreshQuest()
end) 

ScriptStorage.QuestManager:RefreshQuest()

task.spawn(function() 
    while task.wait() do
        RefreshTasksData()
    end 
end)
