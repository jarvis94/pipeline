#!/bin/sh -e
ghdl -a ../rtl/fdu.vhd
ghdl -a ../tbs/fdu_tb.vhd
ghdl -e fdu_tb
ghdl -r fdu_tb --stop-time=90ns --wave=fdu_tb.ghw
#gtkwave lm_sm_rd_gen_tb.ghw &