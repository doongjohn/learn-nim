import std/[
  typetraits,
  strutils,
  strformat,
  math,
  sugar,
  terminal
]


proc consoleFillHorizontal*(fillWith = '-') =
  stdout.write (fillWith.repeat max(0, terminalWidth() - 1)) & '\n'


proc consoleFillHorizontal*(fillWith: string, cutoff = true) =
  let width = terminalWidth() - 1
  if cutoff:
    let repeated = fillWith.repeat max(0, (width / fillWith.len).ceil().int)
    stdout.write repeated[0 ..< width] & '\n'
  else:
    stdout.write (fillWith.repeat max(0, (width / fillWith.len)).int) & '\n'


proc consoleReadLineParse*[T](parseFn: (string) -> T): T =
  var input: string
  while true:
    try:
      input = stdin.readLine()
      return input.parseFn()
    except:
      echo &"Can not parse \"{input}\" to type: \"{$T}\""


proc consoleReadLineParse*[T](prompt: string, parseFn: (string) -> T): T =
  var input: string
  while true:
    try:
      stdout.write prompt
      input = stdin.readLine()
      return input.parseFn()
    except:
      echo &"Can not parse \"{input}\" to type: \"{$T}\""
