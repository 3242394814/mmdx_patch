-- 将萌萌的新的GetUpvalue、SetUpvalue替换为bbgoat_upvaluehelper.lua的版本
local function override_getupvalue_helper(MOD_util)
    if MOD_util.GetUpvalue then
        MOD_util.GetUpvalue = function(self, fn, path)
            local path_list = {}
            for path in path:gmatch("[^%.]+") do
                table.insert(path_list, path)
            end
            return Upvaluehelper.GetUpvalue(fn, unpack(path_list))
        end
    end
    if MOD_util.SetUpvalue then
        MOD_util.SetUpvalue = function(self, fn, path, value)
            local path_list = {}
            for path in path:gmatch("[^%.]+") do
                table.insert(path_list, path)
            end
            Upvaluehelper.SetUpvalue(fn, value, unpack(path_list))
        end
    end
    if MOD_util.GetUpvalue_deekseek then
        MOD_util.GetUpvalue_deekseek = function(self, fn, path, depth, fn_filter_fn)
            local path_list = {}
            for path in path:gmatch("[^%.]+") do
                table.insert(path_list, path)
            end

            local prv, i, prv_var = nil, nil, "(起点)"
            for j,var in ipairs(path_list) do
                if type(fn) ~= "function" then
                    MOD_util:Warning("我们正在寻找 "..var..", 但在它之前的值 " ..prv_var.." 不是function (它是一个 "..type(fn) ..") 这是完整的链条: "..table.concat({"(起点)", unpack(path_list)}, "→"), 3)
                    return
                end

                prv_var = var
                local is_last = (j == #path_list)
                fn, i, prv = Upvaluehelper.FindUpvalue(fn, var, is_last and fn_filter_fn or nil)
            end
            return fn, i, prv
        end
    end
end

-- 控制优化
if KnownModIndex:IsModEnabledAny("workshop-3310943563") then
    local mmdx_MOD_util = Upvaluehelper.Getmoddata("workshop-3310943563", "ComponentPostInit", "playercontroller", "MOD_util")
    if mmdx_MOD_util then
        override_getupvalue_helper(mmdx_MOD_util)
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
        override_getupvalue_helper(mmdx_MOD_util)
    else
        MOD_util:Warning("未找到MOD_util")
    end
end

-- 通用
-- if rawget(_G, "MOD_util") then
--     override_getupvalue_helper(_G.MOD_util)
-- end