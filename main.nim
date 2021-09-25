import std/compilesettings
import std/enumutils
import std/strutils
import std/strformat
import std/options
import std/sugar
import std/with
from std/unicode
  import Rune, toRunes, toUTF8, `$`, reversed

import console/consoleutils
import timecode


# -------------------------------------------------
# compile time code execution
# -------------------------------------------------
static:
  echo "[comp settings] outFile: ", querySetting(outFile)
  echo "[comp settings] outDir: ", querySetting(outDir)
  echo "[comp settings] projectName: ", querySetting(projectName)
  echo "[comp settings] outprojectPathFile: ", querySetting(projectPath)
  echo "[comp settings] projectFull: ", querySetting(projectFull)
  echo "[comp settings] command: ", querySetting(command)

  const version1 = $NimVersion
  const version2 = $NimMajor & "." & $NimMinor & "." & $NimPatch
  echo "Nim Version"
  echo version1
  echo version2


echo "\nLet's Learn Nim!!!"
consoleFillHorizontal()
consoleFillHorizontal("N I M / ")
consoleFillHorizontal()


# -------------------------------------------------
# tuple
# -------------------------------------------------
echo "\n- tuple -"
consoleFillHorizontal()
block:
  # address source: https://dorojuso.kr/서울특별시/서대문구/홍은제1동?page=67
  let homeAddress = (
    street: "홍지문길",
    buildingNumber: 7,
    buildingName: "대진하이츠빌라"
  )
  echo "{homeAddress.street} {homeAddress.buildingNumber} {homeAddress.buildingName}\n".fmt

  echo "swap values using tuples:"
  var
    a = 10
    b = 20
  echo "{a = }, {b = }".fmt
  (a, b) = (b, a)
  echo "{a = }, {b = }".fmt
# -------------------------------------------------
consoleFillHorizontal()

# -------------------------------------------------
# string and array
# -------------------------------------------------
echo "\n- string and array -"
consoleFillHorizontal()
block:
  # -------------------------------------------------
  # array type
  # -------------------------------------------------
  type Arr = array[-3 .. 4, int] # array index can start with any number (for example -3)
  echo "{Arr.low = }, {Arr.high = }".fmt
  var a: Arr
  a = [1, 2, 3, 4, 5, 6, 7, 8]
  echo "{a.low = }, {a.high = }".fmt
  echo "{a = }".fmt
  echo "{a[0] = }, {a[^1] = }".fmt
  echo "{a[a.low] = }, {a[a.high] = }".fmt

block:
  # -------------------------------------------------
  # string fromat
  # -------------------------------------------------
  let
    hello = "   Hello Nim!   "
    someFloat = 0.123456

  echo "someString: " & hello.strip() & "\nsomeFloat: " & someFloat.formatFloat(ffDecimal, 3) & "\n"
  echo "someString: {hello.strip()}\n".fmt & "someFloat: {someFloat.formatFloat(ffDecimal, 3)}\n".fmt

block:
  # -------------------------------------------------
  # get each utf8 runes
  # -------------------------------------------------
  stdout.write "write unicode string: "
  let runes = stdin.readLine().toRunes() # unicode module
  for i, s in runes:
    echo "{i}: {s}".fmt

block:
  # -------------------------------------------------
  # reverse string
  # -------------------------------------------------
  echo "\nreverse string:"
  block sol1:
    let input = "안녕 world!".toRunes()
    var output: string
    for i in countdown(input.high, 0):
      output.add $input[i]
    echo output

  block sol2:
    let input = "안녕 world!".toRunes()
    var output: string
    for c in input:
      output = $c & $output
    echo output

  block sol3:
    let input = "안녕 world!".toRunes()
    var output = newSeq[Rune] input.len
    for i, c in input:
      output[output.high - i] = c
    echo output

  block sol4:
    let input = "안녕 world!"
    let output = input.reversed # unicode module
    echo output

block:
  # -------------------------------------------------
  # array slice
  # -------------------------------------------------
  echo "\narray slice:"

  let someArray = "Hello world!"
  echo someArray

  let someArray2 = someArray[0 .. ^5]
  echo someArray2

  let someArray3 = someArray[0 .. 3] & someArray[7 .. 10]
  echo someArray3
# -------------------------------------------------
consoleFillHorizontal()


#--------------------------------------------------
# enum
#--------------------------------------------------
echo "\n- enums -"
consoleFillHorizontal()
block:
  type SomeEnum = enum # enum with holes
    A = 0,
    B = 2,
    C = 3

  for i in SomeEnum.items: # enumutils module
    stdout.write i
  echo ""
# -------------------------------------------------
consoleFillHorizontal()


