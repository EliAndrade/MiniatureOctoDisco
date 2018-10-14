local _ = {}
_.x = 0
_.y = 0
_.speed = 0
_.width = 16
_.height = 32

_.screenWidth = 400
_.screenHeight = 600

function _:new(x, y, speed)
	local o = {}
	setmetatable(o, {__index = self})
	o.x = x
	o.y = y
	o.speed = speed
	return o
end

function _:update(dt)
	local touchedEnd = false
	self.y = self.y + self.speed*dt
	--
	if self.y >= _.screenHeight then
		touchedEnd = true
	end
	
	return touchedEnd
end

function _:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function _:getBoundingBox()
	return self.x, self.y, self.width, self.height
end

return _