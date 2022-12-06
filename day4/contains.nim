import std/[strutils, strscans, streams, os]

func contains(f1, f2, s1, s2: int) : bool =
    return (f1 <= s1 and f2 >= s2) or (s1 <= f1 and s2 >= f2) 

func overlaps(f1, f2, s1, s2: int) : bool =
    return f1 <= s2 and f2 >= s1

proc processRanges(s: Stream) : (int, int) =
    var containing, overlapping = 0
    for l in s.lines:
        var f1, f2, s1, s2 : int
        if scanf(l, "$i-$i,$i-$i", f1, f2, s1, s2):
            if contains(f1, f2, s1, s2): containing += 1
            if overlaps(f1, f2, s1, s2): overlapping += 1
    return (containing, overlapping)
        
proc main() =
    let p : seq[string] = commandLineParams()
    if p.len() != 1:
        echo getAppFilename(), " takes exactly one argument"; quit(-1)
    try:
        let (containing, overlapping) = processRanges(openFileStream(p[0]))
        echo "Fully containing pairs: ", containing, " overlapping pairs: ", overlapping
    except Exception as e:
        echo e.msg; quit(-1)

when isMainModule:
    main()