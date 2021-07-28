import std/sugar
import std/with
import std/options
import std/strutils
import std/strformat
from std/unicode
  import toRunes, toUTF8, reversed
import console/consoleutils
import timecode

import std/compilesettings

static:
  echo "[comp settings] outFile: ", querySetting(outFile) 
  echo "[comp settings] outDir: ", querySetting(outDir) 
  echo "[comp settings] projectName: ", querySetting(projectName) 
  echo "[comp settings] outprojectPathFile: ", querySetting(projectPath) 
  echo "[comp settings] projectFull: ", querySetting(projectFull) 
  echo "[comp settings] command: ", querySetting(command)


# -------------------------------------------------
# learning nim!
# -------------------------------------------------
echo "\nLearning Nim!!!"
writeHorizontalFill()
writeHorizontalFill("N I M / ")
writeHorizontalFill()


# -------------------------------------------------
echo "\n- string and array -"
writeHorizontalFill()
# -------------------------------------------------
# fromat string
# -------------------------------------------------
block:
  let
    hello = "   Hello Nim!   "
    someFloat = 0.123456

  echo "someString: " & hello.strip() & "\nsomeFloat: " & someFloat.formatFloat(ffDecimal, 3) & "\n"
  echo "someString: {hello.strip()}\nsomeFloat: {someFloat.formatFloat(ffDecimal, 3)}\n".fmt

# -------------------------------------------------
# get each utf8 runes
# -------------------------------------------------
block:
  stdout.write "write unicode string: "
  let runes = stdin.readLine().toRunes() # unicode module
  for i, s in runes:
    echo "{i}: {s}".fmt

# -------------------------------------------------
# reverse string
# -------------------------------------------------
echo "\nreverse string:"

block sol1:
  let input = "Hello world!"
  var output: string
  for i in countdown(input.high, 0):
    output.add input[i]
  echo output

block sol2:
  let input = "Hello world!"
  var output: string
  for c in input:
    output = c & output
  echo output

block sol3:
  let input = "Hello world!"
  var output = newString input.len
  for i, c in input:
    output[output.high - i] = c
  echo output

block sol4:
  let input = "Hello world!"
  let output = input.reversed # unicode module
  echo output

# -------------------------------------------------
# slice
# -------------------------------------------------
echo "\narray slice:"

block:
  var someArray = "Hello world!"
  var someArray2 = someArray[0 .. ^5]
  var someArray3 = someArray[0 .. 3] & someArray[7 .. 10]

  echo someArray
  echo someArray2
  echo someArray3
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- loop -"
writeHorizontalFill()
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
writeHorizontalFill()


# -------------------------------------------------
echo "\n- time -"
writeHorizontalFill()
block:
# -------------------------------------------------
# simple benchmark
# -------------------------------------------------
  let fibbNum = consoleReadLineParse(parseInt, "fibbonacci num: ")

  proc fibbonacci(n: int): int =
    if n <= 1: n else: fibbonacci(n - 1) + fibbonacci(n - 2)

  timeCode: echo "fibbonacci {fibbNum} = {fibbonacci fibbNum}".fmt
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- std macro -"
writeHorizontalFill()
block:
# -------------------------------------------------
# with
# -------------------------------------------------
  var parsed = consoleReadLineParse(parseFloat, "write any number: ")
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
writeHorizontalFill()


# -------------------------------------------------
echo "\n- tuple -"
writeHorizontalFill()
block:
  # 주소 예시 소스: https://dorojuso.kr/서울특별시/서대문구/홍은제1동?page=67
  var homeAddress = (
    street: "홍지문길",
    buildingNumber: 7,
    buildingName: "대진하이츠빌라"
  )
  echo "{homeAddress.street} {homeAddress.buildingNumber} {homeAddress.buildingName}\n".fmt

  echo "Value swap using Tuple:"
  var
    a = 10
    b = 20
  echo "{a = }, {b = }".fmt
  (a, b) = (b, a)
  echo "{a = }, {b = }".fmt
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- defer -"
writeHorizontalFill()
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
writeHorizontalFill()


# -------------------------------------------------
echo "\n- template -"
writeHorizontalFill()
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
writeHorizontalFill()


# -------------------------------------------------
echo "\n- proc & func -"
writeHorizontalFill()
block:
  echo "proc & func can be nested:"
  proc outerProc() =
    proc innerProc() =
      echo "inner proc"
    echo "outer proc"
    innerProc()

  outerProc()

  echo "\nfunc can't have side effect but can still change the var(c#: ref) parameter:"
  var someNumber = 10
  func noSideEffectProc(param: var int) =
    param = 100

  echo "someNumber: {someNumber}".fmt
  noSideEffectProc(someNumber)
  echo "someNumber: {someNumber}".fmt
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- lambda -"
writeHorizontalFill()
block:
  proc lambda(lambdaProc: () -> string, b: int) =
    echo lambdaProc()

  echo "Singleline Lambda:"
  lambda(proc: string = "result", 10)
  lambda(() => "result (sugar)", 10)

  echo "\nMultiline Lambda:"
  lambda(
    proc: string =
      echo "echo"
      if true:
        "result"
      else:
        "Nope",
    10
  )
  lambda(
    () => (block:
      echo "echo (sugar) "
      if true:
        "result (sugar)"
      else:
        "Nope"
    ),
    10
  )
  # when using a sugar syntax
  # () => (block: ...)
  #       ^^^^^^^^^^^^
  #       |
  #       this is necessary for the multi line lambda with sugar.
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- shared closures -"
writeHorizontalFill()
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
    (
      defSayText(text),
      defSetText(text)
    )

  sayText()
  setText("Hello world!")
  sayText()
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- options -"
writeHorizontalFill()
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
writeHorizontalFill()


