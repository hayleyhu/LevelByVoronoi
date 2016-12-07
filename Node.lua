local Class = require("class.lua")

local Node = {}
Node = Class.create("Node", Entity)

function Node:init(id, x, y, diff, isCenter)
	self.id = id
	
	self.x = x
	self.y = y
	
	self.isCenter = isCenter

	self.edges = {}
	self.neighbors = {}

	
	-- for the centers:
	self.members = {}
	self.districtDifficulty = diff;
	self.distPrevDifficulty = nil;
	
	--For just this node
	-- self.prevDifficulty = diff;
	self.mDifficulty = diff;
	
	self.currentClosest = nil;
end

function Node:clearDistrictDiff()
	if self.isCenter
		self.districtDifficulty = self.mDifficulty;
	end
end

function Node:addNeighbor( newNeighbor ,edge)
	table.insert(self.neighbors,newNeighbor)
	self.edges[newNeighbor] = edge
end

return Node

