--[[
Author:superlc
Modifier:presisco
]]--

m = Map("easydrcom", translate("EasyDrcom"), translate("Configure EasyDrcom client."))

s = m:section(TypedSection, "easydrcom", translate("Settings"))
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("Enable"))
enable.default = "0"


s:option(Flag, "boot", translate("Start at boot")).default="0"

s:option(Flag, "autoonline", translate("Auto Online")).default="1"
s:option(Flag, "autoredial", translate("Auto Redial")).default="1"

--[[
autoredial = s:option(ListValue, "autoredial", translate("Auto Redial"))
autoredial:value("0",translate("0(no)"))
autoredial:value("1",translate("1(yes)"))
autoredial.default = "1"
]]--

s:option(Value, "UserName", translate("username"))
pass = s:option(Value, "PassWord", translate("password"))
pass.password = true

mode = s:option(ListValue, "mode", translate("Mode"))
mode:value("0",translate("0(dormitory area1)"))
mode:value("1",translate("1(office area)"))
mode:value("2",translate("2(dormitory area2)"))
mode.default = "2"

s:option(Value, "ip", translate("authentication's IP")).default="172.25.8.4"
s:option(Value, "port", translate("authentication's port")).default="61440"

s:option(Flag, "usebroadcast", translate("MAC BROADCAST")).default="1"

--[[
broadcast = s:option(ListValue, "usebroadcast", translate("MAC BROADCAST"))
broadcast:value("0",translate("0(no)"))
broadcast:value("1",translate("1(yes)"))
broadcast.default = "1"
]]--

s:option(Value, "mac", translate("authentication's MAC address")).default="00:1a:a9:c3:3a:59"

ifname = s:option(ListValue, "nic", translate("Interfaces"))
for k, v in ipairs(luci.sys.net.devices()) do
	if v ~= "lo" then
		ifname:value(v)
	end
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/easydrcom-test restart")
end

s:option(Value, "eaptimeout", translate("Packet timeout (ms)")).default="1000"
s:option(Value, "udptimeout", translate("UDP Packet timeout (ms)")).default="2000"
s:option(Value, "hostname", "HostName").default="EasyDrcom"
s:option(Value, "kernelversion" ,"KernelVersion").default="0.9"

return m
