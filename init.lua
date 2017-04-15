local upower   = require("lgi").require("UPowerGlib")
local wibox    = require("wibox")
local string   = { format = string.format }
local math     = { floor = math.floor }

module("awesome-upower-battery")

local upower_status = {
	[upower.DeviceState.PENDING_DISCHARGE] = "Discharging",
	[upower.DeviceState.PENDING_CHARGE]    = "Charging",
	[upower.DeviceState.FULLY_CHARGED]     = "Full",
	[upower.DeviceState.EMPTY]             = "N/A",
	[upower.DeviceState.DISCHARGING]       = "Discharging",
	[upower.DeviceState.CHARGING]          = "Charging",
	[upower.DeviceState.UNKNOWN]           = "N/A"
}

local upower_kind = {
	[upower.DeviceKind.UNKNOWN]            = "N/A",
	[upower.DeviceKind.LINE_POWER]         = 1,
	[upower.DeviceKind.TABLET]             = "N/A",
	[upower.DeviceKind.COMPUTER]           = "N/A",
	[upower.DeviceKind.LAST]               = "N/A",
	[upower.DeviceKind.BATTERY]            = 0,
	[upower.DeviceKind.UPS]                = "N/A",
	[upower.DeviceKind.MONITOR]            = "N/A",
	[upower.DeviceKind.MOUSE]              = "N/A",
	[upower.DeviceKind.KEYBOARD]           = "N/A",
	[upower.DeviceKind.PDA]                = "N/A",
	[upower.DeviceKind.PHONE]              = "N/A",
	[upower.DeviceKind.MEDIA_PLAYER]       = "N/A"
}

local display_device

local function factory(args)
	local bat 	= { widget = wibox.widget.textbox() }
	local args 	= args or {}
	local settings 	= args.settings or function() end

	function bat.update(device)
		bat_now = {}
		bat_now.status = upower_status[device.state]
		bat_now.ac_status = upower_kind[device.kind]
		bat_now.perc = 0 + device.percentage
		bat_now.watt = device.energy_full_design
		if bat_now.status == "Charging" then
			bat_now.time = toClock(device.time_to_full)
		elseif bat_now.status == "Discharging" then
			bat_now.time = toClock(device.time_to_empty)
		else
			bat_now.time = "N/A"
		end
		widget = bat.widget
		settings(bat_now, widget)
	end

	display_device = upower.Client():get_display_device()
	bat.update(display_device)
	display_device.on_notify = bat.update

	return bat
end

function toClock(seconds)
	if seconds <= 0 then
		return "00:00:00";
	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end

return factory
