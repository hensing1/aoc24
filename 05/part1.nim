import std/sets
import std/strformat
import std/strutils
import std/tables

from std/sequtils import map

type
    Node = object
        id: int
        parents: seq[int]
        children: seq[int]
        topological_index: int

var nodes = initTable[int, Node]()

var input: string

while true:
    let input = readLine(stdin)
    if input == "": break

    let ids = input.split('|').map(parseInt)

    if ids[0] notin nodes:
        nodes[ids[0]] = Node(id: ids[0])
    if ids[1] notin nodes:
        nodes[ids[1]] = Node(id: ids[1])

    nodes[ids[0]].children.add(ids[1])
    nodes[ids[1]].parents.add(ids[0])

var remainder_list: seq[int8]
for key in keys(nodes):
    remainder_list.add(int8(key))

var remainder_set = toHashSet(remainder_list)

var top_id = 0

while true:
    var parentless_nodes: seq[int8]
    for node_id in remainder_set:
        if len(nodes[node_id].parents) == 0:
            parentless_nodes.add(node_id)
            nodes[node_id].topological_index = top_id

    if len(parentless_nodes) == 0:
        echo "Graph contains cycle!"
        break

    for parent in parentless_nodes:
        for child in nodes[parent].children:
            nodes[child].parents.del(nodes[child].parents.find(parent))

    remainder_set = remainder_set - toHashSet(parentless_nodes)

    if len(remainder_set) == 0: break

    top_id += 1

var result = 0
while true:
    var input = ""
    try:
        input = readLine(stdin)
    except EOFError:
        break

    let ids = input.split(',').map(parseInt)

    var valid = true
    var current_top_ind = 0
    for id in ids:
        if nodes[id].topological_index < current_top_ind:
            valid = false
            break
        current_top_ind = nodes[id].topological_index

    if valid:
        var middle_index = len(ids) div 2
        result += ids[middle_index]

echo result
