library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_mux21 is
end entity;

architecture rtl of tb_mux21 is

  constant largura_dado : natural := 5;

  component mux21 is
    generic (
        largura_dado : natural := 5
    );

    port (
        dado_ent_0, dado_ent_1 : in std_logic_vector((largura_dado - 1) downto 0);
        sele_ent               : in std_logic;
        dado_sai               : out std_logic_vector((largura_dado - 1) downto 0)
    );
  end component;

signal aux_dado_0  : std_logic_vector((largura_dado - 1) downto 0) := "00000";
signal aux_dado_1  : std_logic_vector((largura_dado - 1) downto 0) := "11111";
signal aux_sel     : std_logic := '0';
signal aux_out     : std_logic_vector((largura_dado - 1) downto 0);

begin

  MUX_inst: mux21
    port map (
        dado_ent_0   => aux_dado_0,
        dado_ent_1   => aux_dado_1,
        sele_ent     => aux_sel,
        dado_sai     => aux_out
    );

  process
  begin
    aux_sel <= '0';
    wait for 10 ns;
    aux_sel <= '1';
    wait for 10 ns;
    aux_dado_0 <= "10101";
    aux_dado_1 <= "01010";
    wait for 10 ns;
    aux_sel <= '0';
    wait for 10 ns;
    wait ;
  end process;

end architecture;
