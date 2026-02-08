# Cyberpunk Samurai Tab Bar for Kitty
# 侍 サイバーパンク端末

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

# Catppuccin Macchiato
MAUVE = as_rgb(color_as_int((198, 160, 246)))
PINK = as_rgb(color_as_int((245, 189, 230)))
BASE = as_rgb(color_as_int((36, 39, 58)))
MANTLE = as_rgb(color_as_int((30, 32, 48)))
CRUST = as_rgb(color_as_int((24, 25, 38)))
SURFACE0 = as_rgb(color_as_int((54, 58, 79)))
TEXT = as_rgb(color_as_int((202, 211, 245)))
SUBTEXT0 = as_rgb(color_as_int((165, 173, 203)))
OVERLAY0 = as_rgb(color_as_int((110, 115, 141)))
RED = as_rgb(color_as_int((237, 135, 150)))
SKY = as_rgb(color_as_int((145, 215, 227)))

LEFT_SEP = ""
RIGHT_SEP = ""
ICON_ACTIVE = "◈"
ICON_INACTIVE = "◇"

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)

    is_active = extra_data.for_layout.active_tab_idx == index - 1

    if is_active:
        fg = TEXT
        bg = SURFACE0
        icon = ICON_ACTIVE
        accent = MAUVE
    else:
        fg = OVERLAY0
        bg = MANTLE
        icon = ICON_INACTIVE
        accent = OVERLAY0

    # Left separator
    screen.cursor.fg = bg
    screen.cursor.bg = CRUST
    screen.draw(LEFT_SEP)

    # Tab content
    screen.cursor.fg = accent
    screen.cursor.bg = bg
    screen.draw(f" {icon} ")

    screen.cursor.fg = fg
    title = tab.title[:22] if len(tab.title) > 22 else tab.title
    screen.draw(f"{title} ")

    # Right separator
    screen.cursor.fg = bg
    screen.cursor.bg = CRUST
    screen.draw(RIGHT_SEP)

    # Space between tabs
    screen.cursor.fg = 0
    screen.cursor.bg = CRUST
    screen.draw(" ")

    return screen.cursor.x
