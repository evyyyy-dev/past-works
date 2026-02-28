-- ======================= --
-- Generator Module (Snippet)
-- This snippet demonstrates the placement algorithm and failure recovery logic.
-- ========================================================================== --

-- Checks whether a room would collide if placed at targetCFrame.
-- Uses bounding box projection and a shrink multiplier for leniency.
function Generator:_CheckCollisions(roomModel: Model, targetCFrame: CFrame)
	local bboxCFrame, bboxSize = roomModel:GetBoundingBox()
	local bboxOffset = roomModel.PrimaryPart.CFrame:ToObjectSpace(bboxCFrame)

	local collisionCFrame = targetCFrame * bboxOffset

	local parts = workspace:GetPartBoundsInBox(
		collisionCFrame,
		 -- Shrink to make collisions less strict
		bboxSize * COLLISION_SHRINK_MULT
	)

	return #parts > 0
end

-- Attempts to place a room at the next generation index.
-- Handles connector alignment, collision validation, and state updates.
-- @return boolean – true when successfully placed
function Generator:_TryRoom(room, id)
	local roomModel: Model = roomsFolder:FindFirstChild(room)

	if not roomModel then
		warn(`[Generator] Couldn't find room "{room}" inside of the Rooms Folder!`)
		return
	end
	
	local previousRoom = self.newestRoom

	if not previousRoom then
		local roomClone: Model = roomModel:Clone()
		roomClone.Parent = sharedModule.loadedRoomsFolder
		roomClone.Name = string.format("%03d_%s", id, roomClone.Name)
		
		self.RoomsLeftToGenerate -= 1
		self.newestRoom = roomClone
		table.insert(self.placedRooms, roomClone)
		return true
	end

	local prevEndConnector = previousRoom:FindFirstChild("Connectors") and previousRoom.Connectors:FindFirstChild("EndConnector")
	local newStartConnector = roomModel:FindFirstChild("Connectors") and roomModel.Connectors:FindFirstChild("StartConnector")

	if not prevEndConnector then
		warn(`[Generator] Previous room "{previousRoom.Name}" doesn't have endConnector!`)
		return false
	end

	if not newStartConnector then
		warn(`[Generator] Room "{roomModel.Name}" doesn't have a startConnector!`)
		return false
	end
	
	local offset = roomModel.PrimaryPart.CFrame:ToObjectSpace(newStartConnector.CFrame)
	-- Align new room's StartConnector to the previous room's EndConnector
	local targetCFrame = prevEndConnector.CFrame * CFrame.new(0, 0, -prevEndConnector.Size.Z) * offset:Inverse()
	local isColliding = self:_CheckCollisions(roomModel, targetCFrame)
	if isColliding then	return false end
	
	local roomClone: Model = roomModel:Clone()
	roomClone.Parent = sharedModule.loadedRoomsFolder
	roomClone.Name = string.format("%03d_%s", id, roomClone.Name)
	roomClone:PivotTo(targetCFrame)

	self.newestRoom = roomClone
	self.RoomsLeftToGenerate -= 1
	table.insert(self.placedRooms, roomClone)
	
	return true
end

-- Main deterministic generation loop.
-- Selects weighted rooms, tracks failed attempts per index,
-- and performs backtracking when placement fails.
-- Terminates when MAX_RETRIES is exceeded.
function Generator:_GenerationLoop()
	print("[INFO] Started generating!")
	local startTime = os.clock()

	while self.RoomsLeftToGenerate > 0 do
		task.wait()
		local index = self.TotalRooms - self.RoomsLeftToGenerate

		if not self.triedRooms[index] then
			self.triedRooms[index] = {}
		end

		local forced = self.forcedRooms[index]
		if forced and not self:_TryRoom(forced, index) then
			self:_Backtrack(BACKTRACK_AMOUNT, index)
		end

		if forced then continue end

		local availableRooms = {}
		for name, weight in pairs(self.RoomChances) do
			if self.triedRooms[index][name] then continue end
			availableRooms[name] = weight
		end

		local nextRoom = self:_PickNextRoom(availableRooms)
		if nextRoom and self:_TryRoom(nextRoom, index) then
			continue
		end

		if nextRoom then
			self.triedRooms[index][nextRoom] = true
		end

		local triedCount = 0
		local totalCount = 0
		
		for _ in pairs(self.triedRooms[index]) do triedCount += 1 end
		for _ in pairs(self.RoomChances) do totalCount += 1 end

		if triedCount < totalCount then
			continue
		end
		
		--Prevent infinite backtracking loops at the same index
		self.backtrackCount[index] = (self.backtrackCount[index] or 0) + 1

		if self.backtrackCount[index] >= MAX_RETRIES then
			warn(`[Generator] Max retries reached at index {index}, generation has failed!`)
			return
		end

		self:_Backtrack(BACKTRACK_AMOUNT, index)
	end
	
	print(string.format("[INFO] Finished generating in %.5fs!",
		os.clock() - startTime
	))
end

