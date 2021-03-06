-----------------------------------------------------------------------------------------
--
-- settings.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local o=require("Loptions")
local lc=require("Llocale")
local gsm
local curname=1
local window
local snap=1
local names={
		"LOC009","LOC010","LOC011","LOC012","LOC013","LOC014","LOC015","LOC016",
	}
local info={
		-- Gold
		{"demogold.png",140,50},
		-- HP
		{"demohealth.png",140,50},
		-- MP
		{"demomana.png",140,50},
		-- EP
		{"demoenergy.png",140,50},
		-- Unspent point
		{"unspent.png",240,80},
		-- XP Bar
		{"demoxp.png",392,40},
		-- Quest
		{"demoquest.png",447,80},
		-- Pause Button
		{"pauseon.png",84.5,84.5},
	}
local positions={
		-- Gold
		{75,10,0},
		-- HP
		{100,display.contentHeight-180,0},
		-- MP
		{100,display.contentHeight-120,0},
		-- EP
		{100,display.contentHeight-60,0},
		-- Unspent point
		{display.contentWidth-210,display.contentHeight-45},
		-- XP Bar
		{384,142,0},
		-- Quest
		{display.contentWidth-225,40},
		-- Pause Button
		{display.contentWidth-(70/2*1.3),display.contentHeight-(70/2*1.3)},
	}
local defaults={
		-- Gold
		{75,10,0},
		-- HP
		{100,display.contentHeight-180,0},
		-- MP
		{100,display.contentHeight-120,0},
		-- EP
		{100,display.contentHeight-60,0},
		-- Unspent point
		{display.contentWidth-210,display.contentHeight-45},
		-- XP Bar
		{(display.contentWidth/2)+180,27,0},
		-- Quest
		{display.contentWidth-225,40},
		-- Pause Button
		{display.contentWidth-(70/2*1.3),display.contentHeight-(70/2*1.3)},
	}

function Get(element)
	return positions[element+1]
end

function Start()
	Runtime:addEventListener("touch",Moved)
	gsm=display.newGroup()
	window={}
	
	block=display.newImageRect("cblocked.png",653,653)
	block.x=display.contentCenterX
	block.y=display.contentCenterY
	gsm:insert(block)
	
	prevtxt=display.newText(lc.giveText("LOC020"),0,0,"MoolBoran",55)
	prevtxt.x=display.contentCenterX-180
	prevtxt.y=display.contentCenterY+50
	prevtxt:addEventListener("tap",doPrev)
	prevtxt:setFillColor(125/255,125/255,250/255)
	gsm:insert(prevtxt)
	
	resttxt=display.newText(lc.giveText("LOC021"),0,0,"MoolBoran",55)
	resttxt.x=display.contentCenterX
	resttxt.y=display.contentCenterY+50
	resttxt:addEventListener("tap",doReset)
	resttxt:setFillColor(125/255,125/255,250/255)
	gsm:insert(resttxt)
	
	backtxt=display.newText(lc.giveText("LOC008"),0,0,"MoolBoran",65)
	backtxt.x=display.contentCenterX
	backtxt.y=display.contentCenterY+200
	backtxt:addEventListener("tap",doBack)
	backtxt:setFillColor(180/255,180/255,180/255)
	gsm:insert(backtxt)
	
	nexttxt=display.newText(lc.giveText("LOC022"),0,0,"MoolBoran",55)
	nexttxt.x=display.contentCenterX+180
	nexttxt.y=display.contentCenterY+50
	nexttxt:addEventListener("tap",doNext)
	nexttxt:setFillColor(125/255,125/255,250/255)
	gsm:insert(nexttxt)
	
	for s=1,table.maxn(names) do
		window[s]=display.newImageRect(info[s][1],info[s][2],info[s][3])
		window[s].x=positions[s][1]
		if s>=1 and s<=4 then
			window[s].y=positions[s][2]+30
		else
			window[s].y=positions[s][2]
		end
		if curname~=s then
			window[s]:setFillColor(100/255,100/255,100/255,100/255)
		end
		gsm:insert(window[s])
	end
	
	Windows()
	
	timer.performWithDelay(100,Interface)
end

function doNext()
	curname=curname+1
	if curname>table.maxn(names) then
		curname=1
	end
	Interface()
end

function doPrev()
	curname=curname-1
	if curname<1 then
		curname=table.maxn(names)
	end
	Interface()
end

function doReset()
	local thex=defaults[curname][1]
	local they=defaults[curname][2]
	local thez=defaults[curname][3]
	positions[curname][1]=thex
	positions[curname][2]=they
	positions[curname][3]=thez
	Windows()
	Interface()
end

function Windows()
	for s=table.maxn(names),1,-1 do	
		display.remove(window[s])
		window[s]=nil
	end
	for s=1,table.maxn(names) do
		window[s]=display.newImageRect(info[s][1],info[s][2],info[s][3])
		window[s].x=positions[s][1]
		if s>=1 and s<=4 then
			window[s].y=positions[s][2]+30
		else
			window[s].y=positions[s][2]
		end
		if curname~=s then
			window[s]:setFillColor(100/255,100/255,100/255,100/255)
		end
		gsm:insert(window[s])
	end
end

function doBack()
	Runtime:removeEventListener("touch",Moved)
	for i=gsm.numChildren,1,-1 do
		local child = gsm[i]
		child.parent:remove( child )
	end
	Save()
	o.DisplayOptions()
end

