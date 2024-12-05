import std/strutils

from std/sequtils import map

var comp_table: array[10..99, array[10..99, bool]]

while true:
    let input = readLine(stdin)
    if input == "": break

    let ids = input.split('|').map(parseInt)

    comp_table[ids[1]][ids[0]] = true

var result = 0
while true:
    var update = ""
    try:
        update = readLine(stdin)
    except EOFError:
        break

    let ids = update.split(',').map(parseInt)

    var valid = true
    for i in 0..len(ids)-1:
        for j in i+1..len(ids)-1:
            if comp_table[ids[i]][ids[j]]:
                valid = false
                break
        if not valid: break

    if valid:
        var middle_index = len(ids) div 2
        result += ids[middle_index]

echo result
