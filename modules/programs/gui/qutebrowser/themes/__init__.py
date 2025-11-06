import importlib
import os

_current_dir = os.path.dirname(__file__)

for item in os.listdir(_current_dir):
    item_path = os.path.join(_current_dir, item)
    if os.path.isdir(item_path) and os.path.exists(
        os.path.join(item_path, "__init__.py")
    ):
        globals()[item] = importlib.import_module(f".{item}", package=__name__)

del os, importlib, item, item_path, _current_dir
