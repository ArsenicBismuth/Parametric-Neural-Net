vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/blk_mem_gen_v8_4_1

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap blk_mem_gen_v8_4_1 activehdl/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib  -sv2k12 \
"D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/ProgramFiles/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1  -v2k5 \
"../../../../Neural.srcs/sources_1/bd/sbc/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/sbc/ip/sbc_blk_mem_gen_0_0/sim/sbc_blk_mem_gen_0_0.v" \
"../../../bd/sbc/ip/sbc_blk_mem_gen_1_0/sim/sbc_blk_mem_gen_1_0.v" \
"../../../bd/sbc/sim/sbc.v" \

vlog -work xil_defaultlib \
"glbl.v"

