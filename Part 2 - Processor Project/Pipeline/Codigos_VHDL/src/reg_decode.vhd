-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Registrador de carga paralela de tamanho genérico com WE e reset síncrono em nível lógico 1
library ieee;
use ieee.std_logic_1164.all;

entity reg_decode is
  generic (
      largura_dado : natural := 32;
      pc_width     : natural :=  7
    );
    port (
      entrada_instrucao  : in std_logic_vector((largura_dado - 1) downto 0);
      pc_next_in         : in std_logic_vector((pc_width     - 1) downto 0);
      WE, clk, reset     : in std_logic;
      saida_instrucao    : out std_logic_vector((largura_dado - 1) downto 0);
      pc_next_out        : out std_logic_vector((pc_width     - 1) downto 0)
    );
end reg_decode;

architecture comportamental of reg_decode is
begin
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (WE = '1') then
                saida_instrucao <= entrada_instrucao;
                pc_next_out     <= pc_next_in;
            end if;
            if (reset = '1') then
                saida_instrucao <= (others =>'0');
                pc_next_out     <= (others =>'0');
            end if;
        end if;
    end process;
end comportamental;
