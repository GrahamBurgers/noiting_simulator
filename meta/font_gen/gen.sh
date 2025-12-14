generate() {
	uv run main.py --data /home/nathan/Documents/code/noitadata/data \
		--font $1 \
		--root ../../ \
		--icons \
		../../data/ui_gfx/inventory/icon_damage_slice.png \
		../../data/ui_gfx/inventory/icon_damage_melee.png \
		../../data/ui_gfx/inventory/icon_damage_fire.png \
		../../data/ui_gfx/inventory/icon_damage_ice.png \
		../../data/ui_gfx/inventory/icon_damage_drill.png
}

generate font_pixel
generate font_pixel_noshadow
generate font_pixel_white
