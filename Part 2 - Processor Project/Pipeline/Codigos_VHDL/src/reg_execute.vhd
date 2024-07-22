-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Registrador de carga paralela de tamanho genérico com WE e reset síncrono em nível lógico 1
library ieee;
use ieee.std_logic_1164.all;

entity reg_execute is
    generic (
        largura_dado  : natural := 32;
        largura_banco : natural := 5
    );
    port (
        addr_in        : in std_logic_vector((largura_dado - 1) downto 0);
        data_in        : in std_logic_vector((largura_dado - 1) downto 0);

        RegWriteE      : in std_logic;
        MemtoRegE      : in std_logic;
        MemWriteE      : in std_logic;

        reg_dst_in     : in std_logic_vector((largura_banco - 1) downto 0);
        WE, clk, reset : in std_logic;
        addr_out       : out std_logic_vector((largura_dado - 1) downto 0);
        data_out       : out std_logic_vector((largura_dado - 1) downto 0);
        reg_dst_out    : out std_logic_vector((largura_banco - 1) downto 0);

        RegWriteM      : out std_logic;
        MemtoRegM      : out std_logic;
        MemWriteM      : out std_logic

    );
end reg_execute;

architecture comportamental of reg_execute is
begin
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (WE = '1') then
                addr_out    <= addr_in;
                data_out    <= data_in;
                reg_dst_out <= reg_dst_in;
                RegWriteM   <= RegWriteE;
                MemtoRegM   <= MemtoRegE;
                MemWriteM   <= MemWriteE;

            end if;
            if (reset = '1') then
                addr_out    <= (others =>'0');
                data_out    <= (others =>'0');
                reg_dst_out <= (others =>'0');
                RegWriteM   <= '0';
                MemtoRegM   <= '0';
                MemWriteM   <= '0';
            end if;
        end if;
    end process;
end comportamental;

