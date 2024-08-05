library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_unidade_de_controle_ciclo_unico is
end entity tb_unidade_de_controle_ciclo_unico;

architecture rtl of tb_unidade_de_controle_ciclo_unico is

  component unidade_de_controle_ciclo_unico is
    generic (
        INSTR_WIDTH       : natural := 32;
        OPCODE_WIDTH      : natural := 5;
        DP_CTRL_BUS_WIDTH : natural := 7;
        ULA_CTRL_WIDTH    : natural := 5
    );
    port (
        instrucao : in std_logic_vector(INSTR_WIDTH - 1 downto 0);          -- instrução
        controle  : out std_logic_vector(DP_CTRL_BUS_WIDTH - 1 downto 0);    -- controle da via
        alu_ctrl  : out std_logic_vector(ULA_CTRL_WIDTH - 1 downto 0)       -- Controle da ALU
    );
  end component;

  signal aux_instrucao : std_logic_vector (31 downto 0); 
  signal aux_controle : std_logic_vector (6 downto 0); 
  signal aux_alu_ctrl : std_logic_vector (4 downto 0); 

begin

  CTRL_inst: unidade_de_controle_ciclo_unico
    port map (
      instrucao =>  aux_instrucao,
      controle  =>  aux_controle,
      alu_ctrl  =>  aux_alu_ctrl
    );

  STIMULUS: process
  begin
    aux_instrucao(31 downto 27) <= "00001";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00010";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00011";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00100";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00101";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00110";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "00111";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01000";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01001";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01010";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01011";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01100";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01101";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01110";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "01111";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10000";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10001";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10010";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10011";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10100";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10101";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10110";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    aux_instrucao(31 downto 27) <= "10111";
    aux_instrucao(26 downto 0)  <= (others => '0');
    wait for 10 ns; 
    wait;
  end process;

end architecture;