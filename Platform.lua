local _ = {}

_.width = 100
_.height = 16
_.x = 0
_.y = 500
_.screenWidth = 600
_.screenHeight = 800
_.speed = 100

function _:new(width, screenWidth)
	local o = {}
	setmetatable(o, {__index = self})
	o.screenWidth = screenWidth
	o.width = width
	o.x = (screenWidth/2)-(width/2)
	return o
end

function _:setSpeed(speed)
	return self.speed
end

function _:getSpeed(speed)
	self.speed = speed
end

function _:getBoundingBox()
	return self.x, self.y, self.width, self.height
end


function _:update(dt)
	self.x = self.x + self.speed*dt
	
	if self.x >= self.screenWidth - self.width then
		self.x = 2*self.screenWidth - 2*self.width - self.x 
		self.speed = - self.speed
	end
	
	if self.x <= 0 then
		self.x = -self.x
		self.speed = - self.speed
	end
end

function _:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return _
