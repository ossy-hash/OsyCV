from PIL import Image, ImageDraw, ImageFont
import os, math

SIZE = 1024
OUT = "D:\\IT\\Flutter\\cv_maker\\assets\\app_icon.png"

img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Background: rounded rect with primary blue
bg_color = (33, 150, 243)
r = SIZE // 5
draw.rounded_rectangle([0, 0, SIZE, SIZE], radius=r, fill=bg_color)

# White document shape
pad = SIZE * 0.22
doc_left = SIZE * 0.3
doc_top = SIZE * 0.25
doc_w = SIZE * 0.4
doc_h = SIZE * 0.5
dw = int(doc_w)
dh = int(doc_h)
dx = int(doc_left)
dy = int(doc_top)

draw.rounded_rectangle([dx, dy, dx + dw, dy + dh], radius=int(SIZE*0.04), fill=(255,255,255))

# Document lines (text lines)
line_color = (200, 200, 200)
line_margin = int(SIZE * 0.08)
line_spacing = int(SIZE * 0.055)
line_y = dy + int(SIZE * 0.12)
line_w = dw - 2 * line_margin
for i in range(4):
    ly = line_y + i * (line_spacing + int(SIZE * 0.02))
    lw = line_w if i != 2 else int(line_w * 0.85)
    draw.rounded_rectangle([dx + line_margin, ly, dx + line_margin + int(lw), ly + int(SIZE*0.015)], radius=int(SIZE*0.01), fill=line_color)

# Checkmark circle
circle_center = (SIZE - int(SIZE*0.22), SIZE - int(SIZE*0.18))
circle_r = int(SIZE * 0.08)
draw.ellipse([circle_center[0]-circle_r, circle_center[1]-circle_r,
              circle_center[0]+circle_r, circle_center[1]+circle_r], fill=(76, 175, 80))

# Checkmark
cm = int(SIZE * 0.035)
cx, cy = circle_center
draw.line([(cx-cm, cy), (cx-cm+cm//2, cy+cm)], fill=(255,255,255), width=int(SIZE*0.015))
draw.line([(cx-cm+cm//2, cy+cm), (cx+cm, cy-cm)], fill=(255,255,255), width=int(SIZE*0.015))

os.makedirs(os.path.dirname(OUT), exist_ok=True)
img.save(OUT)
print(f"Saved {OUT}")
