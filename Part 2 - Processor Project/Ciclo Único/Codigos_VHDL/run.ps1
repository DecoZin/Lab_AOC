ghdl -a .\src\ula.vhd .\Testbench\tb_ula_simples.vhd

ghdl -e tb_ula 

ghdl -r tb_ula --stop-time=10us --wave=tb_ula_output.ghw 

gtkwave tb_ula_output.ghw 