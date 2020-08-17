# This is unnecessary in the next version. 

when defined(windows):
  import system/widestrs
  import terminal
  
  proc readConsoleW(
    hConsoleInput: FileHandle,
    lpBuffer: WideCString,
    nNumberOfCharsToRead: uint32,
    lpNumberOfCharsRead: ptr uint32,
    pInputControl: pointer
  ): bool {.stdcall, dynlib: "kernel32", importc: "ReadConsoleW".}
  
  proc consoleReadLine*(line: var string): bool =
    if stdin.isatty:
      const bufferSize = 256
      var buffer = newWideCString("", bufferSize + 1)
      var numberOfCharsRead: uint32
      result = readConsoleW(stdin.getOsFileHandle, buffer, bufferSize, numberOfCharsRead.addr, nil)
      if numberOfCharsRead > 1 and buffer[numberOfCharsRead - 2].int == 13:  #"\r\n" was read
        buffer[numberOfCharsRead - 2] = Utf16Char(0)
      elif numberOfCharsRead == bufferSize and buffer[bufferSize - 1].int == 13:  #'\r' was read, '\n' was left out
        buffer[bufferSize - 1] = Utf16Char(0)
        var numberOfCharsDiscarded: uint32
        discard readConsoleW(stdin.getOsFileHandle, newWideCString("", 1), 1, numberOfCharsDiscarded.addr, nil)
      else:  #"\r\n" was left out
        buffer[numberOfCharsRead] = Utf16Char(0)
      line = $buffer
    else:
      result = stdin.readLine(line)
  
  proc consoleReadLine*(): string =
    discard consoleReadLine(result)

else:
  proc consoleReadLine*(line: var string): bool =
    result = stdin.readLine(line)
  
  proc consoleReadLine*(): string =
    result = stdin.readLine