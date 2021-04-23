script_name("Z.O.N.A ASSISTANT")

require "lib.moonloader"

local dlstatus = require('moonloader').download_status
local inicf = require "inicfg"

local keys = require "vkeys"
local fa = require "fAwesome5"
local imgui = require "imgui"
local encoding = require 'encoding'
local sampev = require 'lib.samp.events'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 0
local script_vers_text = "0.01"

local update_url = "https://raw.githubusercontent.com/Koryakat/scripts/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = ""
local script_path = thisScript().path

local names = {
	[0] = 'Yarok',
	[1] = 'Dolg',
	[2] = 'CJlaBa'
}

local white_color = 0xFFFFFF
local main_color = 0x00FF00
local danger_color = 0xFF0000

local main_window_state = imgui.ImBool(false)
local text_buffer_name = imgui.ImBuffer(256)

--local checked_radar = imgui.ImBool(false)
local checked_pickup = imgui.ImBool(false)
local checked_dialog = imgui.ImBool(false)
local checked_textdraw = imgui.ImBool(false)
local checked_sound = imgui.ImBool(false)
local vzlom = imgui.ImBool(false)

local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

show_main_window = imgui.ImBool(false)

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

style.WindowRounding = 12
style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
style.ChildWindowRounding = 11.0
style.FrameRounding = 7
style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
style.ScrollbarSize = 13.0
style.ScrollbarRounding = 0
style.GrabMinSize = 8.0
style.GrabRounding = 1.0
style.WindowPadding = imgui.ImVec2(4.0, 4.0)
style.FramePadding = imgui.ImVec2(3.5, 3.5)
style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 0.00)
colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)

scr = thisScript()

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if _ then
      local myname = sampGetPlayerNickname(id)
      for i = 0, #names do
        if myname == names[i] then
          bool = true
          break
        end
      end
    end
    if bool then
      --i
    else
      thisScript():unload()
    end
    while not bool do wait(0) end

	sampRegisterChatCommand("zhs", cmd_imgui) --/zhs активация скрипт

	sampRegisterChatCommand("bank", bank) -- дистанционный банк

	imgui.Process = show_main_window.v

    thread = lua_thread.create_suspended(thread_function)

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni - inicfg.load(nil, update_path)
			if tonumber(updateIni.info.vers) > script_vers then
				update_state = true
			end
			os.remove(update_path)
		end
	end)

	while true do
		wait(0)
		
		if update_state then
			downloadUrlToFile(update_url, update_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("Скрипт успешно обновлен!", -1)
					thisScript():reload()
				end
			end)
			break
		end

		if isKeyDown(VK_LMENU) and isKeyJustPressed(69)
		then
			cmd_imgui()
		end

		if isKeyJustPressed(VK_R) then
			setPlayerControl(player, true)
			freezeCharPosition(PLAYER_PED, false)
		end

		if main_window_state.v == false then
			imgui.Process = false
        end
	end
end

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

function repcar() 
	if isCharInAnyCar(PLAYER_PED) then
		fixCar(storeCarCharIsInNoSave(PLAYER_PED))
	else
		sampAddChatMessage("Сядь в машину, еблан", white_color)	
    end
end

function flipcar() 
	if isCharInAnyCar(PLAYER_PED) then
		setCarHeading(getCarCharIsUsing(PLAYER_PED), getCarHeading(getCarCharIsUsing(PLAYER_PED)))
	else
		sampAddChatMessage("Сядь в машину, еблан", white_color)	
	end
end

function bank()
	local data = samp_create_sync_data('player')
	data.position.x = -1941.62
	data.position.y = 450.84
	data.position.z = 1022.99
	data.send()
	sampSendPickedUpPickup(528)
end

