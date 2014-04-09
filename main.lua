system.activate("multitouch")


local background = display.newImage( "background1.jpg" )

background.width = display.contentWidth
background.height = display.contentHeight
background.x = display.contentWidth/2
background.y = display.contentHeight/2

local william = display.newImage( "william.png" )

william.width = 200
william.height = 130
william.x = 100
william.y = 100
william.readyToThrow = true

local elliot = display.newImage( "elliot.png" )

elliot.width = 220
elliot.height = 180
elliot.x = 100
elliot.y = 300

local boomerang = display.newImage( "boomerang2.png" )

boomerang.thrown = false
boomerang.width = 50
boomerang.height = 50
boomerang.x = 500
boomerang.y = 500

local iceShots = {}

local function moveAllIceShots()
    for name, object in pairs(iceShots) do
        if object then
            local magnitudeLololo = 6
            object.x = object.x + (object.vector[1] * magnitudeLololo)
            object.y = object.y + (object.vector[2] * magnitudeLololo)
            
            if object.x > 900 or object.x < 100 or object.y < 100 or object.y > 700 then
                object:removeSelf()
                iceShots[name] = nil
            end
        end
    end
end

local function touch_william(actor, event)
    if event.phase == "began" then
        
        display.getCurrentStage():setFocus( actor, event.id )
        
        if boomerang.thrown == false and actor.readyToThrow then
            actor.readyToThrow = false
            boomerang.thrown = true
            boomerang.timer = 0
            boomerang.x = actor.x
            boomerang.y = actor.y
        end
    elseif event.phase == "moved" then
        actor.x = event.x
        actor.y = event.y
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus( actor, nil )
        actor.readyToThrow = true
    end
end

local function touch_elliot(actor, event)
    if event.phase == "began" then
        
        display.getCurrentStage():setFocus( actor, event.id )
        
        local iceShotVectors = {
            {-1,-1},
            {1, -1},
            {1, 1},
            {-1, 1},
        }
        for i = 1, 4 do
            local iceShot = display.newImage("boomerang.png")
            iceShot.width = 20
            iceShot.height = 20
            iceShot.x = actor.x
            iceShot.y = actor.y
            iceShot:setFillColor(0,0,0.5)
            iceShot.vector = iceShotVectors[i]
            table.insert(iceShots, iceShot)
        end
    elseif event.phase == "moved" then
        actor.x = event.x
        actor.y = event.y
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus( actor, nil )
    end
end

william.touch = touch_william
william:addEventListener("touch", william)

elliot.touch = touch_elliot
elliot:addEventListener("touch", elliot)


local function distance(object1, object2)
    local xDist
    local yDist
    if object1.x > object2.x then
        xDist = object1.x - object2.x 
    else
        xDist = object2.x - object1.x 
    end
    if object1.y > object2.y then
        yDist = object1.y - object2.y 
    else
        yDist = object2.y - object1.y 
    end
    return math.sqrt((xDist * xDist) + (yDist * yDist))
end

local function animateBoomerang()
    if boomerang.thrown then
        boomerang.timer = boomerang.timer + 1
        
        boomerang.rotation = boomerang.rotation + 20
        
        if boomerang.timer < 30 then
            boomerang.x = boomerang.x + 14
            boomerang.y = boomerang.y - 2
        else
            boomerang.x = boomerang.x + (william.x - boomerang.x) * (boomerang.timer / 1000)
            boomerang.y = boomerang.y + (william.y - boomerang.y) * (boomerang.timer / 1000)
        end
        
        if distance(boomerang, william) < 100 and boomerang.timer > 30 then
            boomerang.thrown = false
        end
        
    else
        boomerang.rotation = 20
        boomerang.x = william.x - 45
        boomerang.y = william.y - 50
    end
    
end

local function enterFrame()
    animateBoomerang()
    moveAllIceShots()
end

Runtime:addEventListener("enterFrame", enterFrame)
