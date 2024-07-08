ghdl -a .\src\ula.vhd .\Testbench\tb_ula.vhd > log.txt 2>&1

ghdl -e tb_ula >> log.txt 2>&1

ghdl -r tb_ula --stop-time=10us --wave=ula_output.ghw >> log.txt 2>&1

gtkwave ula_output.ghw >> log.txt 2>&1