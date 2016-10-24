--[[
Author:superlc
Modifier:presisco
]]--

module("luci.controller.easydrcom", package.seeall)

function index()
	local page
	page=entry({"admin", "services", "easydrcom"}, cbi("easydrcom"), _("EasyDrcom"))
	page.dependent = true
end