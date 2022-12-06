import std/[algorithm, strutils, strscans, streams, os]

func isMarker(s: string) : bool =
    for c in s:
        if s.count(c) > 1: return false 
    return true

proc processSignal(s: Stream, n: int) : int =
    var idx = n
    var window = newString(n)
    if s.readDataStr(window, 0..<n) != n: raise newException(Exception, "could not read signal")
    if isMarker(window): return idx
    while true:
        idx += 1
        let c = s.readChar()
        window.add(c)
        window.delete(0..0)
        if isMarker(window): return idx
        
proc main() =
    let p : seq[string] = commandLineParams()
    if p.len() != 2:
        echo getAppFilename(), " takes exactly two argument"; quit(-1)
    try:
        let startOfPacket = processSignal(openFileStream(p[0]), parseInt(p[1]))
        echo "Start of packet: ", startOfPacket
    except Exception as e:
        echo e.msg; quit(-1)

when isMainModule:
    main()