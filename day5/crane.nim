import std/[algorithm, strutils, strscans, streams, os]

proc crate(input: string, val: var char, start: int) : int =
    var c: char
    if scanf(input[start..<start+3], "[$c]", c): val = c
    else: val = ' '
    return 3

proc processInstruction9000(stacks: var seq[seq[char]], n: int, src: int , dst: int) =
    for i in countup(1, n):
        stacks[dst].add(stacks[src][^1])
        stacks[src].delete(len(stacks[src])-1)

proc processInstruction9001(stacks: var seq[seq[char]], n: int, src: int , dst: int) =
    for i in countdown(n, 1):        
        stacks[dst].add(stacks[src][^i])
        stacks[src].delete(len(stacks[src])-i)

proc processInitialStacksAndCraneInstructions(s: Stream) : (seq[char], seq[char]) =
    var stackLines: seq[string] = @[]
    while true:
        var l = s.readline()
        if isEmptyOrWhitespace(l):
            break
        stackLines.add(l)
    
    var stacks9000: seq[seq[char]] = @[]
    for i in 0..<9:
        stacks9000.add(newSeq[seq[char]](1))

    for l in reversed(stacklines[0..<len(stacklines)-1]):
        var c1, c2, c3, c4, c5, c6, c7, c8, c9 : char
        if scanf(l, "${crate} ${crate} ${crate} ${crate} ${crate} ${crate} ${crate} ${crate} ${crate}", c1, c2, c3, c4, c5, c6, c7, c8, c9):
            for i, c in [c1, c2, c3, c4, c5, c6, c7, c8, c9]:
                if c != ' ':  stacks9000[i].add(c)

    var stacks9001 = stacks9000                

    var n, src, dst = 0
    var line : string
    while s.readline(line):
        if scanf(line, "move $i from $i to $i", n, src, dst):
            processInstruction9000(stacks9000, n, src-1, dst-1)
            processInstruction9001(stacks9001, n, src-1, dst-1)

    var r9000, r9001 : seq[char] = @[]
    for s in stacks9000:
        r9000.add(s[^1])
    for s in stacks9001:
        r9001.add(s[^1])
            
    return (r9000, r9001)
        
proc main() =
    let p : seq[string] = commandLineParams()
    if p.len() != 1:
        echo getAppFilename(), " takes exactly one argument"; quit(-1)
    try:
        let (r9000, r9001) = processInitialStacksAndCraneInstructions(openFileStream(p[0]))
        echo "Crates 9000: ", r9000, " Crates 9001: ", r9001
    except Exception as e:
        echo e.msg; quit(-1)

when isMainModule:
    main()