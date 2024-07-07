library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_somador is
end entity;

architecture rtl of tb_somador is

  component somador is
    generic (
		largura_dado : natural := 7
	);

	port (
		entrada_a : in std_logic_vector((largura_dado - 1) downto 0);
		entrada_b : in std_logic_vector((largura_dado - 1) downto 0);
		saida     : out std_logic_vector((largura_dado - 1) downto 0)
	);
  end component;

signal aux_entrada_a  : std_logic_vector((largura_dado - 1) downto 0) := '0000000';
signal aux_entrada_b  : std_logic_vector((largura_dado - 1) downto 0) := '0000011';
signal aux_saida      : std_logic_vector((largura_dado - 1) downto 0)

begin

  SOMADOR_inst: somador
    port map (
        entrada_a   => aux_entrada_a,
        entrada_b   => aux_entrada_b,
        saida       => aux_saida
    );


process
  begin
    aux_entrada_a <= '0000000';
    aux_entrada_b <= '0000001';
    wait for 10 ns;
    aux_entrada_a <= '0000001';
    aux_entrada_b <= '0000001';
    wait for 10 ns;
    aux_entrada_a <= '0011000';
    aux_entrada_b <= '0000011';
    wait for 10 ns;
    aux_entrada_a <= '0001110';
    aux_entrada_b <= '1000001';
    wait for 10 ns;
    wait ;
end process;

end architecture;