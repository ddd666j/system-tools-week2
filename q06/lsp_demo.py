"""Minimal LSP client used to demonstrate definition, references, and rename."""

import json
import os
import subprocess
from pathlib import Path
from urllib.parse import quote, unquote, urlparse


ROOT = Path(__file__).resolve().parent


def uri(path: Path) -> str:
    return "file://" + quote(str(path.resolve()))


def send(proc, payload):
    raw = json.dumps(payload).encode("utf-8")
    proc.stdin.write(f"Content-Length: {len(raw)}\r\n\r\n".encode("ascii") + raw)
    proc.stdin.flush()


def receive(proc):
    headers = {}
    while True:
        line = proc.stdout.readline()
        if not line:
            raise RuntimeError("language server closed unexpectedly")
        if line == b"\r\n":
            break
        key, value = line.decode("ascii").split(":", 1)
        headers[key.lower()] = value.strip()
    return json.loads(proc.stdout.read(int(headers["content-length"])).decode("utf-8"))


def request(proc, request_id, method, params):
    send(proc, {"jsonrpc": "2.0", "id": request_id, "method": method, "params": params})
    while True:
        message = receive(proc)
        if message.get("id") == request_id:
            if "error" in message:
                raise RuntimeError(message["error"])
            return message.get("result")


def notify(proc, method, params):
    send(proc, {"jsonrpc": "2.0", "method": method, "params": params})


def path_from_uri(value):
    parsed = urlparse(value)
    return Path(unquote(parsed.path))


def normalized_changes(edit):
    changes = dict(edit.get("changes", {}))
    for item in edit.get("documentChanges", []):
        if "textDocument" in item:
            changes.setdefault(item["textDocument"]["uri"], []).extend(item.get("edits", []))
    return changes


def apply_workspace_edit(edit):
    changes = normalized_changes(edit)
    for file_uri, edits in changes.items():
        path = path_from_uri(file_uri)
        text = path.read_text(encoding="utf-8")
        lines = text.splitlines(keepends=True)

        def offset(position):
            return sum(len(line) for line in lines[: position["line"]]) + position["character"]

        normalized = [(offset(item["range"]["start"]), offset(item["range"]["end"]), item["newText"]) for item in edits]
        for start, end, new_text in sorted(normalized, reverse=True):
            text = text[:start] + new_text + text[end:]
        path.write_text(text, encoding="utf-8")


def main():
    pylsp = str(ROOT.parent / ".venv" / "bin" / "pylsp")
    if not os.path.exists(pylsp):
        pylsp = str(ROOT.parent.parent / ".venv" / "bin" / "pylsp")
    proc = subprocess.Popen([pylsp], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        init = request(proc, 1, "initialize", {"processId": os.getpid(), "rootUri": uri(ROOT), "capabilities": {}})
        notify(proc, "initialized", {})
        for name in ("math_utils.py", "app.py", "test_math_utils.py"):
            path = ROOT / name
            notify(proc, "textDocument/didOpen", {"textDocument": {"uri": uri(path), "languageId": "python", "version": 1, "text": path.read_text(encoding="utf-8")}})

        app_pos = {"line": 2, "character": 8}
        def_pos = {"line": 0, "character": 6}
        definition = request(proc, 2, "textDocument/definition", {"textDocument": {"uri": uri(ROOT / "app.py")}, "position": app_pos})
        references = request(proc, 3, "textDocument/references", {"textDocument": {"uri": uri(ROOT / "math_utils.py")}, "position": def_pos, "context": {"includeDeclaration": True}})
        rename = request(proc, 4, "textDocument/rename", {"textDocument": {"uri": uri(ROOT / "math_utils.py")}, "position": def_pos, "newName": "calculate_total"})

        print("LSP server: python-lsp-server")
        print("Capability definitionProvider:", init["capabilities"].get("definitionProvider"))
        print("Go to definition:", definition)
        print("Find references count:", len(references or []))
        for ref in references or []:
            print("  reference:", Path(path_from_uri(ref["uri"])).name, ref["range"]["start"])
        print("Rename symbol: total_price -> calculate_total")
        change_map = normalized_changes(rename)
        print("Rename files:", ", ".join(sorted(Path(path_from_uri(k)).name for k in change_map)))
        print("Rename edit count:", sum(len(items) for items in change_map.values()))
        apply_workspace_edit(rename)
        print("Semantic rename applied successfully")
        request(proc, 5, "shutdown", None)
        notify(proc, "exit", None)
    finally:
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()


if __name__ == "__main__":
    main()
