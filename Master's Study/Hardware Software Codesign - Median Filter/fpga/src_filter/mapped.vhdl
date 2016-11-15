
-- 
-- Definition of  filter
-- 
--      12/28/13 22:11:35
--      
--      Precision RTL Synthesis, 2012a.10
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Library use clause for technology cells
library unisim ;
use unisim.vcomponents.all;

entity inc_17_0 is 
   port (
      cin : IN std_logic ;
      a : IN std_logic_vector (16 DOWNTO 0) ;
      d : OUT std_logic_vector (16 DOWNTO 0) ;
      cout : OUT std_logic) ;
end inc_17_0 ;

architecture IMPLEMENTATION of inc_17_0 is 
   signal nx8473z2, nx8473z1, nx8473z3, nx8474z1, nx8474z2, nx8475z1, 
      nx8475z2, nx8476z1, nx8476z2, nx8477z1, nx8477z2, nx8478z1, nx8478z2, 
      nx8479z1, nx8479z2, nx8480z1, nx8480z2, nx8481z1, nx8481z2, nx8482z1, 
      nx8482z2, nx60018z1, nx60018z2, nx60019z1, nx60019z2, nx60020z1, 
      nx60020z2, nx60021z1, nx60021z2, nx60022z1, nx60022z2, nx60023z1, 
      nx60023z2, nx20589z1: std_logic ;

begin
   ps_gnd : GND port map ( G=>nx8473z2);
   ps_vcc : VCC port map ( P=>nx8473z1);
   ix8473z1318 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8473z3, I0=>a(0));
   xorcy_0 : XORCY port map ( O=>d(0), CI=>nx8473z1, LI=>nx8473z3);
   muxcy_0 : MUXCY_L port map ( LO=>nx8474z1, CI=>nx8473z1, DI=>nx8473z2, S
      =>nx8473z3);
   ix8474z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8474z2, I0=>a(1));
   xorcy_1 : XORCY port map ( O=>d(1), CI=>nx8474z1, LI=>nx8474z2);
   muxcy_1 : MUXCY_L port map ( LO=>nx8475z1, CI=>nx8474z1, DI=>nx8473z2, S
      =>nx8474z2);
   ix8475z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8475z2, I0=>a(2));
   xorcy_2 : XORCY port map ( O=>d(2), CI=>nx8475z1, LI=>nx8475z2);
   muxcy_2 : MUXCY_L port map ( LO=>nx8476z1, CI=>nx8475z1, DI=>nx8473z2, S
      =>nx8475z2);
   ix8476z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8476z2, I0=>a(3));
   xorcy_3 : XORCY port map ( O=>d(3), CI=>nx8476z1, LI=>nx8476z2);
   muxcy_3 : MUXCY_L port map ( LO=>nx8477z1, CI=>nx8476z1, DI=>nx8473z2, S
      =>nx8476z2);
   ix8477z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8477z2, I0=>a(4));
   xorcy_4 : XORCY port map ( O=>d(4), CI=>nx8477z1, LI=>nx8477z2);
   muxcy_4 : MUXCY_L port map ( LO=>nx8478z1, CI=>nx8477z1, DI=>nx8473z2, S
      =>nx8477z2);
   ix8478z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8478z2, I0=>a(5));
   xorcy_5 : XORCY port map ( O=>d(5), CI=>nx8478z1, LI=>nx8478z2);
   muxcy_5 : MUXCY_L port map ( LO=>nx8479z1, CI=>nx8478z1, DI=>nx8473z2, S
      =>nx8478z2);
   ix8479z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8479z2, I0=>a(6));
   xorcy_6 : XORCY port map ( O=>d(6), CI=>nx8479z1, LI=>nx8479z2);
   muxcy_6 : MUXCY_L port map ( LO=>nx8480z1, CI=>nx8479z1, DI=>nx8473z2, S
      =>nx8479z2);
   ix8480z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8480z2, I0=>a(7));
   xorcy_7 : XORCY port map ( O=>d(7), CI=>nx8480z1, LI=>nx8480z2);
   muxcy_7 : MUXCY_L port map ( LO=>nx8481z1, CI=>nx8480z1, DI=>nx8473z2, S
      =>nx8480z2);
   ix8481z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8481z2, I0=>a(8));
   xorcy_8 : XORCY port map ( O=>d(8), CI=>nx8481z1, LI=>nx8481z2);
   muxcy_8 : MUXCY_L port map ( LO=>nx8482z1, CI=>nx8481z1, DI=>nx8473z2, S
      =>nx8481z2);
   ix8482z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx8482z2, I0=>a(9));
   xorcy_9 : XORCY port map ( O=>d(9), CI=>nx8482z1, LI=>nx8482z2);
   muxcy_9 : MUXCY_L port map ( LO=>nx60018z1, CI=>nx8482z1, DI=>nx8473z2, S
      =>nx8482z2);
   ix60018z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60018z2, I0=>a(10));
   xorcy_10 : XORCY port map ( O=>d(10), CI=>nx60018z1, LI=>nx60018z2);
   muxcy_10 : MUXCY_L port map ( LO=>nx60019z1, CI=>nx60018z1, DI=>nx8473z2, 
      S=>nx60018z2);
   ix60019z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60019z2, I0=>a(11));
   xorcy_11 : XORCY port map ( O=>d(11), CI=>nx60019z1, LI=>nx60019z2);
   muxcy_11 : MUXCY_L port map ( LO=>nx60020z1, CI=>nx60019z1, DI=>nx8473z2, 
      S=>nx60019z2);
   ix60020z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60020z2, I0=>a(12));
   xorcy_12 : XORCY port map ( O=>d(12), CI=>nx60020z1, LI=>nx60020z2);
   muxcy_12 : MUXCY_L port map ( LO=>nx60021z1, CI=>nx60020z1, DI=>nx8473z2, 
      S=>nx60020z2);
   ix60021z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60021z2, I0=>a(13));
   xorcy_13 : XORCY port map ( O=>d(13), CI=>nx60021z1, LI=>nx60021z2);
   muxcy_13 : MUXCY_L port map ( LO=>nx60022z1, CI=>nx60021z1, DI=>nx8473z2, 
      S=>nx60021z2);
   ix60022z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60022z2, I0=>a(14));
   xorcy_14 : XORCY port map ( O=>d(14), CI=>nx60022z1, LI=>nx60022z2);
   muxcy_14 : MUXCY_L port map ( LO=>nx60023z1, CI=>nx60022z1, DI=>nx8473z2, 
      S=>nx60022z2);
   ix60023z1316 : LUT1_L
      generic map (INIT => X"2") 
       port map ( LO=>nx60023z2, I0=>a(15));
   xorcy_15 : XORCY port map ( O=>d(15), CI=>nx60023z1, LI=>nx60023z2);
   muxcy_15 : MUXCY_L port map ( LO=>nx20589z1, CI=>nx60023z1, DI=>nx8473z2, 
      S=>nx60023z2);
   xorcy_16 : XORCY port map ( O=>d(16), CI=>nx20589z1, LI=>a(16));
end IMPLEMENTATION ;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Library use clause for technology cells
library unisim ;
use unisim.vcomponents.all;

entity filter_core is 
   port (
      clk : IN std_logic ;
      rst : IN std_logic ;
      mcu_data_rsc_singleport_data_in : OUT std_logic_vector (31 DOWNTO 0) ;
      
      mcu_data_rsc_singleport_addr : OUT std_logic_vector (8 DOWNTO 0) ;
      mcu_data_rsc_singleport_re : OUT std_logic ;
      mcu_data_rsc_singleport_we : OUT std_logic ;
      mcu_data_rsc_singleport_data_out : IN std_logic_vector (31 DOWNTO 0) ;
      
      in_data_rsc_mgc_in_wire_en_ld : OUT std_logic ;
      in_data_rsc_mgc_in_wire_en_d : IN std_logic_vector (2 DOWNTO 0) ;
      in_data_vld_rsc_mgc_in_wire_d : IN std_logic ;
      out_data_rsc_mgc_out_stdreg_en_ld : OUT std_logic ;
      out_data_rsc_mgc_out_stdreg_en_d : OUT std_logic_vector (2 DOWNTO 0) ;
      
      buffer_buf_rsc_singleport_data_in : OUT std_logic_vector (2 DOWNTO 0)
       ;
      buffer_buf_rsc_singleport_addr : OUT std_logic_vector (9 DOWNTO 0) ;
      buffer_buf_rsc_singleport_re : OUT std_logic ;
      buffer_buf_rsc_singleport_we : OUT std_logic ;
      buffer_buf_rsc_singleport_data_out : IN std_logic_vector (2 DOWNTO 0)
   ) ;
end filter_core ;

architecture v1_unfold_1878 of filter_core is 
   component inc_17_0
      port (
         cin : IN std_logic ;
         a : IN std_logic_vector (16 DOWNTO 0) ;
         d : OUT std_logic_vector (16 DOWNTO 0) ;
         cout : OUT std_logic) ;
   end component ;
   signal buffer_din_lpi_1: std_logic_vector (2 DOWNTO 0) ;
   
   signal BUU_i_1_lpi_1: std_logic_vector (1 DOWNTO 0) ;
   
   signal BUU_else_else_if_qr_lpi_1: std_logic_vector (2 DOWNTO 0) ;
   
   signal BUU_else_else_if_qr_1_lpi_1: std_logic_vector (2 DOWNTO 0) ;
   
   signal framesCNT_sva: std_logic_vector (31 DOWNTO 0) ;
   
   signal histogram_3_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_4_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_2_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_5_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_1_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_6_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_0_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal histogram_7_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal threshold_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal get_thresh_sva: std_logic ;
   
   signal frame_sva: std_logic_vector (3 DOWNTO 0) ;
   
   signal system_input_c_sva: std_logic_vector (8 DOWNTO 0) ;
   
   signal system_input_c_filter_sva: std_logic_vector (8 DOWNTO 0) ;
   
   signal system_input_r_sva: std_logic_vector (7 DOWNTO 0) ;
   
   signal system_input_r_filter_sva: std_logic_vector (7 DOWNTO 0) ;
   
   signal system_input_output_vld_sva: std_logic ;
   
   signal system_input_window_4_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_3_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_5_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_6_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_7_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_8_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal buffer_sel_1_sva: std_logic ;
   
   signal buffer_t0_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal buffer_t1_sva: std_logic_vector (2 DOWNTO 0) ;
   
   signal exit_BUU_sva, if_if_equal_cse_sva_1, equal_tmp_12, equal_tmp_13, 
      exit_BUU_sva_4, io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, 
      clip_window_ac_int_cctor_2_sva_1, clip_window_and_1_cse_sva_1, 
      unequal_tmp_6: std_logic ;
   
   signal window_4_lpi_1_dfm_10: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_5_lpi_1_dfm_8: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_0_lpi_1_dfm_8: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_1_lpi_1_dfm_6: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_2_lpi_1_dfm_7: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_3_lpi_1_dfm_6: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_4_lpi_1_dfm_11: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_5_lpi_1_dfm_9: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_6_lpi_1_dfm_9: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_7_lpi_1_dfm_8: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_4_lpi_1_dfm_12: std_logic_vector (2 DOWNTO 0) ;
   
   signal asn_309_itm_1: std_logic ;
   
   signal BUU_if_acc_itm_1: std_logic_vector (3 DOWNTO 0) ;
   
   signal BUU_else_if_asn_itm_1_8, BUU_else_if_asn_itm_1_7, 
      BUU_else_if_asn_itm_1_6, BUU_and_4_itm_1, BUU_and_5_itm_1, 
      if_if_if_1_else_or_7_itm_1, if_if_if_1_else_or_7_itm_2, 
      if_if_and_7_itm_1, if_if_and_7_itm_2: std_logic ;
   
   signal if_if_mux_13_itm_2: std_logic_vector (31 DOWNTO 0) ;
   
   signal if_if_switch_lp_and_21_itm_1, if_if_switch_lp_and_21_itm_2, 
      if_if_switch_lp_and_21_itm_3, and_35_itm_1, and_35_itm_2, and_37_itm_1, 
      and_37_itm_2, and_37_itm_3, BUU_nor_1_itm_1, BUU_nor_1_itm_2, 
      BUU_i_1_lpi_1_dfm_st_1_0, io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, 
      buffer_sel_1_sva_dfm_1_st_1, system_input_output_vld_sva_dfm_st_1, 
      exit_BUU_sva_1_st_2, system_input_output_vld_sva_dfm_st_2, 
      if_if_equal_cse_sva_st_5, get_thresh_sva_dfm_2_st_1, 
      get_thresh_sva_dfm_2_st_2, 
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_3, exit_BUU_sva_1_st_3, 
      system_input_output_vld_sva_dfm_st_3, main_stage_0_2, main_stage_0_3, 
      main_stage_0_4, write_histogram_sva_sg2, write_histogram_sva_sg1: 
   std_logic ;
   
   signal write_histogram_sva_13: std_logic_vector (1 DOWNTO 0) ;
   
   signal write_histogram_sva_dfm_1_st_1_sg2, 
      write_histogram_sva_dfm_1_st_1_sg1: std_logic ;
   
   signal write_histogram_sva_dfm_1_st_5: std_logic_vector (1 DOWNTO 0) ;
   
   signal write_histogram_sva_dfm_1_st_2_sg2, 
      write_histogram_sva_dfm_1_st_2_sg1: std_logic ;
   
   signal write_histogram_sva_dfm_1_st_6: std_logic_vector (1 DOWNTO 0) ;
   
   signal if_if_if_acc_ctmp_sva: std_logic_vector (16 DOWNTO 0) ;
   
   signal if_if_if_mux_nl: std_logic_vector (16 DOWNTO 0) ;
   
   signal if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_1, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_0, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_1, inc_d_0, nx8474z1, inc_d_1, 
      nx8475z1, inc_d_2, nx8476z1, inc_d_3, nx51684z1, inc_d_4, nx8478z1, 
      inc_d_5, nx8479z1, inc_d_6, nx51681z1, inc_d_7, inc_d_0_dup_446, 
      nx18047z1, inc_d_1_dup_448, nx61390z1, inc_d_2_dup_449, nx26339z1, 
      inc_d_3_dup_450, nx17004z1, inc_d_4_dup_451, nx60347z1, 
      inc_d_5_dup_452, nx26395z1, inc_d_6_dup_453, nx5658z1, inc_d_7_dup_454, 
      nx51680z1, inc_d_8, inc_d_0_dup_485, nx20044z1, inc_d_1_dup_488, 
      nx63387z1, inc_d_2_dup_490, nx24342z1, inc_d_3_dup_492, nx19988z1, 
      inc_d_4_dup_494, nx63331z1, inc_d_5_dup_496, nx47004z1, 
      inc_d_6_dup_498, nx3661z1, inc_d_7_dup_500, inc_d_0_dup_550, nx22042z1, 
      inc_d_1_dup_553, nx836z1, inc_d_2_dup_556, nx21357z1, inc_d_3_dup_557, 
      nx21986z1, inc_d_4_dup_558, nx65329z1, inc_d_5_dup_559, nx22400z1, 
      inc_d_6_dup_560, nx43606z1, inc_d_7_dup_561, nx8481z1, inc_d_8_dup_562, 
      nx8482z1, inc_d_9, nx60018z1, inc_d_10, nx60019z1, inc_d_11, nx60020z1, 
      inc_d_12, nx60021z1, inc_d_13, nx60022z1, inc_d_14, nx60023z1, 
      inc_d_15, nx60024z1, inc_d_16, nx60025z1, inc_d_17, nx60026z1, 
      inc_d_18, nx60027z1, inc_d_19, nx61015z1, inc_d_20, nx61016z1, 
      inc_d_21, nx61017z1, inc_d_22, nx61018z1, inc_d_23, nx61019z1, 
      inc_d_24, nx61020z1, inc_d_25, nx61021z1, inc_d_26, nx61022z1, 
      inc_d_27, nx61023z1, inc_d_28, nx61024z1, inc_d_29, nx62012z1, 
      inc_d_30, nx18600z1, inc_d_31, 
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_3, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_0, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_1, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_2, 
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_3, window_6_lpi_1_dfm_4_mx0_1
   : std_logic ;
   
   signal frame_sva_6n1s2: std_logic_vector (3 DOWNTO 0) ;
   
   signal nx34409z3: std_logic ;
   
   signal buffer_buf_rsc_singleport_data_in_EXMPLR98: std_logic_vector
    (2 DOWNTO 0) ;
   
   signal mux_tmp_1, or_dcpl_39, or_dcpl_86, or_dcpl_118, 
      buffer_buf_rsc_singleport_re_EXMPLR91, NOT_and_208_cse, 
      NOT_and_211_cse, NOT_and_215_cse, NOT_and_217_cse, NOT_and_219_cse, 
      NOT_and_221_cse, NOT_and_224_cse, NOT_and_227_cse, 
      NOT_system_input_land_1_lpi_1_dfm_1, NOT_equal_tmp_15, 
      NOT_equal_tmp_16, NOT_equal_tmp_17, NOT_equal_tmp_19, 
      window_7_lpi_1_dfm_3_mx0_1, window_7_lpi_1_dfm_3_mx0_0, 
      window_6_lpi_1_dfm_4_mx0_0, window_5_lpi_1_dfm_2_mx0_1, 
      window_5_lpi_1_dfm_2_mx0_0, window_4_lpi_1_dfm_3_mx0_1, 
      window_4_lpi_1_dfm_3_mx0_0: std_logic ;
   
   signal window_0_lpi_1_dfm_4_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_7_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_6_lpi_1_dfm_3_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_5_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_4_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_7_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_6_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_4_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_8_lpi_1_dfm_3_mx0_1, window_8_lpi_1_dfm_3_mx0_0: std_logic
    ;
   
   signal window_7_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_6_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_8_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_8_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_6_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_8_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal clip_window_qr_2_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_2_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_3_lpi_1_dfm_1_mx0_1, window_3_lpi_1_dfm_1_mx0_0: std_logic
    ;
   
   signal window_0_lpi_1_dfm_2_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_1_lpi_1_dfm_1_mx0_1, window_1_lpi_1_dfm_1_mx0_0: std_logic
    ;
   
   signal window_1_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_3_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_0_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_2_lpi_1_dfm_1_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_7_sva_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_8_sva_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_2_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal clip_window_qr_3_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal clip_window_qr_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_0_lpi_1_dfm_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal write_histogram_sva_dfm_7_mx0_0, NOT_or_181_cse, mux_154_cse, 
      NOT_and_213_ssc, mux_tmp, mux_tmp_76, mux_tmp_77, mux_tmp_78, 
      mux_tmp_79, mux_tmp_80, mux_tmp_81, mux_tmp_82, 
      get_thresh_sva_dfm_2_mx0, NOT_if_and_1_ssc, NOT_if_if_and_9_tmp: 
   std_logic ;
   
   signal window_4_lpi_1_dfm_12_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_4_lpi_1_dfm_5_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal window_5_lpi_1_dfm_4_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal buffer_sel_1_sva_dfm_1_mx0, BUU_i_1_sva_1_1: std_logic ;
   
   signal buffer_t1_sva_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal buffer_t0_sva_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal BUU_else_else_if_qr_1_lpi_1_dfm_1: std_logic_vector (2 DOWNTO 0)
    ;
   
   signal BUU_else_else_if_qr_lpi_1_dfm_1: std_logic_vector (2 DOWNTO 0) ;
   
   signal system_input_window_6_sva_mx0: std_logic_vector (2 DOWNTO 0) ;
   
   signal mux_159_ssc, nx21705z1, PWR, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_0_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_2_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_4_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_6_sva_dfm_3_mx0_0n0s2_0, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_16, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_15, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_14, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_13, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_12, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_11, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_10, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_9, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_8, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_7, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_6, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_5, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_4, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_3, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_2, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_1, 
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_0, buffer_or_1_cse_0n0s2, 
      NOT_if_if_equal_cse_sva_3_0n0s2, write_histogram_sva_dfm_7_mx0_0n0s14, 
      NOT_write_histogram_sva_dfm_7_mx0_0n0s19, if_if_if_1_mux_10_nl_0n0s4, 
      nor_tmp_1_0n0s2, or_dcpl_19_0n0s2, NOT_or_dcpl_31_0n0s2, 
      NOT_or_dcpl_99_0n0s2, NOT_mcu_data_rsc_singleport_re_0n0s9, nx6197z2, 
      write_histogram_sva_sg2_6n1s1, NOT_write_histogram_sva_13_6n1s20: 
   std_logic ;
   
   signal write_histogram_sva_13_6n1s1: std_logic_vector (1 DOWNTO 0) ;
   
   signal write_histogram_sva_sg1_6n1s1, 
      NOT_system_input_r_filter_sva_6n1s19, not_exit_BUU_sva_6n1s2: 
   std_logic ;
   
   signal BUU_if_acc_itm_1_6n1s1: std_logic_vector (3 DOWNTO 1) ;
   
   signal nx34409z1: std_logic ;
   
   signal rtlc6_copy_n2407: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2414: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2421: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2428: std_logic_vector (2 DOWNTO 0) ;
   
   signal nx23862z5: std_logic ;
   
   signal rtlc6_copy_n2543: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2550: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2557: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2564: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2571: std_logic_vector (2 DOWNTO 0) ;
   
   signal rtlc6_copy_n2578: std_logic_vector (2 DOWNTO 0) ;
   
   signal nx37359z1, nx51923z2, nx34363z3, nx34363z8, nx34363z14, nx34363z9, 
      nx34363z15, nx34363z11, nx9753z4, nx9753z6, nx9753z8, nx9753z10, 
      nx9753z12, nx34363z17, nx31708z2, nx34850z6, nx34850z7, nx34850z2, 
      NOT_system_input_c_sva_6, sclear_dup_435, ce_dup_527, nx51271z1, 
      nx34903z1, nx23862z1, nx12608z4, nx11611z1, NOT_or_dcpl_81_0n0s2, 
      NOT_or_43_cse, and_330_tmp_0n0s11, or_dcpl_85, nx19066z1, nx35275z1, 
      nx11286z1, nx41743z1, nx36152z1, nx23862z4, nx14656z1, nx12083z1, 
      nx12084z1, nx19956z1, nx15189z1, nx12608z2, nx42061z1, nx26289z1, 
      nx18930z1, nx9333z1, nx9333z2, nx44817z1, nx37375z1, nx11174z1, 
      nx17287z1, nx26054z1, nx34903z4, nx54636z1, nx30850z1, nx6197z1, 
      nx34409z2, nx51923z4, nx23862z2, nx21705z2, nx21705z3, nx23862z6, 
      nx34850z3, nx34850z4, nx34850z5, nx34903z2, nx34903z3, nx51271z2, 
      nx51271z3, nx23862z3, nx23862z11, nx23862z7, nx23862z8, nx29629z1, 
      nx29629z2, nx9333z3, nx9333z5, nx37359z2, nx11174z2, nx12171z1, 
      nx13168z1, nx9753z2, nx9753z3, nx9753z5, nx34363z7, nx34363z5, 
      nx34363z6, nx9753z7, nx9753z9, nx9753z11, nx9753z13, nx31708z3, 
      nx29629z4, nx30626z1, nx34363z4, nx34363z2, nx34363z10, nx34363z12, 
      nx34363z13, nx34363z16, nx22775z2, nx33366z2, nx34363z18, nx51803z2, 
      nx34850z1, nx34850z11, nx34850z8, nx34850z9, nx33853z1, nx33853z5, 
      nx33853z2, nx33853z3, nx32856z1, nx32856z5, nx32856z2, nx32856z3, 
      nx31859z1, nx31859z5, nx31859z2, nx31859z3, nx30862z1, nx30862z5, 
      nx30862z2, nx30862z3, nx29865z1, nx29865z5, nx29865z2, nx29865z3, 
      nx28868z1, nx28868z5, nx28868z2, nx28868z3, nx31136z1, nx31136z5, 
      nx31136z2, nx31136z3, nx30139z1, nx30139z5, nx30139z2, nx30139z3, 
      nx29142z1, nx29142z5, nx29142z2, nx29142z3, nx28145z1, nx28145z5, 
      nx28145z2, nx28145z3, nx27148z1, nx27148z5, nx27148z2, nx27148z3, 
      nx26151z1, nx26151z5, nx26151z2, nx26151z3, nx25154z1, nx25154z5, 
      nx25154z2, nx25154z3, nx24157z1, nx24157z5, nx24157z2, nx24157z3, 
      nx23160z1, nx23160z5, nx23160z2, nx23160z3, nx22163z1, nx22163z2, 
      nx22163z3, nx22163z4, nx22163z5, nx20395z1, nx15410z1, nx51803z1, 
      NOT_write_histogram_sva_13_6n1s6_0, NOT_if_and_8_ssc, NOT_if_and_9_ssc, 
      NOT_equal_tmp_23, NOT_equal_tmp_21, NOT_and_230_cse, NOT_equal_tmp_1, 
      NOT_and_dcpl_264, NOT_and_dcpl_240, NOT_BUU_i_1_sva_1_0, nx4197z4, 
      nx34363z20, nx21778z6, nx21778z8, nx4197z6, nx47778z3, nx30626z2, 
      nx51923z3, nx47778z2, nx47778z4, nx4197z2, nx4197z7, nx21778z4, 
      nx21778z9, nx21778z5, nx21778z7, nx34363z19, nx34363z21, nx4197z3, 
      nx4197z5, nx12084z2, nx15410z2, nx23160z4, nx24157z4, nx25154z4, 
      nx26151z4, nx27148z4, nx28145z4, nx29142z4, nx30139z4, nx31136z4, 
      nx28868z4, nx29865z4, nx30862z4, nx31859z4, nx32856z4, nx33853z4, 
      nx34850z10, nx12083z2, nx37359z3, nx12608z3, nx23862z9, nx51923z5, 
      nx9333z4, nx23862z10, nx29629z3, nx12608z1, nx13605z1, nx13605z2, 
      nx21778z2, nx21778z3, nx34409z4, nx34409z5: std_logic ;
   
   signal DANGLING : std_logic_vector (1 downto 0 );

