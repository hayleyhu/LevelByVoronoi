local Node = require("Node")
local Edge = require("Edge")
local Graph = require("Graph")
local astar = require("astar")
local util = require("util")

function weighted_voronoi_diagram(graph, centers)
	-- local migrating_candidates = {}
	print "starting Weighted Voronoi diagram"
	distances = construct_voronoi(graph, centers, migrating_candidates)
	local meanDiff = calculate_mean_diff(graph)
	print("meanDiff: ", meanDiff)
	local k=0
	local initialDistances = util.deepcopy(distances)
	repeat 
		k = k+1
		print("k:",k)
		leastDifficultCenter = updateDifficulties( centers)
		print("leastDifficultCenter: ", leastDifficultCenter.id)
		updateDistances( graph, centers, initialDistances, meanDiff )
		candidates = findMigrationCandidates(graph,centers, distances, leastDifficultCenter)
		print("#candidates: ",#candidates)
		--mean_Diff = calculate_mean_diff(graph)
		transferPoints(graph,candidates,leastDifficultCenter)
		-- construct_voronoi(graph, centers, migrating_candidates)
	until (#candidates==0)
	print("======")
	for i,v in ipairs(graph.nodeList) do
		print("---Node: " .. v.id)
		print("X: " .. v.x)
		print("Y: " .. v.y)
		if v.isCenter then
			print("I am a Center")
		else
			print("Closest Center " .. v.currentClosest.id)
			print("distance to Center: " .. distances[v.id][v.currentClosest.id])
		end
	end
end

function updateDistances( graph , listCenters, initialDistances, meanDiff)
	for i,node in ipairs(graph.nodeList) do
		if not node.isCenter then
			for j,center in ipairs(listCenters) do
				distances[node.id][center.id] = (center.distPrevDifficulty * initialDistances[node.id][center.id]) / meanDiff
			end
		end
	end
end

function updateDifficulties( listCenters )
	local leastDifficultCenter = nil;
	local leastDifficultSum = 999999
	for i,center in ipairs(listCenters) do
		local total = 0;
		for i,v in ipairs(center.members) do
			total = total + v.mDifficulty
		end
		if total < leastDifficultSum then
			leastDifficulty = total
			leastDifficultCenter = center
		end
		center.districtDifficulty = total
		if not center.distPrevDifficulty then
			center.distPrevDifficulty = center.districtDifficulty
		end
	end
	return leastDifficultCenter
end

function findMigrationCandidates(graph,centers,distances, leastDifficultCenter)
	local migrationCandidates = {}
	for i,node in ipairs(graph.nodeList) do
		if not node.isCenter and node.currentClosest ~= leastDifficultCenter then
			local minDist = distances[node.id][leastDifficultCenter.id]
			local candidate = true
			for j,center in ipairs(centers) do
				if distances[node.id][center.id] < minDist then
					candidate = false
					break
				end
			end
			if candidate then table.insert(migrationCandidates,node) end
		end
	end
	return migrationCandidates	
end

function transferPoints( graph, candidateList ,leastDifficultCenter)
	for i,candidate in ipairs(candidateList) do
		local prevCenter = candidate.currentClosest
		prevCenter.distPrevDifficulty = prevCenter.districtDifficulty
		prevCenter.districtDifficulty = prevCenter.districtDifficulty - candidate.mDifficulty
		util.deleteFromTable(prevCenter.members, candidate)

		table.insert(leastDifficultCenter.members,candidate)
		leastDifficultCenter.distPrevDifficulty = leastDifficultCenter.districtDifficulty
		leastDifficultCenter.districtDifficulty = candidate.mDifficulty
	end
end

function calculate_mean_diff(graph)
	local r = #graph.nodeList
	local sum = 0
	for i,v in ipairs(graph.nodeList) do
		sum = sum+v.mDifficulty
	end
	return sum/r
end

function construct_voronoi(graph, centers, migrating_candidates)
	local leastDifficulty = 10000000
	local leastCenter = nil;
	for j,c in ipairs(centers) do
		if c.districtDifficulty<leastDifficulty then
			leastDifficulty = c.districtDifficulty
			leastCenter = c
		end
	end

	migrating_candidates = {}


	for j,c in ipairs(centers) do
		c.districtDifficulty = c.districtDifficulty
	end

	local distances = {}
	for i,node in ipairs(graph.nodeList) do
		if (not node.isCenter) then
			local currentClosest = nil
			local minDistance = 100000
			for j,c in ipairs(centers) do
				local path = astar.path(node, c, graph)
				local pathDist = astar.calculatePathDist(path)
				if not distances[node.id] then distances[node.id] = {} end
				distances[node.id][c.id] = pathDist
				if (pathDist < minDistance) then
					minDistance = pathDist
					currentClosest = c
				end
			end
			node.currentClosest = currentClosest
			if (currentClosest==leastCenter) then
				table.insert(migrating_candidates, node)
			end
			table.insert(currentClosest.members, node)
			currentClosest.districtDifficulty = currentClosest.districtDifficulty+node.mDifficulty
		end
	end
	return distances
end

print "Starting test trial"
node1 = Node(1, 1, 0, 1,true)
node2 = Node(2, 2, 0, 99, false)
node3 = Node(3, 3, 0, 99, false)
node4 = Node(4, 101, 0, 1,true)

edge12 = Edge(node1,node2)
edge23 = Edge(node2,node3)
edge34 = Edge(node3,node4)
testNodeList = {node1, node2, node3, node4}
testGraph = Graph(testNodeList)
weighted_voronoi_diagram(testGraph,{node1,node4})

