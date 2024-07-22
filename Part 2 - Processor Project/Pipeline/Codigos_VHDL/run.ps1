clear

ghdl -a .\src\and_port.vhd .\src\banco_registradores.vhd .\src\deslocador.vhd .\src\extensor.vhd .\src\hazard.vhd .\src\memd.vhd .\src\memi.vhd .\src\multiplicador.vhd .\src\mux21.vhd .\src\mux31.vhd .\src\mux41.vhd .\src\pc.vhd .\src\processador_pipeline.vhd .\src\reg_decode.vhd .\src\reg_execute.vhd .\src\reg_writeback.vhd .\src\registrador.vhd .\src\somador.vhd .\src\ula.vhd .\src\unidade_de_controle_pipeline.vhd .\src\via_de_dados_pipeline.vhd .\Testbench\tb_processador_pipeline.vhd

ghdl -e tb_processador_pipeline 

ghdl -r tb_processador_pipeline --stop-time=10us --wave=tb_processador_pipeline_output.ghw 

gtkwave tb_processador_pipeline_output.ghw 