#--------------------------------------------------
# enum
#--------------------------------------------------
echo "\n- enums -"
writeHorizontalFill()
block:
  type SomeEnum = enum
    A = 0,
    B = 2,
    C = 3

  proc hasOrd(T: typedesc[enum], i: int): bool {.inline.} =
    try: result = $T(i) != "{i} (invalid data!)".fmt
    except: result = false

  proc enumRange[T: enum](): Slice[int] {.inline.} = result = T.low.ord .. T.high.ord

  for i in enumRange[SomeEnum]():
    if not SomeEnum.hasOrd(i): continue
    stdout.write SomeEnum(i)

  echo ""
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- object -"
writeHorizontalFill()
# -------------------------------------------------
# value and reference type
# -------------------------------------------------
block:
  type
    # value type
    Person = object
      name: string
      age: int

    # reference type
    PersonRef = ref Person

  proc setNameAndAge(
      preson: var Person,
      name: typeof(preson.name),
      age: typeof(preson.age)
    ) =
    preson.name = name;
    preson.age = age;

  proc setNameAndAge(
      preson: PersonRef,
      name: typeof(preson.name),
      age: typeof(preson.age)
    ) =
    preson.name = name;
    preson.age = age;

  var personA = Person(name: "A", age: 10)
  var personB = Person(name: "B", age: 20)
  var personRefA = PersonRef(name: "A", age: 10)
  var personRefB = PersonRef(name: "B", age: 20)

  var presonSeq = newSeq[Person]()
  var presonRefSeq = newSeq[PersonRef]()
  presonSeq.add([personA, personB])
  presonRefSeq.add([personRefA, personRefB])

  echo "Person Seq:"
  for person in presonSeq: echo "name: {person.name}, age: {person.age}".fmt
  echo "PersonRef Seq:"
  for person in presonRefSeq: echo "name: {person.name}, age: {person.age}".fmt

  # Modify original data
  personA.setNameAndAge("WOW_A", 100)
  personB.setNameAndAge("WOW_B", 200)
  personRefB.setNameAndAge("WOW_RefB", 200)
  personRefB.setNameAndAge("WOW_RefB", 200)
  echo "\nAfter modifing the original objects...\n"

  echo "Person Seq:"
  for person in presonSeq: echo "name: {person.name}, age: {person.age}".fmt
  echo "PersonRef Seq:"
  for person in presonRefSeq: echo "name: {person.name}, age: {person.age}".fmt

  # --gc:refc 
  # This is the default GC. It's a deferred reference counting based garbage collector with a simple Mark&Sweep backup GC in order to collect cycles. 
  # Heaps are thread-local.

  # --gc:arc
  # Plain reference counting with move semantic optimizations, offers a shared heap.
  # It offers deterministic performance for hard realtime systems. Reference cycles cause memory leaks, beware.

  # --gc:orc
  # Same as --gc:arc but adds a cycle collector based on "trial deletion".
  # Unfortunately, that makes its performance profile hard to reason about so it is less useful for hard real-time systems.

  echo "\nAfter setting the refs to nil...\n"
  personRefA = nil;
  personRefB = nil;
  for i in 0 ..< presonRefSeq.len: presonRefSeq[i] = nil

  echo "PersonRef Seq:"
  for person in presonRefSeq:
    if person != nil:
      echo "name: {person.name}, age: {person.age}".fmt
    else:
      echo "nil"

# -------------------------------------------------
# method overloading
# -------------------------------------------------
  type
    A = ref object of RootObj
    B = ref object of A

  method print(a1, a2: A) = echo "aa"
  method print(a: A, b: B) = echo "ab"

  method print(b1, b2: B) = echo "bb"
  method print(b: B, a: A) = echo "ba"

  let a = A()
  let b = B()

  a.print(b.A) # -> aa
  b.print(b) # -> bb
  a.print(b) # -> ab
  b.A.print(b) # -> bb
  b.print(b.A) # -> ba
# -------------------------------------------------
writeHorizontalFill()


# -------------------------------------------------
echo "\n- file read & write -"
writeHorizontalFill()
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

  textFile.setFilePos(0) # <- This is nessesary because readAll() starts from the current file position.

  echo textFile.readAll()
# -------------------------------------------------
writeHorizontalFill()

