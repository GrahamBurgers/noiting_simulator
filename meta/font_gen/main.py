from PIL import Image
from pathlib import Path
import os
import xml.etree.ElementTree as ET
from dataclasses import dataclass
import numpy as np


@dataclass
class Char:
    rect_w: int
    width: float
    x: int


@dataclass
class Colour:
    r: int
    g: int
    b: int


def main():
    data_dir = Path(input("Noita data dir: "))
    font_name = input("Font name: ")
    out_dir = Path(input("Mod root dir: "))
    font_dir = data_dir / "fonts"
    font_path = font_dir / (font_name + ".xml")
    tree = ET.parse(font_path).getroot()
    texture = tree.find("Texture")
    assert texture is not None
    text = texture.text
    assert text is not None
    text = text.strip()
    font = data_dir / text[len("data/") :]
    coloured_img = Image.open(font)
    coloured_arr = np.array(coloured_img)
    arr = np.array(coloured_img.convert("LA"))

    max_height = 0
    chars: dict[int, Char] = {}
    ascii_width = 0

    for char in tree.findall("QuadChar"):
        id, rect_w, width, x = (
            int(char.attrib["id"]),
            int(char.attrib["rect_w"]),
            float(char.attrib["width"]),
            int(char.attrib["rect_x"]),
        )

        if id < 128:
            chars[id] = Char(rect_w=rect_w, width=width, x=x)
            ascii_width += rect_w

    PUA_START = 0xE000
    COLOURS = [
        Colour(r=225, g=207, b=122),
        Colour(r=238, g=165, b=240),
        Colour(r=165, g=190, b=240),
        Colour(r=120, g=217, b=145),
        Colour(r=208, g=212, b=208),
    ]

    x = arr.shape[1]

    painted = [coloured_arr]
    for k, colour in enumerate(COLOURS):
        start_x = x
        new = np.ndarray((arr.shape[0], ascii_width, 2), dtype=np.uint8)
        for id, char in chars.items():
            new[:, x - start_x : x - start_x + char.rect_w, :] = arr[
                :, char.x : char.x + char.rect_w, :
            ]
            tree.append(
                ET.Element(
                    "QuadChar",
                    {
                        "id": str(id + PUA_START + ascii_width * k),
                        "offset_x": "0",
                        "offset_y": "0",
                        "rect_x": str(x),
                        "rect_y": "0",
                        "rect_w": str(char.rect_w),
                        "rect_h": str(arr.shape[0]),
                    },
                )
            )
            x = x + char.rect_w
        L = new[:, :, 0].astype(np.float32) / 255.0
        A = new[:, :, 1]
        colour_vec = np.array([colour.r, colour.g, colour.b], dtype=np.float32)
        rgb = (L[..., None] * colour_vec).astype(np.uint8)
        rgba = np.dstack([rgb, A])
        painted.append(rgba)
    combined = np.concatenate(painted, axis=1)
    img = Image.fromarray(combined)
    img.save(str(out_dir / text))

    ET.indent(tree, space="\t", level=0)

    xml_str = ET.tostring(
        tree,
        encoding="unicode",
        xml_declaration=False,
    )
    open(out_dir / "data" / "fonts" / (font_name + ".xml"), "w").write(xml_str)


if __name__ == "__main__":
    main()