begin
   buffer_buf_rsc_singleport_data_in(2) <= 
   buffer_buf_rsc_singleport_data_in_EXMPLR98(2) ;
   buffer_buf_rsc_singleport_data_in(1) <= 
   buffer_buf_rsc_singleport_data_in_EXMPLR98(1) ;
   buffer_buf_rsc_singleport_data_in(0) <= 
   buffer_buf_rsc_singleport_data_in_EXMPLR98(0) ;
   if_if_if_acc_ctmp_sva_inc17_2 : inc_17_0 port map ( cin=>DANGLING(0), 
      a(16)=>if_if_if_mux_nl(16), a(15)=>if_if_if_mux_nl(15), a(14)=>
      if_if_if_mux_nl(14), a(13)=>if_if_if_mux_nl(13), a(12)=>
      if_if_if_mux_nl(12), a(11)=>if_if_if_mux_nl(11), a(10)=>
      if_if_if_mux_nl(10), a(9)=>if_if_if_mux_nl(9), a(8)=>
      if_if_if_mux_nl(8), a(7)=>if_if_if_mux_nl(7), a(6)=>if_if_if_mux_nl(6), 
      a(5)=>if_if_if_mux_nl(5), a(4)=>if_if_if_mux_nl(4), a(3)=>
      if_if_if_mux_nl(3), a(2)=>if_if_if_mux_nl(2), a(1)=>if_if_if_mux_nl(1), 
      a(0)=>if_if_if_mux_nl(0), d(16)=>if_if_if_acc_ctmp_sva(16), d(15)=>
      if_if_if_acc_ctmp_sva(15), d(14)=>if_if_if_acc_ctmp_sva(14), d(13)=>
      if_if_if_acc_ctmp_sva(13), d(12)=>if_if_if_acc_ctmp_sva(12), d(11)=>
      if_if_if_acc_ctmp_sva(11), d(10)=>if_if_if_acc_ctmp_sva(10), d(9)=>
      if_if_if_acc_ctmp_sva(9), d(8)=>if_if_if_acc_ctmp_sva(8), d(7)=>
      if_if_if_acc_ctmp_sva(7), d(6)=>if_if_if_acc_ctmp_sva(6), d(5)=>
      if_if_if_acc_ctmp_sva(5), d(4)=>if_if_if_acc_ctmp_sva(4), d(3)=>
      if_if_if_acc_ctmp_sva(3), d(2)=>if_if_if_acc_ctmp_sva(2), d(1)=>
      if_if_if_acc_ctmp_sva(1), d(0)=>if_if_if_acc_ctmp_sva(0), cout=>
      DANGLING(1));
   if_if_if_mux_nl_mux_0Bus105_0_ix15577z55441 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_0_ix15577z55312 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_0_ix15577z55308 : MUXF6 port map ( O=>
      if_if_if_mux_nl(0), I0=>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_1_ix15577z55425 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_1_ix15577z55304 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_1_ix15577z55300 : MUXF6 port map ( O=>
      if_if_if_mux_nl(1), I0=>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_2_ix15577z55409 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_2_ix15577z55296 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_2_ix15577z55292 : MUXF6 port map ( O=>
      if_if_if_mux_nl(2), I0=>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_3_ix15577z55393 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_3_ix15577z55288 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_3_ix15577z55284 : MUXF6 port map ( O=>
      if_if_if_mux_nl(3), I0=>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_4_ix15577z55377 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_4_ix15577z55280 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_4_ix15577z55276 : MUXF6 port map ( O=>
      if_if_if_mux_nl(4), I0=>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_5_ix15577z55361 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_5_ix15577z55272 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_5_ix15577z55268 : MUXF6 port map ( O=>
      if_if_if_mux_nl(5), I0=>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_6_ix15577z55345 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_6_ix15577z55264 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_6_ix15577z55260 : MUXF6 port map ( O=>
      if_if_if_mux_nl(6), I0=>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_7_ix15577z55329 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_7_ix15577z55256 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_7_ix15577z55252 : MUXF6 port map ( O=>
      if_if_if_mux_nl(7), I0=>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_8_ix15577z55313 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_8_ix15577z55248 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_8_ix15577z55244 : MUXF6 port map ( O=>
      if_if_if_mux_nl(8), I0=>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_9_ix15577z55297 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_9_ix15577z55240 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_9_ix15577z55236 : MUXF6 port map ( O=>
      if_if_if_mux_nl(9), I0=>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_0, I1
      =>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_10_ix15577z55281 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_10_ix15577z55232 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_10_ix15577z55228 : MUXF6 port map ( O=>
      if_if_if_mux_nl(10), I0=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_11_ix15577z55265 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_11_ix15577z55224 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_11_ix15577z55220 : MUXF6 port map ( O=>
      if_if_if_mux_nl(11), I0=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_12_ix15577z55249 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_12_ix15577z55216 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_12_ix15577z55212 : MUXF6 port map ( O=>
      if_if_if_mux_nl(12), I0=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_13_ix15577z55233 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_13_ix15577z55208 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_13_ix15577z55204 : MUXF6 port map ( O=>
      if_if_if_mux_nl(13), I0=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_14_ix15577z55217 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_14_ix15577z55200 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_14_ix15577z55196 : MUXF6 port map ( O=>
      if_if_if_mux_nl(14), I0=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_15_ix15577z55201 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_15_ix15577z55192 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_15_ix15577z55188 : MUXF6 port map ( O=>
      if_if_if_mux_nl(15), I0=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   if_if_if_mux_nl_mux_0Bus105_16_ix15577z55183 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_0, I0=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_0, I1=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_1, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_16_ix15577z55184 : MUXF5 port map ( O=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_1, I0=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_2, I1=>
      if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_3, S=>
      window_4_lpi_1_dfm_12_mx0(1));
   if_if_if_mux_nl_mux_0Bus105_16_ix15577z55179 : MUXF6 port map ( O=>
      if_if_if_mux_nl(16), I0=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_0, 
      I1=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_f6_1, S=>
      window_4_lpi_1_dfm_12_mx0(2));
   reg_q_7 : FDRE port map ( Q=>system_input_r_sva(7), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_7, R=>nx51271z1);
   reg_q_6 : FDRE port map ( Q=>system_input_r_sva(6), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_6, R=>nx51271z1);
   reg_q_5 : FDRE port map ( Q=>system_input_r_sva(5), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_5, R=>nx51271z1);
   reg_q_4 : FDRE port map ( Q=>system_input_r_sva(4), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_4, R=>nx51271z1);
   reg_q_3 : FDRE port map ( Q=>system_input_r_sva(3), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_3, R=>nx51271z1);
   reg_q_2 : FDRE port map ( Q=>system_input_r_sva(2), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_2, R=>nx51271z1);
   reg_q_1 : FDRE port map ( Q=>system_input_r_sva(1), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_1, R=>nx51271z1);
   reg_q_0 : FDRE port map ( Q=>system_input_r_sva(0), C=>clk, CE=>
      sclear_dup_435, D=>inc_d_0, R=>nx51271z1);
   xorcy_0 : XORCY port map ( O=>inc_d_0, CI=>PWR, LI=>system_input_r_sva(0)
   );
   muxcy_0 : MUXCY_L port map ( LO=>nx8474z1, CI=>PWR, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(0));
   xorcy_1 : XORCY port map ( O=>inc_d_1, CI=>nx8474z1, LI=>
      system_input_r_sva(1));
   muxcy_1 : MUXCY_L port map ( LO=>nx8475z1, CI=>nx8474z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(1));
   xorcy_2 : XORCY port map ( O=>inc_d_2, CI=>nx8475z1, LI=>
      system_input_r_sva(2));
   muxcy_2 : MUXCY_L port map ( LO=>nx8476z1, CI=>nx8475z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(2));
   xorcy_3 : XORCY port map ( O=>inc_d_3, CI=>nx8476z1, LI=>
      system_input_r_sva(3));
   muxcy_3 : MUXCY_L port map ( LO=>nx51684z1, CI=>nx8476z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(3));
   xorcy_4 : XORCY port map ( O=>inc_d_4, CI=>nx51684z1, LI=>
      system_input_r_sva(4));
   muxcy_4 : MUXCY_L port map ( LO=>nx8478z1, CI=>nx51684z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(4));
   xorcy_5 : XORCY port map ( O=>inc_d_5, CI=>nx8478z1, LI=>
      system_input_r_sva(5));
   muxcy_5 : MUXCY_L port map ( LO=>nx8479z1, CI=>nx8478z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(5));
   xorcy_6 : XORCY port map ( O=>inc_d_6, CI=>nx8479z1, LI=>
      system_input_r_sva(6));
   muxcy_6 : MUXCY_L port map ( LO=>nx51681z1, CI=>nx8479z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_sva(6));
   xorcy_7 : XORCY port map ( O=>inc_d_7, CI=>nx51681z1, LI=>
      system_input_r_sva(7));
   reg_q_8 : FDRE port map ( Q=>system_input_c_sva(8), C=>clk, CE=>nx34903z1, 
      D=>inc_d_8, R=>sclear_dup_435);
   reg_q_7_dup_0 : FDRE port map ( Q=>system_input_c_sva(7), C=>clk, CE=>
      nx34903z1, D=>inc_d_7_dup_454, R=>sclear_dup_435);
   reg_q_6_dup_1 : FDRE port map ( Q=>system_input_c_sva(6), C=>clk, CE=>
      nx34903z1, D=>inc_d_6_dup_453, R=>sclear_dup_435);
   reg_q_5_dup_2 : FDRE port map ( Q=>system_input_c_sva(5), C=>clk, CE=>
      nx34903z1, D=>inc_d_5_dup_452, R=>sclear_dup_435);
   reg_q_4_dup_3 : FDRE port map ( Q=>system_input_c_sva(4), C=>clk, CE=>
      nx34903z1, D=>inc_d_4_dup_451, R=>sclear_dup_435);
   reg_q_3_dup_4 : FDRE port map ( Q=>system_input_c_sva(3), C=>clk, CE=>
      nx34903z1, D=>inc_d_3_dup_450, R=>sclear_dup_435);
   reg_q_2_dup_5 : FDRE port map ( Q=>system_input_c_sva(2), C=>clk, CE=>
      nx34903z1, D=>inc_d_2_dup_449, R=>sclear_dup_435);
   reg_q_1_dup_6 : FDRE port map ( Q=>system_input_c_sva(1), C=>clk, CE=>
      nx34903z1, D=>inc_d_1_dup_448, R=>sclear_dup_435);
   reg_q_0_dup_7 : FDRE port map ( Q=>system_input_c_sva(0), C=>clk, CE=>
      nx34903z1, D=>inc_d_0_dup_446, R=>sclear_dup_435);
   xorcy_0_dup_8 : XORCY port map ( O=>inc_d_0_dup_446, CI=>PWR, LI=>
      system_input_c_sva(0));
   muxcy_0_dup_9 : MUXCY_L port map ( LO=>nx18047z1, CI=>PWR, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(0));
   xorcy_1_dup_10 : XORCY port map ( O=>inc_d_1_dup_448, CI=>nx18047z1, LI=>
      system_input_c_sva(1));
   muxcy_1_dup_11 : MUXCY_L port map ( LO=>nx61390z1, CI=>nx18047z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(1));
   xorcy_2_dup_12 : XORCY port map ( O=>inc_d_2_dup_449, CI=>nx61390z1, LI=>
      system_input_c_sva(2));
   muxcy_2_dup_13 : MUXCY_L port map ( LO=>nx26339z1, CI=>nx61390z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(2));
   xorcy_3_dup_14 : XORCY port map ( O=>inc_d_3_dup_450, CI=>nx26339z1, LI=>
      system_input_c_sva(3));
   muxcy_3_dup_15 : MUXCY_L port map ( LO=>nx17004z1, CI=>nx26339z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(3));
   xorcy_4_dup_16 : XORCY port map ( O=>inc_d_4_dup_451, CI=>nx17004z1, LI=>
      system_input_c_sva(4));
   muxcy_4_dup_17 : MUXCY_L port map ( LO=>nx60347z1, CI=>nx17004z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(4));
   xorcy_5_dup_18 : XORCY port map ( O=>inc_d_5_dup_452, CI=>nx60347z1, LI=>
      system_input_c_sva(5));
   muxcy_5_dup_19 : MUXCY_L port map ( LO=>nx26395z1, CI=>nx60347z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(5));
   xorcy_6_dup_20 : XORCY port map ( O=>inc_d_6_dup_453, CI=>nx26395z1, LI=>
      system_input_c_sva(6));
   muxcy_6_dup_21 : MUXCY_L port map ( LO=>nx5658z1, CI=>nx26395z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(6));
   xorcy_7_dup_22 : XORCY port map ( O=>inc_d_7_dup_454, CI=>nx5658z1, LI=>
      system_input_c_sva(7));
   muxcy_7 : MUXCY_L port map ( LO=>nx51680z1, CI=>nx5658z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_c_sva(7));
   xorcy_8 : XORCY port map ( O=>inc_d_8, CI=>nx51680z1, LI=>
      system_input_c_sva(8));
   reg_q_7_dup_23 : FDRE port map ( Q=>system_input_r_filter_sva(7), C=>clk, 
      CE=>nx23862z1, D=>inc_d_7_dup_500, R=>ce_dup_527);
   reg_q_6_dup_24 : FDRE port map ( Q=>system_input_r_filter_sva(6), C=>clk, 
      CE=>nx23862z1, D=>inc_d_6_dup_498, R=>ce_dup_527);
   reg_q_5_dup_25 : FDRE port map ( Q=>system_input_r_filter_sva(5), C=>clk, 
      CE=>nx23862z1, D=>inc_d_5_dup_496, R=>ce_dup_527);
   reg_q_4_dup_26 : FDRE port map ( Q=>system_input_r_filter_sva(4), C=>clk, 
      CE=>nx23862z1, D=>inc_d_4_dup_494, R=>ce_dup_527);
   reg_q_3_dup_27 : FDRE port map ( Q=>system_input_r_filter_sva(3), C=>clk, 
      CE=>nx23862z1, D=>inc_d_3_dup_492, R=>ce_dup_527);
   reg_q_2_dup_28 : FDRE port map ( Q=>system_input_r_filter_sva(2), C=>clk, 
      CE=>nx23862z1, D=>inc_d_2_dup_490, R=>ce_dup_527);
   reg_q_1_dup_29 : FDRE port map ( Q=>system_input_r_filter_sva(1), C=>clk, 
      CE=>nx23862z1, D=>inc_d_1_dup_488, R=>ce_dup_527);
   reg_q_0_dup_30 : FDRE port map ( Q=>system_input_r_filter_sva(0), C=>clk, 
      CE=>nx23862z1, D=>inc_d_0_dup_485, R=>ce_dup_527);
   xorcy_0_dup_31 : XORCY port map ( O=>inc_d_0_dup_485, CI=>PWR, LI=>
      system_input_r_filter_sva(0));
   muxcy_0_dup_32 : MUXCY_L port map ( LO=>nx20044z1, CI=>PWR, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(0)
   );
   xorcy_1_dup_33 : XORCY port map ( O=>inc_d_1_dup_488, CI=>nx20044z1, LI=>
      system_input_r_filter_sva(1));
   muxcy_1_dup_34 : MUXCY_L port map ( LO=>nx63387z1, CI=>nx20044z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(1)
   );
   xorcy_2_dup_35 : XORCY port map ( O=>inc_d_2_dup_490, CI=>nx63387z1, LI=>
      system_input_r_filter_sva(2));
   muxcy_2_dup_36 : MUXCY_L port map ( LO=>nx24342z1, CI=>nx63387z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(2)
   );
   xorcy_3_dup_37 : XORCY port map ( O=>inc_d_3_dup_492, CI=>nx24342z1, LI=>
      system_input_r_filter_sva(3));
   muxcy_3_dup_38 : MUXCY_L port map ( LO=>nx19988z1, CI=>nx24342z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(3)
   );
   xorcy_4_dup_39 : XORCY port map ( O=>inc_d_4_dup_494, CI=>nx19988z1, LI=>
      system_input_r_filter_sva(4));
   muxcy_4_dup_40 : MUXCY_L port map ( LO=>nx63331z1, CI=>nx19988z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(4)
   );
   xorcy_5_dup_41 : XORCY port map ( O=>inc_d_5_dup_496, CI=>nx63331z1, LI=>
      system_input_r_filter_sva(5));
   muxcy_5_dup_42 : MUXCY_L port map ( LO=>nx47004z1, CI=>nx63331z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(5)
   );
   xorcy_6_dup_43 : XORCY port map ( O=>inc_d_6_dup_498, CI=>nx47004z1, LI=>
      system_input_r_filter_sva(6));
   muxcy_6_dup_44 : MUXCY_L port map ( LO=>nx3661z1, CI=>nx47004z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>system_input_r_filter_sva(6)
   );
   xorcy_7_dup_45 : XORCY port map ( O=>inc_d_7_dup_500, CI=>nx3661z1, LI=>
      system_input_r_filter_sva(7));
   reg_q_31 : FDRE port map ( Q=>framesCNT_sva(31), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_31, R=>rst);
   reg_q_30 : FDRE port map ( Q=>framesCNT_sva(30), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_30, R=>rst);
   reg_q_29 : FDRE port map ( Q=>framesCNT_sva(29), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_29, R=>rst);
   reg_q_28 : FDRE port map ( Q=>framesCNT_sva(28), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_28, R=>rst);
   reg_q_27 : FDRE port map ( Q=>framesCNT_sva(27), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_27, R=>rst);
   reg_q_26 : FDRE port map ( Q=>framesCNT_sva(26), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_26, R=>rst);
   reg_q_25 : FDRE port map ( Q=>framesCNT_sva(25), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_25, R=>rst);
   reg_q_24 : FDRE port map ( Q=>framesCNT_sva(24), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_24, R=>rst);
   reg_q_23 : FDRE port map ( Q=>framesCNT_sva(23), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_23, R=>rst);
   reg_q_22 : FDRE port map ( Q=>framesCNT_sva(22), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_22, R=>rst);
   reg_q_21 : FDRE port map ( Q=>framesCNT_sva(21), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_21, R=>rst);
   reg_q_20 : FDRE port map ( Q=>framesCNT_sva(20), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_20, R=>rst);
   reg_q_19 : FDRE port map ( Q=>framesCNT_sva(19), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_19, R=>rst);
   reg_q_18 : FDRE port map ( Q=>framesCNT_sva(18), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_18, R=>rst);
   reg_q_17 : FDRE port map ( Q=>framesCNT_sva(17), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_17, R=>rst);
   reg_q_16 : FDRE port map ( Q=>framesCNT_sva(16), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_16, R=>rst);
   reg_q_15 : FDRE port map ( Q=>framesCNT_sva(15), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_15, R=>rst);
   reg_q_14 : FDRE port map ( Q=>framesCNT_sva(14), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_14, R=>rst);
   reg_q_13 : FDRE port map ( Q=>framesCNT_sva(13), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_13, R=>rst);
   reg_q_12 : FDRE port map ( Q=>framesCNT_sva(12), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_12, R=>rst);
   reg_q_11 : FDRE port map ( Q=>framesCNT_sva(11), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_11, R=>rst);
   reg_q_10 : FDRE port map ( Q=>framesCNT_sva(10), C=>clk, CE=>ce_dup_527, 
      D=>inc_d_10, R=>rst);
   reg_q_9 : FDRE port map ( Q=>framesCNT_sva(9), C=>clk, CE=>ce_dup_527, D
      =>inc_d_9, R=>rst);
   reg_q_8_dup_46 : FDRE port map ( Q=>framesCNT_sva(8), C=>clk, CE=>
      ce_dup_527, D=>inc_d_8_dup_562, R=>rst);
   reg_q_7_dup_47 : FDRE port map ( Q=>framesCNT_sva(7), C=>clk, CE=>
      ce_dup_527, D=>inc_d_7_dup_561, R=>rst);
   reg_q_6_dup_48 : FDRE port map ( Q=>framesCNT_sva(6), C=>clk, CE=>
      ce_dup_527, D=>inc_d_6_dup_560, R=>rst);
   reg_q_5_dup_49 : FDRE port map ( Q=>framesCNT_sva(5), C=>clk, CE=>
      ce_dup_527, D=>inc_d_5_dup_559, R=>rst);
   reg_q_4_dup_50 : FDRE port map ( Q=>framesCNT_sva(4), C=>clk, CE=>
      ce_dup_527, D=>inc_d_4_dup_558, R=>rst);
   reg_q_3_dup_51 : FDRE port map ( Q=>framesCNT_sva(3), C=>clk, CE=>
      ce_dup_527, D=>inc_d_3_dup_557, R=>rst);
   reg_q_2_dup_52 : FDRE port map ( Q=>framesCNT_sva(2), C=>clk, CE=>
      ce_dup_527, D=>inc_d_2_dup_556, R=>rst);
   reg_q_1_dup_53 : FDRE port map ( Q=>framesCNT_sva(1), C=>clk, CE=>
      ce_dup_527, D=>inc_d_1_dup_553, R=>rst);
   reg_q_0_dup_54 : FDRE port map ( Q=>framesCNT_sva(0), C=>clk, CE=>
      ce_dup_527, D=>inc_d_0_dup_550, R=>rst);
   xorcy_0_dup_55 : XORCY port map ( O=>inc_d_0_dup_550, CI=>PWR, LI=>
      framesCNT_sva(0));
   muxcy_0_dup_56 : MUXCY_L port map ( LO=>nx22042z1, CI=>PWR, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(0));
   xorcy_1_dup_57 : XORCY port map ( O=>inc_d_1_dup_553, CI=>nx22042z1, LI=>
      framesCNT_sva(1));
   muxcy_1_dup_58 : MUXCY_L port map ( LO=>nx836z1, CI=>nx22042z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(1));
   xorcy_2_dup_59 : XORCY port map ( O=>inc_d_2_dup_556, CI=>nx836z1, LI=>
      framesCNT_sva(2));
   muxcy_2_dup_60 : MUXCY_L port map ( LO=>nx21357z1, CI=>nx836z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(2));
   xorcy_3_dup_61 : XORCY port map ( O=>inc_d_3_dup_557, CI=>nx21357z1, LI=>
      framesCNT_sva(3));
   muxcy_3_dup_62 : MUXCY_L port map ( LO=>nx21986z1, CI=>nx21357z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(3));
   xorcy_4_dup_63 : XORCY port map ( O=>inc_d_4_dup_558, CI=>nx21986z1, LI=>
      framesCNT_sva(4));
   muxcy_4_dup_64 : MUXCY_L port map ( LO=>nx65329z1, CI=>nx21986z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(4));
   xorcy_5_dup_65 : XORCY port map ( O=>inc_d_5_dup_559, CI=>nx65329z1, LI=>
      framesCNT_sva(5));
   muxcy_5_dup_66 : MUXCY_L port map ( LO=>nx22400z1, CI=>nx65329z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(5));
   xorcy_6_dup_67 : XORCY port map ( O=>inc_d_6_dup_560, CI=>nx22400z1, LI=>
      framesCNT_sva(6));
   muxcy_6_dup_68 : MUXCY_L port map ( LO=>nx43606z1, CI=>nx22400z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(6));
   xorcy_7_dup_69 : XORCY port map ( O=>inc_d_7_dup_561, CI=>nx43606z1, LI=>
      framesCNT_sva(7));
   muxcy_7_dup_70 : MUXCY_L port map ( LO=>nx8481z1, CI=>nx43606z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(7));
   xorcy_8_dup_71 : XORCY port map ( O=>inc_d_8_dup_562, CI=>nx8481z1, LI=>
      framesCNT_sva(8));
   muxcy_8 : MUXCY_L port map ( LO=>nx8482z1, CI=>nx8481z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(8));
   xorcy_9 : XORCY port map ( O=>inc_d_9, CI=>nx8482z1, LI=>framesCNT_sva(9)
   );
   muxcy_9 : MUXCY_L port map ( LO=>nx60018z1, CI=>nx8482z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(9));
   xorcy_10 : XORCY port map ( O=>inc_d_10, CI=>nx60018z1, LI=>
      framesCNT_sva(10));
   muxcy_10 : MUXCY_L port map ( LO=>nx60019z1, CI=>nx60018z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(10));
   xorcy_11 : XORCY port map ( O=>inc_d_11, CI=>nx60019z1, LI=>
      framesCNT_sva(11));
   muxcy_11 : MUXCY_L port map ( LO=>nx60020z1, CI=>nx60019z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(11));
   xorcy_12 : XORCY port map ( O=>inc_d_12, CI=>nx60020z1, LI=>
      framesCNT_sva(12));
   muxcy_12 : MUXCY_L port map ( LO=>nx60021z1, CI=>nx60020z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(12));
   xorcy_13 : XORCY port map ( O=>inc_d_13, CI=>nx60021z1, LI=>
      framesCNT_sva(13));
   muxcy_13 : MUXCY_L port map ( LO=>nx60022z1, CI=>nx60021z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(13));
   xorcy_14 : XORCY port map ( O=>inc_d_14, CI=>nx60022z1, LI=>
      framesCNT_sva(14));
   muxcy_14 : MUXCY_L port map ( LO=>nx60023z1, CI=>nx60022z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(14));
   xorcy_15 : XORCY port map ( O=>inc_d_15, CI=>nx60023z1, LI=>
      framesCNT_sva(15));
   muxcy_15 : MUXCY_L port map ( LO=>nx60024z1, CI=>nx60023z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(15));
   xorcy_16 : XORCY port map ( O=>inc_d_16, CI=>nx60024z1, LI=>
      framesCNT_sva(16));
   muxcy_16 : MUXCY_L port map ( LO=>nx60025z1, CI=>nx60024z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(16));
   xorcy_17 : XORCY port map ( O=>inc_d_17, CI=>nx60025z1, LI=>
      framesCNT_sva(17));
   muxcy_17 : MUXCY_L port map ( LO=>nx60026z1, CI=>nx60025z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(17));
   xorcy_18 : XORCY port map ( O=>inc_d_18, CI=>nx60026z1, LI=>
      framesCNT_sva(18));
   muxcy_18 : MUXCY_L port map ( LO=>nx60027z1, CI=>nx60026z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(18));
   xorcy_19 : XORCY port map ( O=>inc_d_19, CI=>nx60027z1, LI=>
      framesCNT_sva(19));
   muxcy_19 : MUXCY_L port map ( LO=>nx61015z1, CI=>nx60027z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(19));
   xorcy_20 : XORCY port map ( O=>inc_d_20, CI=>nx61015z1, LI=>
      framesCNT_sva(20));
   muxcy_20 : MUXCY_L port map ( LO=>nx61016z1, CI=>nx61015z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(20));
   xorcy_21 : XORCY port map ( O=>inc_d_21, CI=>nx61016z1, LI=>
      framesCNT_sva(21));
   muxcy_21 : MUXCY_L port map ( LO=>nx61017z1, CI=>nx61016z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(21));
   xorcy_22 : XORCY port map ( O=>inc_d_22, CI=>nx61017z1, LI=>
      framesCNT_sva(22));
   muxcy_22 : MUXCY_L port map ( LO=>nx61018z1, CI=>nx61017z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(22));
   xorcy_23 : XORCY port map ( O=>inc_d_23, CI=>nx61018z1, LI=>
      framesCNT_sva(23));
   muxcy_23 : MUXCY_L port map ( LO=>nx61019z1, CI=>nx61018z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(23));
   xorcy_24 : XORCY port map ( O=>inc_d_24, CI=>nx61019z1, LI=>
      framesCNT_sva(24));
   muxcy_24 : MUXCY_L port map ( LO=>nx61020z1, CI=>nx61019z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(24));
   xorcy_25 : XORCY port map ( O=>inc_d_25, CI=>nx61020z1, LI=>
      framesCNT_sva(25));
   muxcy_25 : MUXCY_L port map ( LO=>nx61021z1, CI=>nx61020z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(25));
   xorcy_26 : XORCY port map ( O=>inc_d_26, CI=>nx61021z1, LI=>
      framesCNT_sva(26));
   muxcy_26 : MUXCY_L port map ( LO=>nx61022z1, CI=>nx61021z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(26));
   xorcy_27 : XORCY port map ( O=>inc_d_27, CI=>nx61022z1, LI=>
      framesCNT_sva(27));
   muxcy_27 : MUXCY_L port map ( LO=>nx61023z1, CI=>nx61022z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(27));
   xorcy_28 : XORCY port map ( O=>inc_d_28, CI=>nx61023z1, LI=>
      framesCNT_sva(28));
   muxcy_28 : MUXCY_L port map ( LO=>nx61024z1, CI=>nx61023z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(28));
   xorcy_29 : XORCY port map ( O=>inc_d_29, CI=>nx61024z1, LI=>
      framesCNT_sva(29));
   muxcy_29 : MUXCY_L port map ( LO=>nx62012z1, CI=>nx61024z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(29));
   xorcy_30 : XORCY port map ( O=>inc_d_30, CI=>nx62012z1, LI=>
      framesCNT_sva(30));
   muxcy_30 : MUXCY_L port map ( LO=>nx18600z1, CI=>nx62012z1, DI=>
      buffer_buf_rsc_singleport_re_EXMPLR91, S=>framesCNT_sva(30));
   xorcy_31 : XORCY port map ( O=>inc_d_31, CI=>nx18600z1, LI=>
      framesCNT_sva(31));
   reg_and_37_itm_1 : FDR port map ( Q=>and_37_itm_1, C=>clk, D=>nx19066z1, 
      R=>rst);
   reg_if_if_switch_lp_and_21_itm_1 : FDR port map ( Q=>
      if_if_switch_lp_and_21_itm_1, C=>clk, D=>nx35275z1, R=>rst);
   reg_and_37_itm_2 : FDR port map ( Q=>and_37_itm_2, C=>clk, D=>
      and_37_itm_1, R=>rst);
   reg_exit_BUU_sva_4 : FDR port map ( Q=>exit_BUU_sva_4, C=>clk, D=>
      nx11286z1, R=>rst);
   reg_equal_tmp_12 : FDR port map ( Q=>equal_tmp_12, C=>clk, D=>nx41743z1, 
      R=>rst);
   reg_BUU_nor_1_itm_1 : FDR port map ( Q=>BUU_nor_1_itm_1, C=>clk, D=>
      nx36152z1, R=>rst);
   reg_and_35_itm_1 : FDR port map ( Q=>and_35_itm_1, C=>clk, D=>nx23862z4, 
      R=>rst);
   reg_if_if_equal_cse_sva_1 : FDR port map ( Q=>if_if_equal_cse_sva_1, C=>
      clk, D=>NOT_if_if_equal_cse_sva_3_0n0s2, R=>rst);
   reg_if_if_if_1_else_or_7_itm_1 : FDR port map ( Q=>
      if_if_if_1_else_or_7_itm_1, C=>clk, D=>if_if_if_1_mux_10_nl_0n0s4, R=>
      rst);
   reg_if_if_switch_lp_and_21_itm_2 : FDR port map ( Q=>
      if_if_switch_lp_and_21_itm_2, C=>clk, D=>if_if_switch_lp_and_21_itm_1, 
      R=>rst);
   reg_write_histogram_sva_dfm_1_st_1_sg1 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_1_sg1, C=>clk, D=>nx14656z1, R=>rst);
   reg_write_histogram_sva_dfm_1_st_5_1 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_5(1), C=>clk, D=>nx12083z1, R=>rst);
   reg_write_histogram_sva_dfm_1_st_5_0 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_5(0), C=>clk, D=>
      write_histogram_sva_dfm_7_mx0_0, R=>rst);
   reg_write_histogram_sva_dfm_1_st_1_sg2 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_1_sg2, C=>clk, D=>nx12084z1, R=>rst);
   reg_get_thresh_sva_dfm_2_st_1 : FDR port map ( Q=>
      get_thresh_sva_dfm_2_st_1, C=>clk, D=>get_thresh_sva_dfm_2_mx0, R=>rst
   );
   reg_BUU_and_5_itm_1 : FDR port map ( Q=>BUU_and_5_itm_1, C=>clk, D=>
      nx19956z1, R=>rst);
   reg_BUU_and_4_itm_1 : FDR port map ( Q=>BUU_and_4_itm_1, C=>clk, D=>
      nx15189z1, R=>rst);
   reg_clip_window_ac_int_cctor_2_sva_1 : FDR port map ( Q=>
      clip_window_ac_int_cctor_2_sva_1, C=>clk, D=>NOT_or_181_cse, R=>rst);
   reg_clip_window_and_1_cse_sva_1 : FDR port map ( Q=>
      clip_window_and_1_cse_sva_1, C=>clk, D=>nx12608z2, R=>rst);
   reg_unequal_tmp_6 : FDR port map ( Q=>unequal_tmp_6, C=>clk, D=>nx37359z1, 
      R=>rst);
   reg_window_4_lpi_1_dfm_10_2 : FDR port map ( Q=>window_4_lpi_1_dfm_10(2), 
      C=>clk, D=>rtlc6_copy_n2578(2), R=>rst);
   reg_window_4_lpi_1_dfm_10_1 : FDR port map ( Q=>window_4_lpi_1_dfm_10(1), 
      C=>clk, D=>rtlc6_copy_n2578(1), R=>rst);
   reg_window_4_lpi_1_dfm_10_0 : FDR port map ( Q=>window_4_lpi_1_dfm_10(0), 
      C=>clk, D=>rtlc6_copy_n2578(0), R=>rst);
   reg_window_0_lpi_1_dfm_8_2 : FDR port map ( Q=>window_0_lpi_1_dfm_8(2), C
      =>clk, D=>rtlc6_copy_n2571(2), R=>rst);
   reg_window_0_lpi_1_dfm_8_1 : FDR port map ( Q=>window_0_lpi_1_dfm_8(1), C
      =>clk, D=>rtlc6_copy_n2571(1), R=>rst);
   reg_window_0_lpi_1_dfm_8_0 : FDR port map ( Q=>window_0_lpi_1_dfm_8(0), C
      =>clk, D=>rtlc6_copy_n2571(0), R=>rst);
   reg_window_5_lpi_1_dfm_8_2 : FDR port map ( Q=>window_5_lpi_1_dfm_8(2), C
      =>clk, D=>rtlc6_copy_n2564(2), R=>rst);
   reg_window_5_lpi_1_dfm_8_1 : FDR port map ( Q=>window_5_lpi_1_dfm_8(1), C
      =>clk, D=>rtlc6_copy_n2564(1), R=>rst);
   reg_window_5_lpi_1_dfm_8_0 : FDR port map ( Q=>window_5_lpi_1_dfm_8(0), C
      =>clk, D=>rtlc6_copy_n2564(0), R=>rst);
   reg_window_1_lpi_1_dfm_6_2 : FDR port map ( Q=>window_1_lpi_1_dfm_6(2), C
      =>clk, D=>rtlc6_copy_n2557(2), R=>rst);
   reg_window_1_lpi_1_dfm_6_1 : FDR port map ( Q=>window_1_lpi_1_dfm_6(1), C
      =>clk, D=>rtlc6_copy_n2557(1), R=>rst);
   reg_window_1_lpi_1_dfm_6_0 : FDR port map ( Q=>window_1_lpi_1_dfm_6(0), C
      =>clk, D=>rtlc6_copy_n2557(0), R=>rst);
   reg_window_2_lpi_1_dfm_7_2 : FDR port map ( Q=>window_2_lpi_1_dfm_7(2), C
      =>clk, D=>rtlc6_copy_n2550(2), R=>rst);
   reg_window_2_lpi_1_dfm_7_1 : FDR port map ( Q=>window_2_lpi_1_dfm_7(1), C
      =>clk, D=>rtlc6_copy_n2550(1), R=>rst);
   reg_window_2_lpi_1_dfm_7_0 : FDR port map ( Q=>window_2_lpi_1_dfm_7(0), C
      =>clk, D=>rtlc6_copy_n2550(0), R=>rst);
   reg_window_3_lpi_1_dfm_6_2 : FDR port map ( Q=>window_3_lpi_1_dfm_6(2), C
      =>clk, D=>rtlc6_copy_n2543(2), R=>rst);
   reg_window_3_lpi_1_dfm_6_1 : FDR port map ( Q=>window_3_lpi_1_dfm_6(1), C
      =>clk, D=>rtlc6_copy_n2543(1), R=>rst);
   reg_window_3_lpi_1_dfm_6_0 : FDR port map ( Q=>window_3_lpi_1_dfm_6(0), C
      =>clk, D=>rtlc6_copy_n2543(0), R=>rst);
   reg_and_35_itm_2 : FDR port map ( Q=>and_35_itm_2, C=>clk, D=>
      and_35_itm_1, R=>rst);
   reg_equal_tmp_13 : FDR port map ( Q=>equal_tmp_13, C=>clk, D=>
      equal_tmp_12, R=>rst);
   reg_BUU_nor_1_itm_2 : FDR port map ( Q=>BUU_nor_1_itm_2, C=>clk, D=>
      BUU_nor_1_itm_1, R=>rst);
   reg_and_37_itm_3 : FDR port map ( Q=>and_37_itm_3, C=>clk, D=>
      and_37_itm_2, R=>rst);
   reg_main_stage_0_4 : FDR port map ( Q=>main_stage_0_4, C=>clk, D=>
      main_stage_0_3, R=>rst);
   reg_main_stage_0_3 : FDR port map ( Q=>main_stage_0_3, C=>clk, D=>
      main_stage_0_2, R=>rst);
   reg_in_data_rsc_mgc_in_wire_en_ld : FDR port map ( Q=>
      in_data_rsc_mgc_in_wire_en_ld, C=>clk, D=>nx42061z1, R=>rst);
   reg_asn_309_itm_1 : FDR port map ( Q=>asn_309_itm_1, C=>clk, D=>
      exit_BUU_sva, R=>rst);
   reg_BUU_i_1_lpi_1_dfm_st_1_0 : FDR port map ( Q=>BUU_i_1_lpi_1_dfm_st_1_0, 
      C=>clk, D=>NOT_BUU_i_1_sva_1_0, R=>rst);
   reg_system_input_output_vld_sva_dfm_st_1 : FDR port map ( Q=>
      system_input_output_vld_sva_dfm_st_1, C=>clk, D=>nx23862z5, R=>rst);
   reg_buffer_sel_1_sva_dfm_1_st_1 : FDR port map ( Q=>
      buffer_sel_1_sva_dfm_1_st_1, C=>clk, D=>buffer_sel_1_sva_dfm_1_mx0, R
      =>rst);
   reg_BUU_else_if_asn_itm_1_8 : FDR port map ( Q=>BUU_else_if_asn_itm_1_8, 
      C=>clk, D=>system_input_c_sva(8), R=>rst);
   reg_BUU_else_if_asn_itm_1_7 : FDR port map ( Q=>BUU_else_if_asn_itm_1_7, 
      C=>clk, D=>system_input_c_sva(7), R=>rst);
   reg_BUU_else_if_asn_itm_1_6 : FDR port map ( Q=>BUU_else_if_asn_itm_1_6, 
      C=>clk, D=>system_input_c_sva(6), R=>rst);
   reg_BUU_else_if_asn_itm_1_5 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(5), C=>clk, D=>system_input_c_sva(5), R
      =>rst);
   reg_BUU_else_if_asn_itm_1_4 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(4), C=>clk, D=>system_input_c_sva(4), R
      =>rst);
   reg_BUU_else_if_asn_itm_1_3 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(3), C=>clk, D=>system_input_c_sva(3), R
      =>rst);
   reg_BUU_else_if_asn_itm_1_2 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(2), C=>clk, D=>system_input_c_sva(2), R
      =>rst);
   reg_BUU_else_if_asn_itm_1_1 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(1), C=>clk, D=>system_input_c_sva(1), R
      =>rst);
   reg_BUU_else_if_asn_itm_1_0 : FDR port map ( Q=>
      buffer_buf_rsc_singleport_addr(0), C=>clk, D=>system_input_c_sva(0), R
      =>rst);
   reg_BUU_if_acc_itm_1_3 : FDR port map ( Q=>BUU_if_acc_itm_1(3), C=>clk, D
      =>BUU_if_acc_itm_1_6n1s1(3), R=>rst);
   reg_BUU_if_acc_itm_1_2 : FDR port map ( Q=>BUU_if_acc_itm_1(2), C=>clk, D
      =>BUU_if_acc_itm_1_6n1s1(2), R=>rst);
   reg_BUU_if_acc_itm_1_1 : FDR port map ( Q=>BUU_if_acc_itm_1(1), C=>clk, D
      =>BUU_if_acc_itm_1_6n1s1(1), R=>rst);
   reg_BUU_if_acc_itm_1_0 : FDR port map ( Q=>BUU_if_acc_itm_1(0), C=>clk, D
      =>NOT_system_input_c_sva_6, R=>rst);
   reg_exit_BUU_sva : FDS port map ( Q=>exit_BUU_sva, C=>clk, D=>
      not_exit_BUU_sva_6n1s2, S=>rst);
   reg_write_histogram_sva_sg1 : FDR port map ( Q=>write_histogram_sva_sg1, 
      C=>clk, D=>write_histogram_sva_sg1_6n1s1, R=>rst);
   reg_write_histogram_sva_13_1 : FDR port map ( Q=>
      write_histogram_sva_13(1), C=>clk, D=>write_histogram_sva_13_6n1s1(1), 
      R=>rst);
   reg_write_histogram_sva_13_0 : FDR port map ( Q=>
      write_histogram_sva_13(0), C=>clk, D=>write_histogram_sva_13_6n1s1(0), 
      R=>rst);
   reg_write_histogram_sva_sg2 : FDR port map ( Q=>write_histogram_sva_sg2, 
      C=>clk, D=>write_histogram_sva_sg2_6n1s1, R=>rst);
   reg_frame_sva_3 : FDR port map ( Q=>frame_sva(3), C=>clk, D=>
      frame_sva_6n1s2(3), R=>rst);
   reg_frame_sva_2 : FDR port map ( Q=>frame_sva(2), C=>clk, D=>
      frame_sva_6n1s2(2), R=>rst);
   reg_frame_sva_1 : FDR port map ( Q=>frame_sva(1), C=>clk, D=>
      frame_sva_6n1s2(1), R=>rst);
   reg_frame_sva_0 : FDR port map ( Q=>frame_sva(0), C=>clk, D=>
      frame_sva_6n1s2(0), R=>rst);
   reg_io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2 : FDR port map ( Q=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, C=>clk, D=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, R=>rst);
   reg_exit_BUU_sva_1_st_2 : FDR port map ( Q=>exit_BUU_sva_1_st_2, C=>clk, 
      D=>exit_BUU_sva_4, R=>rst);
   reg_system_input_output_vld_sva_dfm_st_2 : FDR port map ( Q=>
      system_input_output_vld_sva_dfm_st_2, C=>clk, D=>
      system_input_output_vld_sva_dfm_st_1, R=>rst);
   reg_window_6_lpi_1_dfm_9_2 : FDR port map ( Q=>window_6_lpi_1_dfm_9(2), C
      =>clk, D=>rtlc6_copy_n2428(2), R=>rst);
   reg_window_6_lpi_1_dfm_9_1 : FDR port map ( Q=>window_6_lpi_1_dfm_9(1), C
      =>clk, D=>rtlc6_copy_n2428(1), R=>rst);
   reg_window_6_lpi_1_dfm_9_0 : FDR port map ( Q=>window_6_lpi_1_dfm_9(0), C
      =>clk, D=>rtlc6_copy_n2428(0), R=>rst);
   reg_window_4_lpi_1_dfm_11_2 : FDR port map ( Q=>window_4_lpi_1_dfm_11(2), 
      C=>clk, D=>rtlc6_copy_n2421(2), R=>rst);
   reg_window_4_lpi_1_dfm_11_1 : FDR port map ( Q=>window_4_lpi_1_dfm_11(1), 
      C=>clk, D=>rtlc6_copy_n2421(1), R=>rst);
   reg_window_4_lpi_1_dfm_11_0 : FDR port map ( Q=>window_4_lpi_1_dfm_11(0), 
      C=>clk, D=>rtlc6_copy_n2421(0), R=>rst);
   reg_window_7_lpi_1_dfm_8_2 : FDR port map ( Q=>window_7_lpi_1_dfm_8(2), C
      =>clk, D=>rtlc6_copy_n2414(2), R=>rst);
   reg_window_7_lpi_1_dfm_8_1 : FDR port map ( Q=>window_7_lpi_1_dfm_8(1), C
      =>clk, D=>rtlc6_copy_n2414(1), R=>rst);
   reg_window_7_lpi_1_dfm_8_0 : FDR port map ( Q=>window_7_lpi_1_dfm_8(0), C
      =>clk, D=>rtlc6_copy_n2414(0), R=>rst);
   reg_window_5_lpi_1_dfm_9_2 : FDR port map ( Q=>window_5_lpi_1_dfm_9(2), C
      =>clk, D=>rtlc6_copy_n2407(2), R=>rst);
   reg_window_5_lpi_1_dfm_9_1 : FDR port map ( Q=>window_5_lpi_1_dfm_9(1), C
      =>clk, D=>rtlc6_copy_n2407(1), R=>rst);
   reg_window_5_lpi_1_dfm_9_0 : FDR port map ( Q=>window_5_lpi_1_dfm_9(0), C
      =>clk, D=>rtlc6_copy_n2407(0), R=>rst);
   reg_if_if_and_7_itm_2 : FDR port map ( Q=>if_if_and_7_itm_2, C=>clk, D=>
      if_if_and_7_itm_1, R=>rst);
   reg_write_histogram_sva_dfm_1_st_6_1 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_6(1), C=>clk, D=>
      write_histogram_sva_dfm_1_st_5(1), R=>rst);
   reg_write_histogram_sva_dfm_1_st_6_0 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_6(0), C=>clk, D=>
      write_histogram_sva_dfm_1_st_5(0), R=>rst);
   reg_write_histogram_sva_dfm_1_st_2_sg1 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_2_sg1, C=>clk, D=>
      write_histogram_sva_dfm_1_st_1_sg1, R=>rst);
   reg_write_histogram_sva_dfm_1_st_2_sg2 : FDR port map ( Q=>
      write_histogram_sva_dfm_1_st_2_sg2, C=>clk, D=>
      write_histogram_sva_dfm_1_st_1_sg2, R=>rst);
   reg_get_thresh_sva_dfm_2_st_2 : FDR port map ( Q=>
      get_thresh_sva_dfm_2_st_2, C=>clk, D=>get_thresh_sva_dfm_2_st_1, R=>
      rst);
   reg_if_if_mux_13_itm_2_31 : FDR port map ( Q=>if_if_mux_13_itm_2(31), C=>
      clk, D=>framesCNT_sva(31), R=>rst);
   reg_if_if_mux_13_itm_2_30 : FDR port map ( Q=>if_if_mux_13_itm_2(30), C=>
      clk, D=>framesCNT_sva(30), R=>rst);
   reg_if_if_mux_13_itm_2_29 : FDR port map ( Q=>if_if_mux_13_itm_2(29), C=>
      clk, D=>framesCNT_sva(29), R=>rst);
   reg_if_if_mux_13_itm_2_28 : FDR port map ( Q=>if_if_mux_13_itm_2(28), C=>
      clk, D=>framesCNT_sva(28), R=>rst);
   reg_if_if_mux_13_itm_2_27 : FDR port map ( Q=>if_if_mux_13_itm_2(27), C=>
      clk, D=>framesCNT_sva(27), R=>rst);
   reg_if_if_mux_13_itm_2_26 : FDR port map ( Q=>if_if_mux_13_itm_2(26), C=>
      clk, D=>framesCNT_sva(26), R=>rst);
   reg_if_if_mux_13_itm_2_25 : FDR port map ( Q=>if_if_mux_13_itm_2(25), C=>
      clk, D=>framesCNT_sva(25), R=>rst);
   reg_if_if_mux_13_itm_2_24 : FDR port map ( Q=>if_if_mux_13_itm_2(24), C=>
      clk, D=>framesCNT_sva(24), R=>rst);
   reg_if_if_mux_13_itm_2_23 : FDR port map ( Q=>if_if_mux_13_itm_2(23), C=>
      clk, D=>framesCNT_sva(23), R=>rst);
   reg_if_if_mux_13_itm_2_22 : FDR port map ( Q=>if_if_mux_13_itm_2(22), C=>
      clk, D=>framesCNT_sva(22), R=>rst);
   reg_if_if_mux_13_itm_2_21 : FDR port map ( Q=>if_if_mux_13_itm_2(21), C=>
      clk, D=>framesCNT_sva(21), R=>rst);
   reg_if_if_mux_13_itm_2_20 : FDR port map ( Q=>if_if_mux_13_itm_2(20), C=>
      clk, D=>framesCNT_sva(20), R=>rst);
   reg_if_if_mux_13_itm_2_19 : FDR port map ( Q=>if_if_mux_13_itm_2(19), C=>
      clk, D=>framesCNT_sva(19), R=>rst);
   reg_if_if_mux_13_itm_2_18 : FDR port map ( Q=>if_if_mux_13_itm_2(18), C=>
      clk, D=>framesCNT_sva(18), R=>rst);
   reg_if_if_mux_13_itm_2_17 : FDR port map ( Q=>if_if_mux_13_itm_2(17), C=>
      clk, D=>framesCNT_sva(17), R=>rst);
   reg_if_if_mux_13_itm_2_16 : FDR port map ( Q=>if_if_mux_13_itm_2(16), C=>
      clk, D=>framesCNT_sva(16), R=>rst);
   reg_if_if_mux_13_itm_2_15 : FDR port map ( Q=>if_if_mux_13_itm_2(15), C=>
      clk, D=>framesCNT_sva(15), R=>rst);
   reg_if_if_mux_13_itm_2_14 : FDR port map ( Q=>if_if_mux_13_itm_2(14), C=>
      clk, D=>framesCNT_sva(14), R=>rst);
   reg_if_if_mux_13_itm_2_13 : FDR port map ( Q=>if_if_mux_13_itm_2(13), C=>
      clk, D=>framesCNT_sva(13), R=>rst);
   reg_if_if_mux_13_itm_2_12 : FDR port map ( Q=>if_if_mux_13_itm_2(12), C=>
      clk, D=>framesCNT_sva(12), R=>rst);
   reg_if_if_mux_13_itm_2_11 : FDR port map ( Q=>if_if_mux_13_itm_2(11), C=>
      clk, D=>framesCNT_sva(11), R=>rst);
   reg_if_if_mux_13_itm_2_10 : FDR port map ( Q=>if_if_mux_13_itm_2(10), C=>
      clk, D=>framesCNT_sva(10), R=>rst);
   reg_if_if_mux_13_itm_2_9 : FDR port map ( Q=>if_if_mux_13_itm_2(9), C=>
      clk, D=>framesCNT_sva(9), R=>rst);
   reg_if_if_mux_13_itm_2_8 : FDR port map ( Q=>if_if_mux_13_itm_2(8), C=>
      clk, D=>framesCNT_sva(8), R=>rst);
   reg_if_if_mux_13_itm_2_7 : FDR port map ( Q=>if_if_mux_13_itm_2(7), C=>
      clk, D=>framesCNT_sva(7), R=>rst);
   reg_if_if_mux_13_itm_2_6 : FDR port map ( Q=>if_if_mux_13_itm_2(6), C=>
      clk, D=>framesCNT_sva(6), R=>rst);
   reg_if_if_mux_13_itm_2_5 : FDR port map ( Q=>if_if_mux_13_itm_2(5), C=>
      clk, D=>framesCNT_sva(5), R=>rst);
   reg_if_if_mux_13_itm_2_4 : FDR port map ( Q=>if_if_mux_13_itm_2(4), C=>
      clk, D=>framesCNT_sva(4), R=>rst);
   reg_if_if_mux_13_itm_2_3 : FDR port map ( Q=>if_if_mux_13_itm_2(3), C=>
      clk, D=>framesCNT_sva(3), R=>rst);
   reg_if_if_mux_13_itm_2_2 : FDR port map ( Q=>if_if_mux_13_itm_2(2), C=>
      clk, D=>framesCNT_sva(2), R=>rst);
   reg_if_if_mux_13_itm_2_1 : FDR port map ( Q=>if_if_mux_13_itm_2(1), C=>
      clk, D=>framesCNT_sva(1), R=>rst);
   reg_if_if_mux_13_itm_2_0 : FDR port map ( Q=>if_if_mux_13_itm_2(0), C=>
      clk, D=>framesCNT_sva(0), R=>rst);
   reg_if_if_equal_cse_sva_st_5 : FDR port map ( Q=>if_if_equal_cse_sva_st_5, 
      C=>clk, D=>if_if_equal_cse_sva_1, R=>rst);
   reg_if_if_if_1_else_or_7_itm_2 : FDR port map ( Q=>
      if_if_if_1_else_or_7_itm_2, C=>clk, D=>if_if_if_1_else_or_7_itm_1, R=>
      rst);
   reg_io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_3 : FDR port map ( Q=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_3, C=>clk, D=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, R=>rst);
   reg_exit_BUU_sva_1_st_3 : FDR port map ( Q=>exit_BUU_sva_1_st_3, C=>clk, 
      D=>exit_BUU_sva_1_st_2, R=>rst);
   reg_system_input_output_vld_sva_dfm_st_3 : FDR port map ( Q=>
      system_input_output_vld_sva_dfm_st_3, C=>clk, D=>
      system_input_output_vld_sva_dfm_st_2, R=>rst);
   reg_if_if_switch_lp_and_21_itm_3 : FDR port map ( Q=>
      if_if_switch_lp_and_21_itm_3, C=>clk, D=>if_if_switch_lp_and_21_itm_2, 
      R=>rst);
   reg_window_4_lpi_1_dfm_12_2 : FDR port map ( Q=>window_4_lpi_1_dfm_12(2), 
      C=>clk, D=>window_4_lpi_1_dfm_12_mx0(2), R=>rst);
   reg_window_4_lpi_1_dfm_12_1 : FDR port map ( Q=>window_4_lpi_1_dfm_12(1), 
      C=>clk, D=>window_4_lpi_1_dfm_12_mx0(1), R=>rst);
   reg_window_4_lpi_1_dfm_12_0 : FDR port map ( Q=>window_4_lpi_1_dfm_12(0), 
      C=>clk, D=>window_4_lpi_1_dfm_12_mx0(0), R=>rst);
   reg_out_data_rsc_mgc_out_stdreg_en_ld : FDR port map ( Q=>
      out_data_rsc_mgc_out_stdreg_en_ld, C=>clk, D=>nx26289z1, R=>rst);
   reg_io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1 : FDRE port map ( Q=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, C=>clk, CE=>exit_BUU_sva, D
      =>in_data_vld_rsc_mgc_in_wire_d, R=>rst);
   reg_BUU_i_1_lpi_1_1 : FDRE port map ( Q=>BUU_i_1_lpi_1(1), C=>clk, CE=>
      mux_tmp_1, D=>BUU_i_1_sva_1_1, R=>rst);
   reg_BUU_i_1_lpi_1_0 : FDRE port map ( Q=>BUU_i_1_lpi_1(0), C=>clk, CE=>
      mux_tmp_1, D=>nx18930z1, R=>rst);
   reg_system_input_output_vld_sva : FDRE port map ( Q=>
      system_input_output_vld_sva, C=>clk, CE=>NOT_or_43_cse, D=>nx23862z5, 
      R=>rst);
   reg_system_input_c_filter_sva_8 : FDRE port map ( Q=>
      system_input_c_filter_sva(8), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(8), R=>rst);
   reg_system_input_c_filter_sva_5 : FDRE port map ( Q=>
      system_input_c_filter_sva(5), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(5), R=>rst);
   reg_system_input_c_filter_sva_4 : FDRE port map ( Q=>
      system_input_c_filter_sva(4), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(4), R=>rst);
   reg_system_input_c_filter_sva_3 : FDRE port map ( Q=>
      system_input_c_filter_sva(3), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(3), R=>rst);
   reg_system_input_c_filter_sva_2 : FDRE port map ( Q=>
      system_input_c_filter_sva(2), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(2), R=>rst);
   reg_system_input_c_filter_sva_1 : FDRE port map ( Q=>
      system_input_c_filter_sva(1), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(1), R=>rst);
   reg_system_input_c_filter_sva_0 : FDRE port map ( Q=>
      system_input_c_filter_sva(0), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(0), R=>rst);
   reg_system_input_c_filter_sva_7 : FDRE port map ( Q=>
      system_input_c_filter_sva(7), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(7), R=>rst);
   reg_system_input_c_filter_sva_6 : FDRE port map ( Q=>
      system_input_c_filter_sva(6), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_c_sva(6), R=>rst);
   reg_get_thresh_sva : FDRE port map ( Q=>get_thresh_sva, C=>clk, CE=>
      nx9333z1, D=>nx9333z2, R=>rst);
   reg_histogram_7_sva_0 : FDRE port map ( Q=>histogram_7_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_if_if_and_7_itm_1 : FDRE port map ( Q=>if_if_and_7_itm_1, C=>clk, CE
      =>nx23862z4, D=>nx37375z1, R=>rst);
   reg_system_input_window_7_sva_0 : FDRE port map ( Q=>
      system_input_window_7_sva(0), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0), R=>rst);
   reg_buffer_t1_sva_0 : FDRE port map ( Q=>buffer_t1_sva(0), C=>clk, CE=>
      nx17287z1, D=>buffer_buf_rsc_singleport_data_out(0), R=>rst);
   reg_buffer_t0_sva_0 : FDRE port map ( Q=>buffer_t0_sva(0), C=>clk, CE=>
      nx26054z1, D=>buffer_buf_rsc_singleport_data_out(0), R=>rst);
   reg_BUU_else_else_if_qr_1_lpi_1_0 : FDRE port map ( Q=>
      BUU_else_else_if_qr_1_lpi_1(0), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0), R=>rst);
   reg_system_input_window_4_sva_0 : FDRE port map ( Q=>
      system_input_window_4_sva(0), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_7_sva_mx0(0), R=>rst);
   reg_system_input_window_7_sva_2 : FDRE port map ( Q=>
      system_input_window_7_sva(2), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2), R=>rst);
   reg_buffer_t1_sva_2 : FDRE port map ( Q=>buffer_t1_sva(2), C=>clk, CE=>
      nx17287z1, D=>buffer_buf_rsc_singleport_data_out(2), R=>rst);
   reg_buffer_t0_sva_2 : FDRE port map ( Q=>buffer_t0_sva(2), C=>clk, CE=>
      nx26054z1, D=>buffer_buf_rsc_singleport_data_out(2), R=>rst);
   reg_BUU_else_else_if_qr_1_lpi_1_2 : FDRE port map ( Q=>
      BUU_else_else_if_qr_1_lpi_1(2), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2), R=>rst);
   reg_system_input_window_4_sva_2 : FDRE port map ( Q=>
      system_input_window_4_sva(2), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_7_sva_mx0(2), R=>rst);
   reg_system_input_window_7_sva_1 : FDRE port map ( Q=>
      system_input_window_7_sva(1), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1), R=>rst);
   reg_buffer_t1_sva_1 : FDRE port map ( Q=>buffer_t1_sva(1), C=>clk, CE=>
      nx17287z1, D=>buffer_buf_rsc_singleport_data_out(1), R=>rst);
   reg_buffer_t0_sva_1 : FDRE port map ( Q=>buffer_t0_sva(1), C=>clk, CE=>
      nx26054z1, D=>buffer_buf_rsc_singleport_data_out(1), R=>rst);
   reg_BUU_else_else_if_qr_1_lpi_1_1 : FDRE port map ( Q=>
      BUU_else_else_if_qr_1_lpi_1(1), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1), R=>rst);
   reg_system_input_window_4_sva_1 : FDRE port map ( Q=>
      system_input_window_4_sva(1), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_7_sva_mx0(1), R=>rst);
   reg_system_input_window_6_sva_2 : FDRE port map ( Q=>
      system_input_window_6_sva(2), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(2), R=>rst);
   reg_BUU_else_else_if_qr_lpi_1_2 : FDRE port map ( Q=>
      BUU_else_else_if_qr_lpi_1(2), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(2), R=>rst);
   reg_system_input_window_3_sva_2 : FDRE port map ( Q=>
      system_input_window_3_sva(2), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_6_sva_mx0(2), R=>rst);
   reg_system_input_window_6_sva_1 : FDRE port map ( Q=>
      system_input_window_6_sva(1), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(1), R=>rst);
   reg_BUU_else_else_if_qr_lpi_1_1 : FDRE port map ( Q=>
      BUU_else_else_if_qr_lpi_1(1), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(1), R=>rst);
   reg_system_input_window_3_sva_1 : FDRE port map ( Q=>
      system_input_window_3_sva(1), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_6_sva_mx0(1), R=>rst);
   reg_system_input_window_6_sva_0 : FDRE port map ( Q=>
      system_input_window_6_sva(0), C=>clk, CE=>nx11174z1, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(0), R=>rst);
   reg_BUU_else_else_if_qr_lpi_1_0 : FDRE port map ( Q=>
      BUU_else_else_if_qr_lpi_1(0), C=>clk, CE=>nx34903z4, D=>
      BUU_else_else_if_qr_lpi_1_dfm_1(0), R=>rst);
   reg_system_input_window_3_sva_0 : FDRE port map ( Q=>
      system_input_window_3_sva(0), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_6_sva_mx0(0), R=>rst);
   reg_system_input_window_8_sva_2 : FDRE port map ( Q=>
      system_input_window_8_sva(2), C=>clk, CE=>nx11174z1, D=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(2), R=>rst);
   reg_buffer_din_lpi_1_2 : FDRE port map ( Q=>buffer_din_lpi_1(2), C=>clk, 
      CE=>nx54636z1, D=>in_data_rsc_mgc_in_wire_en_d(2), R=>rst);
   reg_system_input_window_5_sva_2 : FDRE port map ( Q=>
      system_input_window_5_sva(2), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_8_sva_mx0(2), R=>rst);
   reg_system_input_window_8_sva_1 : FDRE port map ( Q=>
      system_input_window_8_sva(1), C=>clk, CE=>nx11174z1, D=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(1), R=>rst);
   reg_buffer_din_lpi_1_1 : FDRE port map ( Q=>buffer_din_lpi_1(1), C=>clk, 
      CE=>nx54636z1, D=>in_data_rsc_mgc_in_wire_en_d(1), R=>rst);
   reg_system_input_window_5_sva_1 : FDRE port map ( Q=>
      system_input_window_5_sva(1), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_8_sva_mx0(1), R=>rst);
   reg_system_input_window_8_sva_0 : FDRE port map ( Q=>
      system_input_window_8_sva(0), C=>clk, CE=>nx11174z1, D=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(0), R=>rst);
   reg_buffer_din_lpi_1_0 : FDRE port map ( Q=>buffer_din_lpi_1(0), C=>clk, 
      CE=>nx54636z1, D=>in_data_rsc_mgc_in_wire_en_d(0), R=>rst);
   reg_system_input_window_5_sva_0 : FDRE port map ( Q=>
      system_input_window_5_sva(0), C=>clk, CE=>NOT_or_43_cse, D=>
      system_input_window_8_sva_mx0(0), R=>rst);
   reg_histogram_6_sva_0 : FDRE port map ( Q=>histogram_6_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_5_sva_0 : FDRE port map ( Q=>histogram_5_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_4_sva_0 : FDRE port map ( Q=>histogram_4_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_3_sva_0 : FDRE port map ( Q=>histogram_3_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_2_sva_0 : FDRE port map ( Q=>histogram_2_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_1_sva_0 : FDRE port map ( Q=>histogram_1_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_0_sva_0 : FDRE port map ( Q=>histogram_0_sva(0), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_0, R=>rst);
   reg_histogram_7_sva_1 : FDRE port map ( Q=>histogram_7_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_6_sva_1 : FDRE port map ( Q=>histogram_6_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_5_sva_1 : FDRE port map ( Q=>histogram_5_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_4_sva_1 : FDRE port map ( Q=>histogram_4_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_3_sva_1 : FDRE port map ( Q=>histogram_3_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_2_sva_1 : FDRE port map ( Q=>histogram_2_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_1_sva_1 : FDRE port map ( Q=>histogram_1_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_0_sva_1 : FDRE port map ( Q=>histogram_0_sva(1), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_1, R=>rst);
   reg_histogram_7_sva_2 : FDRE port map ( Q=>histogram_7_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_6_sva_2 : FDRE port map ( Q=>histogram_6_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_5_sva_2 : FDRE port map ( Q=>histogram_5_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_4_sva_2 : FDRE port map ( Q=>histogram_4_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_3_sva_2 : FDRE port map ( Q=>histogram_3_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_2_sva_2 : FDRE port map ( Q=>histogram_2_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_1_sva_2 : FDRE port map ( Q=>histogram_1_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_0_sva_2 : FDRE port map ( Q=>histogram_0_sva(2), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_2, R=>rst);
   reg_histogram_7_sva_3 : FDRE port map ( Q=>histogram_7_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_6_sva_3 : FDRE port map ( Q=>histogram_6_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_5_sva_3 : FDRE port map ( Q=>histogram_5_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_4_sva_3 : FDRE port map ( Q=>histogram_4_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_3_sva_3 : FDRE port map ( Q=>histogram_3_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_2_sva_3 : FDRE port map ( Q=>histogram_2_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_1_sva_3 : FDRE port map ( Q=>histogram_1_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_0_sva_3 : FDRE port map ( Q=>histogram_0_sva(3), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_3, R=>rst);
   reg_histogram_7_sva_4 : FDRE port map ( Q=>histogram_7_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_6_sva_4 : FDRE port map ( Q=>histogram_6_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_5_sva_4 : FDRE port map ( Q=>histogram_5_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_4_sva_4 : FDRE port map ( Q=>histogram_4_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_3_sva_4 : FDRE port map ( Q=>histogram_3_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_2_sva_4 : FDRE port map ( Q=>histogram_2_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_1_sva_4 : FDRE port map ( Q=>histogram_1_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_0_sva_4 : FDRE port map ( Q=>histogram_0_sva(4), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_4, R=>rst);
   reg_histogram_7_sva_5 : FDRE port map ( Q=>histogram_7_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_6_sva_5 : FDRE port map ( Q=>histogram_6_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_5_sva_5 : FDRE port map ( Q=>histogram_5_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_4_sva_5 : FDRE port map ( Q=>histogram_4_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_3_sva_5 : FDRE port map ( Q=>histogram_3_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_2_sva_5 : FDRE port map ( Q=>histogram_2_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_1_sva_5 : FDRE port map ( Q=>histogram_1_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_0_sva_5 : FDRE port map ( Q=>histogram_0_sva(5), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_5, R=>rst);
   reg_histogram_7_sva_6 : FDRE port map ( Q=>histogram_7_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_6_sva_6 : FDRE port map ( Q=>histogram_6_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_5_sva_6 : FDRE port map ( Q=>histogram_5_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_4_sva_6 : FDRE port map ( Q=>histogram_4_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_3_sva_6 : FDRE port map ( Q=>histogram_3_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_2_sva_6 : FDRE port map ( Q=>histogram_2_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_1_sva_6 : FDRE port map ( Q=>histogram_1_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_0_sva_6 : FDRE port map ( Q=>histogram_0_sva(6), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_6, R=>rst);
   reg_histogram_7_sva_7 : FDRE port map ( Q=>histogram_7_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_6_sva_7 : FDRE port map ( Q=>histogram_6_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_5_sva_7 : FDRE port map ( Q=>histogram_5_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_4_sva_7 : FDRE port map ( Q=>histogram_4_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_3_sva_7 : FDRE port map ( Q=>histogram_3_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_2_sva_7 : FDRE port map ( Q=>histogram_2_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_1_sva_7 : FDRE port map ( Q=>histogram_1_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_0_sva_7 : FDRE port map ( Q=>histogram_0_sva(7), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_7, R=>rst);
   reg_histogram_7_sva_8 : FDRE port map ( Q=>histogram_7_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_6_sva_8 : FDRE port map ( Q=>histogram_6_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_5_sva_8 : FDRE port map ( Q=>histogram_5_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_4_sva_8 : FDRE port map ( Q=>histogram_4_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_3_sva_8 : FDRE port map ( Q=>histogram_3_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_2_sva_8 : FDRE port map ( Q=>histogram_2_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_1_sva_8 : FDRE port map ( Q=>histogram_1_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_0_sva_8 : FDRE port map ( Q=>histogram_0_sva(8), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_8, R=>rst);
   reg_histogram_7_sva_9 : FDRE port map ( Q=>histogram_7_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_6_sva_9 : FDRE port map ( Q=>histogram_6_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_5_sva_9 : FDRE port map ( Q=>histogram_5_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_4_sva_9 : FDRE port map ( Q=>histogram_4_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_3_sva_9 : FDRE port map ( Q=>histogram_3_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_2_sva_9 : FDRE port map ( Q=>histogram_2_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_1_sva_9 : FDRE port map ( Q=>histogram_1_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_0_sva_9 : FDRE port map ( Q=>histogram_0_sva(9), C=>clk, CE
      =>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_9, R=>rst);
   reg_histogram_7_sva_10 : FDRE port map ( Q=>histogram_7_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_6_sva_10 : FDRE port map ( Q=>histogram_6_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_5_sva_10 : FDRE port map ( Q=>histogram_5_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_4_sva_10 : FDRE port map ( Q=>histogram_4_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_3_sva_10 : FDRE port map ( Q=>histogram_3_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_2_sva_10 : FDRE port map ( Q=>histogram_2_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_1_sva_10 : FDRE port map ( Q=>histogram_1_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_0_sva_10 : FDRE port map ( Q=>histogram_0_sva(10), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_10, R=>rst);
   reg_histogram_7_sva_11 : FDRE port map ( Q=>histogram_7_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_6_sva_11 : FDRE port map ( Q=>histogram_6_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_5_sva_11 : FDRE port map ( Q=>histogram_5_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_4_sva_11 : FDRE port map ( Q=>histogram_4_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_3_sva_11 : FDRE port map ( Q=>histogram_3_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_2_sva_11 : FDRE port map ( Q=>histogram_2_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_1_sva_11 : FDRE port map ( Q=>histogram_1_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_0_sva_11 : FDRE port map ( Q=>histogram_0_sva(11), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_11, R=>rst);
   reg_histogram_7_sva_12 : FDRE port map ( Q=>histogram_7_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_6_sva_12 : FDRE port map ( Q=>histogram_6_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_5_sva_12 : FDRE port map ( Q=>histogram_5_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_4_sva_12 : FDRE port map ( Q=>histogram_4_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_3_sva_12 : FDRE port map ( Q=>histogram_3_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_2_sva_12 : FDRE port map ( Q=>histogram_2_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_1_sva_12 : FDRE port map ( Q=>histogram_1_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_0_sva_12 : FDRE port map ( Q=>histogram_0_sva(12), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_12, R=>rst);
   reg_histogram_7_sva_13 : FDRE port map ( Q=>histogram_7_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_6_sva_13 : FDRE port map ( Q=>histogram_6_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_5_sva_13 : FDRE port map ( Q=>histogram_5_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_4_sva_13 : FDRE port map ( Q=>histogram_4_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_3_sva_13 : FDRE port map ( Q=>histogram_3_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_2_sva_13 : FDRE port map ( Q=>histogram_2_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_1_sva_13 : FDRE port map ( Q=>histogram_1_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_0_sva_13 : FDRE port map ( Q=>histogram_0_sva(13), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_13, R=>rst);
   reg_histogram_7_sva_14 : FDRE port map ( Q=>histogram_7_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_6_sva_14 : FDRE port map ( Q=>histogram_6_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_5_sva_14 : FDRE port map ( Q=>histogram_5_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_4_sva_14 : FDRE port map ( Q=>histogram_4_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_3_sva_14 : FDRE port map ( Q=>histogram_3_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_2_sva_14 : FDRE port map ( Q=>histogram_2_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_1_sva_14 : FDRE port map ( Q=>histogram_1_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_0_sva_14 : FDRE port map ( Q=>histogram_0_sva(14), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_14, R=>rst);
   reg_histogram_7_sva_15 : FDRE port map ( Q=>histogram_7_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_6_sva_15 : FDRE port map ( Q=>histogram_6_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_5_sva_15 : FDRE port map ( Q=>histogram_5_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_4_sva_15 : FDRE port map ( Q=>histogram_4_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_3_sva_15 : FDRE port map ( Q=>histogram_3_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_2_sva_15 : FDRE port map ( Q=>histogram_2_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_1_sva_15 : FDRE port map ( Q=>histogram_1_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_0_sva_15 : FDRE port map ( Q=>histogram_0_sva(15), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_15, R=>rst);
   reg_histogram_7_sva_16 : FDRE port map ( Q=>histogram_7_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_6_sva_16 : FDRE port map ( Q=>histogram_6_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_5_sva_16 : FDRE port map ( Q=>histogram_5_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_4_sva_16 : FDRE port map ( Q=>histogram_4_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_3_sva_16 : FDRE port map ( Q=>histogram_3_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_2_sva_16 : FDRE port map ( Q=>histogram_2_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_1_sva_16 : FDRE port map ( Q=>histogram_1_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_histogram_0_sva_16 : FDRE port map ( Q=>histogram_0_sva(16), C=>clk, 
      CE=>nx44817z1, D=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_16, R=>rst);
   reg_threshold_sva_2 : FDSE port map ( Q=>threshold_sva(2), C=>clk, CE=>
      nx30850z1, D=>mcu_data_rsc_singleport_data_out(2), S=>rst);
   reg_threshold_sva_1 : FDRE port map ( Q=>threshold_sva(1), C=>clk, CE=>
      nx30850z1, D=>mcu_data_rsc_singleport_data_out(1), R=>rst);
   reg_threshold_sva_0 : FDRE port map ( Q=>threshold_sva(0), C=>clk, CE=>
      nx30850z1, D=>mcu_data_rsc_singleport_data_out(0), R=>rst);
   reg_out_data_rsc_mgc_out_stdreg_en_d_drv_0 : FDRE port map ( Q=>
      out_data_rsc_mgc_out_stdreg_en_d(2), C=>clk, CE=>nx26289z1, D=>
      nx34409z1, R=>rst);
   reg_buffer_sel_1_sva : FDSE port map ( Q=>buffer_sel_1_sva, C=>clk, CE=>
      nx6197z1, D=>nx6197z2, S=>rst);
   reg_main_stage_0_2 : FDR port map ( Q=>main_stage_0_2, C=>clk, D=>PWR, R
      =>rst);
   ix15577z1648 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_0, I0=>
      histogram_0_sva(0), I1=>histogram_1_sva(0), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1649 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_1, I0=>
      histogram_2_sva(0), I1=>histogram_3_sva(0), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1651 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_2, I0=>
      histogram_4_sva(0), I1=>histogram_5_sva(0), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1652 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_0_nx_mx8_l3_3, I0=>
      histogram_6_sva(0), I1=>histogram_7_sva(0), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1640 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_0, I0=>
      histogram_0_sva(1), I1=>histogram_1_sva(1), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1641 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_1, I0=>
      histogram_2_sva(1), I1=>histogram_3_sva(1), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1643 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_2, I0=>
      histogram_4_sva(1), I1=>histogram_5_sva(1), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1644 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_1_nx_mx8_l3_3, I0=>
      histogram_6_sva(1), I1=>histogram_7_sva(1), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1632 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_0, I0=>
      histogram_0_sva(2), I1=>histogram_1_sva(2), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1633 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_1, I0=>
      histogram_2_sva(2), I1=>histogram_3_sva(2), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1635 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_2, I0=>
      histogram_4_sva(2), I1=>histogram_5_sva(2), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1636 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_2_nx_mx8_l3_3, I0=>
      histogram_6_sva(2), I1=>histogram_7_sva(2), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1624 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_0, I0=>
      histogram_0_sva(3), I1=>histogram_1_sva(3), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1625 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_1, I0=>
      histogram_2_sva(3), I1=>histogram_3_sva(3), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1627 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_2, I0=>
      histogram_4_sva(3), I1=>histogram_5_sva(3), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1628 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_3_nx_mx8_l3_3, I0=>
      histogram_6_sva(3), I1=>histogram_7_sva(3), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1616 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_0, I0=>
      histogram_0_sva(4), I1=>histogram_1_sva(4), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1617 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_1, I0=>
      histogram_2_sva(4), I1=>histogram_3_sva(4), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1619 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_2, I0=>
      histogram_4_sva(4), I1=>histogram_5_sva(4), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1620 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_4_nx_mx8_l3_3, I0=>
      histogram_6_sva(4), I1=>histogram_7_sva(4), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1608 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_0, I0=>
      histogram_0_sva(5), I1=>histogram_1_sva(5), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1609 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_1, I0=>
      histogram_2_sva(5), I1=>histogram_3_sva(5), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1611 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_2, I0=>
      histogram_4_sva(5), I1=>histogram_5_sva(5), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1612 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_5_nx_mx8_l3_3, I0=>
      histogram_6_sva(5), I1=>histogram_7_sva(5), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1600 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_0, I0=>
      histogram_0_sva(6), I1=>histogram_1_sva(6), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1601 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_1, I0=>
      histogram_2_sva(6), I1=>histogram_3_sva(6), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1603 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_2, I0=>
      histogram_4_sva(6), I1=>histogram_5_sva(6), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1604 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_6_nx_mx8_l3_3, I0=>
      histogram_6_sva(6), I1=>histogram_7_sva(6), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1592 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_0, I0=>
      histogram_0_sva(7), I1=>histogram_1_sva(7), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1593 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_1, I0=>
      histogram_2_sva(7), I1=>histogram_3_sva(7), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1595 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_2, I0=>
      histogram_4_sva(7), I1=>histogram_5_sva(7), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1596 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_7_nx_mx8_l3_3, I0=>
      histogram_6_sva(7), I1=>histogram_7_sva(7), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1584 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_0, I0=>
      histogram_0_sva(8), I1=>histogram_1_sva(8), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1585 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_1, I0=>
      histogram_2_sva(8), I1=>histogram_3_sva(8), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1587 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_2, I0=>
      histogram_4_sva(8), I1=>histogram_5_sva(8), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1588 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_8_nx_mx8_l3_3, I0=>
      histogram_6_sva(8), I1=>histogram_7_sva(8), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1576 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_0, I0=>
      histogram_0_sva(9), I1=>histogram_1_sva(9), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1577 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_1, I0=>
      histogram_2_sva(9), I1=>histogram_3_sva(9), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1579 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_2, I0=>
      histogram_4_sva(9), I1=>histogram_5_sva(9), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1580 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_9_nx_mx8_l3_3, I0=>
      histogram_6_sva(9), I1=>histogram_7_sva(9), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1568 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_0, I0=>
      histogram_0_sva(10), I1=>histogram_1_sva(10), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1569 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_1, I0=>
      histogram_2_sva(10), I1=>histogram_3_sva(10), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1571 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_2, I0=>
      histogram_4_sva(10), I1=>histogram_5_sva(10), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1572 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_10_nx_mx8_l3_3, I0=>
      histogram_6_sva(10), I1=>histogram_7_sva(10), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1560 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_0, I0=>
      histogram_0_sva(11), I1=>histogram_1_sva(11), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1561 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_1, I0=>
      histogram_2_sva(11), I1=>histogram_3_sva(11), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1563 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_2, I0=>
      histogram_4_sva(11), I1=>histogram_5_sva(11), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1564 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_11_nx_mx8_l3_3, I0=>
      histogram_6_sva(11), I1=>histogram_7_sva(11), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1552 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_0, I0=>
      histogram_0_sva(12), I1=>histogram_1_sva(12), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1553 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_1, I0=>
      histogram_2_sva(12), I1=>histogram_3_sva(12), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1555 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_2, I0=>
      histogram_4_sva(12), I1=>histogram_5_sva(12), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1556 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_12_nx_mx8_l3_3, I0=>
      histogram_6_sva(12), I1=>histogram_7_sva(12), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1544 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_0, I0=>
      histogram_0_sva(13), I1=>histogram_1_sva(13), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1545 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_1, I0=>
      histogram_2_sva(13), I1=>histogram_3_sva(13), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1547 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_2, I0=>
      histogram_4_sva(13), I1=>histogram_5_sva(13), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1548 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_13_nx_mx8_l3_3, I0=>
      histogram_6_sva(13), I1=>histogram_7_sva(13), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1536 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_0, I0=>
      histogram_0_sva(14), I1=>histogram_1_sva(14), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1537 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_1, I0=>
      histogram_2_sva(14), I1=>histogram_3_sva(14), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1539 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_2, I0=>
      histogram_4_sva(14), I1=>histogram_5_sva(14), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1540 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_14_nx_mx8_l3_3, I0=>
      histogram_6_sva(14), I1=>histogram_7_sva(14), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1528 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_0, I0=>
      histogram_0_sva(15), I1=>histogram_1_sva(15), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1529 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_1, I0=>
      histogram_2_sva(15), I1=>histogram_3_sva(15), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1531 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_2, I0=>
      histogram_4_sva(15), I1=>histogram_5_sva(15), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1532 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_15_nx_mx8_l3_3, I0=>
      histogram_6_sva(15), I1=>histogram_7_sva(15), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1519 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_0, I0=>
      histogram_0_sva(16), I1=>histogram_1_sva(16), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1521 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_1, I0=>
      histogram_2_sva(16), I1=>histogram_3_sva(16), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1523 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_2, I0=>
      histogram_4_sva(16), I1=>histogram_5_sva(16), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix15577z1524 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>if_if_if_mux_nl_mux_0Bus105_16_nx_mx8_l3_3, I0=>
      histogram_6_sva(16), I1=>histogram_7_sva(16), I2=>
      window_4_lpi_1_dfm_12_mx0(0));
   ix21778z55179 : MUXF5 port map ( O=>window_6_lpi_1_dfm_4_mx0_1, I0=>
      nx21778z2, I1=>nx21778z3, S=>nx34363z11);
   ix13605z55178 : MUXF5 port map ( O=>frame_sva_6n1s2(1), I0=>nx13605z1, I1
      =>nx13605z2, S=>frame_sva(1));
   ix34409z55180 : MUXF5 port map ( O=>nx34409z3, I0=>nx34409z4, I1=>
      nx34409z5, S=>if_if_switch_lp_and_21_itm_3);
   ix51803z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(31), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(31), I2=>nx51803z2);
   ix50806z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(30), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(30), I2=>nx51803z2);
   ix48810z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(29), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(29), I2=>nx51803z2);
   ix47813z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(28), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(28), I2=>nx51803z2);
   ix46816z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(27), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(27), I2=>nx51803z2);
   ix45819z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(26), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(26), I2=>nx51803z2);
   ix44822z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(25), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(25), I2=>nx51803z2);
   ix43825z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(24), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(24), I2=>nx51803z2);
   ix42828z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(23), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(23), I2=>nx51803z2);
   ix41831z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(22), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(22), I2=>nx51803z2);
   ix40834z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(21), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(21), I2=>nx51803z2);
   ix39837z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(20), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(20), I2=>nx51803z2);
   ix37841z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(19), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(19), I2=>nx51803z2);
   ix36844z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(18), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(18), I2=>nx51803z2);
   ix35847z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>mcu_data_rsc_singleport_data_in(17), I0=>nx51803z1, I1
      =>if_if_mux_13_itm_2(17), I2=>nx51803z2);
   ix34850z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(16), I0=>nx34850z1, I1
      =>nx34850z8, I2=>nx34850z9, I3=>nx34850z10);
   ix33853z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(15), I0=>nx33853z1, I1
      =>nx33853z2, I2=>nx33853z3, I3=>nx33853z4);
   ix32856z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(14), I0=>nx32856z1, I1
      =>nx32856z2, I2=>nx32856z3, I3=>nx32856z4);
   ix31859z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(13), I0=>nx31859z1, I1
      =>nx31859z2, I2=>nx31859z3, I3=>nx31859z4);
   ix30862z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(12), I0=>nx30862z1, I1
      =>nx30862z2, I2=>nx30862z3, I3=>nx30862z4);
   ix29865z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(11), I0=>nx29865z1, I1
      =>nx29865z2, I2=>nx29865z3, I3=>nx29865z4);
   ix28868z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(10), I0=>nx28868z1, I1
      =>nx28868z2, I2=>nx28868z3, I3=>nx28868z4);
   ix31136z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(9), I0=>nx31136z1, I1=>
      nx31136z2, I2=>nx31136z3, I3=>nx31136z4);
   ix30139z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(8), I0=>nx30139z1, I1=>
      nx30139z2, I2=>nx30139z3, I3=>nx30139z4);
   ix29142z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(7), I0=>nx29142z1, I1=>
      nx29142z2, I2=>nx29142z3, I3=>nx29142z4);
   ix28145z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(6), I0=>nx28145z1, I1=>
      nx28145z2, I2=>nx28145z3, I3=>nx28145z4);
   ix27148z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(5), I0=>nx27148z1, I1=>
      nx27148z2, I2=>nx27148z3, I3=>nx27148z4);
   ix26151z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(4), I0=>nx26151z1, I1=>
      nx26151z2, I2=>nx26151z3, I3=>nx26151z4);
   ix25154z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(3), I0=>nx25154z1, I1=>
      nx25154z2, I2=>nx25154z3, I3=>nx25154z4);
   ix24157z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(2), I0=>nx24157z1, I1=>
      nx24157z2, I2=>nx24157z3, I3=>nx24157z4);
   ix23160z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mcu_data_rsc_singleport_data_in(1), I0=>nx23160z1, I1=>
      nx23160z2, I2=>nx23160z3, I3=>nx23160z4);
   ix22163z1105 : LUT4
      generic map (INIT => X"FF2F") 
       port map ( O=>mcu_data_rsc_singleport_data_in(0), I0=>
      if_if_mux_13_itm_2(0), I1=>NOT_and_227_cse, I2=>NOT_and_230_cse, I3=>
      nx22163z1);
   ix21705z1316 : LUT4
      generic map (INIT => X"0002") 
       port map ( O=>mcu_data_rsc_singleport_addr(3), I0=>nx21705z1, I1=>
      nx21705z2, I2=>nx21705z3, I3=>nx51803z1);
   ix20708z53732 : LUT4
      generic map (INIT => X"CCC2") 
       port map ( O=>mcu_data_rsc_singleport_addr(2), I0=>
      write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix19711z55088 : LUT4
      generic map (INIT => X"D20E") 
       port map ( O=>mcu_data_rsc_singleport_addr(1), I0=>
      write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix18714z1568 : LUT4
      generic map (INIT => X"00FE") 
       port map ( O=>mcu_data_rsc_singleport_addr(0), I0=>
      write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix20395z1185 : LUT4
      generic map (INIT => X"FF7F") 
       port map ( O=>mcu_data_rsc_singleport_re, I0=>exit_BUU_sva_1_st_2, I1
      =>system_input_output_vld_sva_dfm_st_2, I2=>get_thresh_sva_dfm_2_st_2, 
      I3=>nx20395z1);
   ix15410z1305 : LUT4
      generic map (INIT => X"FFF7") 
       port map ( O=>mcu_data_rsc_singleport_we, I0=>exit_BUU_sva_1_st_2, I1
      =>system_input_output_vld_sva_dfm_st_2, I2=>nx15410z1, I3=>nx15410z2);
   ix51923z1489 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>buffer_buf_rsc_singleport_data_in_EXMPLR98(2), I0=>
      in_data_rsc_mgc_in_wire_en_d(2), I1=>buffer_din_lpi_1(2), I2=>
      asn_309_itm_1);
   ix51923z1538 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_buf_rsc_singleport_data_in_EXMPLR98(1), I0=>
      asn_309_itm_1, I1=>in_data_rsc_mgc_in_wire_en_d(1), I2=>
      buffer_din_lpi_1(1));
   ix51923z1540 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_buf_rsc_singleport_data_in_EXMPLR98(0), I0=>
      asn_309_itm_1, I1=>in_data_rsc_mgc_in_wire_en_d(0), I2=>
      buffer_din_lpi_1(0));
   ix57829z34244 : LUT4
      generic map (INIT => X"80A2") 
       port map ( O=>buffer_buf_rsc_singleport_addr(9), I0=>
      BUU_if_acc_itm_1(3), I1=>exit_BUU_sva_4, I2=>
      buffer_sel_1_sva_dfm_1_st_1, I3=>BUU_i_1_lpi_1_dfm_st_1_0);
   ix58826z1516 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>buffer_buf_rsc_singleport_addr(8), I0=>
      BUU_if_acc_itm_1(2), I1=>BUU_else_if_asn_itm_1_8, I2=>mux_159_ssc);
   ix59823z1530 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_buf_rsc_singleport_addr(7), I0=>mux_159_ssc, I1
      =>BUU_else_if_asn_itm_1_7, I2=>BUU_if_acc_itm_1(1));
   ix60820z1530 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_buf_rsc_singleport_addr(6), I0=>mux_159_ssc, I1
      =>BUU_else_if_asn_itm_1_6, I2=>BUU_if_acc_itm_1(0));
   ix17933z48554 : LUT4
      generic map (INIT => X"B888") 
       port map ( O=>mux_tmp_1, I0=>in_data_vld_rsc_mgc_in_wire_d, I1=>
      exit_BUU_sva, I2=>io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, I3=>
      main_stage_0_2);
   ix12608z1331 : LUT2
      generic map (INIT => X"D") 
       port map ( O=>or_dcpl_86, I0=>system_input_r_filter_sva(6), I1=>
      system_input_r_filter_sva(4));
   ix23862z34086 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>or_dcpl_118, I0=>system_input_c_filter_sva(5), I1=>
      system_input_c_filter_sva(4), I2=>system_input_c_filter_sva(3), I3=>
      system_input_c_filter_sva(2));
   mcu_data_rsc_singleport_addr_4_EXMPLR99 : GND port map ( G=>
      buffer_buf_rsc_singleport_re_EXMPLR91);
   ix34850z1570 : LUT3
      generic map (INIT => X"FE") 
       port map ( O=>NOT_and_208_cse, I0=>write_histogram_sva_dfm_1_st_2_sg2, 
      I1=>write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1));
   ix34850z1300 : LUT4
      generic map (INIT => X"FFEF") 
       port map ( O=>NOT_and_211_cse, I0=>write_histogram_sva_dfm_1_st_2_sg2, 
      I1=>write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1598 : LUT3
      generic map (INIT => X"FD") 
       port map ( O=>NOT_and_215_cse, I0=>write_histogram_sva_dfm_1_st_2_sg1, 
      I1=>write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1560 : LUT3
      generic map (INIT => X"DF") 
       port map ( O=>NOT_and_217_cse, I0=>write_histogram_sva_dfm_1_st_2_sg1, 
      I1=>write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1585 : LUT3
      generic map (INIT => X"F7") 
       port map ( O=>NOT_and_219_cse, I0=>write_histogram_sva_dfm_1_st_2_sg1, 
      I1=>write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1467 : LUT3
      generic map (INIT => X"7F") 
       port map ( O=>NOT_and_221_cse, I0=>write_histogram_sva_dfm_1_st_2_sg1, 
      I1=>write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1338 : LUT4
      generic map (INIT => X"FFFD") 
       port map ( O=>NOT_and_224_cse, I0=>write_histogram_sva_dfm_1_st_2_sg2, 
      I1=>write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z830 : LUT4
      generic map (INIT => X"FDFF") 
       port map ( O=>NOT_and_227_cse, I0=>write_histogram_sva_dfm_1_st_2_sg2, 
      I1=>write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix39154z1441 : LUT3
      generic map (INIT => X"7F") 
       port map ( O=>buffer_buf_rsc_singleport_we, I0=>exit_BUU_sva_4, I1=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, I2=>main_stage_0_2);
   ix13605z1323 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_system_input_land_1_lpi_1_dfm_1, I0=>NOT_or_181_cse, 
      I1=>nx12608z2);
   ix12084z62754 : LUT4
      generic map (INIT => X"EFFF") 
       port map ( O=>NOT_equal_tmp_15, I0=>nx12084z1, I1=>nx14656z1, I2=>
      nx12083z1, I3=>write_histogram_sva_dfm_7_mx0_0);
   ix30626z1566 : LUT3
      generic map (INIT => X"FB") 
       port map ( O=>NOT_equal_tmp_16, I0=>nx12084z1, I1=>nx14656z1, I2=>
      write_histogram_sva_dfm_7_mx0_0);
   ix29629z290 : LUT4
      generic map (INIT => X"FBFF") 
       port map ( O=>NOT_equal_tmp_17, I0=>nx12084z1, I1=>nx14656z1, I2=>
      nx12083z1, I3=>write_histogram_sva_dfm_7_mx0_0);
   ix12083z50466 : LUT4
      generic map (INIT => X"BFFF") 
       port map ( O=>NOT_equal_tmp_19, I0=>nx12084z1, I1=>nx14656z1, I2=>
      nx12083z1, I3=>write_histogram_sva_dfm_7_mx0_0);
   ix47778z45007 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>window_7_lpi_1_dfm_3_mx0_1, I0=>
      window_7_lpi_1_dfm_2_mx0(1), I1=>window_6_lpi_1_dfm_3_mx0(1), I2=>
      nx21778z5, I3=>nx21778z7);
   ix47778z45009 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>window_7_lpi_1_dfm_3_mx0_0, I0=>
      window_7_lpi_1_dfm_2_mx0(0), I1=>window_6_lpi_1_dfm_3_mx0(0), I2=>
      nx21778z5, I3=>nx21778z7);
   ix21778z53748 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>window_6_lpi_1_dfm_4_mx0_0, I0=>
      window_7_lpi_1_dfm_2_mx0(0), I1=>window_6_lpi_1_dfm_3_mx0(0), I2=>
      nx21778z5, I3=>nx21778z7);
   ix4197z687 : LUT4
      generic map (INIT => X"FD8C") 
       port map ( O=>window_5_lpi_1_dfm_2_mx0_1, I0=>
      window_5_lpi_1_dfm_1_mx0(2), I1=>window_5_lpi_1_dfm_1_mx0(1), I2=>
      window_4_lpi_1_dfm_2_mx0(2), I3=>window_4_lpi_1_dfm_2_mx0(1));
   ix4197z45009 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>window_5_lpi_1_dfm_2_mx0_0, I0=>
      window_5_lpi_1_dfm_1_mx0(0), I1=>window_4_lpi_1_dfm_2_mx0(0), I2=>
      nx4197z3, I3=>nx4197z5);
   ix34363z54115 : LUT4
      generic map (INIT => X"CE40") 
       port map ( O=>window_4_lpi_1_dfm_3_mx0_1, I0=>
      window_5_lpi_1_dfm_1_mx0(2), I1=>window_5_lpi_1_dfm_1_mx0(1), I2=>
      window_4_lpi_1_dfm_2_mx0(2), I3=>window_4_lpi_1_dfm_2_mx0(1));
   ix35360z53741 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>window_4_lpi_1_dfm_3_mx0_0, I0=>
      window_5_lpi_1_dfm_1_mx0(0), I1=>window_4_lpi_1_dfm_2_mx0(0), I2=>
      nx4197z3, I3=>nx4197z5);
   ix34363z1603 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_0_lpi_1_dfm_4_mx0(1), I0=>
      window_0_lpi_1_dfm_8(1), I1=>window_8_lpi_1_dfm_3_mx0_1, I2=>
      nx34363z17);
   ix34363z1551 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_0_lpi_1_dfm_4_mx0(0), I0=>
      window_0_lpi_1_dfm_8(0), I1=>window_8_lpi_1_dfm_3_mx0_0, I2=>
      nx34363z17);
   ix21778z1529 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_7_lpi_1_dfm_2_mx0(1), I0=>
      window_5_lpi_1_dfm_8(1), I1=>window_7_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z11);
   ix21778z1525 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_7_lpi_1_dfm_2_mx0(0), I0=>
      window_5_lpi_1_dfm_8(0), I1=>window_7_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z11);
   ix21778z1491 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_6_lpi_1_dfm_3_mx0(1), I0=>
      window_6_lpi_1_dfm_2_mx0(1), I1=>window_4_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z15);
   ix21778z1496 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_6_lpi_1_dfm_3_mx0(0), I0=>
      window_6_lpi_1_dfm_2_mx0(0), I1=>window_4_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z15);
   ix34363z1537 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_5_lpi_1_dfm_1_mx0(1), I0=>
      window_5_lpi_1_dfm_8(1), I1=>window_7_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z11);
   ix4197z1490 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_5_lpi_1_dfm_1_mx0(0), I0=>
      window_5_lpi_1_dfm_8(0), I1=>window_7_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z11);
   ix34363z1563 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_4_lpi_1_dfm_2_mx0(1), I0=>
      window_6_lpi_1_dfm_2_mx0(1), I1=>window_4_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z15);
   ix33366z1518 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_4_lpi_1_dfm_2_mx0(0), I0=>
      window_6_lpi_1_dfm_2_mx0(0), I1=>window_4_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z15);
   ix34363z1512 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_7_lpi_1_dfm_1_mx0(1), I0=>
      window_7_lpi_1_dfm_mx0(1), I1=>window_6_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z9);
   ix34363z1523 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_7_lpi_1_dfm_1_mx0(0), I0=>
      window_7_lpi_1_dfm_mx0(0), I1=>window_6_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z9);
   ix34363z1564 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_6_lpi_1_dfm_2_mx0(1), I0=>
      window_7_lpi_1_dfm_mx0(1), I1=>window_6_lpi_1_dfm_1_mx0(1), I2=>
      nx34363z9);
   ix21778z1527 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_6_lpi_1_dfm_2_mx0(0), I0=>
      window_7_lpi_1_dfm_mx0(0), I1=>window_6_lpi_1_dfm_1_mx0(0), I2=>
      nx34363z9);
   ix34363z1535 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_1_mx0(1), I0=>
      window_4_lpi_1_dfm_10(1), I1=>window_8_lpi_1_dfm_2_mx0(1), I2=>
      nx34363z14);
   ix34363z1542 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_1_mx0(0), I0=>
      window_4_lpi_1_dfm_10(0), I1=>window_8_lpi_1_dfm_2_mx0(0), I2=>
      nx34363z14);
   ix34363z1637 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_8_lpi_1_dfm_3_mx0_1, I0=>
      window_4_lpi_1_dfm_10(1), I1=>window_8_lpi_1_dfm_2_mx0(1), I2=>
      nx34363z14);
   ix34363z1579 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_8_lpi_1_dfm_3_mx0_0, I0=>
      window_4_lpi_1_dfm_10(0), I1=>window_8_lpi_1_dfm_2_mx0(0), I2=>
      nx34363z14);
   ix34363z1543 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_7_lpi_1_dfm_mx0(1), I0=>
      window_8_lpi_1_dfm_mx0(1), I1=>clip_window_qr_2_lpi_1_dfm_mx0(1), I2=>
      nx34363z3);
   ix34363z1554 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_7_lpi_1_dfm_mx0(0), I0=>
      window_8_lpi_1_dfm_mx0(0), I1=>clip_window_qr_2_lpi_1_dfm_mx0(0), I2=>
      nx34363z3);
   ix34363z1544 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_6_lpi_1_dfm_1_mx0(1), I0=>
      window_8_lpi_1_dfm_1_mx0(1), I1=>window_6_lpi_1_dfm_mx0(1), I2=>
      nx34363z8);
   ix34363z1548 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_6_lpi_1_dfm_1_mx0(0), I0=>
      window_8_lpi_1_dfm_1_mx0(0), I1=>window_6_lpi_1_dfm_mx0(0), I2=>
      nx34363z8);
   ix34363z1068 : LUT4
      generic map (INIT => X"FEDC") 
       port map ( O=>window_8_lpi_1_dfm_2_mx0(2), I0=>unequal_tmp_6, I1=>
      window_8_lpi_1_dfm_1_mx0(2), I2=>BUU_else_else_if_qr_1_lpi_1_dfm_1(2), 
      I3=>BUU_else_else_if_qr_lpi_1_dfm_1(2));
   ix34363z1575 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_8_lpi_1_dfm_2_mx0(1), I0=>
      window_8_lpi_1_dfm_1_mx0(1), I1=>window_6_lpi_1_dfm_mx0(1), I2=>
      nx34363z8);
   ix34363z1531 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_8_lpi_1_dfm_2_mx0(0), I0=>
      window_8_lpi_1_dfm_1_mx0(0), I1=>window_6_lpi_1_dfm_mx0(0), I2=>
      nx34363z8);
   ix34363z304 : LUT4
      generic map (INIT => X"FBF8") 
       port map ( O=>window_8_lpi_1_dfm_1_mx0(2), I0=>
      system_input_window_7_sva(2), I1=>clip_window_and_1_cse_sva_1, I2=>
      window_8_lpi_1_dfm_mx0(2), I3=>BUU_else_else_if_qr_1_lpi_1_dfm_1(2));
   ix34363z1491 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_8_lpi_1_dfm_1_mx0(1), I0=>
      window_8_lpi_1_dfm_mx0(1), I1=>clip_window_qr_2_lpi_1_dfm_mx0(1), I2=>
      nx34363z3);
   ix34363z1519 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_8_lpi_1_dfm_1_mx0(0), I0=>
      window_8_lpi_1_dfm_mx0(0), I1=>clip_window_qr_2_lpi_1_dfm_mx0(0), I2=>
      nx34363z3);
   ix34363z1561 : LUT3
      generic map (INIT => X"E4") 
       port map ( O=>window_6_lpi_1_dfm_mx0(2), I0=>unequal_tmp_6, I1=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2), I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(2));
   ix34363z1555 : LUT3
      generic map (INIT => X"E4") 
       port map ( O=>window_6_lpi_1_dfm_mx0(1), I0=>unequal_tmp_6, I1=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1), I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(1));
   ix34363z1558 : LUT3
      generic map (INIT => X"E4") 
       port map ( O=>window_6_lpi_1_dfm_mx0(0), I0=>unequal_tmp_6, I1=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0), I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(0));
   ix34363z1549 : LUT3
      generic map (INIT => X"E2") 
       port map ( O=>window_8_lpi_1_dfm_mx0(2), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(2), I1=>
      clip_window_ac_int_cctor_2_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2));
   ix34363z1546 : LUT3
      generic map (INIT => X"E2") 
       port map ( O=>window_8_lpi_1_dfm_mx0(1), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(1), I1=>
      clip_window_ac_int_cctor_2_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1));
   ix34363z1574 : LUT3
      generic map (INIT => X"E2") 
       port map ( O=>window_8_lpi_1_dfm_mx0(0), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(0), I1=>
      clip_window_ac_int_cctor_2_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0));
   ix34363z1508 : LUT3
      generic map (INIT => X"B8") 
       port map ( O=>clip_window_qr_2_lpi_1_dfm_mx0(2), I0=>
      system_input_window_7_sva(2), I1=>clip_window_and_1_cse_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2));
   ix34363z1505 : LUT3
      generic map (INIT => X"B8") 
       port map ( O=>clip_window_qr_2_lpi_1_dfm_mx0(1), I0=>
      system_input_window_7_sva(1), I1=>clip_window_and_1_cse_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1));
   ix34363z1510 : LUT3
      generic map (INIT => X"B8") 
       port map ( O=>clip_window_qr_2_lpi_1_dfm_mx0(0), I0=>
      system_input_window_7_sva(0), I1=>clip_window_and_1_cse_sva_1, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0));
   ix31708z1517 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_2_lpi_1_dfm_2_mx0(1), I0=>
      window_0_lpi_1_dfm_1_mx0(1), I1=>window_2_lpi_1_dfm_1_mx0(1), I2=>
      nx9753z8);
   ix32705z1517 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_2_lpi_1_dfm_2_mx0(0), I0=>
      window_0_lpi_1_dfm_1_mx0(0), I1=>window_2_lpi_1_dfm_1_mx0(0), I2=>
      nx9753z8);
   ix31708z1518 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_3_lpi_1_dfm_1_mx0_1, I0=>
      window_1_lpi_1_dfm_mx0(1), I1=>window_3_lpi_1_dfm_mx0(1), I2=>
      nx9753z10);
   ix31708z1522 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_3_lpi_1_dfm_1_mx0_0, I0=>
      window_1_lpi_1_dfm_mx0(0), I1=>window_3_lpi_1_dfm_mx0(0), I2=>
      nx9753z10);
   ix9753z1487 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_0_lpi_1_dfm_2_mx0(1), I0=>
      window_0_lpi_1_dfm_1_mx0(1), I1=>window_2_lpi_1_dfm_1_mx0(1), I2=>
      nx9753z8);
   ix10750z1487 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_0_lpi_1_dfm_2_mx0(0), I0=>
      window_0_lpi_1_dfm_1_mx0(0), I1=>window_2_lpi_1_dfm_1_mx0(0), I2=>
      nx9753z8);
   ix9753z1543 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_1_lpi_1_dfm_1_mx0_1, I0=>
      window_1_lpi_1_dfm_mx0(1), I1=>window_3_lpi_1_dfm_mx0(1), I2=>
      nx9753z10);
   ix9753z1525 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_1_lpi_1_dfm_1_mx0_0, I0=>
      window_1_lpi_1_dfm_mx0(0), I1=>window_3_lpi_1_dfm_mx0(0), I2=>
      nx9753z10);
   ix9753z572 : LUT4
      generic map (INIT => X"FCFA") 
       port map ( O=>window_1_lpi_1_dfm_mx0(2), I0=>
      system_input_window_4_sva(2), I1=>system_input_window_3_sva(2), I2=>
      clip_window_qr_lpi_1_dfm_mx0(2), I3=>nx37359z1);
   ix9753z1515 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_1_lpi_1_dfm_mx0(1), I0=>
      clip_window_qr_lpi_1_dfm_mx0(1), I1=>window_0_lpi_1_dfm_mx0(1), I2=>
      nx9753z4);
   ix9753z1526 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_1_lpi_1_dfm_mx0(0), I0=>
      clip_window_qr_lpi_1_dfm_mx0(0), I1=>window_0_lpi_1_dfm_mx0(0), I2=>
      nx9753z4);
   ix9753z1546 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_3_lpi_1_dfm_mx0(1), I0=>
      window_2_lpi_1_dfm_mx0(1), I1=>clip_window_qr_3_lpi_1_dfm_mx0(1), I2=>
      nx9753z6);
   ix9753z1551 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_3_lpi_1_dfm_mx0(0), I0=>
      window_2_lpi_1_dfm_mx0(0), I1=>clip_window_qr_3_lpi_1_dfm_mx0(0), I2=>
      nx9753z6);
   ix9753z1518 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_0_lpi_1_dfm_1_mx0(1), I0=>
      clip_window_qr_lpi_1_dfm_mx0(1), I1=>window_0_lpi_1_dfm_mx0(1), I2=>
      nx9753z4);
   ix10750z1518 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>window_0_lpi_1_dfm_1_mx0(0), I0=>
      clip_window_qr_lpi_1_dfm_mx0(0), I1=>window_0_lpi_1_dfm_mx0(0), I2=>
      nx9753z4);
   ix9753z53 : LUT4
      generic map (INIT => X"FAFC") 
       port map ( O=>window_2_lpi_1_dfm_1_mx0(2), I0=>
      system_input_window_4_sva(2), I1=>system_input_window_5_sva(2), I2=>
      clip_window_qr_3_lpi_1_dfm_mx0(2), I3=>NOT_or_181_cse);
   ix9753z1499 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_2_lpi_1_dfm_1_mx0(1), I0=>
      window_2_lpi_1_dfm_mx0(1), I1=>clip_window_qr_3_lpi_1_dfm_mx0(1), I2=>
      nx9753z6);
   ix9753z1511 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_2_lpi_1_dfm_1_mx0(0), I0=>
      window_2_lpi_1_dfm_mx0(0), I1=>clip_window_qr_3_lpi_1_dfm_mx0(0), I2=>
      nx9753z6);
   ix51923z59341 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_7_sva_mx0(2), I0=>
      system_input_window_7_sva(2), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(2), I3=>nx34903z4);
   ix51923z59346 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_7_sva_mx0(1), I0=>
      system_input_window_7_sva(1), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(1), I3=>nx34903z4);
   ix26941z59341 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_7_sva_mx0(0), I0=>
      system_input_window_7_sva(0), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_1_lpi_1_dfm_1(0), I3=>nx34903z4);
   ix51923z45552 : LUT4
      generic map (INIT => X"ACCC") 
       port map ( O=>system_input_window_8_sva_mx0(2), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(2), I1=>
      system_input_window_8_sva(2), I2=>exit_BUU_sva_4, I3=>nx34903z4);
   ix51923z45557 : LUT4
      generic map (INIT => X"ACCC") 
       port map ( O=>system_input_window_8_sva_mx0(1), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(1), I1=>
      system_input_window_8_sva(1), I2=>exit_BUU_sva_4, I3=>nx34903z4);
   ix51923z45559 : LUT4
      generic map (INIT => X"ACCC") 
       port map ( O=>system_input_window_8_sva_mx0(0), I0=>
      buffer_buf_rsc_singleport_data_in_EXMPLR98(0), I1=>
      system_input_window_8_sva(0), I2=>exit_BUU_sva_4, I3=>nx34903z4);
   ix9753z1547 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_2_lpi_1_dfm_mx0(2), I0=>NOT_or_181_cse, I1=>
      system_input_window_4_sva(2), I2=>system_input_window_5_sva(2));
   ix9753z1544 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_2_lpi_1_dfm_mx0(1), I0=>NOT_or_181_cse, I1=>
      system_input_window_4_sva(1), I2=>system_input_window_5_sva(1));
   ix9753z1556 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_2_lpi_1_dfm_mx0(0), I0=>NOT_or_181_cse, I1=>
      system_input_window_4_sva(0), I2=>system_input_window_5_sva(0));
   ix9753z1548 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>clip_window_qr_3_lpi_1_dfm_mx0(2), I0=>nx37359z1, I1=>
      system_input_window_6_sva_mx0(2), I2=>system_input_window_7_sva_mx0(2)
   );
   ix9753z1545 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>clip_window_qr_3_lpi_1_dfm_mx0(1), I0=>nx37359z1, I1=>
      system_input_window_6_sva_mx0(1), I2=>system_input_window_7_sva_mx0(1)
   );
   ix9753z1550 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>clip_window_qr_3_lpi_1_dfm_mx0(0), I0=>nx37359z1, I1=>
      system_input_window_6_sva_mx0(0), I2=>system_input_window_7_sva_mx0(0)
   );
   ix9753z45015 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>clip_window_qr_lpi_1_dfm_mx0(2), I0=>
      system_input_window_4_sva(2), I1=>system_input_window_7_sva_mx0(2), I2
      =>nx9753z2, I3=>nx9753z3);
   ix9753z45009 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>clip_window_qr_lpi_1_dfm_mx0(1), I0=>
      system_input_window_4_sva(1), I1=>system_input_window_7_sva_mx0(1), I2
      =>nx9753z2, I3=>nx9753z3);
   ix9753z45047 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>clip_window_qr_lpi_1_dfm_mx0(0), I0=>
      system_input_window_4_sva(0), I1=>system_input_window_7_sva_mx0(0), I2
      =>nx9753z2, I3=>nx9753z3);
   ix9753z1540 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_0_lpi_1_dfm_mx0(2), I0=>nx37359z1, I1=>
      system_input_window_3_sva(2), I2=>system_input_window_4_sva(2));
   ix9753z1537 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_0_lpi_1_dfm_mx0(1), I0=>nx37359z1, I1=>
      system_input_window_3_sva(1), I2=>system_input_window_4_sva(1));
   ix9753z1542 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>window_0_lpi_1_dfm_mx0(0), I0=>nx37359z1, I1=>
      system_input_window_3_sva(0), I2=>system_input_window_4_sva(0));
   ix29629z53745 : LUT4
      generic map (INIT => X"CCCD") 
       port map ( O=>write_histogram_sva_dfm_7_mx0_0, I0=>or_dcpl_86, I1=>
      write_histogram_sva_13(0), I2=>nx29629z1, I3=>nx29629z2);
   ix12608z17700 : LUT4
      generic map (INIT => X"4000") 
       port map ( O=>NOT_or_181_cse, I0=>nx12608z1, I1=>
      system_input_r_filter_sva(0), I2=>system_input_r_filter_sva(2), I3=>
      system_input_r_filter_sva(1));
   ix23862z1513 : LUT3
      generic map (INIT => X"B8") 
       port map ( O=>mux_154_cse, I0=>in_data_vld_rsc_mgc_in_wire_d, I1=>
      exit_BUU_sva, I2=>io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1);
   ix34850z1537 : LUT3
      generic map (INIT => X"BF") 
       port map ( O=>NOT_and_213_ssc, I0=>write_histogram_sva_dfm_1_st_2_sg1, 
      I1=>write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z1318 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mux_tmp, I0=>or_dcpl_39, I1=>if_if_and_7_itm_2, I2=>
      window_4_lpi_1_dfm_12_mx0(2), I3=>window_4_lpi_1_dfm_12_mx0(1));
   ix43472z1313 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>mux_tmp_76, I0=>if_if_and_7_itm_2, I1=>
      window_4_lpi_1_dfm_12_mx0(2), I2=>window_4_lpi_1_dfm_12_mx0(1), I3=>
      NOT_or_dcpl_31_0n0s2);
   ix64847z1058 : LUT4
      generic map (INIT => X"FEFF") 
       port map ( O=>mux_tmp_77, I0=>or_dcpl_39, I1=>if_if_and_7_itm_2, I2=>
      window_4_lpi_1_dfm_12_mx0(2), I3=>window_4_lpi_1_dfm_12_mx0(1));
   ix42094z1298 : LUT4
      generic map (INIT => X"FFEF") 
       port map ( O=>mux_tmp_78, I0=>if_if_and_7_itm_2, I1=>
      window_4_lpi_1_dfm_12_mx0(2), I2=>window_4_lpi_1_dfm_12_mx0(1), I3=>
      NOT_or_dcpl_31_0n0s2);
   ix46195z1298 : LUT4
      generic map (INIT => X"FFEF") 
       port map ( O=>mux_tmp_79, I0=>or_dcpl_39, I1=>if_if_and_7_itm_2, I2=>
      window_4_lpi_1_dfm_12_mx0(2), I3=>window_4_lpi_1_dfm_12_mx0(1));
   ix62124z1310 : LUT4
      generic map (INIT => X"FFFB") 
       port map ( O=>mux_tmp_80, I0=>if_if_and_7_itm_2, I1=>
      window_4_lpi_1_dfm_12_mx0(2), I2=>window_4_lpi_1_dfm_12_mx0(1), I3=>
      NOT_or_dcpl_31_0n0s2);
   ix26165z62754 : LUT4
      generic map (INIT => X"EFFF") 
       port map ( O=>mux_tmp_81, I0=>or_dcpl_39, I1=>if_if_and_7_itm_2, I2=>
      window_4_lpi_1_dfm_12_mx0(2), I3=>window_4_lpi_1_dfm_12_mx0(1));
   ix16618z1250 : LUT4
      generic map (INIT => X"FFBF") 
       port map ( O=>mux_tmp_82, I0=>if_if_and_7_itm_2, I1=>
      window_4_lpi_1_dfm_12_mx0(2), I2=>window_4_lpi_1_dfm_12_mx0(1), I3=>
      NOT_or_dcpl_31_0n0s2);
   ix30626z1492 : LUT3
      generic map (INIT => X"AB") 
       port map ( O=>get_thresh_sva_dfm_2_mx0, I0=>get_thresh_sva, I1=>
      nx9333z3, I2=>nx9333z5);
   ix29629z1573 : LUT3
      generic map (INIT => X"FD") 
       port map ( O=>NOT_if_and_1_ssc, I0=>NOT_equal_tmp_23, I1=>
      NOT_write_histogram_sva_13_6n1s20, I2=>nx29629z3);
   ix14602z64802 : LUT4
      generic map (INIT => X"F7FF") 
       port map ( O=>NOT_if_if_and_9_tmp, I0=>NOT_or_181_cse, I1=>nx12608z2, 
      I2=>NOT_if_if_equal_cse_sva_3_0n0s2, I3=>nx23862z4);
   ix34850z1507 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_12_mx0(1), I0=>
      window_4_lpi_1_dfm_5_mx0(1), I1=>window_5_lpi_1_dfm_4_mx0(1), I2=>
      nx34850z2);
   ix15577z1490 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_12_mx0(0), I0=>
      window_4_lpi_1_dfm_5_mx0(0), I1=>window_5_lpi_1_dfm_4_mx0(0), I2=>
      nx34850z2);
   ix34850z1500 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_5_mx0(1), I0=>
      window_4_lpi_1_dfm_11(1), I1=>window_6_lpi_1_dfm_9(1), I2=>nx34850z6);
   ix34850z1502 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_4_lpi_1_dfm_5_mx0(0), I0=>
      window_4_lpi_1_dfm_11(0), I1=>window_6_lpi_1_dfm_9(0), I2=>nx34850z6);
   ix34850z1503 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_5_lpi_1_dfm_4_mx0(1), I0=>
      window_5_lpi_1_dfm_9(1), I1=>window_7_lpi_1_dfm_8(1), I2=>nx34850z7);
   ix34850z1505 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>window_5_lpi_1_dfm_4_mx0(0), I0=>
      window_5_lpi_1_dfm_9(0), I1=>window_7_lpi_1_dfm_8(0), I2=>nx34850z7);
   ix15189z53695 : LUT4
      generic map (INIT => X"CC9C") 
       port map ( O=>buffer_sel_1_sva_dfm_1_mx0, I0=>system_input_c_sva(0), 
      I1=>buffer_sel_1_sva, I2=>exit_BUU_sva, I3=>buffer_or_1_cse_0n0s2);
   ix17933z1333 : LUT3
      generic map (INIT => X"12") 
       port map ( O=>BUU_i_1_sva_1_1, I0=>BUU_i_1_lpi_1(1), I1=>exit_BUU_sva, 
      I2=>BUU_i_1_lpi_1(0));
   ix11174z1489 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>buffer_t1_sva_mx0(2), I0=>
      buffer_buf_rsc_singleport_data_out(2), I1=>buffer_t1_sva(2), I2=>
      nx17287z1);
   ix12171z1532 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_t1_sva_mx0(1), I0=>nx17287z1, I1=>
      buffer_buf_rsc_singleport_data_out(1), I2=>buffer_t1_sva(1));
   ix13168z1532 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_t1_sva_mx0(0), I0=>nx17287z1, I1=>
      buffer_buf_rsc_singleport_data_out(0), I2=>buffer_t1_sva(0));
   ix11174z1490 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>buffer_t0_sva_mx0(2), I0=>
      buffer_buf_rsc_singleport_data_out(2), I1=>buffer_t0_sva(2), I2=>
      nx26054z1);
   ix12171z1533 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_t0_sva_mx0(1), I0=>nx26054z1, I1=>
      buffer_buf_rsc_singleport_data_out(1), I2=>buffer_t0_sva(1));
   ix13168z1533 : LUT3
      generic map (INIT => X"D8") 
       port map ( O=>buffer_t0_sva_mx0(0), I0=>nx26054z1, I1=>
      buffer_buf_rsc_singleport_data_out(0), I2=>buffer_t0_sva(0));
   ix11174z1557 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_1_lpi_1_dfm_1(2), I0=>
      BUU_else_else_if_qr_1_lpi_1(2), I1=>exit_BUU_sva_4, I2=>nx11174z2);
   ix12171z1556 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_1_lpi_1_dfm_1(1), I0=>
      BUU_else_else_if_qr_1_lpi_1(1), I1=>exit_BUU_sva_4, I2=>nx12171z1);
   ix13168z1556 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_1_lpi_1_dfm_1(0), I0=>
      BUU_else_else_if_qr_1_lpi_1(0), I1=>exit_BUU_sva_4, I2=>nx13168z1);
   ix34363z1576 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_lpi_1_dfm_1(2), I0=>
      BUU_else_else_if_qr_lpi_1(2), I1=>exit_BUU_sva_4, I2=>nx34363z7);
   ix34363z1570 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_lpi_1_dfm_1(1), I0=>
      BUU_else_else_if_qr_lpi_1(1), I1=>exit_BUU_sva_4, I2=>nx34363z5);
   ix34363z1573 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>BUU_else_else_if_qr_lpi_1_dfm_1(0), I0=>
      BUU_else_else_if_qr_lpi_1(0), I1=>exit_BUU_sva_4, I2=>nx34363z6);
   ix53466z59340 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_6_sva_mx0(2), I0=>
      system_input_window_6_sva(2), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(2), I3=>nx34903z4);
   ix54463z59340 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_6_sva_mx0(1), I0=>
      system_input_window_6_sva(1), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(1), I3=>nx34903z4);
   ix55460z59340 : LUT4
      generic map (INIT => X"E2AA") 
       port map ( O=>system_input_window_6_sva_mx0(0), I0=>
      system_input_window_6_sva(0), I1=>exit_BUU_sva_4, I2=>
      BUU_else_else_if_qr_lpi_1_dfm_1(0), I3=>nx34903z4);
   ix58826z1429 : LUT3
      generic map (INIT => X"72") 
       port map ( O=>mux_159_ssc, I0=>exit_BUU_sva_4, I1=>
      buffer_sel_1_sva_dfm_1_st_1, I2=>BUU_i_1_lpi_1_dfm_st_1_0);
   ix21705z62754 : LUT4
      generic map (INIT => X"EFFF") 
       port map ( O=>nx21705z1, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   PWR_EXMPLR100 : VCC port map ( P=>PWR);
   ix34850z44358 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_0_sva(16));
   ix45814z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_0_sva(15));
   ix46811z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_0_sva(14));
   ix47808z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_0_sva(13));
   ix48805z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_0_sva(12));
   ix49802z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_0_sva(11));
   ix50799z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_0_sva(10));
   ix21399z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_0_sva(9));
   ix22396z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_0_sva(8));
   ix23393z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_0_sva(7));
   ix24390z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_0_sva(6));
   ix25387z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_0_sva(5));
   ix26384z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_0_sva(4));
   ix27381z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_0_sva(3));
   ix28378z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_0_sva(2));
   ix29375z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_0_sva(1));
   ix30372z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_0_sva(0), I1=>mux_tmp, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix43472z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_1_sva(16));
   ix42475z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_1_sva(15));
   ix41478z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_1_sva(14));
   ix40481z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_1_sva(13));
   ix39484z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_1_sva(12));
   ix38487z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_1_sva(11));
   ix37490z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_1_sva(10));
   ix43594z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_1_sva(9));
   ix44591z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_1_sva(8));
   ix45588z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_1_sva(7));
   ix46585z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_1_sva(6));
   ix47582z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_1_sva(5));
   ix48579z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_1_sva(4));
   ix49576z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_1_sva(3));
   ix50573z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_1_sva(2));
   ix51570z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_76, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_1_sva(1));
   ix52567z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_1_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_1_sva(0), I1=>mux_tmp_76, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix64847z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_2_sva(16));
   ix308z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_2_sva(15));
   ix1305z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_2_sva(14));
   ix2302z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_2_sva(13));
   ix3299z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_2_sva(12));
   ix4296z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_2_sva(11));
   ix5293z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_2_sva(10));
   ix65283z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_2_sva(9));
   ix64286z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_2_sva(8));
   ix63289z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_2_sva(7));
   ix62292z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_2_sva(6));
   ix61295z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_2_sva(5));
   ix60298z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_2_sva(4));
   ix59301z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_2_sva(3));
   ix58304z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_2_sva(2));
   ix57307z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_77, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_2_sva(1));
   ix56310z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_2_sva(0), I1=>mux_tmp_77, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix42094z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_3_sva(16));
   ix43091z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_3_sva(15));
   ix44088z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_3_sva(14));
   ix45085z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_3_sva(13));
   ix46082z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_3_sva(12));
   ix47079z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_3_sva(11));
   ix48076z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_3_sva(10));
   ix43088z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_3_sva(9));
   ix42091z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_3_sva(8));
   ix41094z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_3_sva(7));
   ix40097z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_3_sva(6));
   ix39100z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_3_sva(5));
   ix38103z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_3_sva(4));
   ix37106z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_3_sva(3));
   ix36109z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_3_sva(2));
   ix35112z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_78, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_3_sva(1));
   ix34115z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_3_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_3_sva(0), I1=>mux_tmp_78, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix46195z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_4_sva(16));
   ix45198z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_4_sva(15));
   ix44201z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_4_sva(14));
   ix43204z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_4_sva(13));
   ix42207z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_4_sva(12));
   ix41210z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_4_sva(11));
   ix40213z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_4_sva(10));
   ix44643z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_4_sva(9));
   ix45640z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_4_sva(8));
   ix46637z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_4_sva(7));
   ix47634z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_4_sva(6));
   ix48631z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_4_sva(5));
   ix49628z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_4_sva(4));
   ix50625z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_4_sva(3));
   ix51622z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_4_sva(2));
   ix52619z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_79, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_4_sva(1));
   ix53616z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_4_sva(0), I1=>mux_tmp_79, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix62124z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_5_sva(16));
   ix63121z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_5_sva(15));
   ix64118z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_5_sva(14));
   ix65115z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_5_sva(13));
   ix576z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_5_sva(12));
   ix1573z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_5_sva(11));
   ix2570z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_5_sva(10));
   ix1302z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_5_sva(9));
   ix2299z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_5_sva(8));
   ix3296z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_5_sva(7));
   ix4293z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_5_sva(6));
   ix5290z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_5_sva(5));
   ix6287z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_5_sva(4));
   ix7284z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_5_sva(3));
   ix8281z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_5_sva(2));
   ix9278z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_80, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_5_sva(1));
   ix10275z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_5_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_5_sva(0), I1=>mux_tmp_80, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix26165z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_6_sva(16));
   ix25168z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_6_sva(15));
   ix24171z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_6_sva(14));
   ix23174z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_6_sva(13));
   ix22177z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_6_sva(12));
   ix21180z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_6_sva(11));
   ix20183z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_6_sva(10));
   ix42039z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_6_sva(9));
   ix41042z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_6_sva(8));
   ix40045z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_6_sva(7));
   ix39048z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_6_sva(6));
   ix38051z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_6_sva(5));
   ix37054z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_6_sva(4));
   ix36057z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_6_sva(3));
   ix35060z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_6_sva(2));
   ix34063z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_81, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_6_sva(1));
   ix33066z46498 : LUT4
      generic map (INIT => X"B080") 
       port map ( O=>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_0, I0=>
      histogram_6_sva(0), I1=>mux_tmp_81, I2=>NOT_and_dcpl_264, I3=>
      if_if_if_acc_ctmp_sva(0));
   ix16618z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_16, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(16), I3=>
      histogram_7_sva(16));
   ix17615z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_15, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(15), I3=>
      histogram_7_sva(15));
   ix18612z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_14, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(14), I3=>
      histogram_7_sva(14));
   ix19609z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_13, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(13), I3=>
      histogram_7_sva(13));
   ix20606z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_12, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(12), I3=>
      histogram_7_sva(12));
   ix21603z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_11, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(11), I3=>
      histogram_7_sva(11));
   ix22600z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_10, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(10), I3=>
      histogram_7_sva(10));
   ix45692z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_9, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(9), I3=>
      histogram_7_sva(9));
   ix46689z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_8, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(8), I3=>
      histogram_7_sva(8));
   ix47686z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_7, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(7), I3=>
      histogram_7_sva(7));
   ix48683z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_6, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(6), I3=>
      histogram_7_sva(6));
   ix49680z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_5, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(5), I3=>
      histogram_7_sva(5));
   ix50677z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_4, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(4), I3=>
      histogram_7_sva(4));
   ix51674z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_3, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(3), I3=>
      histogram_7_sva(3));
   ix52671z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_2, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(2), I3=>
      histogram_7_sva(2));
   ix53668z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_1, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(1), I3=>
      histogram_7_sva(1));
   ix54665z44354 : LUT4
      generic map (INIT => X"A820") 
       port map ( O=>NOT_histogram_7_sva_dfm_3_mx0_0n0s2_0, I0=>
      NOT_and_dcpl_264, I1=>mux_tmp_82, I2=>if_if_if_acc_ctmp_sva(0), I3=>
      histogram_7_sva(0));
   ix23862z1324 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>buffer_or_1_cse_0n0s2, I0=>system_input_c_sva(4), I1=>
      system_input_c_sva(3), I2=>nx23862z9, I3=>nx23862z10);
   ix14656z1316 : LUT4
      generic map (INIT => X"0001") 
       port map ( O=>NOT_if_if_equal_cse_sva_3_0n0s2, I0=>frame_sva(2), I1=>
      frame_sva(1), I2=>frame_sva(3), I3=>frame_sva(0));
   ix9333z1188 : LUT4
      generic map (INIT => X"FF7F") 
       port map ( O=>write_histogram_sva_dfm_7_mx0_0n0s14, I0=>
      system_input_r_filter_sva(3), I1=>system_input_r_filter_sva(2), I2=>
      system_input_r_filter_sva(0), I3=>nx9333z4);
   ix29629z1326 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_write_histogram_sva_dfm_7_mx0_0n0s19, I0=>
      system_input_c_filter_sva(4), I1=>system_input_c_filter_sva(3));
   ix9333z1062 : LUT4
      generic map (INIT => X"FEFF") 
       port map ( O=>if_if_if_1_mux_10_nl_0n0s4, I0=>frame_sva(3), I1=>
      frame_sva(2), I2=>frame_sva(1), I3=>frame_sva(0));
   ix12608z1323 : LUT3
      generic map (INIT => X"02") 
       port map ( O=>nor_tmp_1_0n0s2, I0=>frame_sva(0), I1=>frame_sva(2), I2
      =>frame_sva(1));
   ix20395z1323 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>or_dcpl_19_0n0s2, I0=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, I1=>main_stage_0_3);
   ix23862z1339 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_or_dcpl_99_0n0s2, I0=>system_input_c_filter_sva(5), 
      I1=>system_input_c_filter_sva(4));
   ix20395z1324 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_mcu_data_rsc_singleport_re_0n0s9, I0=>
      write_histogram_sva_dfm_1_st_6(1), I1=>
      write_histogram_sva_dfm_1_st_6(0));
   ix6197z1316 : LUT1
      generic map (INIT => X"1") 
       port map ( O=>nx6197z2, I0=>buffer_sel_1_sva);
   ix11611z42963 : LUT4
      generic map (INIT => X"A2B1") 
       port map ( O=>frame_sva_6n1s2(3), I0=>frame_sva(3), I1=>
      NOT_and_dcpl_240, I2=>NOT_if_if_and_9_tmp, I3=>nx11611z1);
   ix12608z42963 : LUT4
      generic map (INIT => X"A2B1") 
       port map ( O=>frame_sva_6n1s2(2), I0=>frame_sva(2), I1=>
      NOT_and_dcpl_240, I2=>NOT_if_if_and_9_tmp, I3=>nx12608z4);
   ix14602z1455 : LUT3
      generic map (INIT => X"8D") 
       port map ( O=>frame_sva_6n1s2(0), I0=>frame_sva(0), I1=>
      NOT_if_if_and_9_tmp, I2=>NOT_and_dcpl_240);
   ix12083z22014 : LUT4
      generic map (INIT => X"50DC") 
       port map ( O=>write_histogram_sva_sg2_6n1s1, I0=>NOT_equal_tmp_19, I1
      =>NOT_if_and_1_ssc, I2=>nx23862z4, I3=>nx12083z2);
   ix30626z38181 : LUT4
      generic map (INIT => X"8FFF") 
       port map ( O=>NOT_write_histogram_sva_13_6n1s20, I0=>nx12084z1, I1=>
      nx14656z1, I2=>write_histogram_sva_dfm_7_mx0_0, I3=>nx23862z4);
   ix29629z1173 : LUT4
      generic map (INIT => X"FF73") 
       port map ( O=>write_histogram_sva_13_6n1s1(1), I0=>NOT_equal_tmp_17, 
      I1=>NOT_if_and_1_ssc, I2=>nx23862z4, I3=>nx29629z4);
   ix30626z64030 : LUT4
      generic map (INIT => X"F4FC") 
       port map ( O=>write_histogram_sva_13_6n1s1(0), I0=>NOT_equal_tmp_16, 
      I1=>nx23862z4, I2=>nx30626z1, I3=>nx30626z2);
   ix12084z57714 : LUT4
      generic map (INIT => X"DC50") 
       port map ( O=>write_histogram_sva_sg1_6n1s1, I0=>NOT_equal_tmp_15, I1
      =>NOT_if_and_1_ssc, I2=>nx23862z4, I3=>nx12084z2);
   ix23862z1322 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_system_input_r_filter_sva_6n1s19, I0=>
      system_input_c_filter_sva(2), I1=>system_input_c_filter_sva(1));
   ix19635z24961 : LUT4
      generic map (INIT => X"5C5F") 
       port map ( O=>not_exit_BUU_sva_6n1s2, I0=>
      in_data_vld_rsc_mgc_in_wire_d, I1=>BUU_i_1_lpi_1(1), I2=>exit_BUU_sva, 
      I3=>io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1);
   ix19422z1548 : LUT3
      generic map (INIT => X"EA") 
       port map ( O=>BUU_if_acc_itm_1_6n1s1(3), I0=>system_input_c_sva(8), 
      I1=>system_input_c_sva(7), I2=>system_input_c_sva(6));
   ix20419z1463 : LUT3
      generic map (INIT => X"95") 
       port map ( O=>BUU_if_acc_itm_1_6n1s1(2), I0=>system_input_c_sva(8), 
      I1=>system_input_c_sva(7), I2=>system_input_c_sva(6));
   ix21416z1320 : LUT2
      generic map (INIT => X"6") 
       port map ( O=>BUU_if_acc_itm_1_6n1s1(1), I0=>system_input_c_sva(7), 
      I1=>system_input_c_sva(6));
   ix34409z1546 : LUT3
      generic map (INIT => X"E8") 
       port map ( O=>nx34409z1, I0=>window_4_lpi_1_dfm_12(2), I1=>nx34409z2, 
      I2=>nx34409z3);
   ix4197z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2407(1), I0=>window_1_lpi_1_dfm_6(1), I1=>
      window_5_lpi_1_dfm_2_mx0_1, I2=>nx4197z2, I3=>nx4197z7);
   ix3200z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2407(0), I0=>window_1_lpi_1_dfm_6(0), I1=>
      window_5_lpi_1_dfm_2_mx0_0, I2=>nx4197z2, I3=>nx4197z7);
   ix48775z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>rtlc6_copy_n2414(2), I0=>window_3_lpi_1_dfm_6(2), I1=>
      window_7_lpi_1_dfm_2_mx0(2), I2=>window_6_lpi_1_dfm_2_mx0(2), I3=>
      window_4_lpi_1_dfm_1_mx0(2));
   ix47778z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2414(1), I0=>window_3_lpi_1_dfm_6(1), I1=>
      window_7_lpi_1_dfm_3_mx0_1, I2=>nx47778z2, I3=>nx47778z4);
   ix46781z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2414(0), I0=>window_3_lpi_1_dfm_6(0), I1=>
      window_7_lpi_1_dfm_3_mx0_0, I2=>nx47778z2, I3=>nx47778z4);
   ix33366z61452 : LUT4
      generic map (INIT => X"EAEA") 
       port map ( O=>rtlc6_copy_n2421(2), I0=>window_0_lpi_1_dfm_4_mx0(2), 
      I1=>window_5_lpi_1_dfm_1_mx0(2), I2=>window_4_lpi_1_dfm_2_mx0(2), I3=>
      nx33366z2);
   ix34363z45006 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>rtlc6_copy_n2421(1), I0=>window_4_lpi_1_dfm_3_mx0_1, I1
      =>window_0_lpi_1_dfm_4_mx0(1), I2=>nx34363z19, I3=>nx34363z21);
   ix35360z45006 : LUT4
      generic map (INIT => X"AAAC") 
       port map ( O=>rtlc6_copy_n2421(0), I0=>window_4_lpi_1_dfm_3_mx0_0, I1
      =>window_0_lpi_1_dfm_4_mx0(0), I2=>nx34363z19, I3=>nx34363z21);
   ix22775z61452 : LUT4
      generic map (INIT => X"EAEA") 
       port map ( O=>rtlc6_copy_n2428(2), I0=>window_2_lpi_1_dfm_7(2), I1=>
      window_7_lpi_1_dfm_2_mx0(2), I2=>window_6_lpi_1_dfm_3_mx0(2), I3=>
      nx22775z2);
   ix21778z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2428(1), I0=>window_2_lpi_1_dfm_7(1), I1=>
      window_6_lpi_1_dfm_4_mx0_1, I2=>nx21778z4, I3=>nx21778z9);
   ix20781z53740 : LUT4
      generic map (INIT => X"CCCA") 
       port map ( O=>rtlc6_copy_n2428(0), I0=>window_2_lpi_1_dfm_7(0), I1=>
      window_6_lpi_1_dfm_4_mx0_0, I2=>nx21778z4, I3=>nx21778z9);
   ix23862z45012 : LUT4
      generic map (INIT => X"AAAB") 
       port map ( O=>nx23862z5, I0=>system_input_output_vld_sva, I1=>
      nx23862z6, I2=>nx23862z7, I3=>nx23862z8);
   ix5708z1516 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>rtlc6_copy_n2543(1), I0=>window_2_lpi_1_dfm_2_mx0(1), 
      I1=>window_3_lpi_1_dfm_1_mx0_1, I2=>nx31708z2);
   ix6705z1516 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>rtlc6_copy_n2543(0), I0=>window_2_lpi_1_dfm_2_mx0(0), 
      I1=>window_3_lpi_1_dfm_1_mx0_0, I2=>nx31708z2);
   ix31708z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2550(1), I0=>window_2_lpi_1_dfm_2_mx0(1), 
      I1=>window_3_lpi_1_dfm_1_mx0_1, I2=>nx31708z2);
   ix32705z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2550(0), I0=>window_2_lpi_1_dfm_2_mx0(0), 
      I1=>window_3_lpi_1_dfm_1_mx0_0, I2=>nx31708z2);
   ix24666z1516 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>rtlc6_copy_n2557(1), I0=>window_0_lpi_1_dfm_2_mx0(1), 
      I1=>window_1_lpi_1_dfm_1_mx0_1, I2=>nx9753z12);
   ix23669z1516 : LUT3
      generic map (INIT => X"CA") 
       port map ( O=>rtlc6_copy_n2557(0), I0=>window_0_lpi_1_dfm_2_mx0(0), 
      I1=>window_1_lpi_1_dfm_1_mx0_0, I2=>nx9753z12);
   ix51923z45516 : LUT4
      generic map (INIT => X"ACAA") 
       port map ( O=>rtlc6_copy_n2564(2), I0=>
      system_input_window_7_sva_mx0(2), I1=>system_input_window_8_sva_mx0(2), 
      I2=>NOT_or_181_cse, I3=>nx51923z2);
   ix52920z45516 : LUT4
      generic map (INIT => X"ACAA") 
       port map ( O=>rtlc6_copy_n2564(1), I0=>
      system_input_window_7_sva_mx0(1), I1=>system_input_window_8_sva_mx0(1), 
      I2=>NOT_or_181_cse, I3=>nx51923z2);
   ix53917z45516 : LUT4
      generic map (INIT => X"ACAA") 
       port map ( O=>rtlc6_copy_n2564(0), I0=>
      system_input_window_7_sva_mx0(0), I1=>system_input_window_8_sva_mx0(0), 
      I2=>NOT_or_181_cse, I3=>nx51923z2);
   ix9753z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2571(1), I0=>window_0_lpi_1_dfm_2_mx0(1), 
      I1=>window_1_lpi_1_dfm_1_mx0_1, I2=>nx9753z12);
   ix10750z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2571(0), I0=>window_0_lpi_1_dfm_2_mx0(0), 
      I1=>window_1_lpi_1_dfm_1_mx0_0, I2=>nx9753z12);
   ix24947z1488 : LUT3
      generic map (INIT => X"AE") 
       port map ( O=>rtlc6_copy_n2578(2), I0=>
      system_input_window_7_sva_mx0(2), I1=>system_input_window_8_sva_mx0(2), 
      I2=>nx51923z2);
   ix25944z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2578(1), I0=>
      system_input_window_7_sva_mx0(1), I1=>system_input_window_8_sva_mx0(1), 
      I2=>nx51923z2);
   ix26941z1486 : LUT3
      generic map (INIT => X"AC") 
       port map ( O=>rtlc6_copy_n2578(0), I0=>
      system_input_window_7_sva_mx0(0), I1=>system_input_window_8_sva_mx0(0), 
      I2=>nx51923z2);
   ix37359z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx37359z1, I0=>system_input_r_filter_sva(1), I1=>
      system_input_r_filter_sva(0), I2=>nx37359z2, I3=>nx37359z3);
   ix51923z1572 : LUT3
      generic map (INIT => X"FE") 
       port map ( O=>nx51923z2, I0=>NOT_or_181_cse, I1=>nx51923z3, I2=>
      nx51923z5);
   ix34363z1500 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx34363z3, I0=>window_8_lpi_1_dfm_mx0(2), I1=>
      clip_window_qr_2_lpi_1_dfm_mx0(2), I2=>nx34363z4);
   ix34363z1521 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx34363z8, I0=>window_8_lpi_1_dfm_1_mx0(2), I1=>
      window_6_lpi_1_dfm_mx0(2), I2=>nx34363z2);
   ix34363z1629 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34363z14, I0=>window_4_lpi_1_dfm_10(2), I1=>
      window_8_lpi_1_dfm_2_mx0(2), I2=>nx34363z13);
   ix34363z1522 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx34363z9, I0=>window_7_lpi_1_dfm_mx0(2), I1=>
      window_6_lpi_1_dfm_1_mx0(2), I2=>nx34363z10);
   ix34363z1599 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx34363z15, I0=>window_6_lpi_1_dfm_2_mx0(2), I1=>
      window_4_lpi_1_dfm_1_mx0(2), I2=>nx34363z16);
   ix9753z1500 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx9753z4, I0=>clip_window_qr_lpi_1_dfm_mx0(2), I1=>
      window_0_lpi_1_dfm_mx0(2), I2=>nx9753z5);
   ix9753z1508 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx9753z6, I0=>window_2_lpi_1_dfm_mx0(2), I1=>
      clip_window_qr_3_lpi_1_dfm_mx0(2), I2=>nx9753z7);
   ix9753z1513 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx9753z8, I0=>window_0_lpi_1_dfm_1_mx0(2), I1=>
      window_2_lpi_1_dfm_1_mx0(2), I2=>nx9753z9);
   ix9753z1523 : LUT3
      generic map (INIT => X"B2") 
       port map ( O=>nx9753z10, I0=>window_1_lpi_1_dfm_mx0(2), I1=>
      window_3_lpi_1_dfm_mx0(2), I2=>nx9753z11);
   ix9753z45128 : LUT4
      generic map (INIT => X"AB02") 
       port map ( O=>nx9753z12, I0=>window_0_lpi_1_dfm_2_mx0(2), I1=>
      window_1_lpi_1_dfm_mx0(2), I2=>window_3_lpi_1_dfm_mx0(2), I3=>
      nx9753z13);
   ix34363z145 : LUT4
      generic map (INIT => X"FB32") 
       port map ( O=>nx34363z17, I0=>window_4_lpi_1_dfm_10(2), I1=>
      window_0_lpi_1_dfm_8(2), I2=>window_8_lpi_1_dfm_2_mx0(2), I3=>
      nx34363z18);
   ix31708z50255 : LUT4
      generic map (INIT => X"BF2A") 
       port map ( O=>nx31708z2, I0=>window_2_lpi_1_dfm_2_mx0(2), I1=>
      window_1_lpi_1_dfm_mx0(2), I2=>window_3_lpi_1_dfm_mx0(2), I3=>
      nx31708z3);
   ix34850z1541 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34850z6, I0=>window_4_lpi_1_dfm_11(2), I1=>
      window_6_lpi_1_dfm_9(2), I2=>nx34850z3);
   ix34850z1544 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34850z7, I0=>window_5_lpi_1_dfm_9(2), I1=>
      window_7_lpi_1_dfm_8(2), I2=>nx34850z4);
   ix34850z1534 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34850z2, I0=>window_4_lpi_1_dfm_5_mx0(2), I1=>
      window_5_lpi_1_dfm_4_mx0(2), I2=>nx34850z5);
   ix22413z1315 : LUT1
      generic map (INIT => X"1") 
       port map ( O=>NOT_system_input_c_sva_6, I0=>system_input_c_sva(6));
   ix34903z45006 : LUT4
      generic map (INIT => X"AAAB") 
       port map ( O=>sclear_dup_435, I0=>rst, I1=>and_330_tmp_0n0s11, I2=>
      nx34903z2, I3=>nx34903z3);
   ix23862z1487 : LUT3
      generic map (INIT => X"AB") 
       port map ( O=>ce_dup_527, I0=>rst, I1=>nx23862z2, I2=>nx23862z3);
   ix51271z1485 : LUT3
      generic map (INIT => X"AB") 
       port map ( O=>nx51271z1, I0=>rst, I1=>nx51271z2, I2=>nx51271z3);
   ix23862z53743 : LUT4
      generic map (INIT => X"CCCD") 
       port map ( O=>nx23862z1, I0=>NOT_system_input_r_filter_sva_6n1s19, I1
      =>ce_dup_527, I2=>nx23862z2, I3=>nx23862z11);
   ix12608z1329 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>nx12608z4, I0=>frame_sva(1), I1=>frame_sva(0));
   ix11611z1442 : LUT3
      generic map (INIT => X"7F") 
       port map ( O=>nx11611z1, I0=>frame_sva(2), I1=>frame_sva(1), I2=>
      frame_sva(0));
   ix23862z1337 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>NOT_or_dcpl_81_0n0s2, I0=>system_input_c_filter_sva(1), 
      I1=>system_input_c_filter_sva(0));
   ix34903z1330 : LUT2
      generic map (INIT => X"E") 
       port map ( O=>and_330_tmp_0n0s11, I0=>system_input_c_sva(7), I1=>
      system_input_c_sva(6));
   ix9753z1334 : LUT2
      generic map (INIT => X"E") 
       port map ( O=>or_dcpl_85, I0=>system_input_c_filter_sva(7), I1=>
      system_input_c_filter_sva(6));
   ix19066z1322 : LUT2
      generic map (INIT => X"8") 
       port map ( O=>nx19066z1, I0=>nx23862z4, I1=>nx35275z1);
   ix11286z1316 : LUT2
      generic map (INIT => X"2") 
       port map ( O=>nx11286z1, I0=>BUU_i_1_lpi_1(1), I1=>exit_BUU_sva);
   ix41743z1330 : LUT3
      generic map (INIT => X"10") 
       port map ( O=>nx41743z1, I0=>BUU_i_1_lpi_1(1), I1=>exit_BUU_sva, I2=>
      BUU_i_1_lpi_1(0));
   ix36152z1555 : LUT3
      generic map (INIT => X"F1") 
       port map ( O=>nx36152z1, I0=>BUU_i_1_lpi_1(1), I1=>BUU_i_1_lpi_1(0), 
      I2=>exit_BUU_sva);
   ix23862z1448 : LUT4
      generic map (INIT => X"0080") 
       port map ( O=>nx23862z4, I0=>nx23862z5, I1=>mux_154_cse, I2=>
      BUU_i_1_lpi_1(1), I3=>exit_BUU_sva);
   ix12083z53740 : LUT4
      generic map (INIT => X"CCC8") 
       port map ( O=>nx12083z1, I0=>or_dcpl_86, I1=>
      write_histogram_sva_13(1), I2=>nx29629z1, I3=>nx29629z2);
   ix19956z1318 : LUT3
      generic map (INIT => X"04") 
       port map ( O=>nx19956z1, I0=>buffer_sel_1_sva_dfm_1_mx0, I1=>
      BUU_i_1_lpi_1(1), I2=>exit_BUU_sva);
   ix15189z1322 : LUT3
      generic map (INIT => X"08") 
       port map ( O=>nx15189z1, I0=>buffer_sel_1_sva_dfm_1_mx0, I1=>
      BUU_i_1_lpi_1(1), I2=>exit_BUU_sva);
   ix12608z5415 : LUT4
      generic map (INIT => X"1000") 
       port map ( O=>nx12608z2, I0=>nx23862z2, I1=>nx12608z3, I2=>
      system_input_c_filter_sva(5), I3=>system_input_c_filter_sva(0));
   ix42061z1322 : LUT2
      generic map (INIT => X"8") 
       port map ( O=>nx42061z1, I0=>in_data_vld_rsc_mgc_in_wire_d, I1=>
      exit_BUU_sva);
   ix26289z34082 : LUT4
      generic map (INIT => X"8000") 
       port map ( O=>nx26289z1, I0=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_3, I1=>exit_BUU_sva_1_st_3, 
      I2=>system_input_output_vld_sva_dfm_st_3, I3=>main_stage_0_4);
   ix18930z1327 : LUT2
      generic map (INIT => X"D") 
       port map ( O=>nx18930z1, I0=>BUU_i_1_lpi_1(0), I1=>exit_BUU_sva);
   ix9333z36271 : LUT4
      generic map (INIT => X"888C") 
       port map ( O=>nx9333z2, I0=>get_thresh_sva, I1=>NOT_equal_tmp_23, I2
      =>nx9333z3, I3=>nx9333z5);
   ix44817z1322 : LUT2
      generic map (INIT => X"8") 
       port map ( O=>nx44817z1, I0=>and_35_itm_2, I1=>main_stage_0_3);
   ix37375z1378 : LUT3
      generic map (INIT => X"40") 
       port map ( O=>nx37375z1, I0=>NOT_if_if_equal_cse_sva_3_0n0s2, I1=>
      NOT_or_181_cse, I2=>nx12608z2);
   ix11174z1442 : LUT3
      generic map (INIT => X"80") 
       port map ( O=>nx11174z1, I0=>exit_BUU_sva_4, I1=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, I2=>main_stage_0_2);
   ix17287z1442 : LUT3
      generic map (INIT => X"80") 
       port map ( O=>nx17287z1, I0=>BUU_nor_1_itm_2, I1=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, I2=>main_stage_0_3);
   ix26054z1442 : LUT3
      generic map (INIT => X"80") 
       port map ( O=>nx26054z1, I0=>equal_tmp_13, I1=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_st_2, I2=>main_stage_0_3);
   ix34903z1327 : LUT2
      generic map (INIT => X"8") 
       port map ( O=>nx34903z4, I0=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, I1=>main_stage_0_2);
   ix54636z1442 : LUT3
      generic map (INIT => X"80") 
       port map ( O=>nx54636z1, I0=>asn_309_itm_1, I1=>
      io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1, I2=>main_stage_0_2);
   ix30850z1322 : LUT2
      generic map (INIT => X"8") 
       port map ( O=>nx30850z1, I0=>and_37_itm_3, I1=>main_stage_0_4);
   ix6197z1346 : LUT4
      generic map (INIT => X"0020") 
       port map ( O=>nx6197z1, I0=>mux_tmp_1, I1=>system_input_c_sva(0), I2
      =>exit_BUU_sva, I3=>buffer_or_1_cse_0n0s2);
   ix34409z1354 : LUT3
      generic map (INIT => X"27") 
       port map ( O=>nx34409z2, I0=>if_if_switch_lp_and_21_itm_3, I1=>
      mcu_data_rsc_singleport_data_out(2), I2=>threshold_sva(2));
   ix51923z1336 : LUT2
      generic map (INIT => X"B") 
       port map ( O=>nx51923z4, I0=>system_input_window_7_sva_mx0(2), I1=>
      system_input_window_8_sva_mx0(2));
   ix23862z1570 : LUT3
      generic map (INIT => X"FD") 
       port map ( O=>nx23862z2, I0=>system_input_c_filter_sva(8), I1=>
      system_input_c_filter_sva(7), I2=>system_input_c_filter_sva(6));
   ix21705z1601 : LUT4
      generic map (INIT => X"011D") 
       port map ( O=>nx21705z2, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix21705z1389 : LUT3
      generic map (INIT => X"48") 
       port map ( O=>nx21705z3, I0=>write_histogram_sva_dfm_1_st_6(0), I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1));
   ix23862z1333 : LUT2
      generic map (INIT => X"B") 
       port map ( O=>nx23862z6, I0=>system_input_r_sva(4), I1=>
      system_input_r_sva(0));
   ix34850z1536 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34850z3, I0=>window_4_lpi_1_dfm_11(1), I1=>
      window_6_lpi_1_dfm_9(1), I2=>window_6_lpi_1_dfm_9(0));
   ix34850z1538 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34850z4, I0=>window_5_lpi_1_dfm_9(1), I1=>
      window_7_lpi_1_dfm_8(1), I2=>window_7_lpi_1_dfm_8(0));
   ix34850z1440 : LUT3
      generic map (INIT => X"71") 
       port map ( O=>nx34850z5, I0=>window_4_lpi_1_dfm_5_mx0(1), I1=>
      window_4_lpi_1_dfm_5_mx0(0), I2=>window_5_lpi_1_dfm_4_mx0(1));
   ix34903z34084 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>nx34903z2, I0=>system_input_c_sva(8), I1=>
      system_input_c_sva(5), I2=>system_input_c_sva(4), I3=>
      system_input_c_sva(3));
   ix34903z34085 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>nx34903z3, I0=>system_input_c_sva(2), I1=>
      system_input_c_sva(1), I2=>system_input_c_sva(0), I3=>NOT_or_43_cse);
   ix51271z34082 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>nx51271z2, I0=>system_input_r_sva(7), I1=>
      system_input_r_sva(6), I2=>system_input_r_sva(5), I3=>
      system_input_r_sva(3));
   ix51271z1187 : LUT4
      generic map (INIT => X"FF7F") 
       port map ( O=>nx51271z3, I0=>system_input_r_sva(2), I1=>
      system_input_r_sva(1), I2=>sclear_dup_435, I3=>nx23862z6);
   ix23862z1253 : LUT4
      generic map (INIT => X"FFBF") 
       port map ( O=>nx23862z3, I0=>or_dcpl_118, I1=>NOT_or_181_cse, I2=>
      nx23862z4, I3=>NOT_or_dcpl_81_0n0s2);
   ix23862z64818 : LUT4
      generic map (INIT => X"F7FF") 
       port map ( O=>nx23862z11, I0=>system_input_c_filter_sva(3), I1=>
      system_input_c_filter_sva(0), I2=>NOT_or_dcpl_99_0n0s2, I3=>nx23862z4
   );
   ix23862z1320 : LUT4
      generic map (INIT => X"FFFD") 
       port map ( O=>nx23862z7, I0=>system_input_c_sva(0), I1=>
      system_input_r_sva(7), I2=>system_input_r_sva(6), I3=>
      system_input_r_sva(5));
   ix23862z1335 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx23862z8, I0=>system_input_r_sva(3), I1=>
      system_input_r_sva(2), I2=>system_input_r_sva(1), I3=>
      buffer_or_1_cse_0n0s2);
   ix29629z34084 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>nx29629z1, I0=>system_input_c_filter_sva(5), I1=>
      system_input_c_filter_sva(2), I2=>system_input_r_filter_sva(5), I3=>
      NOT_if_if_equal_cse_sva_3_0n0s2);
   ix29629z1316 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx29629z2, I0=>write_histogram_sva_dfm_7_mx0_0n0s14, I1
      =>NOT_write_histogram_sva_dfm_7_mx0_0n0s19, I2=>NOT_or_dcpl_81_0n0s2, 
      I3=>nx23862z2);
   ix9333z1314 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx9333z3, I0=>or_dcpl_118, I1=>
      system_input_r_filter_sva(4), I2=>write_histogram_sva_dfm_7_mx0_0n0s14, 
      I3=>if_if_if_1_mux_10_nl_0n0s4);
   ix9333z1311 : LUT4
      generic map (INIT => X"FFF7") 
       port map ( O=>nx9333z5, I0=>system_input_r_filter_sva(6), I1=>
      system_input_r_filter_sva(5), I2=>NOT_or_dcpl_81_0n0s2, I3=>nx23862z2
   );
   ix37359z1313 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx37359z2, I0=>system_input_r_filter_sva(7), I1=>
      system_input_r_filter_sva(6), I2=>system_input_r_filter_sva(5), I3=>
      system_input_r_filter_sva(4));
   ix11174z61412 : LUT4
      generic map (INIT => X"EAC0") 
       port map ( O=>nx11174z2, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(2), I3=>buffer_t0_sva_mx0(2));
   ix12171z61411 : LUT4
      generic map (INIT => X"EAC0") 
       port map ( O=>nx12171z1, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(1), I3=>buffer_t0_sva_mx0(1));
   ix13168z61411 : LUT4
      generic map (INIT => X"EAC0") 
       port map ( O=>nx13168z1, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(0), I3=>buffer_t0_sva_mx0(0));
   ix9753z1316 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx9753z2, I0=>system_input_c_filter_sva(8), I1=>
      system_input_c_filter_sva(5), I2=>system_input_c_filter_sva(4), I3=>
      system_input_c_filter_sva(3));
   ix9753z1317 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx9753z3, I0=>system_input_c_filter_sva(2), I1=>
      system_input_c_filter_sva(1), I2=>system_input_c_filter_sva(0), I3=>
      or_dcpl_85);
   ix9753z1368 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx9753z5, I0=>clip_window_qr_lpi_1_dfm_mx0(1), I1=>
      window_0_lpi_1_dfm_mx0(1), I2=>window_0_lpi_1_dfm_mx0(0));
   ix34363z61911 : LUT4
      generic map (INIT => X"ECA0") 
       port map ( O=>nx34363z7, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(2), I3=>buffer_t0_sva_mx0(2));
   ix34363z61905 : LUT4
      generic map (INIT => X"ECA0") 
       port map ( O=>nx34363z5, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(1), I3=>buffer_t0_sva_mx0(1));
   ix34363z61908 : LUT4
      generic map (INIT => X"ECA0") 
       port map ( O=>nx34363z6, I0=>BUU_and_4_itm_1, I1=>BUU_and_5_itm_1, I2
      =>buffer_t1_sva_mx0(0), I3=>buffer_t0_sva_mx0(0));
   ix9753z1376 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx9753z7, I0=>window_2_lpi_1_dfm_mx0(1), I1=>
      clip_window_qr_3_lpi_1_dfm_mx0(1), I2=>
      clip_window_qr_3_lpi_1_dfm_mx0(0));
   ix9753z1381 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx9753z9, I0=>window_0_lpi_1_dfm_1_mx0(1), I1=>
      window_2_lpi_1_dfm_1_mx0(1), I2=>window_2_lpi_1_dfm_1_mx0(0));
   ix9753z1391 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx9753z11, I0=>window_1_lpi_1_dfm_mx0(1), I1=>
      window_3_lpi_1_dfm_mx0(1), I2=>window_3_lpi_1_dfm_mx0(0));
   ix9753z1395 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx9753z13, I0=>window_0_lpi_1_dfm_2_mx0(1), I1=>
      window_1_lpi_1_dfm_1_mx0_1, I2=>window_1_lpi_1_dfm_1_mx0_0);
   ix31708z1362 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx31708z3, I0=>window_2_lpi_1_dfm_2_mx0(1), I1=>
      window_3_lpi_1_dfm_1_mx0_1, I2=>window_3_lpi_1_dfm_1_mx0_0);
   ix29629z47401 : LUT4
      generic map (INIT => X"B3FF") 
       port map ( O=>nx29629z4, I0=>write_histogram_sva_13(1), I1=>
      NOT_if_and_9_ssc, I2=>NOT_write_histogram_sva_13_6n1s20, I3=>
      NOT_write_histogram_sva_13_6n1s6_0);
   ix30626z47395 : LUT4
      generic map (INIT => X"B3FF") 
       port map ( O=>nx30626z1, I0=>write_histogram_sva_13(0), I1=>
      NOT_if_and_8_ssc, I2=>NOT_write_histogram_sva_13_6n1s20, I3=>
      NOT_write_histogram_sva_13_6n1s6_0);
   ix34363z1368 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx34363z4, I0=>window_8_lpi_1_dfm_mx0(1), I1=>
      clip_window_qr_2_lpi_1_dfm_mx0(1), I2=>
      clip_window_qr_2_lpi_1_dfm_mx0(0));
   ix34363z1361 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx34363z2, I0=>window_8_lpi_1_dfm_1_mx0(1), I1=>
      window_6_lpi_1_dfm_mx0(1), I2=>window_6_lpi_1_dfm_mx0(0));
   ix34363z1388 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx34363z10, I0=>window_7_lpi_1_dfm_mx0(1), I1=>
      window_6_lpi_1_dfm_1_mx0(1), I2=>window_6_lpi_1_dfm_1_mx0(0));
   ix34363z1562 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34363z12, I0=>window_5_lpi_1_dfm_8(1), I1=>
      window_7_lpi_1_dfm_1_mx0(1), I2=>window_7_lpi_1_dfm_1_mx0(0));
   ix34363z1568 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34363z13, I0=>window_4_lpi_1_dfm_10(1), I1=>
      window_8_lpi_1_dfm_2_mx0(1), I2=>window_8_lpi_1_dfm_2_mx0(0));
   ix34363z1412 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx34363z16, I0=>window_6_lpi_1_dfm_2_mx0(1), I1=>
      window_4_lpi_1_dfm_1_mx0(1), I2=>window_4_lpi_1_dfm_1_mx0(0));
   ix22775z1358 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx22775z2, I0=>window_7_lpi_1_dfm_2_mx0(1), I1=>
      window_6_lpi_1_dfm_3_mx0(1), I2=>window_6_lpi_1_dfm_3_mx0(0));
   ix33366z1358 : LUT3
      generic map (INIT => X"2B") 
       port map ( O=>nx33366z2, I0=>window_5_lpi_1_dfm_1_mx0(1), I1=>
      window_4_lpi_1_dfm_2_mx0(1), I2=>window_4_lpi_1_dfm_2_mx0(0));
   ix34363z1588 : LUT3
      generic map (INIT => X"D4") 
       port map ( O=>nx34363z18, I0=>window_0_lpi_1_dfm_8(1), I1=>
      window_8_lpi_1_dfm_3_mx0_1, I2=>window_8_lpi_1_dfm_3_mx0_0);
   ix51803z17185 : LUT4
      generic map (INIT => X"3DFD") 
       port map ( O=>nx51803z2, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix34850z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx34850z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_16, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_16);
   ix34850z31344 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx34850z11, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, 
      I2=>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_16, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_16);
   ix34850z30856 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx34850z8, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_16, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_16);
   ix34850z30859 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx34850z9, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_16, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_16);
   ix33853z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx33853z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_15, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_15);
   ix33853z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx33853z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_15, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_15);
   ix33853z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx33853z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_15, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_15);
   ix33853z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx33853z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_15, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_15);
   ix32856z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx32856z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_14, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_14);
   ix32856z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx32856z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_14, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_14);
   ix32856z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx32856z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_14, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_14);
   ix32856z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx32856z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_14, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_14);
   ix31859z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31859z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_13, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_13);
   ix31859z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx31859z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_13, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_13);
   ix31859z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31859z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_13, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_13);
   ix31859z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31859z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_13, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_13);
   ix30862z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30862z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_12, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_12);
   ix30862z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx30862z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_12, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_12);
   ix30862z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30862z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_12, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_12);
   ix30862z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30862z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_12, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_12);
   ix29865z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29865z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_11, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_11);
   ix29865z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx29865z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_11, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_11);
   ix29865z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29865z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_11, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_11);
   ix29865z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29865z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_11, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_11);
   ix28868z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28868z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_10, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_10);
   ix28868z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx28868z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_10, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_10);
   ix28868z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28868z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_10, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_10);
   ix28868z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28868z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_10, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_10);
   ix31136z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31136z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_9, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_9);
   ix31136z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx31136z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_9, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_9);
   ix31136z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31136z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_9, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_9);
   ix31136z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx31136z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_9, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_9);
   ix30139z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30139z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_8, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_8);
   ix30139z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx30139z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_8, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_8);
   ix30139z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30139z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_8, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_8);
   ix30139z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx30139z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_8, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_8);
   ix29142z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29142z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_7, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_7);
   ix29142z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx29142z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_7, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_7);
   ix29142z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29142z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_7, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_7);
   ix29142z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx29142z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_7, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_7);
   ix28145z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28145z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_6, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_6);
   ix28145z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx28145z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_6, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_6);
   ix28145z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28145z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_6, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_6);
   ix28145z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx28145z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_6, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_6);
   ix27148z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx27148z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_5, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_5);
   ix27148z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx27148z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_5, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_5);
   ix27148z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx27148z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_5, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_5);
   ix27148z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx27148z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_5, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_5);
   ix26151z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx26151z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_4, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_4);
   ix26151z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx26151z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_4, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_4);
   ix26151z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx26151z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_4, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_4);
   ix26151z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx26151z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_4, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_4);
   ix25154z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx25154z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_3, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_3);
   ix25154z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx25154z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_3, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_3);
   ix25154z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx25154z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_3, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_3);
   ix25154z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx25154z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_3, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_3);
   ix24157z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx24157z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_2, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_2);
   ix24157z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx24157z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_2, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_2);
   ix24157z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx24157z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_2, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_2);
   ix24157z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx24157z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_2, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_2);
   ix23160z30835 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx23160z1, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_1, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_1);
   ix23160z31319 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx23160z5, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_1, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_1);
   ix23160z30836 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx23160z2, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_1, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_1);
   ix23160z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx23160z3, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_1, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_1);
   ix22163z1314 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx22163z1, I0=>nx22163z2, I1=>nx22163z3, I2=>nx22163z4, 
      I3=>nx22163z5);
   ix22163z30837 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx22163z2, I0=>NOT_and_208_cse, I1=>NOT_and_211_cse, I2
      =>NOT_histogram_0_sva_dfm_3_mx0_0n0s2_0, I3=>
      NOT_histogram_1_sva_dfm_3_mx0_0n0s2_0);
   ix22163z31318 : LUT4
      generic map (INIT => X"7530") 
       port map ( O=>nx22163z3, I0=>NOT_and_215_cse, I1=>NOT_and_213_ssc, I2
      =>NOT_histogram_2_sva_dfm_3_mx0_0n0s2_0, I3=>
      NOT_histogram_3_sva_dfm_3_mx0_0n0s2_0);
   ix22163z30839 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx22163z4, I0=>NOT_and_217_cse, I1=>NOT_and_219_cse, I2
      =>NOT_histogram_4_sva_dfm_3_mx0_0n0s2_0, I3=>
      NOT_histogram_5_sva_dfm_3_mx0_0n0s2_0);
   ix22163z30840 : LUT4
      generic map (INIT => X"7350") 
       port map ( O=>nx22163z5, I0=>NOT_and_221_cse, I1=>NOT_and_224_cse, I2
      =>NOT_histogram_6_sva_dfm_3_mx0_0n0s2_0, I3=>
      NOT_histogram_7_sva_dfm_3_mx0_0n0s2_0);
   ix20395z1312 : LUT4
      generic map (INIT => X"FFFD") 
       port map ( O=>nx20395z1, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>or_dcpl_19_0n0s2, I3=>
      NOT_mcu_data_rsc_singleport_re_0n0s9);
   ix15410z36268 : LUT4
      generic map (INIT => X"8889") 
       port map ( O=>nx15410z1, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix51803z34467 : LUT4
      generic map (INIT => X"8180") 
       port map ( O=>nx51803z1, I0=>write_histogram_sva_dfm_1_st_2_sg1, I1=>
      write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0), I3=>
      write_histogram_sva_dfm_1_st_2_sg2);
   ix30626z1558 : LUT3
      generic map (INIT => X"EF") 
       port map ( O=>NOT_write_histogram_sva_13_6n1s6_0, I0=>
      NOT_equal_tmp_23, I1=>get_thresh_sva_dfm_2_mx0, I2=>nx23862z4);
   ix30626z804 : LUT4
      generic map (INIT => X"FDFF") 
       port map ( O=>NOT_if_and_8_ssc, I0=>nx12084z1, I1=>nx14656z1, I2=>
      write_histogram_sva_dfm_7_mx0_0, I3=>nx23862z4);
   ix29629z1334 : LUT2
      generic map (INIT => X"B") 
       port map ( O=>NOT_if_and_9_ssc, I0=>NOT_equal_tmp_21, I1=>nx23862z4);
   ix30626z58663 : LUT4
      generic map (INIT => X"DFFF") 
       port map ( O=>NOT_equal_tmp_23, I0=>nx12084z1, I1=>nx14656z1, I2=>
      nx12083z1, I3=>write_histogram_sva_dfm_7_mx0_0);
   ix29629z811 : LUT4
      generic map (INIT => X"FDFF") 
       port map ( O=>NOT_equal_tmp_21, I0=>nx12084z1, I1=>nx14656z1, I2=>
      nx12083z1, I3=>write_histogram_sva_dfm_7_mx0_0);
   ix22163z1282 : LUT4
      generic map (INIT => X"FFDF") 
       port map ( O=>NOT_and_230_cse, I0=>write_histogram_sva_dfm_1_st_2_sg2, 
      I1=>write_histogram_sva_dfm_1_st_2_sg1, I2=>
      write_histogram_sva_dfm_1_st_6(1), I3=>
      write_histogram_sva_dfm_1_st_6(0));
   ix13605z804 : LUT4
      generic map (INIT => X"FDFF") 
       port map ( O=>NOT_equal_tmp_1, I0=>frame_sva(3), I1=>frame_sva(2), I2
      =>frame_sva(1), I3=>frame_sva(0));
   ix34850z1330 : LUT2
      generic map (INIT => X"B") 
       port map ( O=>NOT_and_dcpl_264, I0=>if_if_if_1_else_or_7_itm_2, I1=>
      if_if_and_7_itm_2);
   ix12608z64802 : LUT4
      generic map (INIT => X"F7FF") 
       port map ( O=>NOT_and_dcpl_240, I0=>NOT_or_181_cse, I1=>nx12608z2, I2
      =>nor_tmp_1_0n0s2, I3=>nx23862z4);
   ix25262z1316 : LUT2
      generic map (INIT => X"2") 
       port map ( O=>NOT_BUU_i_1_sva_1_0, I0=>BUU_i_1_lpi_1(0), I1=>
      exit_BUU_sva);
   ix4197z49435 : LUT4
      generic map (INIT => X"BBF3") 
       port map ( O=>nx4197z4, I0=>window_5_lpi_1_dfm_8(2), I1=>
      window_4_lpi_1_dfm_2_mx0(2), I2=>window_7_lpi_1_dfm_1_mx0(2), I3=>
      nx34363z11);
   ix47778z1315 : LUT4
      generic map (INIT => X"FFFD") 
       port map ( O=>nx47778z3, I0=>window_3_lpi_1_dfm_6(2), I1=>
      window_7_lpi_1_dfm_2_mx0(2), I2=>window_6_lpi_1_dfm_2_mx0(2), I3=>
      window_4_lpi_1_dfm_1_mx0(2));
   ix30626z1209 : LUT4
      generic map (INIT => X"FF8F") 
       port map ( O=>nx30626z2, I0=>nx12084z1, I1=>nx14656z1, I2=>nx12083z1, 
      I3=>write_histogram_sva_dfm_7_mx0_0);
   ix51923z12071 : LUT4
      generic map (INIT => X"2A00") 
       port map ( O=>nx51923z3, I0=>system_input_window_7_sva_mx0(1), I1=>
      system_input_window_8_sva_mx0(1), I2=>system_input_window_8_sva_mx0(0), 
      I3=>nx51923z4);
   ix47778z55588 : LUT4
      generic map (INIT => X"D400") 
       port map ( O=>nx47778z2, I0=>window_3_lpi_1_dfm_6(1), I1=>
      window_7_lpi_1_dfm_3_mx0_1, I2=>window_7_lpi_1_dfm_3_mx0_0, I3=>
      nx47778z3);
   ix47778z23163 : LUT4
      generic map (INIT => X"5554") 
       port map ( O=>nx47778z4, I0=>window_3_lpi_1_dfm_6(2), I1=>
      window_7_lpi_1_dfm_2_mx0(2), I2=>window_6_lpi_1_dfm_2_mx0(2), I3=>
      window_4_lpi_1_dfm_1_mx0(2));
   ix4197z55588 : LUT4
      generic map (INIT => X"D400") 
       port map ( O=>nx4197z2, I0=>window_1_lpi_1_dfm_6(1), I1=>
      window_5_lpi_1_dfm_2_mx0_1, I2=>window_5_lpi_1_dfm_2_mx0_0, I3=>
      nx4197z6);
   ix21778z55593 : LUT4
      generic map (INIT => X"D400") 
       port map ( O=>nx21778z4, I0=>window_2_lpi_1_dfm_7(1), I1=>
      window_6_lpi_1_dfm_4_mx0_1, I2=>window_6_lpi_1_dfm_4_mx0_0, I3=>
      nx21778z8);
   ix21778z12334 : LUT4
      generic map (INIT => X"2B00") 
       port map ( O=>nx21778z5, I0=>window_7_lpi_1_dfm_2_mx0(1), I1=>
      window_6_lpi_1_dfm_3_mx0(1), I2=>window_6_lpi_1_dfm_3_mx0(0), I3=>
      nx21778z6);
   ix34363z12386 : LUT4
      generic map (INIT => X"2B00") 
       port map ( O=>nx34363z19, I0=>window_4_lpi_1_dfm_3_mx0_1, I1=>
      window_0_lpi_1_dfm_4_mx0(1), I2=>window_0_lpi_1_dfm_4_mx0(0), I3=>
      nx34363z20);
   ix4197z12327 : LUT4
      generic map (INIT => X"2B00") 
       port map ( O=>nx4197z3, I0=>window_5_lpi_1_dfm_1_mx0(1), I1=>
      window_4_lpi_1_dfm_2_mx0(1), I2=>window_4_lpi_1_dfm_2_mx0(0), I3=>
      nx4197z4);
   ix4197z10073 : LUT4
      generic map (INIT => X"2230") 
       port map ( O=>nx4197z5, I0=>window_5_lpi_1_dfm_8(2), I1=>
      window_4_lpi_1_dfm_2_mx0(2), I2=>window_7_lpi_1_dfm_1_mx0(2), I3=>
      nx34363z11);
   ix12084z1455 : LUT3
      generic map (INIT => X"8A") 
       port map ( O=>nx12084z2, I0=>write_histogram_sva_sg1, I1=>
      NOT_equal_tmp_19, I2=>nx23862z4);
   ix15410z1188 : LUT4
      generic map (INIT => X"FF80") 
       port map ( O=>nx15410z2, I0=>write_histogram_sva_dfm_1_st_2_sg2, I1=>
      write_histogram_sva_dfm_1_st_6(1), I2=>
      write_histogram_sva_dfm_1_st_6(0), I3=>or_dcpl_19_0n0s2);
   ix23160z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx23160z4, I0=>if_if_mux_13_itm_2(1), I1=>
      NOT_and_227_cse, I2=>nx23160z5);
   ix24157z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx24157z4, I0=>if_if_mux_13_itm_2(2), I1=>
      NOT_and_227_cse, I2=>nx24157z5);
   ix25154z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx25154z4, I0=>if_if_mux_13_itm_2(3), I1=>
      NOT_and_227_cse, I2=>nx25154z5);
   ix26151z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx26151z4, I0=>if_if_mux_13_itm_2(4), I1=>
      NOT_and_227_cse, I2=>nx26151z5);
   ix27148z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx27148z4, I0=>if_if_mux_13_itm_2(5), I1=>
      NOT_and_227_cse, I2=>nx27148z5);
   ix28145z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx28145z4, I0=>if_if_mux_13_itm_2(6), I1=>
      NOT_and_227_cse, I2=>nx28145z5);
   ix29142z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx29142z4, I0=>if_if_mux_13_itm_2(7), I1=>
      NOT_and_227_cse, I2=>nx29142z5);
   ix30139z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx30139z4, I0=>if_if_mux_13_itm_2(8), I1=>
      NOT_and_227_cse, I2=>nx30139z5);
   ix31136z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx31136z4, I0=>if_if_mux_13_itm_2(9), I1=>
      NOT_and_227_cse, I2=>nx31136z5);
   ix28868z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx28868z4, I0=>if_if_mux_13_itm_2(10), I1=>
      NOT_and_227_cse, I2=>nx28868z5);
   ix29865z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx29865z4, I0=>if_if_mux_13_itm_2(11), I1=>
      NOT_and_227_cse, I2=>nx29865z5);
   ix30862z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx30862z4, I0=>if_if_mux_13_itm_2(12), I1=>
      NOT_and_227_cse, I2=>nx30862z5);
   ix31859z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx31859z4, I0=>if_if_mux_13_itm_2(13), I1=>
      NOT_and_227_cse, I2=>nx31859z5);
   ix32856z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx32856z4, I0=>if_if_mux_13_itm_2(14), I1=>
      NOT_and_227_cse, I2=>nx32856z5);
   ix33853z1560 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx33853z4, I0=>if_if_mux_13_itm_2(15), I1=>
      NOT_and_227_cse, I2=>nx33853z5);
   ix34850z1584 : LUT3
      generic map (INIT => X"F2") 
       port map ( O=>nx34850z10, I0=>if_if_mux_13_itm_2(16), I1=>
      NOT_and_227_cse, I2=>nx34850z11);
   ix12083z31354 : LUT4
      generic map (INIT => X"7555") 
       port map ( O=>nx12083z2, I0=>write_histogram_sva_sg2, I1=>
      NOT_equal_tmp_23, I2=>get_thresh_sva_dfm_2_mx0, I3=>nx23862z4);
   ix37359z1330 : LUT2
      generic map (INIT => X"E") 
       port map ( O=>nx37359z3, I0=>system_input_r_filter_sva(3), I1=>
      system_input_r_filter_sva(2));
   ix12608z34087 : LUT4
      generic map (INIT => X"7FFF") 
       port map ( O=>nx12608z3, I0=>system_input_c_filter_sva(4), I1=>
      system_input_c_filter_sva(3), I2=>system_input_c_filter_sva(2), I3=>
      system_input_c_filter_sva(1));
   ix23862z1325 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>nx23862z9, I0=>system_input_c_sva(7), I1=>
      system_input_c_sva(6), I2=>system_input_c_sva(2), I3=>
      system_input_c_sva(1));
   ix51923z10073 : LUT4
      generic map (INIT => X"222B") 
       port map ( O=>nx51923z5, I0=>system_input_window_7_sva_mx0(2), I1=>
      system_input_window_8_sva_mx0(2), I2=>system_input_window_8_sva_mx0(1), 
      I3=>system_input_window_8_sva_mx0(0));
   ix9333z1325 : LUT2
      generic map (INIT => X"7") 
       port map ( O=>nx9333z4, I0=>system_input_r_filter_sva(7), I1=>
      system_input_r_filter_sva(1));
   ix23862z1342 : LUT2
      generic map (INIT => X"E") 
       port map ( O=>nx23862z10, I0=>system_input_c_sva(8), I1=>
      system_input_c_sva(5));
   ix29629z23337 : LUT4
      generic map (INIT => X"5600") 
       port map ( O=>nx29629z3, I0=>nx12084z1, I1=>nx14656z1, I2=>nx12083z1, 
      I3=>write_histogram_sva_dfm_7_mx0_0);
   ix12608z50468 : LUT4
      generic map (INIT => X"BFFF") 
       port map ( O=>nx12608z1, I0=>or_dcpl_86, I1=>
      system_input_r_filter_sva(7), I2=>system_input_r_filter_sva(5), I3=>
      system_input_r_filter_sva(3));
   ix13605z9507 : LUT4
      generic map (INIT => X"2000") 
       port map ( O=>nx13605z1, I0=>frame_sva(0), I1=>
      NOT_system_input_land_1_lpi_1_dfm_1, I2=>NOT_equal_tmp_1, I3=>
      nx23862z4);
   ix13605z57893 : LUT4
      generic map (INIT => X"DCFF") 
       port map ( O=>nx13605z2, I0=>frame_sva(0), I1=>
      NOT_system_input_land_1_lpi_1_dfm_1, I2=>NOT_equal_tmp_1, I3=>
      nx23862z4);
   ix21778z45892 : LUT4
      generic map (INIT => X"AE20") 
       port map ( O=>nx21778z2, I0=>window_5_lpi_1_dfm_8(1), I1=>
      window_7_lpi_1_dfm_2_mx0(2), I2=>window_6_lpi_1_dfm_3_mx0(2), I3=>
      window_6_lpi_1_dfm_3_mx0(1));
   ix21778z63816 : LUT4
      generic map (INIT => X"F420") 
       port map ( O=>nx21778z3, I0=>window_7_lpi_1_dfm_2_mx0(2), I1=>
      window_6_lpi_1_dfm_3_mx0(2), I2=>window_6_lpi_1_dfm_3_mx0(1), I3=>
      window_7_lpi_1_dfm_1_mx0(1));
   ix34409z64150 : LUT4
      generic map (INIT => X"F571") 
       port map ( O=>nx34409z4, I0=>threshold_sva(1), I1=>threshold_sva(0), 
      I2=>window_4_lpi_1_dfm_12(1), I3=>window_4_lpi_1_dfm_12(0));
   ix34409z64151 : LUT4
      generic map (INIT => X"F571") 
       port map ( O=>nx34409z5, I0=>mcu_data_rsc_singleport_data_out(1), I1
      =>mcu_data_rsc_singleport_data_out(0), I2=>window_4_lpi_1_dfm_12(1), 
      I3=>window_4_lpi_1_dfm_12(0));
   ix35275z23075 : LUT4
      generic map (INIT => X"5501") 
       port map ( O=>nx35275z1, I0=>NOT_equal_tmp_23, I1=>nx9333z5, I2=>
      nx9333z3, I3=>get_thresh_sva);
   ix34903z46028 : LUT4
      generic map (INIT => X"AEAA") 
       port map ( O=>nx34903z1, I0=>sclear_dup_435, I1=>nx34903z4, I2=>
      exit_BUU_sva, I3=>BUU_i_1_lpi_1(1));
   ix9333z3362 : LUT4
      generic map (INIT => X"0800") 
       port map ( O=>nx9333z1, I0=>nx23862z5, I1=>nx34903z4, I2=>
      exit_BUU_sva, I3=>BUU_i_1_lpi_1(1));
   ix14656z20974 : LUT4
      generic map (INIT => X"4CCC") 
       port map ( O=>nx14656z1, I0=>NOT_if_if_equal_cse_sva_3_0n0s2, I1=>
      write_histogram_sva_sg1, I2=>nx12608z2, I3=>NOT_or_181_cse);
   ix12084z20976 : LUT4
      generic map (INIT => X"4CCC") 
       port map ( O=>nx12084z1, I0=>NOT_if_if_equal_cse_sva_3_0n0s2, I1=>
      write_histogram_sva_sg2, I2=>nx12608z2, I3=>NOT_or_181_cse);
   ix34850z1526 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_4_lpi_1_dfm_12_mx0(2), I0=>nx34850z5, I1=>
      window_5_lpi_1_dfm_4_mx0(2), I2=>window_4_lpi_1_dfm_5_mx0(2));
   ix27784z17698 : LUT4
      generic map (INIT => X"4000") 
       port map ( O=>NOT_or_43_cse, I0=>exit_BUU_sva, I1=>BUU_i_1_lpi_1(1), 
      I2=>main_stage_0_2, I3=>io_read_in_data_vld_rsc_d_sft_lpi_1_dfm_1);
   ix43472z23811 : LUT4
      generic map (INIT => X"57DF") 
       port map ( O=>NOT_or_dcpl_31_0n0s2, I0=>if_if_equal_cse_sva_st_5, I1
      =>nx34850z2, I2=>window_5_lpi_1_dfm_4_mx0(0), I3=>
      window_4_lpi_1_dfm_5_mx0(0));
   ix34850z670 : LUT4
      generic map (INIT => X"FD75") 
       port map ( O=>or_dcpl_39, I0=>if_if_equal_cse_sva_st_5, I1=>nx34850z2, 
      I2=>window_5_lpi_1_dfm_4_mx0(0), I3=>window_4_lpi_1_dfm_5_mx0(0));
   ix34850z1515 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_4_lpi_1_dfm_5_mx0(2), I0=>nx34850z3, I1=>
      window_6_lpi_1_dfm_9(2), I2=>window_4_lpi_1_dfm_11(2));
   ix34850z1517 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_5_lpi_1_dfm_4_mx0(2), I0=>nx34850z4, I1=>
      window_7_lpi_1_dfm_8(2), I2=>window_5_lpi_1_dfm_9(2));
   ix34363z9575 : LUT4
      generic map (INIT => X"2000") 
       port map ( O=>nx34363z21, I0=>window_4_lpi_1_dfm_2_mx0(2), I1=>
      window_0_lpi_1_dfm_4_mx0(2), I2=>window_5_lpi_1_dfm_8(2), I3=>
      window_7_lpi_1_dfm_1_mx0(2));
   ix34363z47255 : LUT4
      generic map (INIT => X"B333") 
       port map ( O=>nx34363z20, I0=>window_4_lpi_1_dfm_2_mx0(2), I1=>
      window_0_lpi_1_dfm_4_mx0(2), I2=>window_5_lpi_1_dfm_8(2), I3=>
      window_7_lpi_1_dfm_1_mx0(2));
   ix4197z14157 : LUT4
      generic map (INIT => X"3222") 
       port map ( O=>nx4197z7, I0=>window_4_lpi_1_dfm_2_mx0(2), I1=>
      window_1_lpi_1_dfm_6(2), I2=>window_5_lpi_1_dfm_8(2), I3=>
      window_7_lpi_1_dfm_1_mx0(2));
   ix4197z229 : LUT4
      generic map (INIT => X"FBBB") 
       port map ( O=>nx4197z6, I0=>window_4_lpi_1_dfm_2_mx0(2), I1=>
      window_1_lpi_1_dfm_6(2), I2=>window_5_lpi_1_dfm_8(2), I3=>
      window_7_lpi_1_dfm_1_mx0(2));
   ix5194z1040 : LUT4
      generic map (INIT => X"FEEE") 
       port map ( O=>rtlc6_copy_n2407(2), I0=>window_4_lpi_1_dfm_2_mx0(2), 
      I1=>window_1_lpi_1_dfm_6(2), I2=>window_5_lpi_1_dfm_8(2), I3=>
      window_7_lpi_1_dfm_1_mx0(2));
   ix21778z10067 : LUT4
      generic map (INIT => X"2220") 
       port map ( O=>nx21778z9, I0=>window_6_lpi_1_dfm_3_mx0(2), I1=>
      window_2_lpi_1_dfm_7(2), I2=>window_7_lpi_1_dfm_1_mx0(2), I3=>
      window_5_lpi_1_dfm_8(2));
   ix21778z49381 : LUT4
      generic map (INIT => X"BBB3") 
       port map ( O=>nx21778z8, I0=>window_6_lpi_1_dfm_3_mx0(2), I1=>
      window_2_lpi_1_dfm_7(2), I2=>window_7_lpi_1_dfm_1_mx0(2), I3=>
      window_5_lpi_1_dfm_8(2));
   ix21778z1343 : LUT4
      generic map (INIT => X"000E") 
       port map ( O=>nx21778z7, I0=>window_5_lpi_1_dfm_8(2), I1=>
      window_7_lpi_1_dfm_1_mx0(2), I2=>window_4_lpi_1_dfm_1_mx0(2), I3=>
      window_6_lpi_1_dfm_2_mx0(2));
   ix21778z62495 : LUT4
      generic map (INIT => X"EEEF") 
       port map ( O=>nx21778z6, I0=>window_5_lpi_1_dfm_8(2), I1=>
      window_7_lpi_1_dfm_1_mx0(2), I2=>window_4_lpi_1_dfm_1_mx0(2), I3=>
      window_6_lpi_1_dfm_2_mx0(2));
   ix34363z63013 : LUT4
      generic map (INIT => X"F0C0") 
       port map ( O=>window_0_lpi_1_dfm_4_mx0(2), I0=>nx34363z18, I1=>
      window_8_lpi_1_dfm_2_mx0(2), I2=>window_0_lpi_1_dfm_8(2), I3=>
      window_4_lpi_1_dfm_10(2));
   ix34363z1484 : LUT3
      generic map (INIT => X"A8") 
       port map ( O=>window_5_lpi_1_dfm_1_mx0(2), I0=>
      window_5_lpi_1_dfm_8(2), I1=>window_6_lpi_1_dfm_1_mx0(2), I2=>
      window_7_lpi_1_dfm_mx0(2));
   ix34363z49399 : LUT4
      generic map (INIT => X"BBB2") 
       port map ( O=>nx34363z11, I0=>nx34363z12, I1=>window_5_lpi_1_dfm_8(2), 
      I2=>window_6_lpi_1_dfm_1_mx0(2), I3=>window_7_lpi_1_dfm_mx0(2));
   ix21778z1571 : LUT3
      generic map (INIT => X"FE") 
       port map ( O=>window_7_lpi_1_dfm_2_mx0(2), I0=>
      window_5_lpi_1_dfm_8(2), I1=>window_6_lpi_1_dfm_1_mx0(2), I2=>
      window_7_lpi_1_dfm_mx0(2));
   ix34363z1560 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_6_lpi_1_dfm_2_mx0(2), I0=>nx34363z10, I1=>
      window_6_lpi_1_dfm_1_mx0(2), I2=>window_7_lpi_1_dfm_mx0(2));
   ix34363z42313 : LUT4
      generic map (INIT => X"A000") 
       port map ( O=>window_4_lpi_1_dfm_2_mx0(2), I0=>
      window_4_lpi_1_dfm_1_mx0(2), I1=>nx34363z10, I2=>
      window_6_lpi_1_dfm_1_mx0(2), I3=>window_7_lpi_1_dfm_mx0(2));
   ix21778z65488 : LUT4
      generic map (INIT => X"FAAA") 
       port map ( O=>window_6_lpi_1_dfm_3_mx0(2), I0=>
      window_4_lpi_1_dfm_1_mx0(2), I1=>nx34363z10, I2=>
      window_6_lpi_1_dfm_1_mx0(2), I3=>window_7_lpi_1_dfm_mx0(2));
   ix34363z1589 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_4_lpi_1_dfm_1_mx0(2), I0=>nx34363z13, I1=>
      window_8_lpi_1_dfm_2_mx0(2), I2=>window_4_lpi_1_dfm_10(2));
   ix30711z64938 : LUT4
      generic map (INIT => X"F888") 
       port map ( O=>rtlc6_copy_n2550(2), I0=>window_3_lpi_1_dfm_mx0(2), I1
      =>window_1_lpi_1_dfm_mx0(2), I2=>window_2_lpi_1_dfm_1_mx0(2), I3=>
      window_0_lpi_1_dfm_1_mx0(2));
   ix8756z1312 : LUT4
      generic map (INIT => X"FFFE") 
       port map ( O=>rtlc6_copy_n2571(2), I0=>window_3_lpi_1_dfm_mx0(2), I1
      =>window_1_lpi_1_dfm_mx0(2), I2=>window_2_lpi_1_dfm_1_mx0(2), I3=>
      window_0_lpi_1_dfm_1_mx0(2));
   ix25663z290 : LUT4
      generic map (INIT => X"FC00") 
       port map ( O=>rtlc6_copy_n2557(2), I0=>nx9753z13, I1=>
      window_3_lpi_1_dfm_mx0(2), I2=>window_1_lpi_1_dfm_mx0(2), I3=>
      window_0_lpi_1_dfm_2_mx0(2));
   ix4711z50466 : LUT4
      generic map (INIT => X"C000") 
       port map ( O=>rtlc6_copy_n2543(2), I0=>nx31708z3, I1=>
      window_3_lpi_1_dfm_mx0(2), I2=>window_1_lpi_1_dfm_mx0(2), I3=>
      window_2_lpi_1_dfm_2_mx0(2));
   ix34363z1529 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_7_lpi_1_dfm_mx0(2), I0=>nx34363z4, I1=>
      clip_window_qr_2_lpi_1_dfm_mx0(2), I2=>window_8_lpi_1_dfm_mx0(2));
   ix34363z65552 : LUT4
      generic map (INIT => X"FAAA") 
       port map ( O=>window_7_lpi_1_dfm_1_mx0(2), I0=>
      window_6_lpi_1_dfm_1_mx0(2), I1=>nx34363z4, I2=>
      clip_window_qr_2_lpi_1_dfm_mx0(2), I3=>window_8_lpi_1_dfm_mx0(2));
   ix34363z1509 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_6_lpi_1_dfm_1_mx0(2), I0=>nx34363z2, I1=>
      window_6_lpi_1_dfm_mx0(2), I2=>window_8_lpi_1_dfm_1_mx0(2));
   ix9753z1539 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_3_lpi_1_dfm_mx0(2), I0=>nx9753z7, I1=>
      clip_window_qr_3_lpi_1_dfm_mx0(2), I2=>window_2_lpi_1_dfm_mx0(2));
   ix9753z1528 : LUT3
      generic map (INIT => X"C0") 
       port map ( O=>window_0_lpi_1_dfm_1_mx0(2), I0=>nx9753z5, I1=>
      window_0_lpi_1_dfm_mx0(2), I2=>clip_window_qr_lpi_1_dfm_mx0(2));
   ix31708z42278 : LUT4
      generic map (INIT => X"A000") 
       port map ( O=>window_2_lpi_1_dfm_2_mx0(2), I0=>
      window_2_lpi_1_dfm_1_mx0(2), I1=>nx9753z5, I2=>
      window_0_lpi_1_dfm_mx0(2), I3=>clip_window_qr_lpi_1_dfm_mx0(2));
   ix9753z65521 : LUT4
      generic map (INIT => X"FAAA") 
       port map ( O=>window_0_lpi_1_dfm_2_mx0(2), I0=>
      window_2_lpi_1_dfm_1_mx0(2), I1=>nx9753z5, I2=>
      window_0_lpi_1_dfm_mx0(2), I3=>clip_window_qr_lpi_1_dfm_mx0(2));
