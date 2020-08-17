import std/times
import std/strutils
import std/strformat

var startTime = cpuTime()

proc timeCodeStart*() =
  startTime = cpuTime()
  echo "[TimeCode] Start timing code..."

proc timeCodeEnd*() =
  echo &"[TimeCode] Time taken (sec): {(cpuTime() - startTime).formatFloat(ffDecimal, 15)}"

template timeCode*(code: untyped) =
  timeCodeStart()
  code
  timeCodeEnd()