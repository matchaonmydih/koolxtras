return {
    GetContainer = function(self)
        return workspace.CurrentCamera
    end,
    PlayAnimation = function(self, tool)
        if not self:GetContainer().Viewmodel:FindFirstChild('Viewmodel') then return end
            
        local toolnme, animObj = nil, self:GetContainer().Viewmodel:WaitForChild(tool, 10)
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
        
        track.Stopped:Connect(function()
            v:Destroy()
        end)
    
        for _, v in animObj.AnimationController.Animator:GetPlayingAnimationTracks() do
			if v.Name == 'ToolAnimation' and (tool:find('Sword') or tool:find('Pickaxe')) then
				v.TimePosition = 0
				v:Stop()
			end
		end
		
		track:Play()
		
		return track
    end
}
