clear

ghdl -a .\src\and_port.vhd .\src\banco_registradores.vhd .\src\deslocador.vhd .\src\extensor.vhd .\src\memd.vhd .\src\memi.vhd .\src\multiplicador.vhd .\src\mux21.vhd .\src\mux41.vhd .\src\pc.vhd .\src\processador_ciclo_unico.vhd .\src\somador.vhd .\src\ula.vhd .\src\unidade_de_controle_ciclo_unico.vhd .\src\via_de_dados_ciclo_unico.vhd .\Testbench\tb_processador_ciclo_unico.vhd

ghdl -e tb_processador_ciclo_unico 

ghdl -r tb_processador_ciclo_unico --stop-time=10us --wave=tb_processador_ciclo_unico_output.ghw 

gtkwave tb_processador_ciclo_unico_output.ghw 