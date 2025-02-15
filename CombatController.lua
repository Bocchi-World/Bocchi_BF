local Exports = {
    GRAB = true, 
    GRAB_DISTANCE = 350, 
    
    MAX_ATTACK_DURATION = 10, 
    LEVITATE_TIME = 10, 
    
    CurrentIndex = 1, 
}

function Exports.Grab(MobName) 
    
    local MidPoint, Count = nil, 0 
    local ForcePosition = nil 
    local MobsTable = {} 
    
    for _, Mon in Services.Workspace.Enemies:GetChildren() do 
        if Mon.Name == MobName then 
            if Mon:FindFirstChild("Humanoid") and Mon.Humanoid.Health > 0 then 
                Count = Count + 1 
                local MonPosition = Mon.HumanoidRootPart.Position 
                if not ForcePosition or ( MonPosition - ForcePosition ).magnitude < Exports.GRAB_DISTANCE then 
                    MidPoint = not MidPoint and MonPosition or MidPoint + MonPosition
                    ForcePosition = ForcePosition or MonPosition
                    table.insert(MobsTable, Mon) 
                end
            end
        end
    end 
    MidPoint = MidPoint / Count  
    
    table.foreach(MobsTable, function(_, ChildInstance) 
        pcall(function() 
            ChildInstance:SetPrimaryPartCFrame(CFrame.new(MidPoint))
        end)
    end)
end 

function Exports.Search(MobTable) 
    for _, ChildInstance in Services.Workspace.Enemies:GetChildren() do
        if table.find(MobTable, ChildInstance.Name) then
            return ChildInstance
        end 
    end
end 

function Exports.Attack(MobTable)
    MobTable = type(MobTable) == "string" and {MobTable} or MobTable 
    
    for _, Child in MobTable do 
        local Result = Exports.Search(MobTable) 
        
        if Result then 
            local Count, Debounce = 0, os.time()
            while task.wait() do 
                
                if Count >= Exports.MAX_ATTACK_DURATION then HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 5000, 0) 
                    wait(Exports.LEVITATE_TIME)
                    Count = 0 
                end 
                
                if os.time() ~= Debounce then Debounce = os.time()
                    Count = Count + 1
                end 
                
                local MobHumanoid = Result:FindFirstChild("Humanoid")
                local MobHumanoidRootPart = Result:FindFirstChild("HumanoidRootPart")
                
                if MobHumanoid.Health < 1 then 
                    break
                end 
                
                Exports.Grab(MobTable)
                if CaculateDistance(MobHumanoidRootPart.Position) < 50 then 
                    ScriptStorage.AttackController:Attack()
                end 
            end 
        else 
            local Region = ScriptStorage.MobRegions[Child] 
            local CurrentPosition
            
            if not Region[Exports.CurrentIndex] then 
                Exports.CurrentIndex = 1
            else 
                Exports.CurrentIndex = Exports.CurrentIndex + 1
            end 
            
            CurrentPosition = Region[Exports.CurrentIndex] 
            
            ScriptStorage.Tween.Create(CurrentPosition)
        end 
    end 
end 

return Exports
