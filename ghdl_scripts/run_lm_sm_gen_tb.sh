#!/bin/sh -e
ghdl -a ../rtl/lm_sm_rd_gen.vhd
ghdl -a ../rtl/register.vhd
ghdl -a ../rtl/register_1.vhd
ghdl -a ../rtl/mux.vhd
ghdl -a ../tbs/lm_sm_rd_gen_tb.vhd
ghdl -e lm_sm_rd_gen_tb
ghdl -r lm_sm_rd_gen_tb --stop-time=150ns --wave=lm_sm_rd_gen_tb.ghw
#gtkwave lm_sm_rd_gen_tb.ghw &
