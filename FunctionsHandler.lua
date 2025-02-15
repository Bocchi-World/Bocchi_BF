local Exports = {
    Initalized = false 
}; 
print("func")

setmetatable(Exports, {
    __index = function(Self, Index) 
        QueryResult = rawget(Self, Index) 
        
        if not QueryResult then 
            return {
                Register = function(Coditional) 
                    if Coditional == false then return end 
                    
                    Result = {
                        CacheListener = {}, 
                        RealCache = {},
                        Methods = {}, 
                        Constants = {}, 
                        Events = {}, 
                        Initalized = true
                    } 
                    
                    function Result.RegisterMethod(Self, Name, Function) 
                        Self.Methods[Name] =
                        {
                            Name = Name, 
                            Callback = Function,
                            Call = function(Self, ...) 
                                return Self.Callback(...) 
                                
                            end, 
                            Events = {} 
                            
                        }
                        return true
                        
                    end 
                    
                    setmetatable(Result.Constants, {
                            __newindex = function() 
                                assert(false, "cannot change constant value!") 
                                
                        end
                    })
                
                    function Result.SaveConstant(Self, Key, Value) 
                        if Self.Constants[Key] then  
                            return assert(false, "constant name was used before!") 
                        end 
                        
                        rawset(Self.Constants, Key, Value)
                        
                    end 
                    
                    function Result.Set(Self, Key, Value) 
                        Self.CacheListener[Key] = Value 
                        return Value
                        
                    end
                    
                    function Result.Get(Self, Index) 
                        return Self.Constants[Index] or Self.RealCache[Index]
                        
                    end 
                    
                    function Result.AddVariableChangeListener(Self, Index, Callback) 
                        Self.Events[Index] = Callback
                        
                    end
                    
                    Result.CacheListener.__parent = Result; 
                    
                    setmetatable(Result.CacheListener, {
                        __newindex = function(Self, Key, Value) 
                            _ = Self.__parent.Events[Key] and Self.__parent.Events[Key](Key, Value)
                            
                            Self.__parent.RealCache[Key] = Value
                            
                        end 
                    })
                    
                    r_debug("Registed", Index, "module!!!")
                    
                    Exports[Index] = Result
                    
                end, 
                Initalized = false
            }
        end 
        
        return QueryResult
        
    end 
})

function Exports.SynchorizeUntilModuleLoaded(Self, Timeout) 
    local StartTime = os.time() 
    
    while not Self.Initalized do 
        wait() 
        local Difference = os.time() - StartTime 
        
        assert(not ( Timeout and Difference > Timeout ), "timed out")
    end 
    
end 


-- LP Controller 

Exports.LocalPlayerController.Register()
-- Items / Sword
Exports.Saber:Register()
Exports.Rengoku:Register()
Exports.Yama:Register()
Exports.Tushita:Register()
Exports.SpikeyTrident:Register()
Exports.SharkAchor:Register()
Exports.Pole:Register()
Exports.FoxLamp:Register()
Exports.DarkDagger:Register()
Exports.Canvander:Register()
Exports.BuddySword:Register()
Exports.HallowScythe:Register()
Exports.CursedDualKatana:Register()

-- Items / Guns 

Exports.AcidumRifle:Register()
Exports.Kabucha:Register()
Exports.VenomBow:Register()
Exports.SoulGuitar:Register()
Exports.DragonStorm:Register()

-- Items / Etc

Exports.InsictV2:Register()
Exports.RainbowSaviour:Register()

-- Puzzles / First Sea

Exports.DarkBladeV2:Register()
Exports.SecondSeaPuzzle:Register()

-- Puzzles / Second Sea

Exports.ColosseumPuzzle:Register()
Exports.EvoRace:Register()
Exports.Wenlocktoad:Register()
Exports.DarkBladeV3:Register()
Exports.ThirdSeaPuzzle:Register()

-- Puzzles / Third Sea 

Exports.DojoQuest:Register()
Exports.RaceAwakening:Register()

-- Functions / Raid 

Exports.RaidController:Register() 

-- Functions / Auto Melees 

Exports.Superhuman:Register()
Exports.DeathStep:Register()
Exports.SharkmanKarate:Register()
Exports.ElectricClaw:Register()
Exports.DragonTalon:Register()
Exports.Godhuman:Register()

-- LP Controller 

