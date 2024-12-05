import std/algorithm
import std/strutils

from std/sequtils import map

type Comp = enum none, before, after

var comp_table: array[10..99, array[10..99, Comp]]

proc myComp(a, b: int): int =
    case comp_table[a][b]
        of before: -1
        of none: 0
        of after: 1

while true:
    let input = readLine(stdin)
    if input == "": break

    let ids = input.split('|').map(parseInt)

    comp_table[ids[0]][ids[1]] = before
    comp_table[ids[1]][ids[0]] = after

var result = 0
while true:
    var input = ""
    try:
        input = readLine(stdin)
    except EOFError:
        break

    var ids = input.split(',').map(parseInt)

    var valid = true
    for i in 0..len(ids)-1:
        for j in i+1..len(ids)-1:
            if comp_table[ids[i]][ids[j]] == after:
                ids.sort(myComp)
                valid = false
                break
        if not valid: break

    if not valid:
        var middle_index = len(ids) div 2
        result += ids[middle_index]

echo result
