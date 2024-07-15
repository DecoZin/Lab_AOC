ghdl -a .\src\ula.vhd .\Testbench\tb_via_de_dados_ciclo_unico.vhd

ghdl -e tb_via_de_dados_ciclo_unico 

ghdl -r tb_via_de_dados_ciclo_unico --stop-time=10us --wave=tb_via_de_dados_ciclo_unico_output.ghw 

gtkwave tb_via_de_dados_ciclo_unico_output.ghw 