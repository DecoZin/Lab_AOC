library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity tb_deslocador is
end entity tb_deslocador;

architecture rtl of tb_deslocador is

  component deslocador is
    generic (
		largura_dado : natural := 32;
		largura_qtde : natural :=  5
	);

	port (
		ent_rs_dado           : in std_logic_vector((largura_dado - 1) downto 0);
		ent_rt_ende           : in std_logic_vector((largura_qtde - 1) downto 0); -- o campo de endereços de rt, representa a quantidade a ser deslocada nesse contexto.
		ent_tipo_deslocamento : in std_logic_vector(1 downto 0);
		sai_rd_dado           : out std_logic_vector((largura_dado - 1) downto 0)
	);
  end component;

begin

  

end architecture;