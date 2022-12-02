import std/[strutils, streams, os]

type
    Outcome {.pure.} = enum
        LOOSE = 0, DRAW = 3, WIN = 6 
    ShapeKind {.pure.} = enum
        ROCK, SCISSOR, PAPER
    Shape = object
        kind: ShapeKind
        defeats: ShapeKind
        score: int

func outcome(self, other: Shape): Outcome =
    if self == other:
        return DRAW
    elif self.defeats == other.kind:
        return WIN
    else:
        return LOOSE

func play(self, other: Shape): int =
    case self.outcome(other)
        of WIN: ord(WIN) + self.score 
        of LOOSE: ord(LOOSE) + self.score
        of DRAW: ord(DRAW) + self.score

const ROCK = Shape(kind: ShapeKind.ROCK, defeats: ShapeKind.SCISSOR, score: 1)
const PAPER = Shape(kind: ShapeKind.PAPER, defeats: ShapeKind.ROCK, score: 2)
const SCISSOR = Shape(kind: ShapeKind.SCISSOR, defeats: ShapeKind.PAPER, score: 3)
const SHAPES = @[ROCK, PAPER, SCISSOR]

func defeatedBy(self: Shape): Shape = 
    for s in SHAPES:
        if s.defeats == self.kind: return s

func winsAgainst(self: Shape): Shape = 
    for s in SHAPES:
        if self.defeats == s.kind: return s

func symbol2shape(s: string): Shape =
    case s
        of "A", "X": ROCK
        of "B", "Y": PAPER
        of "C", "Z": SCISSOR
        else: raise newException(Exception, "unknown symbol")

func symbol2desiredOutcome(s: string): Outcome =
    case s
        of "X": LOOSE
        of "Y": DRAW
        of "Z": WIN
        else: raise newException(Exception, "unknown symbol")

func shape2play(desiredOutcome: Outcome, otherShape: Shape) : Shape =
    case desiredOutcome
        of LOOSE: otherShape.winsAgainst()
        of DRAW: otherShape
        of WIN: otherShape.defeatedBy()

func symbols2shapes(s: tuple[first: string, second: string]) : tuple[first: Shape, seconds: Shape] =
    (symbol2shape(s.first), symbol2shape(s.second))
    
func str2symbols(s: string) : tuple[first: string, second: string] =
    let symbols = s.split()
    (first: symbols[0], second: symbols[1])

proc playFirstRound(s: Stream) : int =
    defer: s.close()
    var finalScore = 0
    for l in s.lines:
        if isEmptyOrWhitespace(l): continue
        let (otherShape, myShape) = symbols2shapes(str2symbols(l))
        finalScore += myShape.play(otherShape)
    return finalScore

proc playSecondRound(s: Stream) : int =
    defer: s.close()
    var finalScore = 0
    for l in s.lines:
        if isEmptyOrWhitespace(l): continue
        let symbols = str2symbols(l)
        let (otherShape, _) = symbols2shapes(symbols)
        let desiredOutcome = symbol2desiredOutcome(symbols.second)
        finalScore += shape2play(desiredOutcome, otherShape).play(otherShape)
    return finalScore

proc main() = 
    let p : seq[string] = commandLineParams()
    if p.len() != 1:
        echo getAppFilename(), " takes exactly one argument"; quit(-1)
    try:
        echo "Total score round 1: ", playFirstRound(openFileStream(p[0]))
        echo "Total score round 2: ", playSecondRound(openFileStream(p[0]))
    except Exception:
        echo getCurrentExceptionMsg(); quit(-1)

when isMainModule:
    main()