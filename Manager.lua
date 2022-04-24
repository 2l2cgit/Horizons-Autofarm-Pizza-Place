local Players = game:GetService("Players")
local player = Players.LocalPlayer
local humanoid = player.Character.Humanoid
local mteam = game:GetService("Teams").Manager
local man = mteam:GetPlayers()[1]
--deletes a glitchy chair in the office (optional)
if workspace:FindFirstChild("ExtraChair") and workspace.ExtraChair:FindFirstChild("Seat") then
	workspace.ExtraChair.Seat:Destroy()
end

if man then
	--check if he's respawning or sitting
	local htxt
	if man.Character==nil or man.Character:FindFirstChild("HumanoidRootPart")==nil or man.Character:FindFirstChild("Humanoid")==nil then
		htxt = "Failed because manager is respawning"
	end
	local target = man.Character.HumanoidRootPart
	if man.Character.Humanoid.Sit then
		htxt = "Failed because manager is sitting"
	end
	if htxt then
		local h = Instance.new("Hint",workspace)
		h.Text = htxt
		wait(3)
		h:Destroy()
		return
	end
	--get in a car
	if not workspace.Cars:IsAncestorOf(humanoid.SeatPart) then
		humanoid.Jump=true
		wait(0.1)
		for _,car in ipairs(workspace.Cars:GetChildren()) do
			if car:FindFirstChild("Driver") and car.Driver.Occupant==nil and car:FindFirstChild("Owner") and car.Owner.Value==nil then
				car.Driver:Sit(humanoid)
				wait(0.3)
				if humanoid.SeatPart then
					break
				end
			end
		end
	end
	local seat = humanoid.SeatPart
	local car = seat.Parent
	local returncf = CFrame.new(14,-4.5,21)*CFrame.Angles(0,math.pi/2,0)
	for j=1,4 do
		--attempt to sit manager
		seat.Anchored=false
		local e = 0
		while car.HoodSeat.Occupant==nil and mteam:GetPlayers()[1] and target.Parent and e<5 do
			local newpos = target.Position+Vector3.new(0,-3,0)+target.CFrame.lookVector*5.5+target.Velocity*.7
			local flatdir = (target.CFrame.lookVector*Vector3.new(1,0,1)).Unit --target's looking direction, flattened
			if not (flatdir.x < 2) then --inf
				flatdir = Vector3.new(1,0,0)
			end
			car:SetPrimaryPartCFrame(CFrame.new(newpos,newpos-flatdir))
			seat.Velocity=Vector3.new()
			local e2=0
			while car.HoodSeat.Occupant==nil and mteam:GetPlayers()[1] and target.Parent and e2<0.7 do
				e2=e2+wait()
			end
			e=e+e2
		end
		--attempt to move manager
		car:SetPrimaryPartCFrame(returncf)
		wait(.1)
		car:SetPrimaryPartCFrame(returncf)
		seat.Anchored=true
		e = 0
		while mteam:GetPlayers()[1] and target.Parent and e<1 do
			e=e+wait()
		end
		car.HoodSeat:ClearAllChildren() --unsits anyone
		e = 0
		while mteam:GetPlayers()[1] and target.Parent and e<0.5 do
			e=e+wait()
		end
		if mteam:GetPlayers()[1]==nil or target.Parent==nil then
			break
		end
	end
	--reset car
	seat.Anchored=false
	wait()
	car:SetPrimaryPartCFrame(CFrame.new(120,10,-75))
	wait()
end

--become manager
humanoid.Jump=true
wait(0.1)
pcall(function() workspace.ManagerChair.Seat:Sit(humanoid) end)
wait(0.3)
humanoid.Jump=true
wait(0.1)
player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame+Vector3.new(5,5,6)