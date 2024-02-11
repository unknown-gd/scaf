local addonName = "Simple Chromatic Aberration Filter"

local pp_scaf = CreateClientConVar( "pp_scaf", "0", false, false, "Enable/Disable chromatic aberration filter.", 0, 1 )
local pp_scaf_intensity = CreateClientConVar( "pp_scaf_intensity", "2", true, false, "How intense the chromatic aberration will be.", 0, 100 )

local pp_scaf_redx = CreateClientConVar( "pp_scaf_redx", "8", true, false, "Mixing of chromatic aberrations in the red channel along the X-axis. <Default 8>", 0, 100 )
local pp_scaf_redy = CreateClientConVar( "pp_scaf_redy", "4", true, false, "Mixing of chromatic aberrations in the red channel along the Y-axis. <Default 4>", 0, 100 )

local pp_scaf_greenx = CreateClientConVar( "pp_scaf_greenx", "4", true, false, "Mixing of chromatic aberrations in the green channel along the X-axis. <Default 4>", 0, 100 )
local pp_scaf_greeny = CreateClientConVar( "pp_scaf_greeny", "2", true, false, "Mixing of chromatic aberrations in the green channel along the Y-axis. <Default 2>", 0, 100 )

local pp_scaf_bluey = CreateClientConVar( "pp_scaf_bluey", "0", true, false, "Mixing of chromatic aberrations in the blue channel along the Y-axis. <Default 0>", 0, 100 )
local pp_scaf_bluex = CreateClientConVar( "pp_scaf_bluex", "0", true, false, "Mixing of chromatic aberrations in the blue channel along the X-axis. <Default 0>", 0, 100 )

