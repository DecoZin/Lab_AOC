library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_and_port is
end entity;

architecture rtl of tb_and_port is

  component and_port is
    port (
        entrada1  :   in std_logic;
        entrada2  :   in std_logic;
        saida     :   out std_logic
    );
  end component;

signal in_a : std_logic := '0';
signal in_b : std_logic := '0';
signal out_1  : std_logic := '0';

begin

  AND_inst: and_port
    port map (
      entrada1  => in_a,
      entrada2  => in_b,
      saida     => out_1
    );

  process
  begin
    in_a <= '0';
    in_b <= '0';
    wait for 10 ns;
    in_a <= '1';
    in_b <= '0';
    wait for 10 ns;
    in_a <= '1';
    in_b <= '1';
    wait for 10 ns;
    in_a <= '0';
    in_b <= '1';
    wait for 10 ns;
    wait ;
  end process;

end architecture;