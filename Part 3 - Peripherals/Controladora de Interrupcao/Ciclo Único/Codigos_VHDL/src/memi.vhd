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
		--clk       : in std_logic;
		reset     : in std_logic;
		Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1 downto 0);
		Instrucao : out std_logic_vector(INSTR_WIDTH - 1 downto 0)
	);
end entity;

architecture comportamental of memi is
	type rom_type is array (0 to 2 ** MI_ADDR_WIDTH - 1) of std_logic_vector(INSTR_WIDTH - 1 downto 0);
	signal rom : rom_type;
begin
	process (Endereco, reset) is
	begin
		--if (rising_edge(clk)) then
			if (reset = '1') then
				rom <= (
           0 => "00010000000000000001000000000010",
           1 => "00010000000000000010000000000110",
           2 => "00001000100000100011000000000000",
           3 => "00011000100000100100000000000000",
           4 => "00100000100000100101000000000000",
           5 => "00101000100000100110000000000000",
           6 => "00110000100000100111000000000000",
           7 => "00111000100000101000000000000000",
           8 => "01000000100000001001000000111111",
           9 => "01001000100000001010000000000010",
          10 => "01010000100000001011000000000010",
          11 => "01100000000001000000000000000010",
          12 => "01011000000000001100000000000010",
          13 => "01111001000001100000000000000010",
          14 => "00010000000000000001000000011100",
          15 => "10001000010000000000000000000000",
          16 => "01011000000000000001000000000000",
          17 => "01011000000000000010000000000001",
          18 => "10011000100000101101000000000000",
          19 => "10100000100000101110000000000000",
          20 => "10101000100000101111000000000000",
          21 => "01101000100000110000000000000000",
          22 => "10110000100000010001000000000000",
          23 => "10110000010000010010000000000000",
          24 => "10111000010000010011000000000000",
          25 => "10111000100000010100000000000000",
          26 => "10000100011001000000111111110011",
					others => X"00000000"  -- exemplo de uma instrução qualquer de 32 bits
					);
			else
				Instrucao <= rom(to_integer(unsigned(Endereco)));
			end if;
		--end if;
	end process;
end comportamental;
