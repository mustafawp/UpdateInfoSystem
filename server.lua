db = dbConnect("sqlite","db.db")
local giren
local id
if db then
    print("[GuncellemePanel:INFO] - Başarıyla VeriTabanına bağlandı.")
end

addEventHandler("onPlayerLogin",root,function()
    if db then
        giren = source
	local adam = getPlayerAccount(source)
	setTimer(function()
	if getAccountData(adam,"GuncellemeBildirim") == true then return end
        dbQuery(kayitgoster, db,"SELECT * FROM kayitlar")
	end,1000,1)
    end
end)

function kayitgoster(veriler)
    local veriler = dbPoll(veriler,0)
    triggerClientEvent(giren,"GuncellemePanel:ShowScreen",giren,veriler)
end

addEvent("GuncellemePanel:geriilerial",true)
addEventHandler("GuncellemePanel:geriilerial",root,function(ids)
        if db then
            id = ids
            giren = source
            dbQuery(gerial, db,"SELECT * FROM kayitlar")
        end
end)

function gerial(veriler)
    local veriler = dbPoll(veriler,0)
    local guncelleme
    local tarih
    local yetkili
    for i,v in pairs(veriler) do
        if tonumber(id) == tonumber(v.id) then
            guncelleme = v.guncelleme
            tarih = v.tarih
            yetkili = v.yetkili
        end
    end
    triggerClientEvent(giren,"GuncellemePanel:yazdir",giren,guncelleme,tarih,yetkili)
end

addEvent("GuncellemePanel:guncellemeekle",true)
addEventHandler("GuncellemePanel:guncellemeekle",root,function(text)
    local nick = getPlayerName(source)
    nick = nick:gsub('#%x%x%x%x%x%x', '')
    local time = getRealTime()
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local tarih = string.format("%02d-%02d-%04d", monthday, month + 1, year + 1900)
    dbExec(db,"INSERT INTO kayitlar(yetkili,tarih,guncelleme) VALUES (?,?,?)",nick,tarih,text)
    exports.hud:dm("#ffffffBaşarıyla #ff7f00Yeni Güncelleme Eklendi! #ffffffçık gir yaparak kontrol edebilirsin.",source,255,255,255,true)
end)

addCommandHandler("guncellemeekle",function(oyuncu,komut)
    if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(oyuncu)), aclGetGroup("Console")) then return end
    triggerClientEvent(oyuncu,"GuncellemePanel:adminwindow",oyuncu)
end)





--[[
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local tarih = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday)
]]