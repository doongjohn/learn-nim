import macros
import strutils


# proc expectKind(n: NimNode, k: openArray[NimNodeKind]) {.compileTime.} =
#   if not k.contains(n.kind):
#     error("Expected a node of kind " & $k & ", got " & $n.kind, n)

# proc expectNotKind(n: NimNode, k: NimNodeKind) {.compileTime.} =
#   if n.kind == k:
#     error("Expected a node not of kind " & $k & ", got " & $n.kind, n)

template containsKind(n: NimNode, k: openArray[NimNodeKind]): bool =
  k.contains(n.kind)

macro nameofAux(x: untyped): string =
  if x.kind notin {nnkIdent, nnkDotExpr, nnkBracketExpr}:
    let msg = "'" & x.repr & "' is not valid for nameof"
    quote do: {.error: `msg`.}
  else:
    if x.len < 2: return x.toStrLit
    if x.containsKind([nnkDotExpr]):
      for i in 1 .. x.len:
        if x[^i].kind == nnkDotExpr:
          return x[^(i-1)].toStrLit
    elif x.containsKind([nnkBracketExpr]):
      return x[0].toStrLit
    return x.last.toStrLit

template nameof*(x: untyped): string =
  when compiles(x):
    nameofAux(x)
  else:
    {.error: "'" & x.repr & "' is not defined" .}


proc toArray*[S: static string](): array[S.len, char] =
  for i, c in S:
    result[i] = c

# This does not work!
# proc toArray*(str: static string): array[str.len, char] =
#   for i, c in str:
#     result[i] = c