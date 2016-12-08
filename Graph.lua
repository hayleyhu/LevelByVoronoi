local Class = require("class.lua")

local Graph = Class.create("Graph", Entity)

function Graph:init(NodeList)
	self.nodeList = NodeList
	self.mean_Diff = calculate_mean_diff(self.nodeList)
end

return Graph