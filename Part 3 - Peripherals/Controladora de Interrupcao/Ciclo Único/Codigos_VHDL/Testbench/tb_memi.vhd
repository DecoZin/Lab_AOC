library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real.all;

entity tb_memi is
end entity;

architecture rtl of tb_memi is

  constant INSTR_WIDTH : natural := 32;
  constant MI_ADDR_WIDTH : natural := 7;

  component memi is
    generic (
		INSTR_WIDTH   : natural := 32; -- tamanho da instrucaoo em numero de bits
		MI_ADDR_WIDTH : natural := 7  -- tamanho do endereco da memoria de instrucoes em numero de bits
	);
	port (
		clk       : in std_logic;
		reset     : in std_logic;
		Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1 downto 0);
		Instrucao : out std_logic_vector(INSTR_WIDTH - 1 downto 0)
	);
  end component;

  signal clk_tb       : std_logic := '0';
  signal reset_tb     : std_logic := '0';
  signal Endereco_tb  : std_logic_vector(6 downto 0) := (others => '0'); 
  signal Instrucao_tb : std_logic_vector(31 downto 0);

begin

  MEMI_inst: memi
    port map (
      clk => clk_tb,
      reset => reset_tb,
      Endereco => Endereco_tb,
      Instrucao => Instrucao_tb
    );


-- Processo de clock
process
begin
    while now < 1300 ns loop 
        clk_tb <= '0';
        wait for 5 ns;
        clk_tb <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;


-- Processo de estímulo
process
begin
    reset_tb <= '1';  
    wait for 20 ns;
    reset_tb <= '0';  

    -- Testando leitura de instruções
    for i in 0 to 127 loop
        Endereco_tb <= std_logic_vector(to_unsigned(i, 7));
        wait for 10 ns;
        -- Verificando a saída
        assert Instrucao_tb = X"02000200" or
               Instrucao_tb = X"43024302" or
               Instrucao_tb = X"C423C423" or
               Instrucao_tb = X"21442144" or
               Instrucao_tb = X"00000000"
               report "Valor incorreto na saída Instrucao após " & integer'image(i) & " ciclos."
               severity error;
    end loop;

    wait;
end process;

end architecture;
