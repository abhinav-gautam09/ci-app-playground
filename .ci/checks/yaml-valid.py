import sys
from pathlib import Path

import yaml

broken = []
for path in sorted(Path("apps").rglob("*.yaml")):
    try:
        list(yaml.safe_load_all(path.read_text()))
    except yaml.YAMLError as err:
        broken.append(f"FAIL {path}: {err}")

print("\n".join(broken) or "OK all YAML files parse")
sys.exit(1 if broken else 0)
