local addonName = "Simple Chromatic Aberration Filter"

-- https://wiki.facepunch.com/gmod/Global.CreateClientConVar
local pp_scaf = CreateClientConVar( "pp_scaf", "0", true, false, "Enable/Disable chromatic aberration filter.", 0, 1 )
local pp_scaf_intensity = CreateClientConVar( "pp_scaf_intensity", "2", true, false, "How intense the chromatic aberration will be.", 0, 100 )

-- https://i.imgur.com/8B3KakB.png
local pp_scaf_redx = CreateClientConVar( "pp_scaf_redx", "8", true, false, "Mixing of chromatic aberrations in the red channel along the X-axis.", 0, 128 )
local pp_scaf_redy = CreateClientConVar( "pp_scaf_redy", "4", true, false, "Mixing of chromatic aberrations in the red channel along the Y-axis.", 0, 128 )

local pp_scaf_greenx = CreateClientConVar( "pp_scaf_greenx", "4", true, false, "Mixing of chromatic aberrations in the green channel along the X-axis.", 0, 128 )
local pp_scaf_greeny = CreateClientConVar( "pp_scaf_greeny", "2", true, false, "Mixing of chromatic aberrations in the green channel along the Y-axis.", 0, 128 )

local pp_scaf_bluex = CreateClientConVar( "pp_scaf_bluex", "0", true, false, "Mixing of chromatic aberrations in the blue channel along the X-axis.", 0, 128 )
local pp_scaf_bluey = CreateClientConVar( "pp_scaf_bluey", "0", true, false, "Mixing of chromatic aberrations in the blue channel along the Y-axis.", 0, 128 )

-- Brightness options
local mat_autoexposure_min = GetConVar( "mat_autoexposure_min" )
local mat_autoexposure_max = GetConVar( "mat_autoexposure_max" )
local mat_bloom_scalefactor_scalar = GetConVar( "mat_bloom_scalefactor_scalar" )
local mat_bloomscale = GetConVar( "mat_bloomscale" )

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
					[ pp_scaf_bluex:GetName() ] = pp_scaf_bluex:GetDefault(),
					[ pp_scaf_bluey:GetName() ] = pp_scaf_bluey:GetDefault(),
					[ mat_autoexposure_min:GetName() ] = mat_autoexposure_min:GetDefault(),
					[ mat_autoexposure_max:GetName() ] = mat_autoexposure_max:GetDefault(),
					[ mat_bloom_scalefactor_scalar:GetName() ] = mat_bloom_scalefactor_scalar:GetDefault(),
					[ mat_bloomscale:GetName() ] = mat_bloomscale:GetDefault()
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
				pp_scaf_bluex:GetName(),
				mat_autoexposure_min:GetName(),
				mat_autoexposure_max:GetName(),
				mat_bloom_scalefactor_scalar:GetName(),
				mat_bloomscale:GetName()
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
			
		-- Brightness options
                panel:ControlHelp(" ")
		panel:AddControl( "Label", {
			["Text"] = "#brightness.text"
		} )
			
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.autoexposure_min",
			["Command"] = mat_autoexposure_min:GetName(),
			["Min"] = tostring( mat_autoexposure_min:GetMin() or 0 ),
			["Max"] = tostring( mat_autoexposure_min:GetMax() or 10 ),
			["Type"] = "Float",
			["Help"] = true
		} )
		
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.autoexposure_max",
			["Command"] = mat_autoexposure_max:GetName(),
			["Min"] = tostring( mat_autoexposure_max:GetMin() or 0 ),
			["Max"] = tostring( mat_autoexposure_max:GetMax() or 10 ),
			["Type"] = "Float",
			["Help"] = true
		} )
		
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.bloom_scalefactor",
			["Command"] = mat_bloom_scalefactor_scalar:GetName(),
			["Min"] = tostring( mat_bloom_scalefactor_scalar:GetMin() or 0 ),
			["Max"] = tostring( mat_bloom_scalefactor_scalar:GetMax() or 2 ),
			["Type"] = "Float",
			["Help"] = true
		} )
		
		panel:AddControl( "Slider", {
			["Label"] = "#pp_scaf.bloomscale",
			["Command"] = mat_bloomscale:GetName(),
			["Min"] = tostring( mat_bloomscale:GetMin() or 0 ),
			["Max"] = tostring( mat_bloomscale:GetMax() or 2 ),
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

local function isPostProcessPermitted()
	return enabled and Run( "PostProcessPermitted", "scafilter" ) ~= false
end

local redX, greenX, blueX = 0, 0, 0
local redY, greenY, blueY = 0, 0, 0
local floor = math.floor
local intensity = 0

hook.Add( "Think", addonName, function()
	if isPostProcessPermitted() then
		intensity = pp_scaf_intensity:GetFloat()
		redX, greenX, blueX = floor( pp_scaf_redx:GetInt() * intensity ), floor( pp_scaf_greenx:GetInt() * intensity ), floor( pp_scaf_bluex:GetInt() * intensity )
		redY, greenY, blueY = floor( pp_scaf_redy:GetInt() * intensity ), floor( pp_scaf_greeny:GetInt() * intensity ), floor( pp_scaf_bluey:GetInt() * intensity )
	end
end )

-- https://wiki.facepunch.com/gmod/GM:OnScreenSizeChanged
local width, height = ScrW(), ScrH()
hook.Add( "OnScreenSizeChanged", addonName, function()
	width, height = ScrW(), ScrH()
end )

-- https://gitspartv.github.io/LuaJIT-Benchmarks/#test1
local SetMaterial, DrawScreenQuad, DrawScreenQuadEx, UpdateScreenEffectTexture = render.SetMaterial, render.DrawScreenQuad, render.DrawScreenQuadEx, render.UpdateScreenEffectTexture
local screenEffectTexture, black = render.GetScreenEffectTexture( 0 ), Material( "vgui/black" )

local red = Material( "color/red" )
red:SetTexture( "$basetexture", screenEffectTexture )

local green = Material( "color/green" )
green:SetTexture( "$basetexture", screenEffectTexture )

local blue = Material( "color/blue" )
blue:SetTexture( "$basetexture", screenEffectTexture )

hook.Add( "RenderScreenspaceEffects", addonName, function()
	if isPostProcessPermitted() then
		UpdateScreenEffectTexture()

		SetMaterial( black )
		DrawScreenQuad()

		SetMaterial( red )
		DrawScreenQuadEx( -redX / 2, -redY / 2, width + redX, height + redY )

		SetMaterial( green )
		DrawScreenQuadEx( -greenX / 2, -greenY / 2, width + greenX, height + greenY )

		SetMaterial( blue )
		DrawScreenQuadEx( -blueX / 2, -blueY / 2, width + blueX, height + blueY )
	end
end )
