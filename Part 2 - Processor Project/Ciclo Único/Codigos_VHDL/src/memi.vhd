-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletronica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Memória de Programas ou Memória de Instruções de tamanho genérico
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memi is
	generic (
		INSTR_WIDTH   : natural := 32; -- tamanho da instrucaoo em numero de bits
		MI_ADDR_WIDTH : natural := 7  -- tamanho do endereco da memoria de instrucoes em numero de bits
	);
	port (
		clk       : in std_logic;
		reset     : in std_logic;
		Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1 downto 0);
		Instrucao : out std_logic_vector(INSTR_WIDTH - 1 downto 0)
	);
end entity;

architecture comportamental of memi is
	type rom_type is array (0 to 2 ** MI_ADDR_WIDTH - 1) of std_logic_vector(INSTR_WIDTH - 1 downto 0);
	signal rom : rom_type;
begin
	process (clk, reset) is
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				rom <= (
					0      => X"02000200", -- exemplo de uma instrução qualquer de 32 bits
					1      => X"43024302", -- exemplo de uma instrução qualquer de 32 bits
					2      => X"C423C423", -- exemplo de uma instrução qualquer de 32 bits
					3      => X"21442144", -- exemplo de uma instrução qualquer de 32 bits
					others => X"00000000"  -- exemplo de uma instrução qualquer de 32 bits
					);
			else
				Instrucao <= rom(to_integer(unsigned(Endereco)));
			end if;
		end if;
	end process;
end comportamental;