function Interface()
	display.remove(selected)
	selected=nil
	display.remove(alwaysV)
	alwaysV=nil
	display.remove(alwaysV2)
	alwaysV2=nil
	display.remove(alwaysV3)
	alwaysV3=nil
	display.remove(snap1)
	snap1=nil
	display.remove(snap2)
	snap2=nil
	display.remove(snap3)
	snap3=nil
	
	selected=display.newText(( lc.giveText(names[curname]) ),0,0,"MoolBoran",70)
	selected.x=display.contentCenterX
	selected.y=display.contentCenterY-100
	selected:setFillColor(230/255,230/255,230/255)
	gsm:insert(selected)
	
	if curname==1 or curname==2 or curname==3 or curname==4 or curname==6 then
		alwaysV3=display.newRect(0,0,400,50)
		alwaysV3.x=display.contentCenterX
		alwaysV3.y=display.contentCenterY-60
		alwaysV3:setFillColor(1,1,1,0.01)
		alwaysV3:addEventListener("tap",doVisible)
		gsm:insert(alwaysV3)
		
	
		alwaysV=display.newText(lc.giveText("LOC017"),0,0,"MoolBoran",60)
		alwaysV.x=display.contentCenterX-45
		alwaysV.y=display.contentCenterY-50
		alwaysV:setFillColor(180/255,180/255,180/255)
		gsm:insert(alwaysV)
		
		if positions[curname][3]==0 then
			alwaysV2=display.newText(lc.giveText("LOC018"),0,0,"MoolBoran",60)
			alwaysV2.x=display.contentCenterX+120
			alwaysV2.y=alwaysV.y
			alwaysV2:setFillColor(255/255,125/255,125/255)
			gsm:insert(alwaysV2)
		else
			alwaysV2=display.newText(lc.giveText("LOC019"),0,0,"MoolBoran",60)
			alwaysV2.x=display.contentCenterX+120
			alwaysV2.y=alwaysV.y
			alwaysV2:setFillColor(125/255,255/255,125/255)
			gsm:insert(alwaysV2)
		end
	end
	
	snap3=display.newRect(0,0,400,50)
	snap3.x=display.contentCenterX
	snap3.y=display.contentCenterY+100
	snap3:setFillColor(1,1,1,0.01)
	snap3:addEventListener("tap",doSnap)
	gsm:insert(snap3)
	
	snap1=display.newText(lc.giveText("LOC023"),0,0,"MoolBoran",60)
	snap1.x=display.contentCenterX-45
	snap1.y=display.contentCenterY+110
	snap1:setFillColor(180/255,180/255,180/255)
	gsm:insert(snap1)
	
	if snap==0 then
		snap2=display.newText(lc.giveText("LOC018"),0,0,"MoolBoran",60)
		snap2.x=display.contentCenterX+120
		snap2.y=snap1.y
		snap2:setFillColor(255/255,125/255,125/255)
		gsm:insert(snap2)
	else
		snap2=display.newText(lc.giveText("LOC019"),0,0,"MoolBoran",60)
		snap2.x=display.contentCenterX+120
		snap2.y=snap1.y
		snap2:setFillColor(125/255,255/255,125/255)
		gsm:insert(snap2)
	end
	
	for s=1,table.maxn(names) do
		if curname~=s then
			window[s]:setFillColor(100/255,100/255,100/255,100/255)
		else
			window[s]:setFillColor(255/255,255/255,255/255,255/255)
		end
	end
	
end

function doVisible()
	if positions[curname][3]==1 then
		positions[curname][3]=0
	else
		positions[curname][3]=1
	end
	Interface()
end

function doSnap()
print "!!"
	if snap==1 then
		snap=0
	else
		snap=1
	end
	Interface()
end

function Moved( event )
	if (window[curname]) then
		if event.y>800 or event.y<200 then
			window[curname].x=event.x
			if snap==1 then
				for s=1,table.maxn(names) do
					if curname~=s then
						if window[curname].x+10>window[s].x and window[curname].x-10<window[s].x then
							window[curname].x=window[s].x
						end
					end
				end
				if window[curname].x+10>display.contentCenterX and window[curname].x-10<display.contentCenterX then
					window[curname].x=display.contentCenterX
				end
			end
			positions[curname][1]=window[curname].x
			local uno=(info[curname][3]/2)
			if event.y+uno<(display.contentCenterY-(610/2)) or event.y-uno>(display.contentCenterY+(610/2)) then
				window[curname].y=event.y
				if curname>=1 and curname<=4 then
					window[curname].y=event.y+30
				else
					window[curname].y=event.y
				end
				if snap==1 then
					for s=1,table.maxn(names) do
						if curname~=s then
							if window[curname].y+10>window[s].y and window[curname].y-10<window[s].y then
								window[curname].y=window[s].y
							end
						end
					end
				end
				if curname>=1 and curname<=4 then
					positions[curname][2]=window[curname].y-30
				else
					positions[curname][2]=window[curname].y
				end
			end
		end
	end	
end

function Load()
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "r" )
	if (fh) then
		local Sve={}
		local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
		for line in io.lines( path ) do
			local n=tonumber(line)
			if (n) then
				Sve[#Sve+1]=n
			else
				Sve[#Sve+1]=line
			end
		end
		local count=0
		for p=1,table.maxn(positions) do
			for i=1,table.maxn(positions[p]) do
				count=count+1
				positions[p][i]=Sve[count]
			end
		end
		io.close(fh)
	end
end

function Save()
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	
	for p=1,table.maxn(positions) do
		for i=1,table.maxn(positions[p]) do
			fh:write(positions[p][i],"\n")
		end
	end
	io.close( fh )
	
	
end

function WipeSave()
	local path = system.pathForFile(  "DoGSettings.stn", system.DocumentsDirectory )
	local fh, errStr = io.open( path, "w+" )
	fh:write("")
	io.close( fh )
end 