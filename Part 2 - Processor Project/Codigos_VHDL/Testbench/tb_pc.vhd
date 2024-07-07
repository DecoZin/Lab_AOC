library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_pc is
end entity;

architecture rtl of tb_pc is

  component pc is
    generic (
		PC_WIDTH : natural:= 7 
	);
	port (
		entrada : in std_logic_vector (PC_WIDTH - 1 downto 0);
		saida   : out std_logic_vector(PC_WIDTH - 1 downto 0);
		clk     : in std_logic;
		we      : in std_logic;
		reset   : in std_logic
	);
  end component;

signal aux_entrada  : std_logic_vector (PC_WIDTH - 1 downto 0) := '1111111';
signal aux_saida    : std_logic_vector (PC_WIDTH - 1 downto 0);
signal CLK_tb       : std_logic := '0';
signal aux_we       : std_logic := '1';
signal aux_reset    : std_logic := '0';

begin

  PC_inst: pc
    port map (
        entrada   => aux_entrada,
        clk       => CLK_tb,
        saida     => aux_saida,
        we        => aux_we,
        reset     => aux_reset
    );


process
    begin
        CLK_tb <= '0';
        wait for 5 ns;
        CLK_tb <= '1';
        wait for 5 ns;
        CLK_tb <= '0';
        wait for 5 ns;
        CLK_tb <= '1';
        wait for 5 ns;
end process;



process
  begin
    aux_entrada <= '1111111';
    wait for 10 ns;
    aux_entrada <= '1000001';
    wait for 10 ns;
    aux_entrada <= '1011001';
    wait for 10 ns;
    aux_reset <= '1';
    wait for 10 ns;
    wait ;
end process;

end architecture;