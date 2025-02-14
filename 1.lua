local rep = game.ReplicatedStorage
local plr = game.Players.LocalPlayer

local bName
if _G.dodconfig.moveset == "Y0" then
	bName = "Brawler"
else
	bName = "Ouryu"
end

local ME = rep.Events.ME
local styles = rep.Styles
local rush = styles.Rush
local brawler = styles.Brawler
local beast = styles.Beast
local moves = rep.Moves
local char = plr.Character
local pgui = plr.PlayerGui
local status = plr.Status
local interf = pgui.Interface
local Main = interf.Battle.Main
local rStrike9 = 0
local cas = game:GetService("ContextActionService")
local uis = game:GetService("UserInputService")
local rHact = Instance.new("BoolValue", status)

local humanoidRootPart = char.HumanoidRootPart
local humanoid = char.Humanoid
local animator = humanoid:FindFirstChildOfClass("Animator")

local rds = Instance.new("BoolValue", status)

--set voicepack
local voiceset = rep.Voices:FindFirstChild(_G.dodconfig.useVoice)

--notification event
local function sendNotification(text, color, stroke, sound)
	local upper = string.upper(text)
	-- Fire the notification event
	if sound then
		pgui["Notify"]:Fire(text, sound)
	else
		pgui["Notify"]:Fire(text)
	end
	-- If color is not provided, default to white
	if not color then
		color = Color3.new(1, 1, 1)
	end

	if not stroke then
		stroke = Color3.new(0, 0, 0)
	end

	-- Listen for when a new child is added to NotifyUI.Awards
	for i, v in ipairs(pgui.NotifyUI.Awards:GetChildren()) do
		if v.Name == "XPEx" and v.Text == upper then
			v.Text = text
			v.TextColor3 = color
			v.TextStrokeColor3 = stroke
			v.Text = text
			if v.Text == "Feel the HEAT!!" then
				v.Font = Enum.Font.PermanentMarker
			end
		end
	end
end

if _G.dodconfig.moveset ~= "Y0" and _G.dodconfig.moveset ~= "DE" then
	sendNotification("BRAWLER MOVESET IS INVALID", Color3.new(1, 0, 0), Color3.new(0, 0, 0), "buzz")
	return
end

if rep:FindFirstChild("Dragon") then
	sendNotification("SCRIPT IS ALREADY LOADED", Color3.new(1, 0, 0), Color3.new(0, 0, 0), "buzz")
	return
end

if not _G.dodconfig.rushMoveset then
	_G.dodconfig.rushMoveset = "Y0"
	sendNotification("_G.dodconfig.rushMoveset not found,\nset to Y0 as default.", Color3.new(1, 0, 0), Color3.new(0, 0, 0))	
end

--replace move
local function addMove(name, style, value)
	if game.ReplicatedStorage.Styles[style]:FindFirstChild(name) then
		v = game.ReplicatedStorage.Styles[style][name]
	else
		v = Instance.new("StringValue", game.ReplicatedStorage.Styles[style])
	end

	v.Value = value

	v.Name = name
end

--style replace
local function replaceStyle(oldStyle, newStyle)
	for _, val in ipairs(styles[newStyle]:GetChildren()) do
		if not styles[oldStyle]:FindFirstChild(val.Name) then
			local cloneVal = val:Clone()
			cloneVal.Name = val.Name
			cloneVal.Parent = styles[oldStyle]
		else
			if val:IsA("StringValue") then
				styles[oldStyle][val.Name].Value = val.Value
			elseif val:IsA("Animation") then
				styles[oldStyle][val.Name].AnimationId = val.AnimationId
			end
		end
	end

	for _, val in ipairs(styles[oldStyle]:GetChildren()) do
		if not val:IsA("Animation") and not styles[newStyle]:FindFirstChild(val.Name) then
			val:Destroy()
		end
	end
end

sendNotification("REAL LEGENDS PLAY UNMODDED", Color3.new(1, 0, 0), Color3.new(0, 0, 0), "HeatDepleted")

local function fillHeat(howmany)
	for i = 1, howmany , 1 do
		local A_1 = {
			[1] = "heat",
			[2] = game:GetService("ReplicatedStorage").Moves.Taunt
		}
		ME:FireServer(A_1)
	end
end

local function depleteHeat(howmany)
	for i = 1, howmany , 1 do
		local A_2 = {
			[1] = {
				[1] = "evade",
				[3] = false,
				[4] = true
			}
		}
		ME:FireServer(unpack(A_2))
	end
end

function UseHeatAction(HeatAction, Style, Bots)
	-- Script generated by SimpleSpy - credits to exx#9394

	local args = {
		[1] = {
			[1] = "heatmove",
			[2] = game:GetService("ReplicatedStorage").Moves[HeatAction],
			[3] = {},
			[4] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
			[5] = Style
		}
	}

	for i, v in ipairs(Bots) do
		table.insert(
			args[1][3], {
			[1] = v,
			[2] = 10.49982091806829,
			[3] = false,
			[4] = Vector3.new(0.854888916015625, - 0.499908447265625, - 3.08367919921875)
		})
	end

	game:GetService("ReplicatedStorage").Events.ME:FireServer(unpack(args))
end

local function anger()
	local anger = {
		[1] = {
			[1] = "anger"
		}
	}

	ME:FireServer(unpack(anger))
end

local function noanger()
	local noanger = {
		[1] = {
			[1] = "noanger"
		}
	}

	ME:FireServer(unpack(noanger))
end

if char.Head:FindFirstChild("HeavyYell") then
	char.Head.HeavyYell:Destroy()
end

-- rplaysoundlolhehehahaw
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Ambassador = require(ReplicatedFirst.Ambassador)
local Variables = require(ReplicatedFirst.Variables)
local SoundModule = require(ReplicatedStorage.Modules.Sound)

local function deflect(bot, move)
	local humanoidRootPart = bot:FindFirstChild("HumanoidRootPart")
	local botPosition = humanoidRootPart.Position
	local lookVector = humanoidRootPart.CFrame.LookVector
	local args = {
		[1] = "damage",
		[3] = humanoidRootPart,
		[4] = botPosition,
		[5] = move,
		[6] = "Brawler"
	}

	ME:FireServer(args)
