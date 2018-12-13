-makelib ies_lib/xil_defaultlib -sv \
  "D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../../Neural.srcs/sources_1/bd/sbc/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/sbc/ip/sbc_blk_mem_gen_0_0/sim/sbc_blk_mem_gen_0_0.v" \
  "../../../bd/sbc/ip/sbc_blk_mem_gen_1_0/sim/sbc_blk_mem_gen_1_0.v" \
  "../../../bd/sbc/sim/sbc.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

