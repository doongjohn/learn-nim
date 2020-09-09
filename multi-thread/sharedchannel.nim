type SharedChannel*[T] = ptr Channel[T]

proc newSharedChannel*[T](): SharedChannel[T] =
  result = cast[SharedChannel[T]](allocShared0(sizeof(Channel[T])))
  result[].open()

proc close*[T](ch: var SharedChannel[T]) =
  ch[].close()
  deallocShared(ch)
  ch = nil

proc send*[T](ch: SharedChannel[T], msg: T) =
  ch[].send(msg)

proc recv*[T](ch: SharedChannel[T]): T =
  result = ch[].recv()

proc peek*[T](ch: SharedChannel[T]): int =
  result = ch[].peek()

proc ready*[T](ch: SharedChannel[T]): bool =
  result = ch[].ready()

