import std/strutils
import std/tables

from std/sequtils import map

type
    Node = object
        id: int
        parents: seq[int]
        children: seq[int]

var nodes = initTable[int, Node]()

var input: string

input = readLine(stdin)
while input != "":
    let ids = input.split('|').map(parseInt)

    if ids[0] notin nodes:
        nodes[ids[0]] = Node(id: ids[0])
    if ids[1] notin nodes:
        nodes[ids[1]] = Node(id: ids[1])

    nodes[ids[0]].children.add(ids[1])
    nodes[ids[1]].parents.add(ids[0])
    input = readLine(stdin)

echo nodes
