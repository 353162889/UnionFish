SortRes = {}
function SortRes.SortGunUnlock()
	local result = {}
	for k,v in pairs(Res.gun_unlock) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end
SortRes.Gun_Unlock = SortRes.SortGunUnlock()	--炮倍解锁按id排序列表

function SortRes.DicView()
	local result = {}
	for k,v in pairs(Res.view) do
		result[v.ViewName] = v
	end
	return result
end

SortRes.DicView = SortRes.DicView()			--面板可通过名称获取配置

function SortRes.SortSkill()
	local result = {}
	for k,v in pairs(Res.skill) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end
SortRes.Skill = SortRes.SortSkill()			--技能按照id排序

function SortRes.SortGun()
	local result = {}
	for k,v in pairs(Res.gun) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end
SortRes.Gun = SortRes.SortGun()				--炮按照id排序

function SortRes.SortRank()
	local result = {}
	for k,v in pairs(Res.rank) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end

SortRes.Rank = SortRes.SortRank()

function SortRes.DicRank()
	local result = {}
	for k,v in pairs(Res.rank) do
		result[v.type] = v
	end
	return result
end

SortRes.DicRank = SortRes.DicRank()


--7天签到
function SortRes.DicSign7()
	local result = {}
	for k,v in pairs(Res.day7) do
		result[v.id] = v
	end
	return result
end

SortRes.DicSign7 = SortRes.DicSign7()


function SortRes.SortTaskBase()
	local result = {}
	for k,v in pairs(Res.task_base) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end

SortRes.Task_Base = SortRes.SortTaskBase()

function SortRes.SortTaskScore()
	local result = {}
	for k,v in pairs(Res.task_score) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end

SortRes.Task_Score = SortRes.SortTaskScore()

function SortRes.DicTaskScore()
	local result = {}
	for k,v in pairs(Res.task_score) do
		result[v.task_count] = v
	end
	return result
end

SortRes.DicTask_Score = SortRes.DicTaskScore()

function SortRes.SortLoadingDesc()
	local result = {}
	for k,v in pairs(Res.loadingdesc) do
		table.insert(result,v)
	end
	table.sort(result,function (a,b)
		return a.id < b.id
	end)
	return result
end

SortRes.SortLoadingDesc = SortRes.SortLoadingDesc()
