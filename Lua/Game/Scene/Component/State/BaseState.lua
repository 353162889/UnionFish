BaseState = Class()

function BaseState:ctor()
	self.id = nil
end

--初始化
function BaseState:Init(unit,id,...)
	--LogColor("#ff0000","BaseState:Init",id)
	self.unit = unit
	self.id = id
	self.cfg = Res.status[id]
end

--更新当前状态数据
function BaseState:OnUpdate(...)

end

--对象首次初始化（有可能不是刚好添加状态，而是当前状态已经在身上运行了一段时间）
function BaseState:OnInit()
	-- body
end

function BaseState:OnTriggerTime(triggerTime)
	-- body
end

--进入当前状态
function BaseState:OnEnter()
	LogColor("#ff0000","OnEnter")
end

--退出当前状态
function BaseState:OnExit()
	LogColor("#ff0000","OnExit")
end

--销毁状态
function BaseState:OnDispose()
	--LogColor("#ff0000","OnDispose")
	self.unit = nil
	self.cfg = nil
end


