-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Unidade Lógica e Aritmética com capacidade para 8 operações distintas, além de entradas e saída de dados genérica.
-- Os três bits que selecionam o tipo de operação da ULA são os 3 bits menos significativos do OPCODE (vide aqrquivo: par.xls)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    generic (
        largura_dado : natural := 32;
        largura_controle : natural := 5
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
    signal real_a : signed;
    signal imag_a : signed;
    signal real_b : signed;
    signal imag_b : signed;
    signal divisor : signed;
    signal dividendor_real : signed;
    signal dividendor_imag : signed;

begin
    real_a <= signed(entrada_a((largura_dado - 1) downto (largura_dado / 2)));
    imag_a <= signed(entrada_a(((largura_dado / 2) - 1) downto 0));
    real_b <= signed(entrada_b((largura_dado - 1) downto (largura_dado / 2)));
    imag_b <= signed(entrada_b(((largura_dado / 2) - 1) downto 0));
    process (entrada_a, entrada_b, seletor) is
        -- Variables for square roots
        variable d : unsigned(31 downto 0):=(others => '0'); --original input.
        variable a : unsigned(31 downto 0):=(others => '0'); --input copy.
        variable q : unsigned(15 downto 0):=(others => '0');  --result.
        --'left' and 'right' are inputs to adder/sub. 'r' is remainder.
        variable left,right,r : unsigned(17 downto 0):=(others => '0');  
        variable i : integer:=0;  --loop index
    begin
        case(seletor) is
            when "00000" => -- adição
            resultado_ula <= std_logic_vector(signed(entrada_a) + signed(entrada_b));
            
            when "00001" => -- subtração
            resultado_ula <= std_logic_vector(signed(entrada_a) - signed(entrada_b));
            
            when "00010" => -- multiplicação
            resultado_ula <= std_logic_vector(signed(entrada_a) * signed(entrada_b));
            
            when "00011" => -- divisão
            resultado_ula <= std_logic_vector(signed(entrada_a) / signed(entrada_b));
            
            when "00100" => -- adição complexa
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(real_a + real_b);
            resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(imag_a + imag_b);
            
            when "00101" => -- subtração complexa
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(real_a - real_b);
            resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(imag_a - imag_b);

            when "00110" => -- multiplicação complexa
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector((real_a * real_b) - (imag_a * imag_b));
            resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector((real_a * imag_b) + (imag_a * real_b));
            
            when "00111" => -- divisão complexa
            divisor <= (real_b * real_b) + (imag_b * imag_b);
            dividendor_real <= (real_a * real_b) - (imag_a * (-imag_b));
            dividendor_imag <= (real_a * (-imag_b)) + (imag_a * real_b);
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(dividendor_real / divisor);
            resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(dividendor_imag / divisor);
            
            when "01000" => -- módulo
            d := unsigned(std_logic_vector((real_a * real_a) + (imag_a * imag_a)));
            a := d;
            for i in 0 to 15 loop  --iterate 16 times.
                right := q & r(17) & '1';  --'&' is used for concatenation in VHDL
                left := r(15 downto 0) & a(31 downto 30);
                a := a(29 downto 0) & "00";  --shifting left by 2 bit.
                if ( r(17) = '1') then
                    r := left + right; --add
                else
                    r := left - right; --subtract
                end if;
                q := q(14 downto 0) & not r(17);  --left shift and pad msb of 'r'
            end loop;
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= q;  --assign output
            a := d-q*q;  --calculate remainder manually
            resultado_ula (((largura_dado / 2) - 1) downto 0) <= a(15 downto 0);  --take only lsb 16 bits for output.
            
            when "01001" => -- conjulgado
            resultado_ula ((largura_dado - 1) downto (largura_dado / 2)) <= std_logic_vector(real_a);
            resultado_ula (((largura_dado / 2) - 1) downto 0)            <= std_logic_vector(-imag_b);
            
            when "01010" => -- and
            resultado_ula <= entrada_a and entrada_b;
            
            when "01011" => -- or
            resultado_ula <= entrada_a or entrada_b;
            
            when "01100" => -- shift left
            resultado_ula <= entrada_a sll entrada_b;
            
            when "01101" => -- shift right
            resultado_ula <= entrada_a srl entrada_b;
            
            when "01110" => -- igual
            if (entrada_a = entrada_b) then
                resultado_ula <= "11111111111111111111111111111111";
            else
                resultado_ula <= "00000000000000000000000000000000";
            end if;

            when "01111" => -- maior que
            if (entrada_a > entrada_b) then
                resultado_ula <= "11111111111111111111111111111111";
            else
                resultado_ula <= "00000000000000000000000000000000";
            end if;
            
            when "10000" => -- menor que
            if (entrada_a < entrada_b) then
                resultado_ula <= "11111111111111111111111111111111";
            else
                resultado_ula <= "00000000000000000000000000000000";
            end if;
            
            when others =>
            resultado_ula <= std_logic_vector(0);

        end case;
    end process;
    saida <= resultado_ula;
end comportamental;