function thread_function(option)

	if option == "electronics" then
		local g = 200
		local data = samp_create_sync_data('player')
		data.position.x = 1323.87
		data.position.y = 1969.79
		data.position.z = 11.47
		data.keysData = data.keysData + 16
		data.send()
		wait(g)
		local data1 = samp_create_sync_data('player')
		data1.position.x = 1358
		data1.position.y = 2007
		data1.position.z = 11.47
		data1.keysData = data1.keysData + 16
		data1.send()
		wait(g)
		local data2 = samp_create_sync_data('player')
		data2.position.x = 1357
		data2.position.y = 1994
		data2.position.z = 11.47
		data2.keysData = data2.keysData + 16
		data2.send()
		wait(g)
		local data3 = samp_create_sync_data('player')
		data3.position.x = 1357
		data3.position.y = 1900
		data3.position.z = 11.47
		data3.keysData = data3.keysData + 16
		data3.send()
		wait(g)
		local data4 = samp_create_sync_data('player')
		data4.position.x = 1417
		data4.position.y = 1929
		data4.position.z = 11.47
		data4.keysData = data4.keysData + 16
		data4.send()
		wait(g)
		local data5 = samp_create_sync_data('player')
		data5.position.x = 1453
		data5.position.y = 1922
		data5.position.z = 11.47
		data5.keysData = data5.keysData + 16
		data5.send()
		wait(g)
		local data6 = samp_create_sync_data('player')
		data6.position.x = 1462
		data6.position.y = 1922
		data6.position.z = 11.47
		data6.keysData = data6.keysData + 16
		data6.send()
		wait(150)
		local data7 = samp_create_sync_data('player')
		data7.position.x = 1549
		data7.position.y = 2105
		data7.position.z = 11.47
		data7.keysData = data7.keysData + 16
		data7.send()
		wait(g)
		local data8 = samp_create_sync_data('player')
		data8.position.x = 1589
		data8.position.y = 2042
		data8.position.z = 11.47
		data8.keysData = data8.keysData + 16
		data8.send()
		wait(g)
		local data9 = samp_create_sync_data('player')
		data9.position.x = 1589
		data9.position.y = 2127
		data9.position.z = 11.47
		data9.keysData = data9.keysData + 16
		data9.send()
		wait(g)
		local data10 = samp_create_sync_data('player')
		data10.position.x = 1644
		data10.position.y = 2148
		data10.position.z = 11.47
		data10.keysData = data10.keysData + 16
		data10.send()
		wait(g)
		local data11 = samp_create_sync_data('player')
		data11.position.x = 1646
		data11.position.y = 2159
		data11.position.z = 11.47
		data11.keysData = data11.keysData + 16
		data11.send()
		wait(g)
		local data12 = samp_create_sync_data('player')
		data12.position.x = 1681
		data12.position.y = 2125
		data12.position.z = 11.47
		data12.keysData = data12.keysData + 16
		data12.send()
		wait(g)
		local data13 = samp_create_sync_data('player')
		data13.position.x = 1679
		data13.position.y = 2114
		data13.position.z = 11.47
		data13.keysData = data13.keysData + 16
		data13.send()
		wait(g)
		local data14 = samp_create_sync_data('player')
		data14.position.x = 1644
		data14.position.y = 2148
		data14.position.z = 11.47
		data14.keysData = data14.keysData + 16
		data14.send()
		wait(g)
		local data15 = samp_create_sync_data('player') -- 1 склад
		data15.position.x = 2161.29
		data15.position.y = -2266.88
		data15.position.z = 16.73
		data15.send()
		sampSendPickedUpPickup(707) -- взятие пикапа 1 электроники
		wait(g)
		local data16 = samp_create_sync_data('player') -- 2 склад
		data16.position.x = 2160.60
		data16.position.y = -2266.79
		data16.position.z = 16.73
		data16.send()
		sampSendPickedUpPickup(708) -- взятие пикапа 2 электроники
		wait(g)
		local data17 = samp_create_sync_data('player') -- 3 склад
		data17.position.x = 2160.37
		data17.position.y = -2266.85
		data17.position.z = 16.73
		data17.send()
		sampSendPickedUpPickup(709) -- взятие пикапа 3 электроники
		wait(g)
		local data18 = samp_create_sync_data('player') -- 4 склад
		data18.position.x = 2160.37
		data18.position.y = -2266.85
		data18.position.z = 16.73
		data18.send()
		sampSendPickedUpPickup(710) -- взятие пикапа 4 электроники
		wait(g)
		local data19 = samp_create_sync_data('player') -- 1 склад 2 круг
		data19.position.x = 2161.29
		data19.position.y = -2266.88
		data19.position.z = 16.73
		data19.send()
		sampSendPickedUpPickup(707) -- взятие пикапа 1 электроники
		wait(g)
		local data20 = samp_create_sync_data('player') -- 2 склад 2 круг
		data20.position.x = 2160.60
		data20.position.y = -2266.79
		data20.position.z = 16.73
		data20.send()
		sampSendPickedUpPickup(708) -- взятие пикапа 2 электроники
		wait(g)
		local data21 = samp_create_sync_data('player') -- 3 склад 2 круг
		data21.position.x = 2160.37
		data21.position.y = -2266.85
		data21.position.z = 16.73
		data21.send()
		sampSendPickedUpPickup(709) -- взятие пикапа 3 электроники
		wait(g)
		local data22 = samp_create_sync_data('player') -- 4 склад 2 круг
		data22.position.x = 2160.37
		data22.position.y = -2266.85
		data22.position.z = 16.73
		data22.send()
		sampSendPickedUpPickup(710) -- взятие пикапа 4 электроники
		wait(g)
		local data23 = samp_create_sync_data('player') -- бендер
		data23.position.x = 1858.67
		data23.position.y = -2255.09
		data23.position.z = 1505
		data23.keysData = data23.keysData + 16 
		data23.send()
		wait(g)
		if sampIsDialogActive(441) then
			sampSetCurrentDialogListItem(2)
			wait(g)
			sampCloseCurrentDialogWithButton(1)
		end
	end

    if option == "snabzhenie1" then
		setCharCoordinates(PLAYER_PED, 274,1933,18)
		wait(50)
		setCharCoordinates(PLAYER_PED, 668,1844,5)
		wait(50)
		setCharCoordinates(PLAYER_PED, -149,442,12)
		wait(50)
		setCharCoordinates(PLAYER_PED, 254,2006,17)
	end

	if option == "snabzhenie2" then
		setCharCoordinates(PLAYER_PED, -1457,500,18)
		wait(80)
		setCharCoordinates(PLAYER_PED, -1935,-1670,32)
		wait(80)
		setCharCoordinates(PLAYER_PED, 768,1568,6)
		wait(80)
		setCharCoordinates(PLAYER_PED, 305,1979,17)
		wait(80)
		setCharCoordinates(PLAYER_PED, 224,1823,6)
	end

	if option == "shkolnik" then
		local g = 500
		local data = samp_create_sync_data('player') -- библиотека
		data.position.x = 269
		data.position.y = 120
		data.position.z = 3004
		data.keysData = data.keysData + 16
		data.send()
		sampCloseCurrentDialogWithButton(1)
		wait(g)
		local data1 = samp_create_sync_data('player') -- информатика
		data1.position.x = 277.38
		data1.position.y = 110.52
		data1.position.z = 3007.82
		data1.keysData = data1.keysData + 16
		data1.send()
		sampCloseCurrentDialogWithButton(1)
		wait(g)
		local data2 = samp_create_sync_data('player') -- директор
		data2.position.x = 256.81
		data2.position.y = 116.02
		data2.position.z = 3007.82
		data2.keysData = data2.keysData + 16
		data2.send()
		sampCloseCurrentDialogWithButton(1)
		wait(g)
		local data3 = samp_create_sync_data('player') -- система пожаротушения
		data3.position.x = 256.81
		data3.position.y = 119
		data3.position.z = 3008
		data3.keysData = data3.keysData + 16
		data3.send()
		wait(g)
		local data4 = samp_create_sync_data('player') -- принтер
		data4.position.x = 277.84
		data4.position.y = 125.24
		data4.position.z = 3008.82
		data4.keysData = data4.keysData + 16
		data4.send()
		sampCloseCurrentDialogWithButton(1)
		wait(g)
		local data5 = samp_create_sync_data('player') -- карта
		data5.position.x = 261
		data5.position.y = 110
		data5.position.z = 3004
		data5.keysData = data5.keysData + 16
		data5.send()
		sampCloseCurrentDialogWithButton(1)
		wait(g)
		local data6 = samp_create_sync_data('player') -- карта
		data6.position.x = -348.98
		data6.position.y = 1921.62
		data6.position.z = 59.53
		data6.keysData = data6.keysData + 16
		data6.send()
		--setCharCoordinates(PLAYER_PED, 253.82482910156,125.14071655273,3003.21875)
		--wait(2100)
		--setCharCoordinates(PLAYER_PED, -348.98382568359,1921.6213378906,59.535022735596)
	end

	if option == "piratetreasure" then
		local data = samp_create_sync_data('player')
		data.position.x = 1749.33
		data.position.y = 499.80
		data.position.z = -45.95
		data.keysData = data.keysData + 16
		data.send()
		wait(150)
		local data1 = samp_create_sync_data('player')
		data1.position.x = 250
		data1.position.y = 67.7
		data1.position.z = 2003.64
		data1.send()
		sampSendPickedUpPickup(414)
		wait(50)
		sampSendDialogResponse(123, 1, 7)
		wait(100)
		sampCloseCurrentDialogWithButton(0)
	end

	if option == "hotel" then
		Xx, Yy, Zz = getCharCoordinates(playerPed) 
	    X1, Y1, Z1 = math.floor(Xx), math.floor(Yy), math.floor(Zz)
		freezeCharPosition(PLAYER_PED, true)
		wait(0)
		setCharCoordinates(PLAYER_PED, 2206.15,-1170.24,1028.80)
		wait(2500)
		setVirtualKeyDown(70, true)
		wait(40)
		setVirtualKeyDown(70, false)
		wait(40)
		if sampIsDialogActive(413) then
			sampCloseCurrentDialogWithButton(1)
		end
		setCharCoordinates(PLAYER_PED, X1,Y1,Z1)
		wait(0)
		freezeCharPosition(PLAYER_PED, false)
	end

	if option == "post" then
		Xx, Yy, Zz = getCharCoordinates(playerPed) 
	    X1, Y1, Z1 = math.floor(Xx), math.floor(Yy), math.floor(Zz)
		setCharCoordinates(PLAYER_PED, 2816.63,-1177.70,1525.57)
        wait(1850)
		setVirtualKeyDown(70, true)
		wait(40)
		setVirtualKeyDown(70, false)
		wait(450)
		if sampIsDialogActive(790) then
			sampCloseCurrentDialogWithButton(1)
			wait(100)
		end
		setCharCoordinates(PLAYER_PED, X1,Y1,Z1)
	end

	if option == "nano" then
		g = 400
		local data = samp_create_sync_data('player')
		data.position.x = 1857.01
		data.position.y = -2276.49
		data.position.z = 1506.97
		data.keysData = data.keysData + 16
		data.send()
		wait(300)
		local data1 = samp_create_sync_data('player')
		data1.position.x = 1858.84
		data1.position.y = -2255.11
		data1.position.z = 1506.98
		data1.keysData = data1.keysData + 16
		data1.send()
		wait(g)
		if sampIsDialogActive() then
			sampSetCurrentDialogListItem(5)
			wait(100)
			sampCloseCurrentDialogWithButton(1)
		end
		wait(g)
		local data2 = samp_create_sync_data('player')
		data2.position.x = 1855.83
		data2.position.y = -2288.81
		data2.position.z = 1506.97
		data2.keysData = data2.keysData + 16
		data2.send()
		wait(g)
		local data3 = samp_create_sync_data('player')
		data3.position.x = 1860.57
		data3.position.y = -2284.95
		data3.position.z = 1500.83
		data3.keysData = data3.keysData + 16
		data3.send()
		wait(g)
		local data4 = samp_create_sync_data('player')
		data4.position.x = 1865.71
		data4.position.y = -2280.04
		data4.position.z = 1500.83
		data4.keysData = data4.keysData + 16
		data4.send()
		wait(g)
		local data5 = samp_create_sync_data('player')
		data5.position.x = 1879.28
		data5.position.y = -2297.38
		data5.position.z = 1500.83
		data5.keysData = data5.keysData + 16
		data5.send()
		wait(g)
		local data6 = samp_create_sync_data('player')
		data6.position.x = 1886.21
		data6.position.y = -2306.61
		data6.position.z = 1500.83
		data6.keysData = data6.keysData + 16
		data6.send()
		wait(g)
		local data7 = samp_create_sync_data('player')
		data7.position.x = 1893.97
		data7.position.y = -2298.52
		data7.position.z = 1500.83
		data7.keysData = data7.keysData + 16
		data7.send()
		wait(g)
		local data8 = samp_create_sync_data('player')
		data8.position.x =  1860.57
		data8.position.y = -2279.47
		data8.position.z = 1500.83
		data8.keysData = data8.keysData + 16
		data8.send()
		wait(g)
		local data9 = samp_create_sync_data('player')
		data9.position.x =  1862.65
		data9.position.y = -2285.19
		data9.position.z = 1500.83
		data9.keysData = data9.keysData + 16
		data9.send()
		setPlayerControl(player, true)
		freezeCharPosition(PLAYER_PED, false)
	end

	if option == "vzlom" then
		soundd = 0
		repeat
			sampSendClickTextdraw(12)
			wait(200)
		until soundd == 1
	end

	if option == "lesopilka" then
		setCharCoordinates(PLAYER_PED, -564.27,-180.97,77.41)
		wait(2500)
		sampSendPickedUpPickup(412)
		if sampIsDialogActive(110) then
			sampCloseCurrentDialogWithButton(1)
		end
		setCharCoordinates(PLAYER_PED, -529.60,-36.48,62.14)
		wait(50)
		for i = 1, 215 do
			setVirtualKeyDown(01, true)
			wait(0)
			setVirtualKeyDown(01, false)
			wait(0)
		end
	end
