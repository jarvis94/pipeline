#!/bin/sh -e
ghdl -a ../rtl/hdu.vhd
ghdl -a ../tbs/hdu_tb.vhd
ghdl -e hdu_tb
ghdl -r hdu_tb --stop-time=150ns --wave=hdu_tb.ghw
#gtkwave lm_sm_rd_gen_tb.ghw &