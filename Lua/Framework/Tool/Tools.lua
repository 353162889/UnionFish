GameObject = UnityEngine.GameObject
WWW = UnityEngine.WWW
-- _G["print"] = LogError

-- 输出日志--
function Log(...)
    LH.Log(GetLogStr(...))
end
--有颜色的日志, 例如:LogColor("#ff0000","测试")--
function LogColor(color, ... )
    LH.Log(GetLogStr(...),color)
end

-- 错误日志--
function LogError(...)
    LH.LogError(GetLogStr(...))
end

-- 警告日志--
function LogWarn(...)
    LH.LogWarn(GetLogStr(...))
end

function GetLogStr(...)
    local str = ""
    local arg = ""
    for i = 1, select('#', ...) do
        arg = select(i, ...)
        str = str .. "\t" .. tostring(arg)
    end
    return str
end

function Find(go,path)
    if go.transform:FindChild(path) ~= nil then
        return go.transform:FindChild(path).gameObject
    end
	return nil
end

function GetVector3(str)
    local t = string.Split(str,",")
    local v = Vector3.New(tonumber(t[1]),tonumber(t[2]),tonumber(t[3]))
    return v
end

function string.Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function GetEverT(str)
    local rT = {}
    local tempT_1 = string.Split(str,";")
    for _k,_v in pairs(tempT_1) do
        local tempT_2 = string.Split(_v,",")
        table.insert(rT,tempT_2)
    end
    return rT
end

function CopyTable(st)  
    local tab = {}  
    for k, v in pairs(st or {}) do  
        if type(v) ~= "table" then
            tab[k] = v  
        else  
            tab[k] = CopyTable(v)  
        end  
    end  
    return tab  
end

function table.getn(t)
    local x = 0
    for k,v in pairs(t) do
        x = x+1
    end
    return x
end

function table.maxn(t)
    local x = -1
    for k,v in pairs(t) do
        if (type(k) == "number") then
            x = (k > x and k) or x
        end
    end
    return x
end

function table.contains(table, element)
  for key, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end 

function GetStringWordNum(str)
    local lenInByte = #str
    local count = 0
    local i = 1
    while true do
        local curByte = string.byte(str, i)
        if i > lenInByte then
            break
        end
        local byteCount = 1
        local offsetCount = 1
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte>=128 and curByte<224 then
            byteCount = 2
        elseif curByte>=224 and curByte<240 then
            byteCount = 3
            offsetCount = 2
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        else
            break
        end
        i = i + byteCount
        count = count + offsetCount
    end
    return count
end

function IsZero(num)
    if(type(num) == number) then
        return math.abs(num - 0.00001) < 0
    else
        return false
    end
end



local function __TRACKBACK__(errmsg)
    local track_text = debug.traceback(tostring(errmsg), 6);
    LogError(track_text)
    return false;
end

function trycall(func, ...)
    local args = { ... }
    return xpcall(function() func(unpack(args)) end, __TRACKBACK__);
end

function string.split(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end
