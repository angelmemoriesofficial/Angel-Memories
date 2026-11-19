from pathlib import Path
from PIL import Image

ROOT = Path("android/app/src/main/res")
SOURCE = Path("apk icon.png")
if not SOURCE.is_file():
    raise SystemExit("Missing official app icon: apk icon.png")

# Android legacy launcher sizes for all standard density buckets.
sizes = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
source = Image.open(SOURCE).convert("RGBA")
for density, size in sizes.items():
    folder = ROOT / f"mipmap-{density}"
    folder.mkdir(parents=True, exist_ok=True)
    icon = source.resize((size, size), Image.Resampling.LANCZOS)
    icon.save(folder / "ic_launcher.png", optimize=True)
    icon.save(folder / "ic_launcher_round.png", optimize=True)

# Adaptive icon foreground keeps the artwork inside the Android safe zone.
adaptive_sizes = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}
for density, size in adaptive_sizes.items():
    folder = ROOT / f"mipmap-{density}"
    canvas = Image.new("RGBA", (size, size), (6, 21, 53, 255))
    art = source.copy()
    art.thumbnail((int(size * 0.78), int(size * 0.78)), Image.Resampling.LANCZOS)
    canvas.alpha_composite(art, ((size - art.width) // 2, (size - art.height) // 2))
    canvas.save(folder / "ic_launcher_foreground.png", optimize=True)

(ROOT / "values").mkdir(parents=True, exist_ok=True)
(ROOT / "values" / "ic_launcher_background.xml").write_text(
    '<resources><color name="ic_launcher_background">#061535</color></resources>\n',
    encoding="utf-8"
)
(ROOT / "mipmap-anydpi-v26").mkdir(parents=True, exist_ok=True)
adaptive = '''<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
'''
for name in ("ic_launcher.xml", "ic_launcher_round.xml"):
    (ROOT / "mipmap-anydpi-v26" / name).write_text(adaptive, encoding="utf-8")
print("Generated Angel Memories launcher icons for all Android densities.")