end

local function PlaySound(SoundName) -- rplaysound
	SoundModule.playsound(ReplicatedStorage.Sounds[SoundName], Variables.hrp, nil, nil, true)
	ME:FireServer({
		"repsound",
		SoundName
	})
end

local function fetchRandom(instance)
	local instancechildren = instance:GetChildren()
	local random = instancechildren[math.random(1, # instancechildren)]
	return random
end

local function PlayVoice(sound) -- rplaysound
	if _G.dodconfig.voice then
		if char.Head:FindFirstChild("Voice") then
			char.Head.Voice:Destroy()
		end
		
		local soundclone = Instance.new("Sound")
		soundclone.Parent = char.Head
		soundclone.Name = "Voice"
		soundclone.SoundId = sound.Value
		soundclone.Volume = 0.7
		soundclone:Play()
		soundclone.Ended:Connect(
		function()
			game:GetService("Debris"):AddItem(soundclone)
		end)
	end
end

local ts = game:GetService("TweenService")

local function playAnim(anim, pri, spd, dur)
	local animation = Instance.new("Animation", char)
	animation.AnimationId = anim
	local track = humanoid:LoadAnimation(animation)
	track.Priority = Enum.AnimationPriority[pri]
	track:Play()
	
	if spd then
		track:AdjustSpeed(spd)
	end
	
	if dur then
		task.delay(dur, function()
			track:Stop()
			animation:Destroy()
			track:Destroy()
		end)
	end
	
	track.Ended:Connect(function()
		track:Destroy()
		animation:Destroy()
	end)
	
	char.ChildRemoved:Connect(function(c)
		if c.Name == "Heated" then
			track:Stop()
			track:Destroy()
			animation:Destroy()
		end
	end)
end

local function enemyAnim(sub, anim, pri, spd, dur)
	local animation = Instance.new("Animation", char)
	animation.AnimationId = anim
	local track = sub.Humanoid:LoadAnimation(animation)
	track.Priority = Enum.AnimationPriority[pri]
	track:Play()
	
	if spd then
		track:AdjustSpeed(spd)
	end
	
	if dur then
		task.delay(dur, function()
			track:Stop()
			animation:Destroy()
			track:Destroy()
		end)
	end
	
	track.Ended:Connect(function()
		track:Destroy()
		animation:Destroy()
	end)
	
	char.ChildRemoved:Connect(function(c)
		if c.Name == "Heated" then
			track:Stop()
			track:Destroy()
			animation:Destroy()
		end
	end)
end

local function PlaySoundId(sound, part)
	local soundclone = Instance.new("Sound")
	if part then
		soundclone.Parent = char[part]
	else
		soundclone.Parent = char.Head
	end
	soundclone.Name = "sound"
	soundclone.SoundId = sound
	soundclone.Volume = 0.6
	soundclone:Play()
	soundclone.Ended:Connect(
		function()
		game:GetService("Debris"):AddItem(soundclone)
	end)
end

-- player status
local function isInBattle()
	return (plr:FindFirstChild("InBattle") and true or false)
end

local function isDungeon()
	return game.ReplicatedStorage.Dungeon.Value
end

local function doingHact()
	return (char:FindFirstChild("Heated") and true or false)
end

local function showMaxHeatEffect()
	return (isInBattle() and not doingHact() and plr.Status.Heat.Value >= 100) and true or false
end

local function hasWeaponInHand()
	return (char:FindFirstChild("Holding") and true or false)
end

local function angry()
	return (plr.Status:FindFirstChild("ANGRY") and true or false)
end

local function IsInPvp()
	if plr:FindFirstChild("PvPed") then
		return true
	else
		return false
	end
end

local function respawn()
	local oldcframe = char.HumanoidRootPart.CFrame
	interf.Client.Disabled = true
	interf.Client.Disabled = false
	char.HumanoidRootPart.CFrame = oldcframe
end

local torso = char:FindFirstChild("UpperTorso")

if torso then
	-- Create the part to attach
	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1) -- Set size as needed
	part.Anchored = false
	part.CanCollide = false
	part.Parent = char
	part.Name = "Dragon"

	-- Create a Weld constraint to attach it to the torso
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = torso
	weld.Part1 = part
	weld.Parent = part

	-- Position the part relative to the torso
	part.Position = torso.Position -- Adjust as needed for position
	part.Rotation = torso.Rotation

	local mesh = Instance.new("SpecialMesh", part)
	mesh.MeshId = "rbxassetid://13923254523"
	mesh.TextureId = "rbxassetid://13923337347"
end

local yinglong = char.Dragon
yinglong.Transparency = 1

--basic anims
for _, style in ipairs(styles:GetChildren()) do
	local run = Instance.new("Animation", style)
	run.Name = "Run"
	run.AnimationId = brawler.Run.AnimationId
end

if _G.dodconfig.rushMoveset == "7G" then
	rush.Run.AnimationId = "http://www.roblox.com/asset/?id=10921320299"
end

beast.Run.AnimationId = "http://www.roblox.com/asset/?id=10921240218"

brawler.WalkL:Clone().Parent = rush
brawler.WalkB:Clone().Parent = rush
brawler.WalkF:Clone().Parent = rush
brawler.WalkR:Clone().Parent = rush

rush.EvadeL.AnimationId = brawler.EvadeL.AnimationId
rush.EvadeB.AnimationId = brawler.EvadeB.AnimationId
rush.EvadeF.AnimationId = brawler.EvadeF.AnimationId
rush.EvadeR.AnimationId = brawler.EvadeR.AnimationId
rush.EvadeCL.AnimationId = brawler.EvadeL.AnimationId
rush.EvadeCB.AnimationId = brawler.EvadeB.AnimationId
rush.EvadeCF.AnimationId = brawler.EvadeF.AnimationId
rush.EvadeCR.AnimationId = brawler.EvadeR.AnimationId

brawler.SuperEvadeB.AnimationId = beast.EvadeB.AnimationId

--taunts
for _, style in ipairs(styles:GetChildren()) do
	addMove("Taunt", style.Name, "DragonTaunt")
end

rush.Taunt.Value = "RushTaunt"
beast.Taunt.Value = "BeastTaunt"

--replace styles
replaceStyle("Brawler", "堂島の龍")

--style names
rush.VisualName.Value = "Rush"
if _G.dodconfig.rushMoveset == "7G" then
	rush.VisualName.Value = "Agent"
end
beast.VisualName.Value = "Beast"
brawler.VisualName.Value = bName

--style colors
if _G.dodconfig.rushMoveset == "7G" then
	rush.Color.Value = Color3.new(0,1,1)
end

-- rush combos
-- brawler.StanceStrike.Value = "龍GTigerDrop"
if bName == "Ouryu" then
	brawler.Rush3.Value = "BAttack2"
	brawler.Rush4.Value = "FPunch1"
else
	for i = 1, 3 do
		brawler["Rush" .. i].Value = "BAttack" .. i
	end
end

rush.Rush6.Value = "龍Attack4"
rush.Rush7.Value = "BAttack4"

if _G.dodconfig.rushMoveset == "7G" then
	local combos = {
		[1] = "龍Attack1",
		[2] = "BAttack1",
		[3] = "龍Attack1",
		[4] = "龍Attack2",
		[5] = "BAttack2",
		[6] = "RPunch1",
		[7] = "龍Attack3",
		[8] = "RPunch",
		[9] = "FStrike4"
	}
	
	for i = 1, 9 do
		addMove("Rush" .. i, "Rush", combos[i])
	end
end

--finishing blows
brawler.EvadeStrikeB.Value = "RDashAttack"

if _G.dodconfig.rushMoveset == "7G" then
	rush.Strike1.Value = "FPunch1"
	rush.Strike2.Value = "龍Strike5"
	rush.Strike3.Value = "BStrike3"
	rush.Strike4.Value = "龍Strike5"
	rush.Strike5.Value = "MStrike1"
	rush.Strike6.Value = "B2Strike2"
	rush.Strike7.Value = "龍2Strike3"
	rush.Strike8.Value = "RStrike9"
	rush.Strike9.Value = "BTStrike2"
else
	rush.Strike1.Value = "BStrike5"
	rush.Strike2.Value = "FStrike4"
	rush.Strike3.Value = "FStrike4"
	rush.Strike4.Value = "FStrike4"
	rush.Strike5.Value = "FStrike4"
	rush.Strike6.Value = "FStrike4"
	rush.Strike7.Value = "BTStrike2"
	rush.Strike8.Value = "BTStrike2"
	rush.Strike9.Value = "BTStrike2"
end

rush.EvadeStrikeL.Value = "BEvadeStrikeLeft"
rush.EvadeStrikeB.Value = "ParkerDrop"
rush.EvadeStrikeF.Value = "FPunch1"
rush.EvadeStrikeR.Value = "BEvadeStrikeRight"

beast.Strike2.Value = "DashAttack"
beast.Strike3.Value = "BStrike3"
beast.Strike4.Value = "DerekCharge"

if bName == "Ouryu" then
	brawler.Strike2.Value = "BStrike3"
	brawler.Strike3.Value = "B2Strike2"
	brawler.Strike4.Value = "BStrike5"
	brawler.Strike5.Value = "BStrike4"
	brawler["2Strike2"].Value = "B2Strike1"
	brawler["2Strike3"].Value = "BTCounter"
	brawler["2Strike4"].Value = "BStrike4"
	brawler["2Strike5"].Value = "FStrike2"
else
	brawler.Strike4.Value = "BStrike4"
	brawler.Strike5.Value = "FStrike4"
	brawler["2Strike4"].Value = "DashAttack"
	brawler["2Strike5"].Value = "龍2Strike4"
end

-- misc. moves
addMove("GrabStrike", "Brawler", "T_龍GParry")
addMove("DashAttack", "Brawler", "龍2Strike4")
rush.Grab.Value = "BStomp"
rush.DashAttack.Value = "龍2Strike1"
beast.Grab.Value = "Grab"

for i = 1, 4 do
	local Anim = moves["BAttack" .. i].TurnAnim:Clone()
	Anim.Name = "TurnAnim"
	Anim.Parent = moves["龍Attack" .. i]
	Anim.AnimationId = moves["BAttack" .. i].TurnAnim.AnimationId
	local Hitbox = moves["BAttack" .. i].THitboxLocations:Clone()
	Hitbox.Name = "THitboxLocations"
	Hitbox.Parent = moves["龍Attack" .. i]
	Hitbox.Value = moves["BAttack" .. i].THitboxLocations.Value
end

-- headbutt
local function isAnimationPlaying(animator, animationId)
	local playingTracks = animator:GetPlayingAnimationTracks()

	-- Iterate through all currently playing animations
	for _, track in ipairs(playingTracks) do
		if track.Animation.AnimationId == animationId then
			return true
		end
	end
	return false
end

char.ChildAdded:Connect(
	function(child)
	if child.Name == "Heated" then
		local replaceAnim = humanoid:LoadAnimation(moves.BRCounter2.Anim)
		replaceAnim.Priority = Enum.AnimationPriority.Action4
		task.wait(0.016666666666666666)
		if isAnimationPlaying(animator, moves[brawler.HThrow.Value].Anim.AnimationId) then
			replaceAnim:Play()
			replaceAnim:AdjustSpeed(1 / 1.25)
		end
	end
end)

-- hacts
if not IsInPvp() then
	addMove("H_Stunned", "Brawler", "H_GUltimateEssence")
end

addMove("H_GrabStanding", "Brawler", "H_HeadPress")
addMove("H_EvadedF", "Rush", "H_TSpinCounterRight")
addMove("H_EvadedR", "Rush", "H_FrenzySpinCounter")
addMove("H_Standing", "Shotgun", styles.SMG.H_Standing.Value)
addMove("H_Standing", "SMG", styles.Pistol.H_Standing.Value)
addMove("H_Standing", "Rifle", styles.Pistol.H_Standing.Value)
addMove("H_Standing", "Holding", "H_FallenBeatdown")
addMove("H_Standing", "OneHandedHolding", "H_FallenBeatdown")
addMove("H_Fallen", "Holding", styles.OneHandedHolding.H_Fallen.Value)

brawler.H_Distanced:Destroy()
brawler.H_Running4:Destroy()

addMove("H_EvadedF", "Brawler", "H_Escape")

styles.BatHolding.H_Standing.Value = "H_SluggerBat"

--move anims i'm not fucking organizing these
local rushAnims = {
	["RPunch2"] = "龍Attack1",
	["RPunch1"] = "FPunch1",
	["RPunch4"] = "BAttack2",
	["RPunch3"] = "龍Attack2",
	["RPunch5"] = "BAttack3"
}

for i = 1, 5 do
	moves["RPunch" .. i].Anim.AnimationId = moves[rushAnims["RPunch" .. i]].Anim.AnimationId
	moves["RPunch" .. i].HitboxLocations.Value = moves[rushAnims["RPunch" .. i]].HitboxLocations.Value

	if i >= 3 then
		moves["RPunch" .. i].ComboAt.Value = .3
		moves["RPunch" .. i].HitDur.Value = .5
	end

	moves["RPunch5"].ComboAt.Value = .5
end

for i = 1, 4 do
	moves["BAttack" .. i].TurnAnim:Clone().Parent = moves["龍Attack" .. i]
	moves["BAttack" .. i].THitboxLocations:Clone().Parent = moves["龍Attack" .. i]
end

moves["BTStrike4"].Anim.AnimationId = moves["BStrike4"].TurnAnim.AnimationId
moves.BTStrike4.AniSpeed.Value = 1.15
moves.BTStrike4.HitDur.Value = moves["BStrike4"].HitDur.Value
moves.BTStrike4.HSize.Value = moves["龍TigerDrop"].HSize.Value
moves.BTStrike4.SF.Value = 0
moves.BTStrike4.MoveForward.Value = 12

moves["BTStrike2"].Anim.AnimationId = moves["BStrike4"].TurnAnim.AnimationId
moves.BTStrike2.AniSpeed.Value = 1.15
moves.BTStrike2.HitDur.Value = moves["BStrike4"].HitDur.Value
moves.BTStrike2.HitboxLocations.Value = moves.BStrike4.THitboxLocations.Value

if bName == "Ouryu" then
	moves["BStrike4"].Anim.AnimationId = moves["BStrike4"].TurnAnim.AnimationId
	moves["BStrike4"].HitboxLocations.Value = moves.BStrike4.THitboxLocations.Value
	moves.BStrike4.AniSpeed.Value = 1.15
	moves.BStrike4.ComboAt.Value = moves.BStrike4.ComboAt.Value / 1.15
	moves["BTStrike4"].Anim.AnimationId = moves["龍Attack4"].Anim.AnimationId
	moves["BTStrike4"].HitboxLocations.Value = moves["龍Attack4"].HitboxLocations.Value
end

moves["CounterHook"].Anim.AnimationId = moves.BEvadeStrikeForward.Anim.AnimationId
moves["龍Strike5"].Anim.AnimationId = moves.BStrike1.TurnAnim.AnimationId
moves["FStrike2"].Anim.AnimationId = moves.BStrike1.TurnAnim.AnimationId
moves["FStrike4"].Anim.AnimationId = moves.TigerDrop.Anim.AnimationId
moves["FPunch1"].Anim.AnimationId = "rbxassetid://11464955887"
moves["龍Strike1"].Anim.AnimationId = moves.BStomp.Anim.AnimationId
moves["龍2Strike4"].Anim.AnimationId = moves.RPunch7.Anim.AnimationId
moves["BStrike5"].Anim.AnimationId = moves["龍2Strike1"].Anim.AnimationId
moves["B2Strike1"].Anim.AnimationId = moves.BEvadeStrikeBack.Anim.AnimationId
moves["B2Strike2"].Anim.AnimationId = moves["BStrike3"].TurnAnim.AnimationId
moves["B2Strike3"].Anim.AnimationId = moves["BAttack4"].TurnAnim.AnimationId
moves["BEvadeStrikeLeft"].Anim.AnimationId = "rbxassetid://10848059240"
moves["BEvadeStrikeRight"].Anim.AnimationId = "rbxassetid://10848057381"
moves["BAttack4"].Anim.AnimationId = "rbxassetid://11593137190"
moves["BGetup"].Anim.AnimationId = moves.RSweep.Anim.AnimationId

--misc. move shit
Instance.new("StringValue", moves["B2Strike1"]).Name = "AniSpeed"
moves["B2Strike1"].AniSpeed.Value = 1.5
moves["BAttack4"].AniSpeed.Value = 1.15
moves["FStrike4"].AniSpeed.Value = .5
moves["龍2Strike2"].AniSpeed.Value = 1.45
moves["龍2Strike4"].AniSpeed.Value = .4
moves["B2Strike3"].AniSpeed.Value = .8
moves["龍2Strike2"].MoveDuration.Value = .35
moves.BStrike2.ComboAt.Value = moves.BStrike2.ComboAt.Value - 0.15
moves.BStrike2.MoveForward.Value = moves.BStrike2.MoveForward.Value - 3
moves["BStrike3"].AniSpeed.Value = moves.BStrike2.AniSpeed.Value + 0.05
moves["BStrike3"].ComboAt.Value = moves.BStrike2.ComboAt.Value - 0.05
moves["B2Strike1"].HitboxLocations.Value = moves.BEvadeStrikeBack.HitboxLocations.Value
moves["B2Strike3"].HitboxLocations.Value = moves.BAttack4.THitboxLocations.Value
moves["龍Strike5"].HitboxLocations.Value = moves.BStrike1.THitboxLocations.Value
moves["FStrike2"].HitboxLocations.Value = moves.BStrike1.THitboxLocations.Value
moves["B2Strike2"].HitboxLocations.Value = moves.BStrike3.THitboxLocations.Value
moves["FStrike4"].HitboxLocations.Value = moves.TigerDrop.HitboxLocations.Value
moves["龍Strike1"].HitboxLocations.Value = moves.BStomp.HitboxLocations.Value
moves["BEvadeStrikeLeft"].HitboxLocations.Value = moves.BAttack2.HitboxLocations.Value
moves["BEvadeStrikeRight"].HitboxLocations.Value = moves.BAttack1.HitboxLocations.Value
moves["龍TigerDrop"].HSize.Value = moves["龍GTigerDrop"].HSize.Value
moves["BStrike5"].AniSpeed.Value = moves["BStrike5"].AniSpeed.Value + 0.05
moves["BStrike1"].TurnAnim:Clone().Parent = moves["龍Strike1"]
moves["BStrike1"].THitboxLocations:Clone().Parent = moves["龍Strike1"]

moves.BStrike4.ComboAt:Clone().Parent = moves.DashAttack

moves.B2Strike3.Trail.Value = "RightFoot"
moves.BTStrike4.Trail.Value = "RightFoot"

moves.GAttack3.SF:Clone().Parent = moves["龍2Strike2"]

local SF = Instance.new("StringValue", moves.DerekCharge)
SF.Value = "0"
SF.Name = "SF"

for i = 1, 4 do
	moves["龍Attack" .. i].ComboAt.Value = moves["龍Attack" .. i].ComboAt.Value - 0.05
end

moves["龍Attack4"].HitDur:Clone().Parent = moves.FStrike2

moves["GAttack2"].Anim.AnimationId = "rbxassetid://7546691847"

local combo = Instance.new("StringValue", moves.B2Strike2)
combo.Value = moves.BStrike3.ComboAt.Value
combo.Name = "ComboAt"

moves["龍Strike5"].ComboAt:Clone().Parent = moves.B2Strike1

-- heat aura
local function change_color()
	local style = status.Style.Value
	local heatValue = status.Heat.Value

	local Styles = {
		Brawler = brawler.Color.Value,
		Rush = rush.Color.Value,
		Beast = beast.Color.Value
	}

	local selectedColor = Styles[style]
	if not selectedColor then
		return
	end

	local DragonColor = selectedColor

	local DragonSequence = ColorSequence.new(
		{
		ColorSequenceKeypoint.new(0, DragonColor),
		ColorSequenceKeypoint.new(1, DragonColor)
	})

	local fillColor = DragonSequence.Keypoints[1].Value

	local fills = {
		Main.XP.Fill,
		Main.Heat.Fill,
		Main.Heat.ClimaxFill,
		Main.Heat.Fill2,
		Main.Heat.ClimaxFill2
	}
	for _, fill in ipairs(fills) do
		fill.ImageColor3 = fillColor
	end

	local rootPart = char.HumanoidRootPart

	local mainRate = (heatValue >= 100 and 115) or (heatValue >= 75 and 85) or 80
	local secondaryRate = (heatValue >= 100 and 90) or (heatValue >= 75 and 80) or 70
	local linesRate = (heatValue >= 100 and 60) or (heatValue >= 75 and 40) or 20

	rootPart.Fire_Main.Color = DragonSequence
	rootPart.Fire_Secondary.Color = DragonSequence
	rootPart.Fire_Main.Rate = mainRate
	rootPart.Fire_Secondary.Rate = secondaryRate
	rootPart.Lines1.Color = DragonSequence
	rootPart.Lines1.Rate = linesRate
	rootPart.Lines2.Color = DragonSequence
	rootPart.Lines2.Rate = linesRate
	rootPart.Sparks.Color = DragonSequence

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("MeshPart") then
			for _, trail in ipairs(part:GetChildren()) do
				if trail:IsA("MeshPart") then
					trail.Color = DragonSequence
				end
			end
		end
	end

	local auraBurst = char.UpperTorso["r2f_aura_burst"]
	local maxHeatEffect = showMaxHeatEffect()

	auraBurst.Lines1.Color = DragonSequence
	auraBurst.Lines2.Color = DragonSequence
	auraBurst.Flare.Color = DragonSequence
	auraBurst.Lines1.Enabled = maxHeatEffect
	auraBurst.Flare.Enabled = maxHeatEffect
	auraBurst.Smoke.Color = DragonSequence

	char.UpperTorso.Evading.Color = DragonSequence
end

--hact name changes
local heatMoveTextLabel = Main.HeatMove.TextLabel

local hactNames = {
	["Essence of Solid Counter"] = "Essence of Reversal",
	["Essence of Torment"] = "Essence of the Beast: Torment",
	["Essence of Brute"] = "Essence of the Beast: Overrun",
	["Essence of Knockout [Back]"] = "Essence of the Beast: Knockout",
	["Essence of Knockout [Front]"] = "Essence of Extreme Beast",
	["Guru Firearm Flip"] = "Komaki Shot Stopper",
	["Essence of Fisticuffs"] = "Essence of Brawling",
	["Essence of Whirl"] = "Essence of Mad Dog: Aerial Whirl",
	["Essence of Chokehold"] = "Essence of Mad Dog: Chokehold",
}

-- custom heat actions
heatMoveTextLabel:GetPropertyChangedSignal("Text"):Connect(
	function()
	local heatthing = char.Heated
	local currentText = Main.HeatMove.TextLabel.Text
	local newText = hactNames[currentText]
	if newText then
		Main.HeatMove.TextLabel.Text = newText
	end
	
	if Main.HeatMove.TextLabel.Text == "Essence of Frenzy" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Extreme Rush"
		playAnim(moves["H_Tonfa"].Anim.AnimationId, "Action4", 1)
		enemyAnim(heatthing.Heating.Value, moves["H_Tonfa"].Victim1.AnimationId, "Action4", 1)
		PlaySound("Slap")
		task.wait(0.7)
		for i = 1, 4 do
			PlaySound("Slap")
			task.wait(0.3)
		end
		PlaySound("MassiveSlap")
	elseif Main.HeatMove.TextLabel.Text == "Ultimate Essence" then
		if _G.dodconfig.moveset == "DE" and not char:FindFirstChild("BeingHeated") then
			Main.HeatMove.TextLabel.Text = "Essence of the Dragon God"
			yinglong.Transparency = .5
			playAnim(moves["H_Whirl"].Anim.AnimationId, "Action4", .7)
			enemyAnim(heatthing.Heating.Value, moves["H_UltimateEssence"].Victim1.AnimationId, "Action4", 1)
		elseif char:FindFirstChild("BeingHeated") then
			Main.HeatMove.TextLabel.Text = "Essence of Desperation"
			playAnim(moves["H_Whirl"].Anim.AnimationId, "Action4", .7, .9)
			task.wait(.9)
			Main.HeatMove.TextLabel.Text = "it failed :["
		end
	elseif Main.HeatMove.TextLabel.Text == "Essence of Fast Footwork [Left]" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Fast Footwork [Left] "
		task.wait(0.5)
		playAnim(moves["H_TSpinCounterRight"].Anim.AnimationId, "Action4", 1)
	elseif Main.HeatMove.TextLabel.Text == "Essence of Rolling" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Rolling "
		task.wait(0.5)
		playAnim(moves["H_Whirl"].Anim.AnimationId, "Action4", 1)
	elseif Main.HeatMove.TextLabel.Text == "Essence of Crushing" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Fast Footwork [Right]"
		task.wait(0.5)
		playAnim(moves.H_FallenProne.Anim.AnimationId, "Action4", 1)
	elseif status.Style.Value == "Rush" and Main.HeatMove.TextLabel.Text == "Komaki Fist Reversal [Right]" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Fast Footwork [Front]"
	elseif status.Style.Value == "Brawler" and Main.HeatMove.TextLabel.Text == "Essence of Head Press: Prone" and not char:FindFirstChild("BeingHeated") then
		Main.HeatMove.TextLabel.Text = "Essence of Might"
	elseif Main.HeatMove.TextLabel.Text == "Essence of Beatdown" and not char:FindFirstChild("BeingHeated") then
		for _, p in ipairs(char:GetChildren()) do
			if string.find(p.Name, "wep_") or string.find(p.Name, "prop_") then
				Main.HeatMove.TextLabel.Text = "Essence of Weaponry"
			end
		end
	end
end)

char.ChildRemoved:Connect(
	function(c)
	if c.Name == "Heated" then
		yinglong.Transparency = 1
		rHact.Value = false
	end
end)

-- style switching stuff
Main.GUY.GUY.Size = UDim2.new(1, 0, 1, 0)

local function styleswitch()
	local styleText = Main.StyleBar.amount.Text
	local guyImage = Main.GUY.GUY

	-- Common settings
	guyImage.ScaleType = Enum.ScaleType.Fit
	guyImage.ClipsDescendants = false

	if status.Style.Value == "Brawler" then
		if _G.dodconfig.moveset == "Y0" then
			guyImage.Image = "rbxassetid://77002058287348"
		else
			guyImage.Image = "rbxassetid://108063383518240"
		end
	elseif status.Style.Value == "Rush" then
		if _G.dodconfig.rushMoveset == "7G" then
			guyImage.Image = "rbxassetid://108301240160748"
		else
			guyImage.Image = "rbxassetid://104601719368210"
		end
	elseif status.Style.Value == "Beast" then
		guyImage.Image = "rbxassetid://117731163415083"
	end
end

-- 108301240160748

status.Style:GetPropertyChangedSignal("Value"):Connect(
	function()
	if not char:FindFirstChild("Holding") and isInBattle() then
		if status.Style.Value == "Brawler" then
			playAnim(moves["Taunt"].Anim.AnimationId, "Idle", 4)
		elseif status.Style.Value == "Rush" then
			playAnim(rep.Anims.WepEquip.AnimationId, "Idle")
		elseif status.Style.Value == "Beast" then
			playAnim(moves["BeastTaunt"].Anim.AnimationId, "Idle", 4)
		end
	end
end)

status.ChildAdded:Connect(function(c)
	if c.Name == "ANGRY" then
		rds.Value = true
	end
end)

status.ChildRemoved:Connect(function(c)
	if c.Name == "ANGRY" then
		rds.Value = false
	end
end)

rds:GetPropertyChangedSignal("Value"):Connect(function()
	if rds.Value then
		local anim
		local speed
		if status.Style.Value == "Brawler" then
			anim = moves.H_FallenProne.Anim.AnimationId
			speed = 1.25
		else
			anim = rep.Anims.Rage.AnimationId
			speed = 2
		end
		char.HumanoidRootPart.Anchored = true
		rep.IsELO.Value = true
		playAnim(anim, "Action4", speed, .75)
		task.wait(.75)
		rep.IsELO.Value = false
		char.HumanoidRootPart.Anchored = false
		addMove("GrabStrike", "Brawler", "T_FinishingHold1")
	else
		addMove("GrabStrike", "Brawler", "T_龍GParry")
	end
end)

-- extra attacks
status.AttackBegan.Changed:Connect(function()
	if status.AttackBegan.Value and not IsInPvp() then
		if status.CurrentMove.Value.Name == "B2Strike1" then
			brawler.Strike1.Value = "B2Strike3"
			task.delay(.8, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif (status.CurrentMove.Value.Name == "BStrike4" and bName == "Ouryu") or status.CurrentMove.Value.Name == "龍2Strike4" then
			brawler.Strike1.Value = "龍Strike5"
			task.delay(.8, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif status.CurrentMove.Value.Name == "龍2Strike1" then
			brawler.Strike1.Value = "BTStrike4"
			task.delay(.8, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif status.CurrentMove.Value.Name == "龍2Strike2" then
			brawler.Strike1.Value = "龍2Strike3"
			task.delay(.8, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif status.CurrentMove.Value.Name == "DashAttack" and status.Style.Value == "Brawler" then
			brawler.Strike1.Value = "RSweep"
			task.delay(3, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif status.CurrentMove.Value.Name == "BTCounter" then
			brawler.Strike1.Value = "B2Strike2"
			task.delay(.5, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		elseif status.CurrentMove.Value.Name == "FStrike2" then
			task.wait(.4)
			brawler.Strike1.Value = "BTStrike4"
			task.delay(.6, function()
				brawler.Strike1.Value = "龍Strike1"
			end)
		end
	end
end)

plr.ChildRemoved:Connect(function(c)
	if c.Name == "InBattle" then
		if status:FindFirstChild("Invulnerable") then
			status.Invulnerable:Destroy()
		end
	end
end)

char.ChildAdded:Connect(function(c)
	if c.Name == 'Grabbing' and angry() then
		UseHeatAction("T_BeastToss", "Brawler", {c.Value.HumanoidRootPart})
	end
end)

brawler.ChildAdded:Connect(
	function(child)
	if child.Name == "H_FullHeat" then
		child:Destroy()
	end
end)

char.ChildAdded:Connect(function(c)
	if c.Name == 'Grabbing' and rds.Value then
		UseHeatAction("T_龍FinishingHold3", "Brawler", {
			c.Value.HumanoidRootPart
		})
	end
end)

--abilities section
local menu = pgui.MenuUI.Menu
local abil = menu.Abilities.Frame.Frame.Frame
local abilFolder = game.ReplicatedStorage.Abilities

abilFolder.Brawler["Ultimate Essence"].Prompt.Value = "HEAVY ATTACK near stunned enemies while in Red Heat Mode or Feel the Heat"

local abilDescs = {
	["Ultimate Essence"] = "The ultimate attack of the Dragon of Dojima. Unleash enough might to crush any opponent.",
	["Guru Parry"] = "One of many skills in the Komaki style. Parry the enemy's attack and then land a blow to the stomach, or reuse the Twist Counter you haven't used since the Bubble to knock them off-balance in " .. bName .. " Style.",
	["Counter Hook"] = "One of many skills in the Komaki style. The style's strongest counter-attack. The lower your Heat, the more damage it does.",
	["Guru Knockback"] = "One of many skills in the Komaki style. Repel an enemy's attack while guarding.",
	["Resolute Counter"] = bName .. " Style only. You can strike back at enemies attacking you unless you are sent back flying."
}

local function updateAbil()
	if abilFolder then
		local styleList = {
			"Brawler",
			"Rush",
			"Beast"
		}
		
		for _, v in ipairs(styleList) do
			for _, move in ipairs(abilFolder[v]:GetChildren()) do
				if abilDescs[move.Name] then
					move.Description.Value = abilDescs[move.Name]
				end
			end
		end
	end

	abil.Tabs.Tabs.Brawler.Filled.Title.Text = bName
	abil.Tabs.Tabs.Rush.Filled.Title.Text = "Rush"
	abil.Tabs.Tabs.Beast.Filled.Title.Text = "Beast"
	
	local DragonColor = brawler.Color.Value
	for i, v in ipairs(abil.List.ListFrame:GetChildren()) do
		if v:IsA("ImageButton") then
			if v:FindFirstChild("sty").Value == "Brawler" and v:FindFirstChild("MyColor").Value == Color3.fromRGB(19, 157, 255) then
				v.MyColor.Value = DragonColor
				v.Generic.Label.TextColor3 = DragonColor
			end
		end
		if v.Name == "Counter Hook" then
			v.Generic.Label.Text = "Komaki Tiger Drop"
		elseif v.Name == "Guru Knockback" then
			v.Generic.Label.Text = "Komaki Knock Back"
		elseif v.Name == "Ultimate Essence" then
			if _G.dodconfig.moveset == "DE" then
				v.Generic.Label.Text = "Essence of the Dragon God"
			else
				v.Generic.Label.Text = "Ultimate Essence '88"
			end
			if string.sub(v.Lock.Title.Text, 1, 10) ~= "Need to be" then
				v.Lock.Title.Text = "Need to unlock Komaki Parry"
			end
		elseif v.Name == "Guru Parry" then
			v.Generic.Label.Text = "Komaki Parry"
			if string.sub(v.Lock.Title.Text, 1, 10) ~= "Need to be" then
				v.Lock.Title.Text = "Need to unlock Finishing Hold"
			end
		elseif v.Name == "Guru Spin Counter" then
			v.Generic.Label.Text = "Essence of Fast Footwork"
		elseif v.Name == "Guru Firearm Flip" then
			v.Generic.Label.Text = "Komaki Shot Stopper"
		elseif v.Name == "Guru Dodge Shot" then
			v.Generic.Label.Text = "Komaki Evade & Strike"
			if string.sub(v.Lock.Title.Text, 1, 10) ~= "Need to be" then
				v.Lock.Title.Text = "Need to unlock Komaki Knock Back"
			end
		elseif v.Name == "Guru Safety Roll" then
			v.Generic.Label.Text = "Komaki Dharma Tumbler"
		elseif v.Name == "Essence of Fisticuffs" then
			v.Generic.Label.Text = "Essence of Brawling"
		elseif v.Name == "Time for Resolve" then
			v.Generic.Label.Text = "Extreme Heat Mode"
		elseif v.Name == "Essence of Frenzy" then
			v.Generic.Label.Text = "Essence of Extreme Rush"
		elseif v.Name == "Cat-like Reflexes" then
			v.Generic.Label.Text = "Komaki Cat-Like Reflexes"
		end
	end
end

-- ui
local EnemyHP = pgui.EInterface.EnemyHP

local style1 = pgui.MobileUI.MobileFrame.Left.Buttons.DPad.DPadUp
style1.TextLabel.Text = bName
style1.TextLabel.TextStrokeColor3 = brawler.Color.Value

pgui.MobileUI.MobileFrame.Left.Buttons.DPad.DPadLeft.TextLabel.Text = "Rush"
pgui.MobileUI.MobileFrame.Left.Buttons.DPad.DPadLeft.TextLabel.TextStrokeColor3 = rush.Color.Value
pgui.MobileUI.MobileFrame.Left.Buttons.DPad.DPadRight.TextLabel.Text = "Beast"
pgui.MobileUI.MobileFrame.Left.Buttons.DPad.DPadRight.TextLabel.TextStrokeColor3 = beast.Color.Value

--heat bar
local fill3 = Main.Heat.Fill2:Clone()
fill3.Parent = Main.Heat
fill3.Name = "Fill3"
fill3.Visible = false
fill3.ImageColor3 = Color3.fromRGB(255, 255, 255)
fill3.ImageTransparency = 1
Main.Heat.Fill2.Changed:Connect(
	function()
	fill3.Size = Main.Heat.Fill2.Size
end)
local tween = game:GetService("TweenService"):Create(
	fill3, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true, 0), {
	ImageTransparency = 0.4
})
tween:Play()
local function updateFill()
	fill3.Visible = status.Heat.Value >= 50 and true or false
end

local cfill = Main.Heat.ClimaxFill2:Clone()
cfill.Parent = Main.Heat
cfill.Name = "ClimaxFill3"
cfill.Visible = false
cfill.ImageColor3 = Color3.fromRGB(255, 255, 255)
cfill.ImageTransparency = 1
Main.Heat.ClimaxFill.Changed:Connect(
	function()
	cfill.Size = Main.Heat.ClimaxFill2.Size
end)
local tween = game:GetService("TweenService"):Create(
	cfill, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true, 0), {
	ImageTransparency = 0.45
})
tween:Play()
local function updateFill()
	fill3.Visible = status.Heat.Value >= 50 and true or false
	cfill.Visible = status.Heat.Value >= 75 and true or false
end
status.Heat.Changed:Connect(
	function()
	updateFill()
end)
updateFill()

--kiryu easter egg
EnemyHP.TextLabel:GetPropertyChangedSignal("Text"):Connect(
	function()
	if EnemyHP.TextLabel.Text == "Legendary Dragon" then
		EnemyHP.TextLabel.Text = "Kazuma Kiryu"
	end
end)

interf.BattleStart:GetPropertyChangedSignal("Text"):Connect(
	function()
	if interf.BattleStart.Text == "LEGENDARY DRAGON" then
		if _G.dodconfig.morph then
			interf.BattleStart.Text = "KAZUMA KIRYU"
		else
			interf.BattleStart.Text = "堂島の龍"
		end
	end
end)

status.Health.Changed:Connect(
	function()
	if status.Health.Value <= 0 then
		task.wait()
		if not plr.Character:FindFirstChild("ImaDea") then
			return
		end
		local arena = status.MyArena.Value
		if arena then
			if arena:FindFirstChild("AI"):FindFirstChild("Object") and arena.AI.Object.Value and arena.AI.Object.Value.Name == "Legendary Dragon" and _G.dodconfig.morph then
				sendNotification('I wish for you to be at peace."')
				sendNotification('"Whatever happens to me...')
			end
		end
	end
end)

--reload char
--updateSpeed()
moves["龍TigerDrop"].Anim.AnimationId = "rbxassetid://12120052426"
respawn()
moves["龍TigerDrop"].Anim.AnimationId = "rbxassetid://11464955887"

local alrRun = Instance.new("Folder", rep)
alrRun.Name = "Dragon"

if brawler:FindFirstChild("H_FullHeat") then
	brawler.H_FullHeat:Destroy()
end

addMove("H_Stunned", "Brawler", "H_GUltimateEssence")

game:GetService("RunService").RenderStepped:Connect(
	function()
	updateAbil()
	change_color()
	styleswitch()
end)

--morph setup
local characterToChange = "Your Avatar"
local characterToChangeTo = "Kiryu Morph"

if _G.dodconfig.morph then
	_G.Morph = _g.dodconfig.useMorph
	loadstring(game:HttpGet("https://raw.githubusercontent.com/aAAAakakrvmv192/R2FMods/main/charmorphmod.lua"))()
end

if _G.dodconfig.morph and _G.Morph == "Legendary Dragon" and _G.dodconfig.custommorph == "Y5" and char:FindFirstChild("Ignore") then
	local kiryuHairMesh = char.Ignore.FakeHead.Kiryu_Hair.Mesh
	kiryuHairMesh.MeshId = "rbxassetid://14720023616"
	kiryuHairMesh.TextureId = "rbxassetid://14719999915"
	kiryuHairMesh.Offset = Vector3.new(0, - 0.25, 0.15)
	
	local darkGrey = BrickColor.new("Dark grey")
	local black = BrickColor.new("Black")
	local white = BrickColor.new("White")

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("MeshPart") then
			if string.match(part.Name, "Arm") or part.Name == "UpperTorso" then
				part.BrickColor = darkGrey
			elseif not string.match(part.Name, "Hand") and part.Name ~= "Head" then
				part.BrickColor = black
			end
		end
	end

	local colorUpdates = {
		{
			char.Ignore.FakeUpperTorso.Kiryu_Skin,
			white
		},
		{
			char.Ignore.FakeUpperTorso.Kiryu_Suit,
			darkGrey
		},
		{
			char.Ignore.FakeLowerTorso.Kiryu_Tail,
			darkGrey
		},
		{
			char.Ignore.FakeLeftLowerArm.Suit_CuffL,
			darkGrey
		},
		{
			char.Ignore.FakeRightLowerArm.Suit_CuffR,
			darkGrey
		},
		{
			char.Ignore.FakeLeftLowerArm.Suit_CuffSL,
			darkGrey
		},
		{
			char.Ignore.FakeRightLowerArm.Suit_CuffSR,
			darkGrey
		},
		{
			char.Ignore.FakeUpperTorso.Kiryu_Shirt,
			black
		},
		{
			char.Ignore.FakeLowerTorso.Kiryu_BeltLoop,
			black
		},
		{
			char.Ignore.FakeLeftLowerLeg.Suit_PantL,
			black
		},
		{
			char.Ignore.FakeRightLowerLeg.Suit_PantR,
			black
		},
	}

	for _, update in ipairs(colorUpdates) do
		update[1].BrickColor = update[2]
	end
end

--voice mod
if _G.dodconfig.voice then
	if _G.dodconfig.useVoice == "ps2Kiryu" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/manythingsofthings/soundshit/refs/heads/main/spaghetticode.lua"))()
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/manythingsofthings/totally-legitimate-mm2-scripts/refs/heads/main/voice.lua"))()
	end
end

sendNotification("YAKUZA STYLES LOADED", Color3.new(1, 0, 0), Color3.new(0, 0, 0), "HeatDepleted")
