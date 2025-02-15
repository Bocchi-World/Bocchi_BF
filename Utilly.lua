--assert(ModuleController, "This can only be loaded in module controller") 

local Export = {
    MAX_TABLE_DEPTH = 3,
    MAX_TABLE_LENGTH = 10, 
    CUSTOM_LOGGING = true 
} 

function TableDepthResolver(Table, Depth) 
    if typeof(Table) ~= "table" then return ArgumentParser(Table) end 
    
    Depth = Depth or 0 
    if Depth > Export.Config.MAX_TABLE_LENGTH then 
        return "... ( " .. #Table .. " items more )" 
    end 
    
    local Plus = "" 
    for I=0,Depth,1 do 
        Plus = Plus .. "    " 
    end 
    
    local StringifyResult = "{\n    "
    
    for Index, Value in Table do 
        StringifyResult = StringifyResult .."\n" .. Plus .. Index .. " => " .. TableDepthResolver(Value, Depth + 1)
    end
    return StringifyResult .. Plus .. "\n}"
end 


function ArgumentParser(Argl) 
    local ArgType = typeof(Argl) 
    
    if ArgType == "string" then 
        return '"' .. Argl .. '"' 
    elseif ArgType == "number" then 
        return Argl 
    elseif table.find({"Vector2", "Vector3", "CFrame"}, ArgType) then 
        local PreResult = ArgType .. "( " .. Argl.X .. ", " .. Argl.Y 
        PreResult = PreResult .. ( ArgType == "Vector2" and " )" or Argl.Z .. " )" )
        return PreResult
    elseif ArgType == "table" then 
        return TableDepthResolver(Argl, 0)
    else 
        return ArgType .. " ( " .. Argl .. " )"
    end
end 

function r_debug(...) 
    
    if not debug_mode then return end 
    
    if not Export.CUSTOM_LOGGING then return print(...) end 
    
    local Result = "" 
    for Index, Value in {"[ Debugger ]", ...} do 
        Result = Result .. ArgumentParser(Value) .. "  "
    end 
    
    print(Result)
end  

function ErrorLog(Error) 
    Export.Log("[!]", Error)
end 

function GenerateUUID()
    local Template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(Template, '[xy]', function (Idc)
        local V = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', V)
    end)
end

function CheckIsPlayerAlive(Instance) 
    Instance = Instance or LocalPlayer 
    
    return Instance and Instance.Character and Instance.Character.Humanoid and Instance.Character.HumanoidRootPart and Instance.Character.Head and Instance.Character.Humanoid.Health > 0  -- nuh uh
end 

function ConvertTo(Type, Instance)
    return Type.new(Instance.X, Instance.Y, Instance.Z) 
end 

function CaculateDistance(Origin, Desnitation) 
    
    assert(Origin) 
    
    Desnitation = Desnitation or HumanoidRootPart.CFrame 
    
    local Origin, Desnitation = ConvertTo(Vector3, Origin), ConvertTo(Vector3, Desnitation)
    
    return ( Origin - Desnitation ) .magnitude
end  