end v1_unfold_1878 ;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Library use clause for technology cells
library unisim ;
use unisim.vcomponents.all;

entity filter is 
   port (
      in_data_rsc_z : IN std_logic_vector (2 DOWNTO 0) ;
      in_data_rsc_lz : OUT std_logic ;
      in_data_vld_rsc_z : IN std_logic ;
      out_data_rsc_z : OUT std_logic_vector (2 DOWNTO 0) ;
      out_data_rsc_lz : OUT std_logic ;
      clk : IN std_logic ;
      rst : IN std_logic ;
      mcu_data_rsc_singleport_data_in : OUT std_logic_vector (31 DOWNTO 0) ;
      
      mcu_data_rsc_singleport_addr : OUT std_logic_vector (8 DOWNTO 0) ;
      mcu_data_rsc_singleport_re : OUT std_logic ;
      mcu_data_rsc_singleport_we : OUT std_logic ;
      mcu_data_rsc_singleport_data_out : IN std_logic_vector (31 DOWNTO 0)
   ) ;
end filter ;

architecture v1 of filter is 
   component filter_core
      port (
         clk : IN std_logic ;
         rst : IN std_logic ;
         mcu_data_rsc_singleport_data_in : OUT std_logic_vector
          (31 DOWNTO 0) ;
         mcu_data_rsc_singleport_addr : OUT std_logic_vector (8 DOWNTO 0) ;
         mcu_data_rsc_singleport_re : OUT std_logic ;
         mcu_data_rsc_singleport_we : OUT std_logic ;
         mcu_data_rsc_singleport_data_out : IN std_logic_vector
          (31 DOWNTO 0) ;
         in_data_rsc_mgc_in_wire_en_ld : OUT std_logic ;
         in_data_rsc_mgc_in_wire_en_d : IN std_logic_vector (2 DOWNTO 0) ;
         in_data_vld_rsc_mgc_in_wire_d : IN std_logic ;
         out_data_rsc_mgc_out_stdreg_en_ld : OUT std_logic ;
         out_data_rsc_mgc_out_stdreg_en_d : OUT std_logic_vector
          (2 DOWNTO 0) ;
         buffer_buf_rsc_singleport_data_in : OUT std_logic_vector
          (2 DOWNTO 0) ;
         buffer_buf_rsc_singleport_addr : OUT std_logic_vector (9 DOWNTO 0)
          ;
         buffer_buf_rsc_singleport_re : OUT std_logic ;
         buffer_buf_rsc_singleport_we : OUT std_logic ;
         buffer_buf_rsc_singleport_data_out : IN std_logic_vector
          (2 DOWNTO 0)) ;
   end component ;
   signal out_data_rsc_z_EXMPLR152: std_logic_vector (0 DOWNTO 0) ;
   
   signal buffer_buf_rsc_singleport_data_in_1: std_logic_vector (2 DOWNTO 0)
    ;
   
   signal buffer_buf_rsc_singleport_addr_1: std_logic_vector (9 DOWNTO 0) ;
   
   signal buffer_buf_rsc_singleport_we_1_0: std_logic ;
   
   signal filter_core_inst_buffer_buf_rsc_singleport_data_out: 
   std_logic_vector (2 DOWNTO 0) ;
   
   signal mcu_data_rsc_singleport_addr_4_EXMPLR151, 
      buffer_buf_rsc_singleport_not_en, nx39569z1: std_logic ;
   
   signal DANGLING : std_logic_vector (37 downto 0 );

