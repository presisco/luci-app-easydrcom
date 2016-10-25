--[[
Author:superlc
Modifier:presisco
]]--
require("luci.sys")

m = Map("easydrcom", translate("EasyDrcom"), translate("Configure EasyDrcom client."))

local a=require"luci.model.network"
s = m:section(TypedSection, "easydrcom", translate("Settings"))
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("Enable"))
enable.rmempty = false

s:option(Value, "username", translate("username"))
pass = s:option(Value, "password", translate("password"))
pass.password = true

mode = s:option(ListValue, "mode", translate("Mode"))
mode:value("0",translate("0(dormitory area1)"))
mode:value("1",translate("1(office area)"))
mode:value("2",translate("2(dormitory area2)"))
mode.default = "2"

local wanif = luci.util.exec("uci get network.wan.ifname")
s:option(Value, "nic", translate("Auto detected wan inteface:"))
s.default=wanif;

more=s:option(Flag, "more", translate("More Options"),translate("Options for advanced users"))
more.rmempty=false;

usecustomif=s:option(Flag, "usecustomif", translate("Use custom wan interface"),translate("if default has problems"))
usecustomif.rmempty=false;
usecustomif:depends("more", "1")

ifnames = s:option(ListValue, "customif", translate("Extra Interfaces"))
local netinfo=luci.util.execi("uci show network | grep \"\\.ifname='*'\"")
for raw in netinfo do
	i,j=string.find(raw,"'+.+'")
	ifnames:value(string.sub(raw,i+1,j-1))
end

ifnames:depends("usecustomif", "1")

ip=s:option(Value, "ip", translate("authentication's IP"))
ip.default="172.25.8.4"
ip:depends("more", "1")
port=s:option(Value, "port", translate("authentication's port"))
port.default="61440"
port:depends("more", "1")

usebroadcast=s:option(Flag, "usebroadcast", translate("MAC BROADCAST"))
usebroadcast.rmempty = true
usebroadcast:depends("more", "1")
autoonline=s:option(Flag, "autoonline", translate("Auto Online"))
autoonline.rmempty = true
autoonline:depends("more", "1")
autoredial=s:option(Flag, "autoredial", translate("Auto Redial"))
autoredial.rmempty = true
autoredial:depends("more", "1")

mac=s:option(Value, "mac", translate("authentication's MAC address"))
mac.default="00:1a:a9:c3:3a:59"
mac:depends("more", "1")

eaptimeout=s:option(Value, "eaptimeout", translate("Packet timeout (ms)"))
eaptimeout.default="1000"
eaptimeout:depends("more", "1")
udptimeout=s:option(Value, "udptimeout", translate("UDP Packet timeout (ms)"))
udptimeout.default="2000"
udptimeout:depends("more", "1")
hostname=s:option(Value, "hostname", "HostName")
hostname.default="EasyDrcom"
hostname:depends("more", "1")
kernelversion=s:option(Value, "kernelversion" ,"KernelVersion")
kernelversion.default="0.9"
kernelversion:depends("more", "1")

local apply = luci.http.formvalue("cbi.apply")
if apply then
	luci.sys.call("/etc/init.d/easydrcom-conf reload >/dev/null")
end

return m
