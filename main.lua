function love.load()
	love.mouse.setGrabbed(true)
	numberFont = love.graphics.newFont("theboldfont.ttf", 32)
	numberFontSmall = love.graphics.newFont("theboldfont.ttf", 24)
	
	Time = require "Time"
	Platform = require "Platform"
	Arrow = require "Arrow"
	
	platform = Platform:new(100, 400)
	arrows = {}	
	
	CIRCLE_SPEED = 50
	CIRCLE_MAXIMUM_SIZE = 64
		
	RECTANGLE_SPEED = 5
	
	MIN_ARROW_SPEED = 100
	MAX_ARROW_SPEED = 150
	
	TIMER_START = 5
	
	
	score = 0
	bestScore = 0

	timeToNextArrow = TIMER_START
	timer = 0
	
	circles = {}
	rectangles = {}
	
	
	canvas = love.graphics.newCanvas(400, 600)
	text = love.graphics.newText(numberFont, "<-Slower    Faster->")
	
	
	
	
	catchSound = love.audio.newSource("catch.mp3", "static")
	clickSound = love.audio.newSource("C.wav", "static")
	
end

function overlaps(x1, y1, w1, h1, x2, y2, w2, h2)
  	return 	x1 < x2+w2 and
    		x2 < x1+w1 and
  	  		y1 < y2+h2 and
   			y2 < y1+h1
end



function restart()
	collectgarbage()
	if score > bestScore then
		bestScore = score
	end
	score = 0
	timer = 0
	timeToNextArrow = TIMER_START
	arrows = {}
end

local toBeRemoved = {}
function love.update(dt)
	platform:update(Time:getScale()*dt)
	
	
	for i, arrow in ipairs(arrows) do
		if arrow:update(dt) then
			restart()
		end
		
		local x1, y1, w1, h1 = arrow:getBoundingBox()
		local x2, y2, w2, h2 = platform:getBoundingBox()
		
		if overlaps(x1, y1, w1, h1, x2, y2, w2, h2) then
			table.insert(toBeRemoved, i)
			table.insert(rectangles, {x = x1, y = y1, w = w1, h = h1, color = 0.4})
			catchSound:stop()
			catchSound:play()
			score = score + 1
			if score > bestScore then
				bestScore = score
			end
		end
	end	
	
	for i = #toBeRemoved, 1, -1 do
		table.remove(arrows, toBeRemoved[i])
		table.remove(toBeRemoved, i)
	end
	
	for i, circle in ipairs(circles) do
		circle.radius = circle.radius - CIRCLE_SPEED*dt
		if circle.radius <= 0 then
			table.insert(toBeRemoved, i)
		end
	end
	
	for i = #toBeRemoved, 1, -1 do
		table.remove(circles, toBeRemoved[i])
		table.remove(toBeRemoved, i)
	end
	
	for i, rectangle in ipairs(rectangles) do
		rectangle.color = rectangle.color - RECTANGLE_SPEED*dt
		if rectangle.color <= 0 then
			table.insert(toBeRemoved, i)
		end
	end
	
	for i = #toBeRemoved, 1, -1 do
		table.remove(rectangles, toBeRemoved[i])
		table.remove(toBeRemoved, i)
	end
	
	
	timer = timer - dt
	if timer < 0 then
		timer = timeToNextArrow
		table.insert(arrows, Arrow:new(love.math.random(16, love.graphics.getWidth()-Arrow.width-16), 
			-Arrow.height, love.math.random(MIN_ARROW_SPEED, MAX_ARROW_SPEED)))
	end
	
end

function love.draw()
	local oldFont = love.graphics.getFont()
	love.graphics.setBackgroundColor(1, 205/255, 124/255)
	
	
	
	love.graphics.draw(text, love.graphics.getWidth()/2-text:getWidth()/2, 550)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.setFont(numberFont)
	love.graphics.printf(score, 0, 50, love.graphics.getWidth(), "center")
	love.graphics.setFont(numberFontSmall)
	love.graphics.printf(bestScore, 0, 80, love.graphics.getWidth(), "center")
	platform:draw()
	for i, arrow in ipairs(arrows) do
		arrow:draw()
	end
	
	

	love.graphics.setCanvas()
	for i,rectangle in ipairs(rectangles) do
		love.graphics.setColor(0.1, 0.1, 0.1, rectangle.color)
		love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
		
	end
	
	love.graphics.setColor(1, 1, 1, 1)
	for i, circle in ipairs(circles) do
		love.graphics.circle("line", circle.x, circle.y, circle.radius)
	end
	
	
	love.graphics.setColor(0.1, 0.1, 0.1, 0.1)
	love.graphics.draw(canvas, 5, 5)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(canvas, 0, 0)
	love.graphics.setFont(numberFont)
	love.graphics.printf(score, 0, 50, love.graphics.getWidth(), "center")
	love.graphics.setFont(numberFontSmall)
	love.graphics.printf(bestScore, 0, 80, love.graphics.getWidth(), "center")
	
	love.graphics.setFont(oldFont)
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local min, max = Time:getBounds()
		scale = (x*(max-min))/(love.graphics.getWidth())+min
		Time:setScale(scale)
		table.insert(circles, {x = x, y = y, radius = CIRCLE_MAXIMUM_SIZE/scale})
		clickSound:stop()
		clickSound:setPitch(((x+1)/love.graphics.getWidth())+2)
		clickSound:play()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	end
end