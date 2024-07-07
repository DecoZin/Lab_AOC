library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_mux41 is
end entity;

architecture rtl of tb_mux41 is

  component mux41 is
    generic (
        largura_dado : natural := 5
    );

    port (
        dado_ent_0, dado_ent_1, dado_ent_2, dado_ent_3 : in std_logic_vector((largura_dado - 1) downto 0);
        sele_ent                                       : in std_logic_vector(1 downto 0);
        dado_sai                                       : out std_logic_vector((largura_dado - 1) downto 0)              : out std_logic_vector((largura_dado - 1) downto 0)
    );
  end component;

signal aux_dado_0  : std_logic_vector((largura_dado - 1) downto 0) := '00000';
signal aux_dado_1  : std_logic_vector((largura_dado - 1) downto 0) := '00001';
signal aux_dado_2  : std_logic_vector((largura_dado - 1) downto 0) := '00010';
signal aux_dado_3  : std_logic_vector((largura_dado - 1) downto 0) := '00011';
signal aux_sel     : std_logic_vector(1 downto 0) := '00';
signal aux_out     : std_logic_vector((largura_dado - 1) downto 0);

begin

  MUX41_inst: mux41
    port map (
        dado_ent_0   => aux_dado_0,
        dado_ent_1   => aux_dado_1,
        dado_ent_2   => aux_dado_2,
        dado_ent_3   => aux_dado_3,
        sele_ent     => aux_sel,
        dado_sai     => aux_out
    );

  process
  begin
    aux_sel <= '00';
    wait for 10 ns;
    aux_sel <= '01';
    wait for 10 ns;
    aux_sel <= '10';
    wait for 10 ns;
    aux_sel <= '11';
    wait for 10 ns;
    wait ;
  end process;

end architecture;