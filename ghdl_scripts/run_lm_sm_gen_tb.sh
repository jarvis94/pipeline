#!/bin/sh -e
ghdl -a lm_sm_rd_gen.vhd
ghdl -a register.vhd
ghdl -a register_1.vhd
ghdl -a mux.vhd
ghdl -a lm_sm_rd_gen_tb.vhd
ghdl -e lm_sm_rd_gen_tb
ghdl -r lm_sm_rd_gen_tb --stop-time=150ns --wave=lm_sm_rd_gen_tb.ghw
#gtkwave lm_sm_rd_gen_tb.ghw &
