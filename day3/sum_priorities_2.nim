import std/[strutils, sets, sequtils, streams, os]

proc mapChar2priority(c: char) : int =
    if ord(c) > 96: return ord(c)-96
    elif ord(c) > 64: return ord(c)-38
    else: raise newException(Exception, "unknown item")

proc processRucksacks(s: Stream) : int =
    var r : int = 0
    var rucksacks = newSeq[HashSet[char]](3)
    var currentRucksack = 0
    for l in s.lines:
        if isEmptyOrWhitespace(l): raise newException(Exception, "invalid input")
        rucksacks[currentRucksack] = toHashSet(l)
        currentRucksack += 1
        if currentRucksack >= 3:
            currentRucksack = 0
            var itemSet = foldl(rucksacks, a * b)
            var item = itemSet.pop()
            r += mapChar2priority(item)
            continue
        
    return r

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