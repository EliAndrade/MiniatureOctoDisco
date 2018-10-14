local _ = {}

_.scale = 1
_.minScale = 0.5
_.maxScale = 3.75

function _:reset()
	self.scale = 1
end 

function _:getScale()
	return self.scale
end

function _:getBounds()
	return self.minScale, self.maxScale
end

function _:setScale(scale)
	if scale >= self.minScale then
		self.scale = scale
	elseif scale < self.minScale then
		self.scale = self.minScale
	end
	
	if scale < self.maxScale then
		self.scale = scale
	elseif scale > self.maxScale then
		self.scale = self.maxScale
	end
end

return _