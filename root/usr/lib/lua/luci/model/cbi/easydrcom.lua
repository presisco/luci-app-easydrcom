--[[
Author:superlc
Modifier:presisco
]]--
require("luci.sys")

m = Map("easydrcom", translate("EasyDrcom"), translate("Configure EasyDrcom client."))

local a=require"luci.model.network"
s = m:section(TypedSection, "easydrcom", translate("Settings"))
s.anonymous = true

s:tab("basic",  translate("Basic Settings"))
s:tab("advanced", translate("Advanced Settings"))
s:tab("log",translate("Log Settings"))
s:tab("realtime", translate("Realtime"))

enable = s:taboption("basic",Flag, "enable", translate("Enable"))
enable.rmempty = false

username=s:taboption("basic",Value, "uid", translate("username"))
username.default="11111111"
pass = s:taboption("basic",Value, "pwd", translate("password"))
pass.default="00000000"
pass.password = true

mode = s:taboption("basic",ListValue, "mode", translate("Mode"))
mode:value("0",translate("0:802.1x+UDP"))
mode:value("1",translate("1:UDP only"))
mode:value("2",translate("2:802.1x+UDP(Recommended)"))
mode.default = "2"

local wanif = luci.util.exec("uci get network.wan.ifname")
if (wanif == "")
then
	wanif = luci.util.exec("uci get network.WAN.ifname")
end
if (wanif == "")
then
	wanif = "please use custom interface"
end
s:taboption("basic",Value, "nic", translate("Auto detected wan inteface:"))
s.default=wanif

usecustomif=s:taboption("advanced",Flag, "usecustomif", translate("Use custom wan interface"))
usecustomif.rmempty=false;

ifnames = s:taboption("advanced",ListValue, "customif", translate("Extra Interfaces"))
local netinfo=luci.util.execi("uci show network | grep \"\\.ifname='*'\"")
for raw in netinfo do
	i,j=string.find(raw,"'+.+'")
	ifnames:value(string.sub(raw,i+1,j-1))
end

ifnames:depends("usecustomif", "1")

usedelay=s:taboption("advanced",Flag, "usedelay", translate("Delay EasyDrcom if cant find interface"))
usedelay.rmempty=false;

delay=s:taboption("advanced",Value,"startupdelay",translate("Delays in seconds"));
delay.default=0
delay:depends("usedelay","1")

ezlogpath=s:taboption("log",Value,"ezlogpath",translate("Path for log file"));
ezlogpath.default="/tmp/easydrcom.log"
ezlogsize=s:taboption("log",Value,"ezlogsize",translate("Max Size for EasyDrcom log(KB)"));
ezlogsize.default="16"

dlogpath=s:taboption("log",Value,"dlogpath",translate("Path for daemon log file"));
dlogpath.default="/tmp/easydrcom-daemon.log"
dlogsize=s:taboption("log",Value,"dlogsize",translate("Max Size for Daemon log(KB)"));
dlogsize.default="4"

usedaemon=s:taboption("advanced",Flag,"usedaemon",translate("Use EasyDrcom Daemon"));
usedaemon.default=1
usedaemon.rmempty=false;

dinterval=s:taboption("advanced",Value,"dinterval",translate("EasyDrcom Daemon check interval"));
dinterval.default="60"
dinterval:depends("usedaemon","1")

ip=s:taboption("advanced",Value, "ip", translate("authentication's IP"))
ip.default="172.25.8.4"
port=s:taboption("advanced",Value, "port", translate("authentication's port"))
port.default="61440"

usebroadcast=s:taboption("advanced",Flag, "usebroadcast", translate("MAC BROADCAST"))
usebroadcast.rmempty = true
autoonline=s:taboption("advanced",Flag, "autoonline", translate("Auto Online"))
autoonline.rmempty = true
autoredial=s:taboption("advanced",Flag, "autoredial", translate("Auto Redial"))
autoredial.rmempty = true

mac=s:taboption("advanced",Value, "mac", translate("authentication's MAC address"))
mac.default="00:1a:a9:c3:3a:59"

eaptimeout=s:taboption("advanced",Value, "eaptimeout", translate("Packet timeout (ms)"))
eaptimeout.default="1000"
udptimeout=s:taboption("advanced",Value, "udptimeout", translate("UDP Packet timeout (ms)"))
udptimeout.default="2000"
hostname=s:taboption("advanced",Value, "hostname", "HostName")
hostname.default="EasyDrcom"
kernelversion=s:taboption("advanced",Value, "kernelversion" ,"KernelVersion")
kernelversion.default="0.9"

logtext = s:taboption("realtime", TextValue, "logtext",
	translate("last 40 lines of EasyDrcom logs"))
		
--logtext.template = "cbi/tvalue"
--logtext.rows = 20

function logtext.cfgvalue(self, section)
	path=luci.util.exec("uci get easydrcom.@easydrcom[0].ezlogpath")
	return luci.util.exec("tail -n 40 "..path)
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
	luci.util.exec("/etc/init.d/easydrcom-conf reload >/dev/null 2>&1 &")
end

return m