list.Set( "PostProcess", "#pp_scaf.name", {
	["icon"] = "gui/postprocess/scaf.jpg",
	["convar"] = pp_scaf:GetName(),
	["category"] = "#shaders_pp",
	["cpanel"] = function( panel )
		panel:AddControl( "ComboBox", {
			["MenuButton"] = 1,
			["Folder"] = "scaf",
			["Options"] = {
				[ "#preset.default" ] = {
					[ pp_scaf:GetName() ] = pp_scaf:GetDefault(),
					[ pp_scaf_intensity:GetName() ] = pp_scaf_intensity:GetDefault(),
					[ pp_scaf_redx:GetName() ] = pp_scaf_redx:GetDefault(),
					[ pp_scaf_redy:GetName() ] = pp_scaf_redy:GetDefault(),
					[ pp_scaf_greenx:GetName() ] = pp_scaf_greenx:GetDefault(),
					[ pp_scaf_greeny:GetName() ] = pp_scaf_greeny:GetDefault(),
					[ pp_scaf_bluey:GetName() ] = pp_scaf_bluey:GetDefault(),
					[ pp_scaf_bluex:GetName() ] = pp_scaf_bluex:GetDefault()
				}
			},
			["CVars"] = {
				pp_scaf:GetName(),
				pp_scaf_intensity:GetName(),
				pp_scaf_redx:GetName(),
				pp_scaf_redy:GetName(),
				pp_scaf_greenx:GetName(),
				pp_scaf_greeny:GetName(),
				pp_scaf_bluey:GetName(),
				pp_scaf_bluex:GetName()
			}
		} )

		-- Enable/Disable
		panel:AddControl( "CheckBox", {
			["Label"] = "#pp_scaf.enable",
			["Command"] = pp_scaf:GetName()
		} )

		-- Intensity
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.intensity",
			["Command"] = pp_scaf_intensity:GetName(),
			["Min"] = tostring( pp_scaf_intensity:GetMin() ),
			["Max"] = tostring( pp_scaf_intensity:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		-- Red
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.redx",
			["Command"] = pp_scaf_redx:GetName(),
			["Min"] = tostring( pp_scaf_redx:GetMin() ),
			["Max"] = tostring( pp_scaf_redx:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.redy",
			["Command"] = pp_scaf_redy:GetName(),
			["Min"] = tostring( pp_scaf_redy:GetMin() ),
			["Max"] = tostring( pp_scaf_redy:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		-- Green
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.greenx",
			["Command"] = pp_scaf_greenx:GetName(),
			["Min"] = tostring( pp_scaf_greenx:GetMin() ),
			["Max"] = tostring( pp_scaf_greenx:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.greeny",
			["Command"] = pp_scaf_greeny:GetName(),
			["Min"] = tostring( pp_scaf_greeny:GetMin() ),
			["Max"] = tostring( pp_scaf_greeny:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		-- Blue
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.bluex",
			["Command"] = pp_scaf_bluex:GetName(),
			["Min"] = tostring( pp_scaf_bluex:GetMin() ),
			["Max"] = tostring( pp_scaf_bluex:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )

		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.bluey",
			["Command"] = pp_scaf_bluey:GetName(),
			["Min"] = tostring( pp_scaf_bluey:GetMin() ),
			["Max"] = tostring( pp_scaf_bluey:GetMax() ),
			["Type"] = "Float",
			["Help"] = true
		} )
	end
} )

-- https://wiki.facepunch.com/gmod/cvars.AddChangeCallback
local enabled = pp_scaf:GetBool()
cvars.AddChangeCallback( pp_scaf:GetName(), function( _, __, new )
	enabled = new == "1"
end, addonName )

local Run = hook.Run

local redX, greenX, blueX = 0, 0, 0
local redY, greenY, blueY = 0, 0, 0

do

	local floor = math.floor
	local intensity = 0

	hook.Add( "Think", addonName, function()
		if not enabled or Run( "PostProcessPermitted", "scafilter" ) == false then return end
		intensity = pp_scaf_intensity:GetFloat()
		redX, greenX, blueX = floor( pp_scaf_redx:GetInt() * intensity ), floor( pp_scaf_greenx:GetInt() * intensity ), floor( pp_scaf_bluex:GetInt() * intensity )
		redY, greenY, blueY = floor( pp_scaf_redy:GetInt() * intensity ), floor( pp_scaf_greeny:GetInt() * intensity ), floor( pp_scaf_bluey:GetInt() * intensity )
	end )

end

-- https://wiki.facepunch.com/gmod/GM:OnScreenSizeChanged
local width, height = ScrW(), ScrH()
hook.Add( "OnScreenSizeChanged", addonName, function()
	width, height = ScrW(), ScrH()
end )

-- https://gitspartv.github.io/LuaJIT-Benchmarks/#test1
local UpdateScreenEffectTexture, GetScreenEffectTexture = render.UpdateScreenEffectTexture, render.GetScreenEffectTexture
local SetMaterial, DrawScreenQuad, DrawScreenQuadEx = render.SetMaterial, render.DrawScreenQuad, render.DrawScreenQuadEx
local red, green, blue = Material( "color/red" ), Material( "color/green" ), Material( "color/blue" )
local black = Material( "vgui/black" )

hook.Add( "RenderScreenspaceEffects", addonName, function()
	if not enabled or Run( "PostProcessPermitted", "scafilter" ) == false then return end
	UpdateScreenEffectTexture()

	red:SetTexture( "$basetexture", GetScreenEffectTexture() )
	green:SetTexture( "$basetexture", GetScreenEffectTexture() )
	blue:SetTexture( "$basetexture", GetScreenEffectTexture() )

	SetMaterial( black )
	DrawScreenQuad()

	SetMaterial( red )
	DrawScreenQuadEx( -redX / 2, -redY / 2, width + redX, height + redY )

	SetMaterial( green )
	DrawScreenQuadEx( -greenX / 2, -greenY / 2, width + greenX, height + greenY )

	SetMaterial( blue )
	DrawScreenQuadEx( -blueX / 2, -blueY / 2, width + blueX, height + blueY )
end )
