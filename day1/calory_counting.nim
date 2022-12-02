import std/[strutils, algorithm, streams, os]

proc processElvesAndCalories(s: Stream) : seq[int] =
    var r : seq[int] = @[]
    var cur = 0
    for l in s.lines:
        if isEmptyOrWhitespace(l):
            if cur > 0:
                r.add(cur)
                cur = 0
            continue
        cur += parseInt(l)
    return r

func sumNElements(c: seq[int], n: uint): int = 
    var sum = 0
    for i in 0..<n: sum += (c[i])
    return sum

proc main() =
    let p : seq[string] = commandLineParams()
    if p.len() != 2:
        echo getAppFilename(), " takes exactly two arguments"; quit(-1)
    try:
        let c = processElvesAndCalories(openFileStream(p[0]))
        echo "Calories: ", sumNElements(sorted(c, SortOrder.Descending), parseUInt(p[1]))
    except Exception as e:
        echo e.msg; quit(-1)

when isMainModule:
    main()