#--------------------------------------------------
# object
#--------------------------------------------------
echo "\n- object -"
consoleFillHorizontal()
block:
  type
    # value type (memory is allocated in the stack)
    Person = object
      name: string

    # reference type (memory is allocated in the heap. memory is managed by the gc)
    PersonRef = ref object
      name: string
    # --gc:refc
    # This is the default GC. It's a deferred reference counting based garbage collector with a simple Mark&Sweep backup GC in order to collect cycles.
    # Heaps are thread-local.
    # --gc:arc
    # Plain reference counting with move semantic optimizations, offers a shared heap.
    # It offers deterministic performance for hard realtime systems. Reference cycles cause memory leaks, beware.
    # --gc:orc
    # Same as --gc:arc but adds a cycle collector based on "trial deletion".
    # Unfortunately, that makes its performance profile hard to reason about so it is less useful for hard real-time systems.

  var person = Person(name: "John")
  var personRef = PersonRef(name: "Bob")

  var person2 = person       # value types are copied when assigned
  var personRef2 = personRef # reference types point to same memory even when assigned to new variable

  echo "\ninitial object values\n"
  echo "name: {person.name}".fmt
  echo "name: {personRef.name}".fmt

  # modify person2 object
  person2.name = "modified John"
  personRef2.name = "modified Bob"

  echo "\ninitial object values\n"
  echo "name: {person.name}".fmt
  echo "name: {personRef.name}".fmt

  echo "\nassigned object values\n"
  echo "name: {person2.name}".fmt
  echo "name: {personRef2.name}".fmt


# -------------------------------------------------
# option
# -------------------------------------------------
echo "\n- option -"
consoleFillHorizontal()
block:
  proc find(text: string, toFind: char): Option[int] =
    for i, c in text:
      if c == toFind:
        return some(i)
    return none(int) # This line is actually optional,
                      # because the default is none

  var found = "abc".find('c')
  if found.isSome:
    echo found.get()
    found = none(int) # <- Sets the option to none.
  # echo found.get() # <- Exception because found is none.
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# loop
# -------------------------------------------------
echo "\n- loop -"
consoleFillHorizontal()
block:
  # -------------------------------------------------
  # while
  # -------------------------------------------------
  echo "while loop"
  while true:
    echo "break"
    break
  echo ""

  # -------------------------------------------------
  # for
  # -------------------------------------------------
  echo "classic for loop"
  for i in 0 ..< 10:
    stdout.write $i & " "

  echo "\n"

  echo "for each"
  for i, item in [1, 3, 5, 4, 6]:
    echo "[{i}]: {item}".fmt

  echo ""

  for i, (k, v) in [(person: "You", power: 100), (person: "Me", power: 9000)]:
    echo "{k} have {v} power.".fmt
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# defer
# -------------------------------------------------
echo "\n- defer -"
consoleFillHorizontal()
block:
  defer:
    echo "#1.1 defer"
    echo "#1.2 defer"
  defer:
    echo "#2.1 defer"
    echo "#2.2 defer"
  defer:
    echo "#3.1 defer"
    echo "#3.2 defer"
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# template
# -------------------------------------------------
echo "\n- template -"
consoleFillHorizontal()
block:
  echo "Template Copy Pastes code"

  template test() =
    defer: echo "template defer"

  proc testProc() =
    defer: echo "proc defer"

  defer: echo "#1 defer"
  test()
  testProc()
  defer: echo "#2 defer"
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# proc
# -------------------------------------------------
echo "\n- proc -"
consoleFillHorizontal()
block:
  # -------------------------------------------------
  # nested proc
  # -------------------------------------------------
  echo "proc can be nested:"
  proc outerProc() =
    proc innerProc() =
      echo "inner proc"
    echo "outer proc"
    innerProc()

  outerProc()

  # -------------------------------------------------
  # func
  # -------------------------------------------------
  echo "\nfunc can't have side effect but can still change the var parameter:"
  # var parameters are like C# ref parameters
  # `func procName = ...` is equal to `proc procName {.noSideEffect.} = ...`
  var someNumber = 10
  func noSideEffectProc(param: var int) =
    param = 100 # modifying the `var parameter` does not count as side effect. (good? bad? I'm not sure...)
    # someNumber = 1
    # ^^^^^^^^^^^^^^
    # └─> side effect found! (this is compile time error)

  echo "{someNumber = }".fmt
  noSideEffectProc(someNumber)
  echo "{someNumber = }".fmt

