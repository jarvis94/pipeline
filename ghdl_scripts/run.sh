ghdl -a sign_ext.vhd
ghdl -a sign_ext_tb.vhd
ghdl -e sign_ext_tb
ghdl -r sign_ext_tb --stop-time=100ns --wave=sign_ext.ghw
