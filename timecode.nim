import std/times
import std/monotimes
import std/strutils
import std/strformat


var startTime: MonoTime


proc toFloatSec*(d: Duration): float64 =
  inNanoseconds(d).float64 * 1e-9


proc timeCodeStart*() =
  echo "[TimeCode] Start timing code..."
  startTime = getMonoTime()


proc timeCodeEnd*() =
  let timeSpent = (getMonoTime() - startTime).toFloatSec
  echo &"[TimeCode] Time taken (sec): {timeSpent.formatFloat(ffDecimal, 15)}"


template timeCode*(code: untyped) =
  timeCodeStart()
  code
  timeCodeEnd()
