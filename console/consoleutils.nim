import std/sugar
import std/math
import std/strutils
import std/strformat
import std/terminal


proc writeHorizontalFill*(fillWith: char = '-') =
  stdout.write (fillWith.repeat max(0, terminalWidth() - 1)) & '\n'


proc writeHorizontalFill*(fillWith: string, cutoff: bool = true) =
  let width = terminalWidth() - 1
  if cutoff:
    let repeated = fillWith.repeat max(0, (width / fillWith.len).ceil().int)
    stdout.write repeated[0 ..< width] & '\n'
  else:
    stdout.write (fillWith.repeat max(0, (width / fillWith.len)).int) & '\n'


proc consoleReadLineParse*[T](parseProc: (string) -> T): T =
  var input: string
  while true:
    try:
      input = stdin.readLine()
      return input.parseProc()
    except:
      echo &"Can't parse \"{input}\" to type: \"{$T}\""


proc consoleReadLineParse*[T](parseProc: (string) -> T, prompt: string): T =
  var input: string
  while true:
    try:
      stdout.write prompt
      input = stdin.readLine()
      return input.parseProc()
    except:
      echo &"Can't parse \"{input}\" to type: \"{$T}\""


proc consoleReadLineParse*[T](parseProc: (string) -> T, prompt: string, errorMsg: (input: string) -> string): T =
  var input: string
  while true:
    try:
      stdout.write prompt
      input = stdin.readLine()
      return input.parseProc()
    except:
      echo errorMsg(input)