end

function sampev.onPlaySound(soundId)
	while checked_sound.v do
		sampAddChatMessage("ID Звука " .. soundId, danger_color)
		return
	end

	if soundId == 36401 then
		soundd = 1
	end
end

function sampev.onSendClickTextDraw(textdrawId)
	while checked_textdraw.v do
		sampAddChatMessage("ID Текстдрава " .. textdrawId, danger_color)
		return
	end
end

function sampev.onSendPickedUpPickup(pickupId)
	while checked_pickup.v do
		sampAddChatMessage("ID Пикапа " .. pickupId, danger_color)
		return false
    end
	
	--while checked_radar.v and pickupId == 3184 or pickupId == 3170 do
	--	sampAddChatMessage("Защита от входа на радар", danger_color)
	--	return false
	--end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	while checked_dialog.v do
		sampAddChatMessage("ID Диалога " .. dialogId, danger_color)
	    return
	end
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
	if imgui.Process then
		imgui.SetNextWindowSize(imgui.ImVec2(800, 495), 0) -- размер главного меню
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw * 0.15, sh * 0.45), imgui.Cond.FirstUseEver,
		imgui.ImVec2(0.5, 0.5))
		imgui.RenderInMenu = true

		local sw,sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw/2,sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
		imgui.Begin(u8"Z.O.N.A HELPER", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		
		imgui.BeginChild("leftPanel", imgui.ImVec2(158, 487), true)
		
		if imgui.Button("\xef\x97\xbd" .. u8" Основное", imgui.ImVec2(150, 60)) then menu = 1 end
        if imgui.Button("\xef\x8f\x85" .. u8" Телепорт", imgui.ImVec2(150, 60)) then menu = 2 end
		if imgui.Button("\xef\x9c\x8e" .. u8" Квест ", imgui.ImVec2(150, 60)) then menu = 3 end
        if imgui.Button("\xef\x82\xb1" .. u8" Работы", imgui.ImVec2(150, 60)) then menu = 4 end
		if imgui.Button("\xef\x9f\x99" .. u8" Developer's tools", imgui.ImVec2(150, 60)) then menu = 5 end

		imgui.EndChild()

		imgui.SameLine()

		if menu == 1 then
			imgui.BeginChild("rightpanel1", imgui.ImVec2(623, 487), true)
		
			if imgui.Button("\xef\x86\xae" .. u8" Спавн", imgui.ImVec2(150, 60)) then
				sampSpawnPlayer()
				restoreCameraJumpcut()
			end

			imgui.SameLine()

			if imgui.Button("\xef\x9c\x94" .. u8" Суицид", imgui.ImVec2(150, 60)) then
				setCharHealth(playerPed, 0) 
			end

            imgui.SameLine()

			if imgui.Button("\xef\x8b\x9c" .. u8" Зафризить", imgui.ImVec2(150, 60)) then
				setPlayerControl(player, false)
				freezeCharPosition(PLAYER_PED, true)
			end

			imgui.SameLine()
			
			if imgui.Button("\xef\x81\xad" .. u8" Разфризить", imgui.ImVec2(150, 60)) then
				setPlayerControl(player, true)
				freezeCharPosition(PLAYER_PED, false)
			end

			if imgui.Button("\xef\x83\xba" .. u8" Здоровье", imgui.ImVec2(150, 60)) then
				setCharHealth(PLAYER_PED, 100)
			end

			imgui.SameLine()

			if imgui.Button("\xef\x8f\xad" .. u8" Броня", imgui.ImVec2(150, 60)) then
				addArmourToChar(PLAYER_PED, 100)
			end
			
			imgui.SameLine()

			if imgui.Button("\xef\x81\xa7" .. u8" Допы", imgui.ImVec2(150, 60)) then
				local data = samp_create_sync_data('player')
		        data.position.x = 914
				data.position.y = 3706
				data.position.z = 19
				data.send()
				sampSendPickedUpPickup(580)
			end

            imgui.SameLine()

			if imgui.Button("\xef\x82\xad" .. u8" Починить Т/С", imgui.ImVec2(150, 60)) then
				repcar()
			end

			if imgui.Button("\xef\x80\xa1" .. u8" Флипнуть Т/С", imgui.ImVec2(150, 60)) then
				flipcar()
			end

			imgui.SameLine()

			if imgui.Button("\xef\x84\xbe" .. u8" Взлом замков", imgui.ImVec2(150, 60)) then
				thread:run("vzlom")
			end	
		
		imgui.EndChild()
		end
		
		imgui.SameLine()

		if menu == 2 then
			imgui.BeginChild("rightpanel2", imgui.ImVec2(623, 487), true)

			if imgui.Button(u8"Бар", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -70,1375,9)
			end

            imgui.SameLine()

			if imgui.Button(u8"Янов", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 147,1271,22)
			end
			
			imgui.SameLine() 

			if imgui.Button(u8"Арена", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -531,2591,53)
			end

			imgui.SameLine()

			if imgui.Button(u8"Нефтезавод", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 265,1396,10)
			end

			if imgui.Button(u8"Анклав", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 137,1957,19)
			end

			imgui.SameLine()

			if imgui.Button(u8"Сталкеры", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 403,2516,16)
			end

			imgui.SameLine()

			if imgui.Button(u8"Бандиты", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -792,2412,156)
			end

			imgui.SameLine()

			if imgui.Button(u8"Радар", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -376,1549,75)
			end

			if imgui.Button(u8"Склады", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 306,1902,17)
			end

			imgui.SameLine()

			if imgui.Button(u8"Чиллиад", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -2289,-1682,482)
			end

			imgui.SameLine()

			if imgui.Button(u8"Пескадеро", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -926,2037,60)
			end

			imgui.SameLine()

			if imgui.Button(u8"Карсон", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -135,1098,19)
			end

			if imgui.Button(u8"Боун", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -296,2703,62)
			end
			
			imgui.SameLine() 

			if imgui.Button(u8"Бруджас", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -390,2262,41)
			end

			imgui.SameLine()

			if imgui.Button(u8"Кебрадос", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -1498,2673,56)
			end

			imgui.SameLine()

			if imgui.Button(u8"Робада", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -810,1492,20)
			end

			if imgui.Button(u8"Авианосец", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -1263,495,18)
			end

			imgui.SameLine()

			if imgui.Button(u8"Свалка", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 671,1352,11)
			end

			imgui.SameLine() 

			if imgui.Button(u8"Кордон", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, -134,502,9)
			end

			imgui.SameLine()

			if imgui.Button(u8"Актив свободы", imgui.ImVec2(150, 60)) then
				setCharCoordinates(PLAYER_PED, 1090,2099,-5)
			end
			
			if imgui.Button(u8"Пиратский клад", imgui.ImVec2(150, 60)) then 
				setCharCoordinates(PLAYER_PED, 1865.4306640625,509.53121948242,-59.6640625)
			end

			imgui.SameLine()

			if imgui.Button(u8"Левая панель", imgui.ImVec2(150, 60)) then 
				setCharCoordinates(PLAYER_PED, 2154.27,1607.17,993.72)
			end

			imgui.SameLine()

			if imgui.Button(u8"Правая панель", imgui.ImVec2(150, 60)) then 
				setCharCoordinates(PLAYER_PED, 2133.08,1607.17,993.72)
			end

			imgui.SameLine() 

			if imgui.Button(u8"Кибердайн", imgui.ImVec2(150, 60)) then 
				setCharCoordinates(PLAYER_PED, 1869.19,-2254.61,1505.98)
			end

			imgui.SameLine() 

			imgui.SameLine() 
			
			imgui.EndChild()
		end

		if menu == 3 then
			imgui.BeginChild("rightpanel3", imgui.ImVec2(623, 487), true)

			imgui.EndChild()
		end
		
		if menu == 4 then
			imgui.BeginChild("rightpanel4", imgui.ImVec2(623, 487), true)
			if imgui.Button("\xef\x86\xb8" .. u8" Электроника", imgui.ImVec2(150, 60)) then
				thread:run("electronics")
			end

            imgui.SameLine()

			if imgui.Button("\xef\x83\x91" .. u8" Снабжение 1", imgui.ImVec2(150, 60)) then
				thread:run("snabzhenie1")
			end

			imgui.SameLine()

			if imgui.Button("\xef\x94\xb3" .. u8" Снабжение 2", imgui.ImVec2(150, 60)) then
				thread:run("snabzhenie2")
			end

			imgui.SameLine()

			if imgui.Button("\xef\x95\x89" .. u8" Клад школьника", imgui.ImVec2(150, 60)) then
				thread:run("shkolnik")
			end

			if imgui.Button("\xef\x85\x95" .. u8" Пиратский клад", imgui.ImVec2(150, 60)) then
				thread:run("piratetreasure")
			end

			imgui.SameLine()
			
			if imgui.Button("\xef\x83\xa0" .. u8" Взять почту", imgui.ImVec2(150, 60)) then
				thread:run("post")
			end
			
			imgui.SameLine()

			if imgui.Button("\xef\x96\x94" .. u8" Взять отель", imgui.ImVec2(150, 60)) then
				thread:run("hotel")
			end

            imgui.SameLine()
   
            if imgui.Button("\xef\x95\x84" .. u8" Наноботы", imgui.ImVec2(150, 60)) then
				thread:run("nano")
			end

			if imgui.Button("\xef\x86\xbb" .. u8" Лесопилка", imgui.ImVec2(150, 60)) then
				thread:run("lesopilka")
			end
			
			imgui.EndChild()
		end

		if menu == 5 then
			imgui.BeginChild("rightpanel5", imgui.ImVec2(623, 487), true)
			x, y, z = getCharCoordinates(playerPed)

			if imgui.Button("\xef\x83\x85" .. u8" Скопировать позицию игрока") then
				setClipboardText((("%.2f"):format(x)) .. "," .. ("%.2f"):format(y) .. "," .. ("%.2f"):format(z))
				sampAddChatMessage("Координаты успешно скопированы в буфер обмена", white_color)
			end

			imgui.Checkbox(u8"Показывать ID пикапов", checked_pickup)
			imgui.Checkbox(u8"Показывать ID диалогов", checked_dialog)
			imgui.Checkbox(u8"Показывать ID текстдравов", checked_textdraw)
			imgui.Checkbox(u8"Показывать ID звуков", checked_sound)

			--imgui.Checkbox(u8"Запрет входа на радар", checked_radar)

			imgui.EndChild()
		end
	imgui.End()
	end
end