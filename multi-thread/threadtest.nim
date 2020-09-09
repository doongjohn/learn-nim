import sharedchannel

type WorkerArgs = (SharedChannel[string], SharedChannel[bool])

proc main() =
  var mainChannel = newSharedChannel[string]()
  var responseChannel = newSharedChannel[bool]()

  proc workerThread(args: WorkerArgs) {.thread.} =
    let (mainChannel, responseChannel) = args
    while true:
      let stringData = mainChannel.recv()
      if stringData == "": break
      echo "[recv] worker thread: ", stringData
      responseChannel.send(true)
    # every msg responsed
    responseChannel.send(false)

  var th: Thread[WorkerArgs]
  th.createThread(workerThread, (mainChannel, responseChannel))

  for i in ['a', 'b', 'c', 'd']:
    mainChannel.send($i)
    echo "[send] main thread: ", $i
    if not responseChannel.recv():
      break
  # every msg sent
  mainChannel.send("")

  th.joinThread()
  mainChannel.close()
  responseChannel.close()


main()