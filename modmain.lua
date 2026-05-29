GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})
_G = GLOBAL

if not rawget(_G, "Chinese_Pro") then return end -- 必须加载Chinese++ Pro模组才能运行

Upvaluehelper = _G.Chinese_Pro.env.Upvaluehelper
MOD_util = _G.Chinese_Pro.env.MOD_util

modimport("ban_print.lua") -- 关掉萌萌的新print的垃圾消息(你是话痨吗)
modimport("hook_mmdx.lua") -- HOOK 萌萌的新的模组
modimport("hook_lazy_controls.lua") -- HOOK lazy_controls 模组