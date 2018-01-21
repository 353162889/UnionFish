ItemCell = { }
local this = ItemCell

function ItemCell.Create(p)
	local item = this.CreateEntry(p)
    local data = nil

    local SetValue = function(d)
        data = d
        item:GetComponent("MonoData").data = data
        if data == nil then
            item.transform:FindChild("Icon").gameObject:SetActive(false)
            -- item.transform:FindChild("Select").gameObject:SetActive(false)
            item.transform:FindChild("lbl").gameObject:SetActive(false)
            item.transform:FindChild("RightTop").gameObject:SetActive(false)

        else
            local _d = Res.item[data.id]
            item.transform:FindChild("Icon").gameObject:SetActive(true)
            item.transform:FindChild("Icon"):GetComponent("UISprite").spriteName = _d.icon
            -- item.transform:FindChild("Select").gameObject:SetActive(false)
            item.transform:FindChild("RightTop").gameObject:SetActive(false)
            item.transform:FindChild("lbl").gameObject:SetActive(true)
            item.transform:FindChild("lbl"):GetComponent("UILabel").text = tostring(data.cnt)
        end
    end

    local SetName = function(str)
        item.name = str
    end

    local SetBaseDepth = function (depth)
        --local baseWidget = item:GetComponent("UIWidget")
       -- baseWidget.depth = depth
        item.transform:FindChild("BG"):GetComponent("UIWidget").depth = depth + 1
        item.transform:FindChild("Icon"):GetComponent("UIWidget").depth = depth + 2
        item.transform:FindChild("Select"):GetComponent("UIWidget").depth = depth + 3
        item.transform:FindChild("lbl"):GetComponent("UIWidget").depth = depth + 10
        item.transform:FindChild("RightTop"):GetComponent("UIWidget").depth = depth + 4
    end

    return {
        Item = item,
        Data = data,
        SetValue = SetValue,
        SetName = SetName,
        SetBaseDepth = SetBaseDepth,
    }
end

function ItemCell.CreateEntry(p)
	local go = PreloadMgr.GetAsset("View/ItemCell.prefab")
	go.transform.parent = p.transform
	go.transform.localPosition = Vector3.zero
	go.transform.localScale = Vector3.one
    go.transform.localEulerAngles = Vector3.zero
    go.transform:FindChild("Select").gameObject:SetActive(false)
    return go
end