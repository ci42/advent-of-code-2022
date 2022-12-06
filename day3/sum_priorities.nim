import std/[strutils, sets, sequtils, streams, os]

proc mapChar2priority(c: char) : int =
    if ord(c) > 96: return ord(c)-96
    elif ord(c) > 64: return ord(c)-38
    else: raise newException(Exception, "unknown item")

proc processRucksacks(s: Stream) : int =
    var r : seq[int] = @[]
    for l in s.lines:
        if isEmptyOrWhitespace(l): continue
        var itemSet = (toHashSet(l[0 ..< len(l) div 2]) * toHashSet(l[l.len div 2 ..< l.len]))
        r.add(mapChar2priority(itemSet.pop()))
    return foldl(r, a+b)

proc main() =
    let p : seq[string] = commandLineParams()
    if p.len() != 1:
        echo getAppFilename(), " takes exactly one argument"; quit(-1)
    try:
        let sumOfPriorities = processRucksacks(openFileStream(p[0]))
        echo "Sum of priorities: ", sumOfPriorities
    except Exception as e:
        echo e.msg; quit(-1)

when isMainModule:
    main()