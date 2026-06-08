--------------------------------------------------- 禁用调试参数打印 ---------------------------------------------------

AddGamePostInit(function()
    local key_list = {}
    table.insert(key_list, TheInput.onkeydown.events[KEY_LEFT])
    table.insert(key_list, TheInput.onkeydown.events[KEY_RIGHT])
    for _,v in pairs (key_list) do
        for k in pairs (v) do
            local data = debug.getinfo(k.fn, "S")
            if string.match(data.source, "scripts/utils/utils.lua") or string.match(data.source, "m_utils/m_utils.lua") then
                k.processor:RemoveHandler(k)
            end
        end
    end
end)