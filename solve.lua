local Node = require("Node.lua")
local astar = require("astar.lua")
local util = require("util.lua")

function weighted_voronoi_diagram(graph, centers)
	local migrating_candidates = {}
	distances = construct_voronoi(graph, centers, migrating_candidates)
	local meanDiff = calculate_mean_diff(graph)
	local k=0
	local initialDistances = util.deepcopy(distances)
	repeat 
		k += 1
		leastDifficultCenter = updateDifficulties( centers)
		updateDistances( graph, centers, initialDistances, meanDiff )
		candidates = findMigrationCandidates(graph,leastDifficultCenter)
		--mean_Diff = calculate_mean_diff(graph)
		transferPoints(graph,candidates)
		-- construct_voronoi(graph, centers, migrating_candidates)
	until (#migrating_candidates==0)
end

function updateDistances( graph , listCenters, distances, initialDistances, meanDiff)
	for i,node in ipairs(graph.nodeList) do
		if not v.isCenter then
			for j,center in ipairs(listCenters) do
				distances[node.id][center.id] = (center.distPrevDifficulty * initialDistances[node.id][center.id]) / meanDiff
			end
		end
	end
	return updateDifficulties(listCenters)
end

function updateDifficulties( listCenters )
	local leastDifficultCenter = nil;
	local leastDifficultSum = 999999
	for i,center in ipairs(listCenters) do
		local total 
		for i,v in ipairs(center.members) do
			total = total + v.mDifficulty
		end
		if total < leastDifficultSum then
			leastDifficulty = total
			leastDifficultCenter = center
		end
		center.districtDifficulty = total
	end
	return leastDifficultCenter
end

function findMigrationCandidates(graph,centers distances, leastDifficultCenter)
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
		local prevCenter = candidates.currentClosest
		prevCenter.distPrevDifficulty = prevCenter.districtDifficulty
		prevCenter.districtDifficulty = prevCenter.districtDifficulty - candidate.mDifficulty
		table.remove(prevCenter.members, util.find(prevCenter.members, candidate))

		table.insert(leastDifficultCenter.members,candidate)
		leastDifficultCenter.distPrevDifficulty = leastDifficultCenter.districtDifficulty
		leastDifficultCenter.districtDifficulty = candidate.mDifficulty
	end
end

function calculate_mean_diff(graph)
	local r = #graph.nodeList
	local sum = 0
	for i,v in ipairs(graph.nodeList) do
		sum += v.mDifficulty
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
	for i,node in ipairs(graph.NodeList) do
		if (not node.isCenter) then
			local currentClosest = nil
			local minDistance = 100000
			for j,c in ipairs(centers) do
				local pathDist = astar.calculatePathDist(astar.path(node, c, graph))
				distances[node.id][c.id] = pathDist
				if (pathDist < minDistance) then
					minDistance = pathDist
					currentClosest = c
				end
			end
			node.currentClosest = currentClosest
			if (currentClosest==leastCenter) then
				table.insert(migrating_candidates, v)
			table.insert(currentClosest.members, v)
			currentClosest.districtDifficulty += v.mDifficulty
		end
	end
	return distances
end


-- function updateDistances( distances,graph,centers ,initial_distances)
-- 	for i,v in ipairs(distances) do
-- 		if (not graph.NodeList.i.isCenter) then
-- 			for j,v2 in ipairs(v) do
-- 				if (graph.NodeList.j.isCenter) then
-- 					distances.i.j = (initial_distances.i.s*difficulties.i)/mean_Diff
-- 				end
-- 			end
-- 		end
-- 	end
-- end