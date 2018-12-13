vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/blk_mem_gen_v8_4_1

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap blk_mem_gen_v8_4_1 modelsim_lib/msim/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib -64 -incr -sv \
"D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1 -64 -incr \
"../../../../Neural.srcs/sources_1/bd/sbc/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../bd/sbc/ip/sbc_blk_mem_gen_0_0/sim/sbc_blk_mem_gen_0_0.v" \
"../../../bd/sbc/ip/sbc_blk_mem_gen_1_0/sim/sbc_blk_mem_gen_1_0.v" \
"../../../bd/sbc/sim/sbc.v" \

vlog -work xil_defaultlib \
"glbl.v"

