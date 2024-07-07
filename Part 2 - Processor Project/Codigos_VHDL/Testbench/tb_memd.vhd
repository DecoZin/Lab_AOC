library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_memd is
end entity tb_memd;

architecture rtl of tb_memd is

  component memd is
    generic (
        number_of_words : natural := 134217728; -- número de words que a sua memória é capaz de armazenar
        MD_DATA_WIDTH   : natural := 32;        -- tamanho da palavra em bits
        MD_ADDR_WIDTH   : natural := 32         -- tamanho do endereco da memoria de dados em bits
    );
    port (
        clk             : in std_logic;
        mem_write       : in std_logic; --sinais do controlador
        write_data_mem  : in std_logic_vector(MD_DATA_WIDTH - 1 downto 0);
        adress_mem      : in std_logic_vector(MD_ADDR_WIDTH - 1 downto 0);
        read_data_mem   : out std_logic_vector(MD_DATA_WIDTH - 1 downto 0)
    );
  end component;

  constant clk_period : time := 10 ns;
  signal clk_generator : boolean := true;
  signal clk   : std_logic := '0'; 

  signal aux_mem_write      : std_logic := '0';
  signal aux_write_data_mem : std_logic_vector(32 - 1 downto 0) := (others => '0') ;
  signal aux_adress_mem     : std_logic_vector(32 - 1 downto 0) := (others => '0') ;
  signal aux_read_data_mem  : std_logic_vector(32 - 1 downto 0) := (others => '0') ;

begin

  MEMD_Inst: memd
    port map (
      clk             =>  clk,
      mem_write       =>  aux_mem_write,
      write_data_mem  =>  aux_write_data_mem,
      adress_mem      =>  aux_adress_mem,
      read_data_mem   =>  aux_read_data_mem      
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

  STIMULUS : process
  begin
    aux_mem_write <= '0';
    wait for clk_period;
    for i in 0 to 500 loop
      aux_mem_write <= not aux_mem_write;
      aux_write_data_mem <= x"F0F0F0F0";
      aux_adress_mem <= std_logic_vector(to_unsigned(i, 32));
      wait for clk_period;
    end loop;
    for i in 0 to 500 loop
      aux_mem_write <= '0';
      aux_adress_mem <= std_logic_vector(to_unsigned(i, 32));
      -- if (i rem 2 = 0) then
      --   assert (aux_read_data_mem /= x"F0F0F0F0")
      --     report "Failed"
      --     severity error;
      -- else
      --   assert (aux_read_data_mem = x"F0F0F0F0")
      --     report "Failed"
      --     severity error;
      -- end if ;
      wait for clk_period;
    end loop;
    wait;
  end process;

end architecture;