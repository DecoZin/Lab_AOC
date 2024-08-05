library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_extensor is
end entity tb_extensor;

architecture rtl of tb_extensor is

  component extensor is
	generic (
		largura_dado  : natural := 16;
		largura_saida : natural := 32
	);
	port (
		entrada_Rs : in std_logic_vector((largura_dado - 1) downto 0);
		saida      : out std_logic_vector((largura_saida - 1) downto 0)
	);
  end component;

  signal aux_entrada_Rs : std_logic_vector(15 downto 0) := (others => '0') ;
  signal aux_saida      : std_logic_vector(31 downto 0) := (others => '0') ;
  
begin

  EXTENSOR_Inst: extensor
    port map (
      entrada_Rs  => aux_entrada_Rs,
      saida       => aux_saida      
    );

    STIMULUS: process
    begin
      aux_entrada_Rs <= x"0001";
      wait for 10 ns;
      aux_entrada_Rs <= x"F000";
      wait for 10 ns;
      aux_entrada_Rs <= x"FFFF";
      wait for 10 ns;
      aux_entrada_Rs <= x"0FF0";
      wait for 10 ns;
      aux_entrada_Rs <= x"1001";
      wait for 10 ns;
      aux_entrada_Rs <= x"0000";
      wait for 10 ns;
      wait;
    end process;

end architecture;