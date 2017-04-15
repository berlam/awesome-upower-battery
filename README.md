awesome-upower-battery
======================

A widget to display the current battery and power supply status in [awesome wm](https://github.com/awesomeWM/awesome)
using upower, which is used by most desktop environments. This is very efficient as it uses dbus signals from upower instead of polling.
The configuration is similiar to the well-known [lain widgets](https://github.com/copycat-killer/lain/wiki/bat) and can be used as a
drop-in replacement (in most cases) for the lain battery widget. Works flawless with multiple batteries.

## Requirements ##
[AwesomeWM-4.0](https://awesomewm.org) with dbus support enabled

[upower-0.99](https://upower.freedesktop.org/)

[UPowerGlib-1.0](https://lazka.github.io/pgi-docs/UPowerGlib-1.0/index.html)

## Installation ##

Clone the repo into your `$XDG_CONFIG_HOME/awesome` directory and add the
dependency to your `rc.lua`.

```Shell
cd "$XDG_CONFIG_HOME/awesome"
git clone https://github.com/berlam/awesome-upower-battery.git awesome-upower-battery
```

```Lua
local battery = require("awesome-upower-battery")
```

## Configuration ##

You can customize the apperance inside your `rc.lua`. This widgets exposes some fields.

`settings` can use the `bat_now` table, which contains the following strings:

- `status`, battery status ("N/A", "Discharging", "Charging", "Full");
- `ac_status`, AC-plug flag (0 if cable is unplugged, 1 if plugged, "N/A" otherwise);
- `perc`, total charge percentage (integer between 0 and 100 or "N/A");
- `time`, time remaining until charge if charging, until discharge if discharging (HH:SS string or "N/A");
- `watt`, battery watts.

Configure the widget with the settings property.

```Lua
local bat = battery(
        {
                settings = function(bat_now, widget)
                        if bat_now.status == "Discharging" then
                                        widget:set_markup(string.format("%3d", bat_now.perc) .. "% ")
                                        return
                        end
                        -- We must be on AC
                        baticon:set_image(beautiful.ac)
                        widget:set_markup(bat_now.time .. " ")
                end
        }
)
```

Add the `bat.widget` to your wibar.

## Credits ##

This plugin was created by [Matthias Berla](https://github.com/berlam).

## License ##

See [LICENSE](LICENSE).
