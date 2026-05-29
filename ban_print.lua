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

--------------------------------------------------- 禁用萌萌的新getupvalue时的打印 ---------------------------------------------------

local function ban_print(fn)
    local _fn = fn
    local new_fn = function(...)
        local env = getfenv(_fn)
        local _print = env.print
        env.print = function(...) end
        local ret = { _fn(...) }
        env.print = _print
        return unpack(ret)
    end
    return new_fn
end

local function ban_print_from_mod_util(MOD_util)
    local _GetUpvalueHelper_deekseek, fn_i, scope_fn = Upvaluehelper.GetUpvalue(MOD_util.GetUpvalue_deekseek, "GetUpvalueHelper_deekseek")
    if _GetUpvalueHelper_deekseek then
        local new_GetUpvalueHelper_deekseek = ban_print(_GetUpvalueHelper_deekseek)
        debug.setupvalue(scope_fn, fn_i, new_GetUpvalueHelper_deekseek)
    else
        MOD_util:Warning("未找到GetUpvalueHelper_deekseek", 3)
    end
end

-- 控制优化
if KnownModIndex:IsModEnabledAny("workshop-3310943563") then
    local mmdx_MOD_util = Upvaluehelper.Getmoddata("workshop-3310943563", "ComponentPostInit", "playercontroller", "MOD_util")
    if mmdx_MOD_util then
        ban_print_from_mod_util(mmdx_MOD_util)
    else
        MOD_util:Warning("未找到MOD_util")
    end
end

-- 显示所有配方
if KnownModIndex:IsModEnabledAny("workshop-3156267875") then
    local classdef = require "widgets/redux/craftingmenu_widget"
    local constructor = classdef._ctor
    local mmdx_MOD_util = Upvaluehelper.FindUpvalue(constructor, "MOD_util", "workshop%-3156267875/modmain.lua")
    if mmdx_MOD_util then
        ban_print_from_mod_util(mmdx_MOD_util)
    else
        MOD_util:Warning("未找到MOD_util")
    end
end

-- Showme血条
if KnownModIndex:IsModEnabledAny("workshop-3620271154") then
    AddGamePostInit(function()
        local showme_hint_rpc = MOD_RPC.ShowMeSHint and MOD_RPC.ShowMeSHint.Hint
        if showme_hint_rpc then
            local classdef = require "widgets/hoverer"
            local constructor = classdef._ctor
            local mmdx_MOD_util = Upvaluehelper.FindUpvalue(constructor, "MOD_util", "workshop%-3620271154/modmain.lua")
            if mmdx_MOD_util then
                ban_print_from_mod_util(mmdx_MOD_util)
            else
                MOD_util:Warning("未找到MOD_util")
            end
        end
    end)
end

---------------------------------------------------  ---------------------------------------------------