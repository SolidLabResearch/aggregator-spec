set -euo pipefail

rm -rf dist
mkdir dist
cp logo.png dist

python3 <<'PY'
import pathlib
import re
import zlib

template = pathlib.Path("spec.bs").read_text()
pattern = re.compile(r'<pre class="include"\s+path="([^"]+)"></pre>')

def replacement(match: re.Match[str]) -> str:
    rel_path = match.group(1)
    text = pathlib.Path(rel_path).read_text().strip()
    # Ensure surrounding blank lines to keep sections separated.
    return "\n" + text + "\n"

expanded = pattern.sub(replacement, template)

# PlantUML processing
def encode_plantuml(text):
    zlibbed = zlib.compress(text.encode('utf-8'))
    compressed = zlibbed[2:-4]
    return encode64(compressed)

def encode64(data):
    res = ""
    for i in range(0, len(data), 3):
        b1 = data[i]
        b2 = data[i+1] if i+1 < len(data) else 0
        b3 = data[i+2] if i+2 < len(data) else 0
        
        c1 = b1 >> 2
        c2 = ((b1 & 0x3) << 4) | (b2 >> 4)
        c3 = ((b2 & 0xF) << 2) | (b3 >> 6)
        c4 = b3 & 0x3F
        
        if i+1 >= len(data):
            c3 = 64
            c4 = 64
        elif i+2 >= len(data):
            c4 = 64
            
        res += encode6bit(c1) + encode6bit(c2) + encode6bit(c3) + encode6bit(c4)
    return res

def encode6bit(b):
    if b < 10: return chr(48 + b)
    b -= 10
    if b < 26: return chr(65 + b)
    b -= 26
    if b < 26: return chr(97 + b)
    b -= 26
    if b == 0: return '-'
    if b == 1: return '_'
    return '?'

plantuml_pattern = re.compile(r'<pre class="plantuml">\s*(@startuml.*?@enduml)\s*</pre>', re.DOTALL)

def plantuml_replacement(match: re.Match[str]) -> str:
    code = match.group(1)
    encoded = encode_plantuml(code)
    url = f"https://www.plantuml.com/plantuml/svg/{encoded}"
    return f'<img src="{url}" alt="PlantUML Diagram" no-autosize>'

expanded = plantuml_pattern.sub(plantuml_replacement, expanded)

pathlib.Path("dist/spec.bs").write_text(expanded)
PY