do 
    
    Exports.LocalPlayerController:RegisterMethod("EquipTool", function(Tool) 
        if not Humanoid then return end 
        
        for _, Instance in LocalPlayer.Backpack:GetChildren() do 
            if 
            Instance:IsA("Tool")
            and (
                Instance.Name == tostring(Tool)
                or Instance.Tooltip == Tool
                )
            then 
                Humanoid:EquipTool(Tool)
            end 
        end 
    end)
    
    Exports.LocalPlayerController:RegisterMethod("ToggleAbilities", function(Ability, State) 
        
        if Ability == "Buso" then 
            if LocalPlayer:HasTag("Buso") and not State or State then 
                Remotes.CommF_:InvokeServer("Buso")
            end 
            
        elseif Ability == "Observation" then
            
        end 
    end)
    
    Exports.LocalPlayerController:RegisterMethod("ConfigurationAbilitiesToggle", function() 
        Exports.LocalPlayerController.Methods.ToggleAbilities:Call("Buso", SCRIPT_CONFIG.BUSO)
        Exports.LocalPlayerController.Methods.ToggleAbilities:Call("Observation", SCRIPT_CONFIG.OBSERVATION)
    end)
end

-- Items / Saber 

do  
    Exports.Saber:SaveConstant("TASK_SUBTITLES", 
        {
            "Use torchs",
            "Filling cups",
            "Son talk",
            "Defeat Mob Leader",
            "Use relic",
            "Defeat Saber Expert"
    })
    
    Exports.Saber:RegisterMethod("Refresh", function() 
        local Result 
        if ServerRuntime.Tools.Saber then 
            Result = 0
            
        end 
        
        local Tasks = Remotes.CommF_:InvokeServer("ProQuestProgress") 
        for _, Value in Tasks.Plates do
            if Value == false then
                Result = 1
                
            end
        end
        
        if not Result then 
            if not Tasks.UsedTorch then
            Result = 2
                
            elseif not Tasks.UsedCup then
                Result = 3
                
            elseif not Tasks.TalkedSon then
                Result = 4
                
            elseif not Tasks.KilledMob then
                Result = 5
                
            elseif not Tasks.UsedRelic then
                Result = 6
                
            elseif
                not Tasks.KilledShanks
                and ServerRuntime.Enemies["Saber Expert"]
            then
                Result = 7
                
            end
        end 
        
        Exports.Saber:Set("CurrentProgressLevel", Result)
        Exports.Saber:Set("LastestRefreshSenque", os.time()) 
        
        return Result
        
    end) 
    
    Exports.Saber:RegisterMethod("GetQuestplates", function() 
        
        local CachedData = Exports.Saber:Get("QuestplatesCache") 
        
        if CachedData then
            return CachedData 
            
        end 
        
        local Jungle = Services.Workspace.Map.Jungle 
        local Result = {}
        
        table.foreach(Jungle.QuestPlates:GetChildren(), function(_, Inst) 
            _ = Inst:FindFirstChild("Button") and table.insert(Result, Inst) 
            
        end)
        
        Exports.Saber:Get("QuestplatesCache", Result)
        
        return Result 
        
    end)
    
    Exports.Saber:RegisterMethod("Start", function() 
        local 
        Progress,
            LastestRefreshSenque = 
            Exports.Saber:Get("CurrentProgressLevel"),
        Exports.Saber:Get("LastestRefreshSenque") 
        
        if not Progress then 
            Exports.Saber.Methods.Refresh:Call()
            return Exports.Saber.Methods.Start:Call()
            
        elseif Progress == 0 then 
            
        elseif os.time() - LastestRefreshSenque > 60 then 
            Exports.Saber.Methods.Refresh:Call()
            
            return Exports.Saber.Methods.Start:Call()
        
        else
            if Progress == 1 then 
                local Questplates = Exports.Saber.Methods.GetQuestplates:Call()
                
                for _, Questplate in Questplates do  
                    if CaculateDistance(Questplate.Button.CFrame) > 20 then 
                        ScriptStorage.TweenController.Create(Questplate.Button.CFrame + MathLib.RandomArguments(Vector3.zero, Vector3.new(0, -3, 0)))
                    end 
                end
            
            elseif Progress == 2 then 
                Remotes.CommF_:InvokeServer("ProQuestProgress", "GetTorch")
                wait(1) 
                Remotes.CommF_:InvokeServer("ProQuestProgress", "DestroyTorch")
                
            elseif Progress == 3 then  
                Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                
                if LocalPlayer.Backpack.Cup then 
                    Exports.LocalPlayerController.Methods.EquipTool:Call("Cup") 
                    wait(1)
                    
                end 
                
                Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                
            elseif Progress == 4 then 
                Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                
            elseif Progress == 5 then 
                Exports.LocalPlayerController.Methods.RegisterAttacks:Call("Mob Leader")
                
            elseif Progress == 6 then 
                Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            
            elseif Progress == 7 then 
                ScriptStorage.CombatController.Attack("Saber Expert")
                
            end
        end
    end)
    
    Remotes.RefreshQuestPro.OnClientEvent:Connect(Exports.Saber.Methods.Refresh.Callback);
end

return Exports
