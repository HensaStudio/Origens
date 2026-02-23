-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	OnEnterMp()
	SetInstancePriorityMode(true)

	-- Coroner
	RequestIpl("coronertrash")
	RequestIpl("Coroner_Int_On")

	-- Chop shop props
	RequestIpl("chop_props")

	-- Rock Club
	RequestIpl("v_rockclub")

	-- Simeon Concessionária (PDM) - versão sem balcão
	RequestIpl("v_carshowroom")   -- showroom ativo
	RequestIpl("shr_int")         -- interior
	RequestIpl("shr_int_lod")     -- LOD do interior
	RequestIpl("shutter_open")    -- portas abertas
	RemoveIpl("shutter_closed")   -- remove portas/balcão fechado
	RemoveIpl("csr_inMission")    -- remove versão de missão
	RemoveIpl("csr_beforeMission")-- remove versão pré missão
	RequestIpl("csr_afterMission")-- ativa versão limpa sem balcão

	-- Stilthouse
	RemoveIpl("DES_StiltHouse_imapend")
	RequestIpl("DES_stilthouse_rebuild")

	-- FIB / Facade
	RemoveIpl("facelobbyfake")
	RequestIpl("facelobby")
	RequestIpl("FIBlobby")
	RemoveIpl("FIBlobbyfake")
	RequestIpl("FBI_colPLUG")
	RequestIpl("FBI_repair")

	-- Union Depository construction (limpeza)
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")

	-- Farmhouse
	RequestIpl("des_farmhouse")
	RequestIpl("des_farmhs_endimap")
	RequestIpl("des_farmhs_end_occl")
	RequestIpl("des_farmhs_startimap")
	RequestIpl("des_farmhs_start_occl")
	RequestIpl("farm")
	RequestIpl("farm_props")
	RequestIpl("farm_int")
	RequestIpl("farmint")
	RemoveIpl("farm_burnt")
	RemoveIpl("farm_burnt_props")

	-- Trevor
	RemoveIpl("TrevorsMP")
	RemoveIpl("TrevorsTrailer")
	RequestIpl("TrevorsTrailerTidy")
	RemoveIpl("TrevorsTrailerTrash")

	-- Outros interiores
	RequestIpl("dt1_03_gr_closed")
	RequestIpl("dt1_21_prop_lift")
	RequestIpl("dt1_21_prop_lift_on")
	RemoveIpl("DT1_03_Shutter")
	RequestIpl("yogagame")
	RequestIpl("v_tunnel_hole")

	-- Casa do Michael
	RequestIpl("V_Michael")
	RequestIpl("V_Michael_Garage")
	RequestIpl("V_Michael_FameShame")
	RequestIpl("V_Michael_JewelHeist")
	RequestIpl("V_Michael_plane_ticket")
	RequestIpl("V_Michael_Scuba")

	-- Yacht
	RequestIpl("hei_yacht_heist")
	RequestIpl("hei_yacht_heist_Bar")
	RequestIpl("hei_yacht_heist_Bedrm")
	RequestIpl("hei_yacht_heist_Bridge")
	RequestIpl("hei_yacht_heist_DistantLights")
	RequestIpl("hei_yacht_heist_enginrm")
	RequestIpl("hei_yacht_heist_LODLights")
	RequestIpl("hei_yacht_heist_Lounge")

	-- Outros fixes
	RequestIpl("sc1_01_newbill")
	RequestIpl("hw1_02_newbill")
	RequestIpl("hw1_emissive_newbill")
	RequestIpl("sc1_14_newbill")
	RequestIpl("dt1_17_newbill")
	RequestIpl("SC1_01_OldBill")
	RequestIpl("SC1_30_Keep_Closed")
	RequestIpl("refit_unload")
	RequestIpl("post_hiest_unload")
	RequestIpl("occl_meth_grp1")
	RequestIpl("Michael_premier")
	RequestIpl("DT1_05_HC_REQ")
	RequestIpl("DT1_05_REQUEST")

	-- Diversos
	RequestIpl("scafendimap")
	RequestIpl("ferris_finale_anim")
	RequestIpl("ferris_finale_anim_lod")
	RequestIpl("CS2_06_TriAf02")
	RequestIpl("CS4_08_TriAf02")
	RequestIpl("CS4_04_TriAf03")
	RequestIpl("AP1_04_TriAf01")
	RequestIpl("cs5_4_trains")
	RequestIpl("chophillskennel")
	RequestIpl("bnkheist_apt_norm")
	RequestIpl("redcarpet")
	RequestIpl("cs3_05_water_grp1")
	RequestIpl("cs3_05_water_grp1_lod")
	RequestIpl("cs3_05_water_grp2")
	RequestIpl("cs3_05_water_grp2_lod")
	RequestIpl("canyonriver01")
	RequestIpl("canyonriver01_lod")
	RequestIpl("bh1_47_joshhse_unburnt")
	RequestIpl("bh1_47_joshhse_unburnt_lod")
	RequestIpl("bkr_bi_hw1_13_int")
	RequestIpl("CanyonRvrShallow")
	RequestIpl("methtrailer_grp1")
	RequestIpl("lr_cs6_08_grave_closed")
	RequestIpl("ch1_02_open")
	RequestIpl("sp1_10_real_interior")
	RequestIpl("sp1_10_real_interior_lod")
	RequestIpl("Carwash_with_spinners")
	RequestIpl("ex_sm_13_office_02a")
	RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo")
	RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo")
	RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo")
	RequestIpl("ch3_rd2_bishopschickengraffiti")
	RequestIpl("cs5_04_mazebillboardgraffiti")
	RequestIpl("cs5_roads_ronoilgraffiti")
	RequestIpl("gr_grdlc_yacht_lod")
	RequestIpl("gr_grdlc_yacht_placement")
	RequestIpl("gr_heist_yacht2")
	RequestIpl("gr_heist_yacht2_bar")
	RequestIpl("gr_heist_yacht2_bar_lod")
	RequestIpl("gr_heist_yacht2_bedrm")
	RequestIpl("gr_heist_yacht2_bedrm_lod")
	RequestIpl("gr_heist_yacht2_bridge")
	RequestIpl("gr_heist_yacht2_bridge_lod")
	RequestIpl("gr_heist_yacht2_enginrm")
	RequestIpl("gr_heist_yacht2_enginrm_lod")
	RequestIpl("gr_heist_yacht2_lod")
	RequestIpl("gr_heist_yacht2_lounge")
	RequestIpl("gr_heist_yacht2_lounge_lod")
	RequestIpl("gr_heist_yacht2_slod")
	RequestIpl("ex_dt1_02_office_02b")
	RequestIpl("ex_dt1_11_office_02c")
	RequestIpl("ex_sm_15_office_01a")

	-- Cassino
	RequestIpl("vw_casino_main")
	RequestIpl("hei_dlc_windows_casino")

	-- MONEY FRONTS (2025)
	RequestIpl("m25_1_legacy_fixes")
	RequestIpl("m25_1_mp2025_01_additions")
	RequestIpl("m25_1_bobcat")
	RequestIpl("m25_1_garage")
	RequestIpl("m25_1_quikpharma")
end)