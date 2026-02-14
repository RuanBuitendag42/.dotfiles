#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  侍  FETCH-WALLPAPERS.SH  ·  壁紙収集  ·  WALLPAPER FETCHER
#  Download curated wallpapers for the 未来侍 (Futuristic Samurai) setup
#  Source: D3Ext/aesthetic-wallpapers (curated Japanese/samurai selection)
# ═══════════════════════════════════════════════════════════════
# Usage: fetch-wallpapers.sh          # fetch curated 未来侍 wallpapers
#        fetch-wallpapers.sh --list   # show available wallpapers
#        fetch-wallpapers.sh --clean  # remove cached downloads

set -e

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
BASE_URL="https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images"

# ─── Curated wallpapers matching the 未来侍 aesthetic ─────────
# Japanese themes: samurai, torii, sakura, temples, ukiyo-e
# Dark/purple palette: Catppuccin Macchiato compatible tones
# Futuristic: mecha, neon cities, cyberpunk-adjacent dark scenes
WALLPAPERS=(
	# === Japanese / Samurai ===
	"japan.png"
	"japan2.jpg"
	"japan3.jpg"
	"japan-purple-blur.png"
	"japan_anime_city.jpg"
	"japan_torii.png"
	"japanese-house.png"
	"katana.jpg"
	"pink-katana.png"
	"manga-samurai.png"
	"manga.png"
	"rad_samurai.jpg"
	"neosamurai.webp"
	"shougan_castle.png"
	"wano_vector.png"
	"kiryu_black.png"
	"berserkdrac.png"
	"knight.png"
	"chinese.png"
	"towashi.jpg"

	# === Ukiyo-e / Traditional Art ===
	"ink_wave.png"
	"trad-waves.webp"
	"pixelart_pagoda.jpg"
	"pastel-japanese-temple.png"
	"flower_tokyo.png"
	"yellow_kyoto.jpg"
	"sushi_dark.png"

	# === Tokyo / Neon Cities ===
	"neocity.png"
	"neocity2.jpg"
	"neon-lights.jpg"
	"neon-shacks-nord.png"
	"TokyoSimplistic.jpg"
	"anime_cafe_tokyonight.png"
	"anime_skyline.png"
	"nord-shanghai.png"
	"nord-street.png"
	"nord_dark_city.png"
	"skyline.png"
	"pastel-city.png"

	# === Dark / Purple / Macchiato ===
	"catpuccin_landscape.png"
	"catpuccin_samurai.png"
	"catpuccin_w.png"
	"purple-crystal.png"
	"purple_plane_landscape.png"
	"purple-bomb.png"
	"purple-girl.png"
	"shiny_purple.png"
	"nord_purple_waves.png"
	"mushroom-purple.png"
	"a_gas_station_with_purple_lights.jpg"
	"got_red.jpg"

	# === Mecha / Futuristic ===
	"mecha-nostalgia.png"
	"pink-mecha.png"
	"cyberpunk_car.png"
	"blue_demon.png"
	"demon.jpg"
	"dark_skulls.png"
	"pixiv_73483903.png"
	"tropic_island_morning.jpg"
)

mkdir -p "$WALLPAPER_DIR"

# ─── List mode ────────────────────────────────────────────────
if [ "$1" = "--list" ]; then
	echo "壁紙 Curated 未来侍 wallpaper collection (${#WALLPAPERS[@]} images):"
	echo ""
	for w in "${WALLPAPERS[@]}"; do
		if [ -f "$WALLPAPER_DIR/$w" ]; then
			echo "  ✓ $w"
		else
			echo "  ○ $w"
		fi
	done
	echo ""
	local_count=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | wc -l)
	echo "壁紙 Local: $local_count / ${#WALLPAPERS[@]} installed"
	exit 0
fi

# ─── Clean mode ───────────────────────────────────────────────
if [ "$1" = "--clean" ]; then
	echo "壁紙 Cleaning wallpaper history cache..."
	rm -f "$HOME/.cache/wallpaper_history"
	echo "壁紙 Done."
	exit 0
fi

# ─── Download wallpapers ─────────────────────────────────────
count=0
skipped=0

echo "壁紙 Fetching 未来侍 wallpapers from D3Ext/aesthetic-wallpapers..."
echo ""

for w in "${WALLPAPERS[@]}"; do
	if [ -f "$WALLPAPER_DIR/$w" ]; then
		skipped=$((skipped + 1))
	else
		if curl -sL -f -o "$WALLPAPER_DIR/$w" "$BASE_URL/$w"; then
			echo "  侍 Downloaded: $w"
			count=$((count + 1))
		else
			echo "  ✗ Failed: $w"
			rm -f "$WALLPAPER_DIR/$w"
		fi
	fi
done

echo ""
echo "壁紙 Downloaded $count new wallpapers ($skipped already existed)"
echo "壁紙 Total wallpapers: $(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | wc -l)"
echo ""
echo "─── 侍 Tips ──────────────────────────────────────────────"
echo "  • Recolor any wallpaper to Macchiato palette:"
echo "    https://farbenfroh.io/faerber"
echo "  • Cycle wallpapers:  wallpaper.sh"
echo "  • Auto-rotate:       wallpaper.sh --loop"
echo "  • Set specific:      wallpaper.sh /path/to/image.png"
echo "  • List collection:   fetch-wallpapers.sh --list"
