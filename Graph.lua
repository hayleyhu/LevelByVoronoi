local Class = require("class.lua")

local Graph = Class.create("Graph", Entity)

function Graph:init(NodeList, EdgeList)
	self.NodeList = NodeList
	self.EdgeList = EdgeList
	self.mean_Diff = calculate_mean_diff(NodeList)
end

return Graph