block:
  # -------------------------------------------------
  # optinal param
  # -------------------------------------------------
  echo "optinal param:"
  proc optianlParam(v: int = 100) =
    echo v
  
  optianlParam(1)
  optianlParam()

  proc optianlParamWithVoid(v: int | void = void) =
    when v is void:
      echo "void"
    else:
      echo v

  optianlParamWithVoid(1)
  optianlParamWithVoid()
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# lambda (anonymous function)
# -------------------------------------------------
echo "\n- lambda (anonymous function) -"
consoleFillHorizontal()
block:
  proc runFn(fn: () -> string, b: int) =
    #            ^^^^^^^^^^^^
    #            └─> this is same as `proc(): string`
    echo fn()

  echo "single-line lambda:"
  runFn(proc: string = "result", 10)
  runFn(() => "result (sugar)", 10)

  echo "\nmulti-line lambda:"
  runFn(
    proc: string =
      echo "echo"
      if true:
        "result"
      else:
        "Nope",
    10
  )
  runFn(
    () => (block:
    #      ^^^^^^
    #      └─> this is necessary for the multi line lambda using `() =>` sugar.
      echo "echo (sugar) "
      if true:
        "result (sugar)"
      else:
        "Nope"
    ),
    10
  )
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# closure
# doc: https://nim-lang.org/docs/manual.html#procedures-closures
# -------------------------------------------------
echo "\n- closure capture"
block:
  var fns: array[10, proc()]

  echo "loop without capture:"
  for i in 0 .. fns.high:
    fns[i] = proc() =
      stdout.write i, " "

  for f in fns: f()
  echo ""

  echo "loop with capture:"
  for i in 0 .. fns.high:
    capture i:
      fns[i] = proc() =
        stdout.write i, " "

  for f in fns: f()
  echo ""

echo "\n- shared closure -"
consoleFillHorizontal()
block:
  template defSayText(text: string): untyped =
    proc sayText() =
      echo text
    sayText

  template defSetText(text: string): untyped =
    proc setText(newText: string) =
      text = newText
    setText

  let (sayText, setText) = block:
    var text = "Hello Nim!"
    (defSayText(text), defSetText(text))

  sayText()
  setText("Hello world!")
  sayText()
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# method
# -------------------------------------------------
type
  A = ref object of RootObj
  B = ref object of A

method print(a1, a2: A) {.base.} = echo "aa"
method print(a: A, b: B) {.base.} = echo "ab"

method print(b1, b2: B) = echo "bb"
method print(b: B, a: A) = echo "ba"

let a = A()
let b = B()

echo "Method: dynamic dispatch"
a.print(b.A) # -> aa
b.print(b) # -> bb
a.print(b) # -> ab
b.A.print(b) # -> bb
b.print(b.A) # -> ba
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# std macro
# -------------------------------------------------
echo "\n- std macro -"
consoleFillHorizontal()
block:
  # -------------------------------------------------
  # with
  # -------------------------------------------------
  var parsed = consoleReadLineParse("write any number: ", parseFloat)
  with parsed:
    stdout.write " + 8 = "
    += 8
    echo
    stdout.write " - 20 = "
    -= 20
    echo
    stdout.write " * 2 = "
    *= 2
    echo
    stdout.write " / 3 = "
    /= 3
    echo

  # -------------------------------------------------
  # collect
  # -------------------------------------------------
  let randomInts = [1, 21, 312, 12, 10, 14, 45]
  let oddSeq = collect newSeq:
    for i in randomInts:
      if i mod 2 != 0:
        i

  echo "\nGet Odd Numbers from {randomInts}".fmt
  echo "result: {oddSeq}".fmt
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# time
# -------------------------------------------------
echo "\n- time -"
consoleFillHorizontal()
block:
  # -------------------------------------------------
  # simple benchmark
  # -------------------------------------------------
  let fibbNum = consoleReadLineParse("fibbonacci num: ", parseInt)

  proc fibbonacci(n: int): int =
    if n <= 1: n else: fibbonacci(n - 1) + fibbonacci(n - 2)

  timeCode: echo "fibbonacci {fibbNum} = {fibbonacci fibbNum}".fmt
# -------------------------------------------------
consoleFillHorizontal()


# -------------------------------------------------
# file io
# -------------------------------------------------
echo "\n- file io -"
consoleFillHorizontal()
block:
  let textFile = "./test.txt".open(fmReadWrite)
  defer: textFile.close

  textFile.write:
    dedent"""
    # nim hello world
    import std/strformat

    let
      hello = "hello"
      world = "world"

    if hello == "hello": stdout.write hello
    stdout.write "{world}\n".fmt
    """

  textFile.write:
    dedent"""

    <나비보벳따우 가사>
    나비보벳따우 봅 보벳띠 보빗 따우
    나비보벳따우 봅 보벳띠 나비벳 뽀
    휘휘휘휘휘휘휘~ 빗뽀벳 뻬~뺘빗뽀
    """

  textFile.setFilePos(0) # set the file position to 0 because readAll() starts from the current file position.
  echo textFile.readAll()
# -------------------------------------------------
consoleFillHorizontal()