GuideItem = Class()

function GuideItem:ctor(...)
	self.taskInfo = select(1, ...)
end

function GuideItem:OnUpdate(taskInfo)
	self.taskInfo = taskInfo
end

function GuideItem:OnEnter(...)

end

function GuideItem:OnExit()

end

function GuideItem:OnDispose()
	self.taskInfo = nil
end
