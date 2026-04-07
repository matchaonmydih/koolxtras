local animations = {
	Sword = 'rbxassetid://81023102192808',
	Hammer = 'rbxassetid://113992130601874',
	Blocks = 'rbxassetid://76360831574790',
	Pickaxe = 'rbxassetid://81023102192808',
	GoldApple = 'rbxassetid://80789347313662',
	Potion = 'rbxassetid://80789347313662'
}
	
return {
    GetContainer = function(self)
        return workspace.CurrentCamera
    end,
    PlayAnimation = function(self, tool)
        local toolnme
		if not self:GetContainer():FindFirstChild('Viewmodel') then return end

		local animObj = self:GetContainer().Viewmodel:WaitForChild(tool, 10)
		if not animObj then return end

		local anim = animObj.Animation

		if tool:find('Sword') then
			toolnme = 'Sword'
		elseif tool:find('Pickaxe') then
			toolnme = 'Pickaxe'
		elseif tool:find('Potion') then
			toolnme = 'Potion'
		else
			toolnme = tool
		end
		anim.AnimationId = animations[toolnme]

		local track = animObj.AnimationController.Animator:LoadAnimation(anim)
		track.Name = 'ToolAnimation'

		for _, v in animObj.AnimationController.Animator:GetPlayingAnimationTracks() do
			if v.Name == 'ToolAnimation' and (tool:find('Sword') or tool:find('Pickaxe')) then
				v.TimePosition = 0
				v:Destroy()
			end
		end

		track:Play()
		return track
    end
}
