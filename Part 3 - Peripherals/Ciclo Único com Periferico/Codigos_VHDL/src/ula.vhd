-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Unidade Lógica e Aritmética com capacidade para 8 operações distintas, além de entradas e saída de dados genérica.
-- Os três bits que selecionam o tipo de operação da ULA são os 3 bits menos significativos do OPCODE (vide aqrquivo: par.xls)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ula is
    generic (
       constant largura_dado : integer := 32;
       constant largura_controle : integer := 5
    );

    port (
        entrada_a : in std_logic_vector((largura_dado     - 1) downto 0);
        entrada_b : in std_logic_vector((largura_dado     - 1) downto 0);
        seletor   : in std_logic_vector((largura_controle - 1) downto 0);
        saida     : out std_logic_vector((largura_dado    - 1) downto 0)
    );
end ula;

architecture comportamental of ula is
  signal resultado_ula : std_logic_vector((largura_dado - 1) downto 0);
  signal alu_control : signed(4 downto 0);
  signal test1 : std_logic_vector((largura_dado - 1) downto 0) := x"00000000";
  signal test2 : std_logic_vector((largura_dado - 1) downto 0) := x"FFFFFFFF";
  signal test_result : std_logic_vector((largura_dado - 1) downto 0) := x"00000000";

begin
  alu_control <= signed(seletor);
  test_result <= test1 and test2;
  process (entrada_a, entrada_b, alu_control) is
    -- Variables for square roots
    variable d : unsigned(31 downto 0):=(others => '0'); --original input.
    variable a : unsigned(31 downto 0):=(others => '0'); --input copy.
    variable q : unsigned(15 downto 0):=(others => '0');  --result.
    --'left' and 'right' are inputs to adder/sub. 'r' is remainder.
    variable left,right,r : unsigned(17 downto 0):=(others => '0');  
    -- variable i : integer:=0;  --loop index
    variable aux_mul    : signed(63 downto 0);
    variable aux_op_c   : signed(31 downto 0);
    variable real_a     : signed((largura_dado / 2 - 1) downto 0);
    variable imag_a     : signed((largura_dado / 2 - 1) downto 0);
    variable real_b     : signed((largura_dado / 2 - 1) downto 0);
    variable imag_b     : signed((largura_dado / 2 - 1) downto 0);
    variable divisor    : signed((largura_dado - 1) downto 0);
    variable dividendor_real : signed((largura_dado - 1) downto 0);
    variable dividendor_imag : signed((largura_dado - 1) downto 0);
    variable aux_op_64 : std_logic_vector(63 downto 0);

    function sqrt_function (x : integer) return integer is
		begin
			return integer(real(sqrt(real(x))));
		end function;


  begin
    real_a := signed(entrada_a((largura_dado - 1) downto (largura_dado / 2)));
    imag_a := signed(entrada_a(((largura_dado / 2) - 1) downto 0));
    real_b := signed(entrada_b((largura_dado - 1) downto (largura_dado / 2)));
    imag_b := signed(entrada_b(((largura_dado / 2) - 1) downto 0));

    case(alu_control) is
      when "00000" => -- adição
      resultado_ula <= std_logic_vector(signed(entrada_a) + signed(entrada_b));
      
      when "00001" => -- subtração
      resultado_ula <= std_logic_vector(signed(entrada_a) - signed(entrada_b));
      
      when "00010" => -- multiplicação
      aux_mul := signed(entrada_a) * signed(entrada_b);
      resultado_ula <= std_logic_vector(aux_mul(31 downto 0));
      
      when "00011" => -- divisão
      if entrada_b = x"00000000" then
        resultado_ula <= x"FFFFFFFF";
      else
        resultado_ula <= std_logic_vector(signed(entrada_a) / signed(entrada_b));
      end if ;
      
      when "00100" => -- adição complexa
      resultado_ula <= std_logic_vector(real_a + real_b) & std_logic_vector(imag_a + imag_b);
      
      when "00101" => -- subtração complexa
      resultado_ula <= std_logic_vector(real_a - real_b) & std_logic_vector(imag_a - imag_b);

      when "00110" => -- multiplicação complexa
      aux_op_c := (real_a * real_b) - (imag_a * imag_b);
      resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(aux_op_c (15 downto 0));
      aux_op_c := (real_a * imag_b) + (imag_a * real_b);
      resultado_ula (((largura_dado / 2) - 1) downto 0) <= std_logic_vector(aux_op_c (15 downto 0));
      
      when "00111" => -- divisão complexa
      divisor         := (real_b * real_b) + (imag_b * imag_b);
      dividendor_real := (real_a * real_b) - (imag_a * (-imag_b));
      dividendor_imag := (real_a * (-imag_b)) + (imag_a * real_b);
      if (divisor = x"00000000") then
        resultado_ula <= x"FFFFFFFF";
      else
        aux_op_c := dividendor_real / divisor;
        resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(aux_op_c (15 downto 0));
        aux_op_c := dividendor_imag / divisor;
        resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(aux_op_c (15 downto 0));
      end if ;
        
      when "01000" => -- módulo
      resultado_ula ((largura_dado - 1) downto 0) <= std_logic_vector(to_unsigned(sqrt_function(to_integer(real_a*real_a + imag_a*imag_a)), 32));
      
      when "01001" => -- conjulgado
      resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(real_a);
      resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(-imag_a);
      
      when "01010" => -- and
      resultado_ula <= entrada_a and entrada_b;
      
      when "01011" => -- or
      resultado_ula <= entrada_a or entrada_b;
      
      when "01100" => -- shift left
      if (to_integer(signed(entrada_b)) > 0) then
        if (to_integer(signed(entrada_b)) > 32) then
        resultado_ula <= x"00000000";
        else
          aux_op_64 := std_logic_vector(signed(entrada_a) * (2 ** to_integer(signed(entrada_b))));
          resultado_ula <= aux_op_64(31 downto 0);
        end if;
      else
        if (to_integer(signed(entrada_b)) < -32) then
        resultado_ula <= x"00000000";
        else
          resultado_ula <= std_logic_vector(signed(entrada_a) / (2 ** (-to_integer(signed(entrada_b)))));
          -- resultado_ula <= aux_op_64(31 downto 0);
        end if;
      end if;
            
      when "01101" => -- shift right
      if (to_integer(signed(entrada_b)) < 0) then
        if (to_integer(signed(entrada_b)) < -32) then
        resultado_ula <= x"00000000";
        else
          aux_op_64 := std_logic_vector(signed(entrada_a) * (2 ** (-to_integer(signed(entrada_b)))));
          resultado_ula <= aux_op_64(31 downto 0);
        end if;
      else
        if (to_integer(signed(entrada_b)) > 32) then
        resultado_ula <= x"00000000";
        else
          resultado_ula <= std_logic_vector(signed(entrada_a) / (2 ** (to_integer(signed(entrada_b)))));
          -- resultado_ula <= aux_op_64(31 downto 0);
        end if;
      end if;     
       
      when "01110" => -- igual
      if (entrada_a = entrada_b) then
          resultado_ula <= x"FFFFFFFF";
      else
          resultado_ula <= x"00000000";
      end if;

      when "01111" => -- maior que
      if (signed(entrada_a) > signed(entrada_b)) then
          resultado_ula <= x"FFFFFFFF";
      else
          resultado_ula <= x"00000000";
      end if;
      
      when "10000" => -- menor que
      if (signed(entrada_a) < signed(entrada_b)) then
          resultado_ula <= x"FFFFFFFF";
      else
          resultado_ula <= x"00000000";
      end if;
      
      when others =>
      resultado_ula <= x"00000000";

      end case;
  end process;
  saida <= resultado_ula;
end comportamental;