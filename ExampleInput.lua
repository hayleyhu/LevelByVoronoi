local VoronoiSolve = require ("VoronoiSolve")
local Node = require ("Node")
local Edge = require ("Edge")
local Graph = require ("Graph")
-- Arguments: 
-- ID, X-pos, Y-pos, Difficulty, isCenterNode
node1 = Node(1, 1, 0, 1,true)
node2 = Node(2, 2, 0, 99, false)
node3 = Node(3, 3, 0, 99, false)
node4 = Node(4, 101, 0, 1,true)
node5 = Node(5,60,0,50,false)

edge12 = Edge(node1,node2)
edge23 = Edge(node2,node3)
edge34 = Edge(node3,node4)
edge54 = Edge(node5,node4)
edge51 = Edge(node5,node1)
testNodeList = {node1, node2, node3, node4,node5}
testGraph = Graph(testNodeList)
VoronoiSolve.weighted_voronoi_diagram(testGraph,{node1,node4})