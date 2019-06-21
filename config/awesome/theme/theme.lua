---------------------------
-- Max's awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local local_path = gfs.get_configuration_dir().."theme/"

local theme = {}

theme.colorscheme = {
    base03 = "#1b1b1b",
    base02 = "#303030",
    base01 = "#474747",
    base00 = "#5e5e5e",
    base0 = "#919191",
    base1 = "#ababab",
    base2 = "#c6c6c6",
    base3 = "#e2e2e2",
    yellow = "#a68f01",
    orange = "#dd7202",
    red  = "#ff511a",
    magenta = "#fe3bb9",
    violet = "#cc62fe",
    blue = "#3294ff",
    cyan = "#07a38f",
    green = "#4ca340",
}

theme.font          = "FreeSans 11"

theme.bg_normal     = theme.colorscheme.base02
theme.bg_focus      = theme.colorscheme.base03
theme.bg_urgent     = theme.colorscheme.red
theme.bg_minimize   = theme.colorscheme.base02
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.colorscheme.base3
theme.fg_focus      = theme.colorscheme.blue
theme.fg_urgent     = theme.colorscheme.base3
theme.fg_minimize   = theme.colorscheme.base1

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(1)
theme.border_normal = theme.colorscheme.base03
theme.border_focus  = theme.colorscheme.base1
theme.border_marked = theme.colorscheme.base0

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = local_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = local_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = local_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = local_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = local_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = local_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = local_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = local_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = local_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = local_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = local_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = local_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = local_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = local_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = local_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = local_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = local_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = local_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = local_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = local_path.."titlebar/maximized_focus_active.png"

-- theme.wallpaper = local_path.."background.jpg"
theme.wallpaper = function(s)
    --if s == 1 then
        --return "/home/max/Pictures/Splits/Left/calm.jpg"
    --elseif s == 2 then
        --return "/home/max/Pictures/Splits/Right/calm.jpg"
    --end

    --return "/home/max/Pictures/Splits/Both/anemones.jpg"
    return local_path.."background.jpg"
end

-- You can use your own layout icons like this:
theme.layout_fairh = local_path.."layouts/fairhw.png"
theme.layout_fairv = local_path.."layouts/fairvw.png"
theme.layout_floating  = local_path.."layouts/floatingw.png"
theme.layout_magnifier = local_path.."layouts/magnifierw.png"
theme.layout_max = local_path.."layouts/maxw.png"
theme.layout_fullscreen = local_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = local_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = local_path.."layouts/tileleftw.png"
theme.layout_tile = local_path.."layouts/tilew.png"
theme.layout_tiletop = local_path.."layouts/tiletopw.png"
theme.layout_spiral  = local_path.."layouts/spiralw.png"
theme.layout_dwindle = local_path.."layouts/dwindlew.png"
theme.layout_cornernw = local_path.."layouts/cornernww.png"
theme.layout_cornerne = local_path.."layouts/cornernew.png"
theme.layout_cornersw = local_path.."layouts/cornersww.png"
theme.layout_cornerse = local_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
