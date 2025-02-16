local Exports = {
    Listeners = {}
} 

LastNotification = Instance.new("StringValue", workspace)

LastNotification = "LastNotification"

LastNotification.Changed:Connect(function(Content)
    for ListenerContent, Callback in Exports.Listeners do 
        if string.find(string.lower(Content), string.lower(ListenerContent)) then 
            Callback(Content)
        end 
    end 
end) 

function Exports:RegisterNotifyListener(Senque, Callback)
    Exports.Listeners[Senque] = Callback
end 

local old;

old = hookfunction(
    require(ReplicatedStorage.Notification).new,
    function(a, b)
        v21 = tostring(tostring(a or "") .. tostring(b or "")) or ""
        workspace.LastNotification.Value = v21
        return old(a, b)
    end
)

return Exports
