LastNotification = Instance.new("StringValue", workspace)

LastNotification = "LastNotification"

LastNotification.Changed:Connect(function()

end) 


local old;

old = hookfunction(

                require(ReplicatedStorage.Notification).new,

                function(a, b)

                    v21 = tostring(tostring(a or "") .. tostring(b or "")) or ""

                    workspace.LastNotification.Value = v21

                    return old(a, b)

                end

)
