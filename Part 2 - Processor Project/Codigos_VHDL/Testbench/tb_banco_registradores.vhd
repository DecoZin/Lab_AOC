library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_banco_registradores is
end entity;

architecture rtl of tb_banco_registradores is

  component banco_registradores is
    generic (
        largura_dado : natural := 32;
        largura_ende : natural := 5
    );
    port (
        ent_Rs_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rt_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rd_ende : in std_logic_vector((largura_ende - 1) downto 0);
        ent_Rd_dado : in std_logic_vector((largura_dado - 1) downto 0);
        sai_Rs_dado : out std_logic_vector((largura_dado - 1) downto 0);
        sai_Rt_dado : out std_logic_vector((largura_dado - 1) downto 0);
        clk, WE     : in std_logic
    );
  end component;

  constant largura_dado : natural := 32;
  constant largura_ende : natural := 5;

  constant clk_period : time := 100 ns;
  constant signal_input_period : time := 200 us;
  signal clk_generator : boolean := true;
  signal clk   : std_logic := '0'; -- 10 MHz

  signal aux_ent_Rs_ende :  std_logic_vector((largura_ende - 1) downto 0);
  signal aux_ent_Rt_ende :  std_logic_vector((largura_ende - 1) downto 0);
  signal aux_ent_Rd_ende :  std_logic_vector((largura_ende - 1) downto 0);
  signal aux_ent_Rd_dado :  std_logic_vector((largura_dado - 1) downto 0);
  signal aux_sai_Rs_dado :  std_logic_vector((largura_dado - 1) downto 0);
  signal aux_sai_Rt_dado :  std_logic_vector((largura_dado - 1) downto 0);

begin

  AND_inst: banco_registradores
    port map (
      ent_Rs_ende =>  aux_ent_Rs_ende,
      ent_Rt_ende =>  aux_ent_Rt_ende,
      ent_Rd_ende =>  aux_ent_Rd_ende,
      ent_Rd_dado =>  aux_ent_Rd_dado,
      sai_Rs_dado =>  aux_sai_Rs_dado,
      sai_Rt_dado =>  aux_sai_Rt_dado,
      clk =>  clk,
      WE  =>  '1'
    );

  CLOCK_GENERATOR: process
  begin
    while (clk_generator) loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;

  STIMULUS: process
  begin
    -- Testing Writing:
    for i in 0 to 31 loop
      aux_ent_Rd_ende <= std_logic_vector(to_unsigned(i, 5));
      aux_ent_Rd_dado <= std_logic_vector(to_unsigned(i, 32));
      wait for clk_period;
    end loop;

    -- Testing Reading:
    for i in 0 to 31 loop
      aux_ent_Rs_ende <= std_logic_vector(to_unsigned(i, 5));
      aux_ent_Rt_ende <= std_logic_vector(to_unsigned(i, 5));
      wait for clk_period;
    end loop;
    wait ;
  end process;

end architecture;