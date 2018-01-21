HPView=Class(BaseView)

function HPView:ConfigUI()
	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	local OnClickClose = function (go)
		UIMgr.CloseView("HPView")
	end
	LH.AddClickEvent(self.CloseBtn,OnClickClose)

	self.TableItem = Find(self.gameObject,"TabBox/Grid/Item")
	self.TableItem:SetActive(false)
	self.TableItemList = {}
	self.CurTab = nil
	self.txt = Find(self.gameObject,"lblBox/lbl")
	self.tit = Find(self.gameObject,"BG_2/lbl")
	-- LogError("self.txt",self.txt,self.txt:GetComponent("UILabel"))
	local d = Res.hptxt
	for i=1,#d do
		local temp = LH.GetGoBy(self.TableItem,self.TableItem.transform.parent.gameObject)
		temp:SetActive(true)
		-- LogError("temp",temp)
		temp.name = tostring(d[i].id)
		temp.transform:FindChild("lbl"):GetComponent("UILabel").text = L("{1}",d[i].title)
		temp:GetComponent("UISprite").spriteName = "com_weijihuoanniu"
	 	temp:GetComponent("UISprite"):MakePixelPerfect()
	 	self.ClickBtn = temp
	 	local OnClickEvent = function (go)
	 		self:OnClickTableItemBtn(go)
	 	end
	 	LH.AddClickEvent(self.ClickBtn,OnClickEvent)
		table.insert(self.TableItemList,temp)
	end

	--Find(self.gameObject,"BG_2/lbl"):GetComponent("UILabel").text = "帮  助"
	
end

function HPView:OnClickTableItemBtn(go)
	
	if self.CurTab ~= nil then
		self.CurTab:GetComponent("UISprite").spriteName = "com_weijihuoanniu"
	 	self.CurTab:GetComponent("UISprite"):MakePixelPerfect()
	end
	self.CurTab = go
	self.CurTab:GetComponent("UISprite").spriteName = "com_jihuoanniu"
	self.CurTab:GetComponent("UISprite"):MakePixelPerfect()
	--te = "[990707FF]"..te.."[-]"
	local h = Res.hptxt
	local id = tonumber(go.name)

	local title = go.transform:FindChild("lbl"):GetComponent("UILabel").text
	
	
	for k,v in pairs(h) do
		
		if(v.id == id) then
			title = v.title	
			--title = "[990707FF]"..title.."[-]"
		end
	end
	

	

	
	self.txt:GetComponent("UILabel").text = L("{1}",Res.hptxt[id].txt)
	

	self.tit:GetComponent("UILabel").text = title

end




function HPView:AfterOpenView(t)
	self:OnClickTableItemBtn(self.TableItemList[1])
end

function HPView:UpdateView()
end

function HPView:AddListener()
end

function HPView:BeforeCloseView()
end

function HPView:OnDestory()
end

