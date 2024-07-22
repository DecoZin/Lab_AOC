-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Testbench para o processador_pipeline
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Este arquivo irá gerar um sinal de clock e reset de modo a possibilitar a simulação do DUT processador_pipeline

entity tb_processador_pipeline is
end tb_processador_pipeline;

architecture estimulos of tb_processador_pipeline is
	-- Declarar a unidade sob teste
	component processador_pipeline
  generic (
		data_width  : natural := 32	-- tamanho do dado em bits
  );
		port (
		-- Chaves_entrada				: in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Chave_enter						: in std_logic ;
		pc_out                : out std_logic_vector(6 downto 0);
		Leds_vermelhos_saida	: out std_logic_vector(DATA_WIDTH - 1 downto 0);
		Chave_reset						: in std_logic;
		Clock									: in std_logic
	);
	end component;

  constant  data_width  : natural := 32;	-- tamanho do dado em bits

	signal rst : std_logic := '1';
  signal aux_pc_out   : std_logic_vector(6 downto 0) ;
  signal aux_leds_out : std_logic_vector(DATA_WIDTH -1 downto 0) ;  

	-- Definição das configurações de clock				
  constant clk_period : time := 10 ns;
  signal clk_generator : boolean := true;
  signal clk   : std_logic := '0'; 
  
begin
	-- instancia o componente 
	instancia : processador_pipeline 
  port map(
    pc_out => aux_pc_out, 
    Leds_vermelhos_saida => aux_leds_out, 
    Clock => clk, 
    Chave_reset => rst
  );
	-- processo para gerar o sinal de clock 		
CLOCK_GENERATOR: process
  begin
    while (clk_generator) loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;
  
  -- processo para gerar o estimulo de reset		
	STIMULUS : process
	begin
    wait until rising_edge(clk);
    rst <= '0';
		for i in 1 to 50 loop
			wait until rising_edge(clk);
		end loop;
		rst <= '0';
    clk_generator <= false;
		wait;
	end process;
end;