begin
   out_data_rsc_z(2) <= out_data_rsc_z_EXMPLR152(0) ;
   out_data_rsc_z(1) <= out_data_rsc_z_EXMPLR152(0) ;
   out_data_rsc_z(0) <= out_data_rsc_z_EXMPLR152(0) ;
   mcu_data_rsc_singleport_addr(8) <= 
   mcu_data_rsc_singleport_addr_4_EXMPLR151 ;
   mcu_data_rsc_singleport_addr(7) <= 
   mcu_data_rsc_singleport_addr_4_EXMPLR151 ;
   mcu_data_rsc_singleport_addr(6) <= 
   mcu_data_rsc_singleport_addr_4_EXMPLR151 ;
   mcu_data_rsc_singleport_addr(5) <= 
   mcu_data_rsc_singleport_addr_4_EXMPLR151 ;
   mcu_data_rsc_singleport_addr(4) <= 
   mcu_data_rsc_singleport_addr_4_EXMPLR151 ;
   filter_core_inst : filter_core port map ( clk=>clk, rst=>rst, 
      mcu_data_rsc_singleport_data_in(31)=>
      mcu_data_rsc_singleport_data_in(31), 
      mcu_data_rsc_singleport_data_in(30)=>
      mcu_data_rsc_singleport_data_in(30), 
      mcu_data_rsc_singleport_data_in(29)=>
      mcu_data_rsc_singleport_data_in(29), 
      mcu_data_rsc_singleport_data_in(28)=>
      mcu_data_rsc_singleport_data_in(28), 
      mcu_data_rsc_singleport_data_in(27)=>
      mcu_data_rsc_singleport_data_in(27), 
      mcu_data_rsc_singleport_data_in(26)=>
      mcu_data_rsc_singleport_data_in(26), 
      mcu_data_rsc_singleport_data_in(25)=>
      mcu_data_rsc_singleport_data_in(25), 
      mcu_data_rsc_singleport_data_in(24)=>
      mcu_data_rsc_singleport_data_in(24), 
      mcu_data_rsc_singleport_data_in(23)=>
      mcu_data_rsc_singleport_data_in(23), 
      mcu_data_rsc_singleport_data_in(22)=>
      mcu_data_rsc_singleport_data_in(22), 
      mcu_data_rsc_singleport_data_in(21)=>
      mcu_data_rsc_singleport_data_in(21), 
      mcu_data_rsc_singleport_data_in(20)=>
      mcu_data_rsc_singleport_data_in(20), 
      mcu_data_rsc_singleport_data_in(19)=>
      mcu_data_rsc_singleport_data_in(19), 
      mcu_data_rsc_singleport_data_in(18)=>
      mcu_data_rsc_singleport_data_in(18), 
      mcu_data_rsc_singleport_data_in(17)=>
      mcu_data_rsc_singleport_data_in(17), 
      mcu_data_rsc_singleport_data_in(16)=>
      mcu_data_rsc_singleport_data_in(16), 
      mcu_data_rsc_singleport_data_in(15)=>
      mcu_data_rsc_singleport_data_in(15), 
      mcu_data_rsc_singleport_data_in(14)=>
      mcu_data_rsc_singleport_data_in(14), 
      mcu_data_rsc_singleport_data_in(13)=>
      mcu_data_rsc_singleport_data_in(13), 
      mcu_data_rsc_singleport_data_in(12)=>
      mcu_data_rsc_singleport_data_in(12), 
      mcu_data_rsc_singleport_data_in(11)=>
      mcu_data_rsc_singleport_data_in(11), 
      mcu_data_rsc_singleport_data_in(10)=>
      mcu_data_rsc_singleport_data_in(10), 
      mcu_data_rsc_singleport_data_in(9)=>mcu_data_rsc_singleport_data_in(9), 
      mcu_data_rsc_singleport_data_in(8)=>mcu_data_rsc_singleport_data_in(8), 
      mcu_data_rsc_singleport_data_in(7)=>mcu_data_rsc_singleport_data_in(7), 
      mcu_data_rsc_singleport_data_in(6)=>mcu_data_rsc_singleport_data_in(6), 
      mcu_data_rsc_singleport_data_in(5)=>mcu_data_rsc_singleport_data_in(5), 
      mcu_data_rsc_singleport_data_in(4)=>mcu_data_rsc_singleport_data_in(4), 
      mcu_data_rsc_singleport_data_in(3)=>mcu_data_rsc_singleport_data_in(3), 
      mcu_data_rsc_singleport_data_in(2)=>mcu_data_rsc_singleport_data_in(2), 
      mcu_data_rsc_singleport_data_in(1)=>mcu_data_rsc_singleport_data_in(1), 
      mcu_data_rsc_singleport_data_in(0)=>mcu_data_rsc_singleport_data_in(0), 
      mcu_data_rsc_singleport_addr(8)=>DANGLING(0), 
      mcu_data_rsc_singleport_addr(7)=>DANGLING(1), 
      mcu_data_rsc_singleport_addr(6)=>DANGLING(2), 
      mcu_data_rsc_singleport_addr(5)=>DANGLING(3), 
      mcu_data_rsc_singleport_addr(4)=>DANGLING(4), 
      mcu_data_rsc_singleport_addr(3)=>mcu_data_rsc_singleport_addr(3), 
      mcu_data_rsc_singleport_addr(2)=>mcu_data_rsc_singleport_addr(2), 
      mcu_data_rsc_singleport_addr(1)=>mcu_data_rsc_singleport_addr(1), 
      mcu_data_rsc_singleport_addr(0)=>mcu_data_rsc_singleport_addr(0), 
      mcu_data_rsc_singleport_re=>mcu_data_rsc_singleport_re, 
      mcu_data_rsc_singleport_we=>mcu_data_rsc_singleport_we, 
      mcu_data_rsc_singleport_data_out(31)=>DANGLING(5), 
      mcu_data_rsc_singleport_data_out(30)=>DANGLING(6), 
      mcu_data_rsc_singleport_data_out(29)=>DANGLING(7), 
      mcu_data_rsc_singleport_data_out(28)=>DANGLING(8), 
      mcu_data_rsc_singleport_data_out(27)=>DANGLING(9), 
      mcu_data_rsc_singleport_data_out(26)=>DANGLING(10), 
      mcu_data_rsc_singleport_data_out(25)=>DANGLING(11), 
      mcu_data_rsc_singleport_data_out(24)=>DANGLING(12), 
      mcu_data_rsc_singleport_data_out(23)=>DANGLING(13), 
      mcu_data_rsc_singleport_data_out(22)=>DANGLING(14), 
      mcu_data_rsc_singleport_data_out(21)=>DANGLING(15), 
      mcu_data_rsc_singleport_data_out(20)=>DANGLING(16), 
      mcu_data_rsc_singleport_data_out(19)=>DANGLING(17), 
      mcu_data_rsc_singleport_data_out(18)=>DANGLING(18), 
      mcu_data_rsc_singleport_data_out(17)=>DANGLING(19), 
      mcu_data_rsc_singleport_data_out(16)=>DANGLING(20), 
      mcu_data_rsc_singleport_data_out(15)=>DANGLING(21), 
      mcu_data_rsc_singleport_data_out(14)=>DANGLING(22), 
      mcu_data_rsc_singleport_data_out(13)=>DANGLING(23), 
      mcu_data_rsc_singleport_data_out(12)=>DANGLING(24), 
      mcu_data_rsc_singleport_data_out(11)=>DANGLING(25), 
      mcu_data_rsc_singleport_data_out(10)=>DANGLING(26), 
      mcu_data_rsc_singleport_data_out(9)=>DANGLING(27), 
      mcu_data_rsc_singleport_data_out(8)=>DANGLING(28), 
      mcu_data_rsc_singleport_data_out(7)=>DANGLING(29), 
      mcu_data_rsc_singleport_data_out(6)=>DANGLING(30), 
      mcu_data_rsc_singleport_data_out(5)=>DANGLING(31), 
      mcu_data_rsc_singleport_data_out(4)=>DANGLING(32), 
      mcu_data_rsc_singleport_data_out(3)=>DANGLING(33), 
      mcu_data_rsc_singleport_data_out(2)=>
      mcu_data_rsc_singleport_data_out(2), 
      mcu_data_rsc_singleport_data_out(1)=>
      mcu_data_rsc_singleport_data_out(1), 
      mcu_data_rsc_singleport_data_out(0)=>
      mcu_data_rsc_singleport_data_out(0), in_data_rsc_mgc_in_wire_en_ld=>
      in_data_rsc_lz, in_data_rsc_mgc_in_wire_en_d(2)=>in_data_rsc_z(2), 
      in_data_rsc_mgc_in_wire_en_d(1)=>in_data_rsc_z(1), 
      in_data_rsc_mgc_in_wire_en_d(0)=>in_data_rsc_z(0), 
      in_data_vld_rsc_mgc_in_wire_d=>in_data_vld_rsc_z, 
      out_data_rsc_mgc_out_stdreg_en_ld=>out_data_rsc_lz, 
      out_data_rsc_mgc_out_stdreg_en_d(2)=>out_data_rsc_z_EXMPLR152(0), 
      out_data_rsc_mgc_out_stdreg_en_d(1)=>DANGLING(34), 
      out_data_rsc_mgc_out_stdreg_en_d(0)=>DANGLING(35), 
      buffer_buf_rsc_singleport_data_in(2)=>
      buffer_buf_rsc_singleport_data_in_1(2), 
      buffer_buf_rsc_singleport_data_in(1)=>
      buffer_buf_rsc_singleport_data_in_1(1), 
      buffer_buf_rsc_singleport_data_in(0)=>
      buffer_buf_rsc_singleport_data_in_1(0), 
      buffer_buf_rsc_singleport_addr(9)=>buffer_buf_rsc_singleport_addr_1(9), 
      buffer_buf_rsc_singleport_addr(8)=>buffer_buf_rsc_singleport_addr_1(8), 
      buffer_buf_rsc_singleport_addr(7)=>buffer_buf_rsc_singleport_addr_1(7), 
      buffer_buf_rsc_singleport_addr(6)=>buffer_buf_rsc_singleport_addr_1(6), 
      buffer_buf_rsc_singleport_addr(5)=>buffer_buf_rsc_singleport_addr_1(5), 
      buffer_buf_rsc_singleport_addr(4)=>buffer_buf_rsc_singleport_addr_1(4), 
      buffer_buf_rsc_singleport_addr(3)=>buffer_buf_rsc_singleport_addr_1(3), 
      buffer_buf_rsc_singleport_addr(2)=>buffer_buf_rsc_singleport_addr_1(2), 
      buffer_buf_rsc_singleport_addr(1)=>buffer_buf_rsc_singleport_addr_1(1), 
      buffer_buf_rsc_singleport_addr(0)=>buffer_buf_rsc_singleport_addr_1(0), 
      buffer_buf_rsc_singleport_re=>DANGLING(36), 
      buffer_buf_rsc_singleport_we=>buffer_buf_rsc_singleport_we_1_0, 
      buffer_buf_rsc_singleport_data_out(2)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(2), 
      buffer_buf_rsc_singleport_data_out(1)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(1), 
      buffer_buf_rsc_singleport_data_out(0)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(0));
   buffer_buf_rsc_singleport_mem_1 : RAMB16_S4
      generic map (WRITE_MODE => "WRITE_FIRST") 
       port map ( DO(3)=>DANGLING(37), DO(2)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(2), DO(1)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(1), DO(0)=>
      filter_core_inst_buffer_buf_rsc_singleport_data_out(0), ADDR(11)=>
      mcu_data_rsc_singleport_addr_4_EXMPLR151, ADDR(10)=>
      mcu_data_rsc_singleport_addr_4_EXMPLR151, ADDR(9)=>
      buffer_buf_rsc_singleport_addr_1(9), ADDR(8)=>
      buffer_buf_rsc_singleport_addr_1(8), ADDR(7)=>
      buffer_buf_rsc_singleport_addr_1(7), ADDR(6)=>
      buffer_buf_rsc_singleport_addr_1(6), ADDR(5)=>
      buffer_buf_rsc_singleport_addr_1(5), ADDR(4)=>
      buffer_buf_rsc_singleport_addr_1(4), ADDR(3)=>
      buffer_buf_rsc_singleport_addr_1(3), ADDR(2)=>
      buffer_buf_rsc_singleport_addr_1(2), ADDR(1)=>
      buffer_buf_rsc_singleport_addr_1(1), ADDR(0)=>
      buffer_buf_rsc_singleport_addr_1(0), CLK=>clk, DI(3)=>
      mcu_data_rsc_singleport_addr_4_EXMPLR151, DI(2)=>
      buffer_buf_rsc_singleport_data_in_1(2), DI(1)=>
      buffer_buf_rsc_singleport_data_in_1(1), DI(0)=>
      buffer_buf_rsc_singleport_data_in_1(0), EN=>
      buffer_buf_rsc_singleport_not_en, SSR=>
      mcu_data_rsc_singleport_addr_4_EXMPLR151, WE=>nx39569z1);
   mcu_data_rsc_singleport_addr_4_EXMPLR157 : GND port map ( G=>
      mcu_data_rsc_singleport_addr_4_EXMPLR151);
   buffer_buf_rsc_singleport_not_en_EXMPLR158 : VCC port map ( P=>
      buffer_buf_rsc_singleport_not_en);
   ix39569z1401 : LUT4
      generic map (INIT => X"0057") 
       port map ( O=>nx39569z1, I0=>buffer_buf_rsc_singleport_addr_1(9), I1
      =>buffer_buf_rsc_singleport_addr_1(8), I2=>
      buffer_buf_rsc_singleport_addr_1(7), I3=>
      buffer_buf_rsc_singleport_we_1_0);
end v1 ;

