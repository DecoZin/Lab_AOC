library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_ula is
end tb_ula;

architecture tb of tb_ula is
component ula is
port (
	entrada_a	:	in	std_logic_vector(31 downto 0);
	entrada_b	:	in	std_logic_vector(31 downto 0);
	seletor		:	in	std_logic_vector(4 downto 0);
	saida		:	out	std_logic_vector(31 downto 0)
	);
end component;

signal a_in				:	std_logic_vector(31 downto 0);
signal b_in				:	std_logic_vector(31 downto 0);
signal sel_in			:	std_logic_vector(4 downto 0);
signal out_ula			: 	std_logic_vector(31 downto 0);

-- signal flag_read_data  	: std_logic:='0';
-- signal flag_write      	: std_logic:='0';

-- file   arquivo_entrada 	: text open read_mode  is "data_in.txt";
-- file   arquivo_saida1  	: text open write_mode is "saida1.txt";
-- file   arquivo_saida2  	: text open write_mode is "saida2.txt";

constant OFFSET     		: time := 10 ns;
constant OFFSET_WRITE   : time := 12 ns;
constant MEIO_OFFSET    : time := 5 ns;

type vetor_int is array (integer range <>) of integer;
signal vetor			: vetor_int (0 to 10) := (0, 1, 2, 10, 20, 500, -1, -2, -10, -20, -500);

begin
instancia	: ula port map (entrada_a=>a_in, entrada_b=>b_in, seletor=>sel_in, saida=>out_ula);

-- teste de adição
process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(vetor(i),32));
		sel_in <= "00000";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i+vetor(i),32)) report "Erro no teste de adição" severity error;
	end loop;
	wait;
end process;

-- teste de subtração
process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(vetor(i),32));
		sel_in <= "00001";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i+vetor(i),32)) report "Erro no teste de subtração" severity error;
	end loop;
	wait;
end process;

-- teste de multiplicação
process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(vetor(i),32));
		sel_in <= "00010";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i*vetor(i),32)) report "Erro no teste de multiplicação" severity error;
	end loop;
	wait;
end process;

-- teste de divisão
process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(vetor(i),32));
		sel_in <= "00011";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i/vetor(i),32)) report "Erro no teste de divisão" severity error;
	end loop;
	wait;
end process;

-- teste de adição complexa
process
begin
	for i in 0 to 10 loop
		a_real <= i;
		a_imag <= i;
		b_real <= vetor(i);
		b_imag <= vetor(10 - i);
		a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
		b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
		sel_in <= "00100";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(a_real + b_real,16)) & 
						 std_logic_vector(to_signed(a_imag + b_imag),16);
			report "Erro no teste de adição complexa" severity error;
	end loop;
	wait;
end process;

-- teste de subtração complexa
process
begin
	for i in 0 to 10 loop
		a_real <= i;
		a_imag <= i;
		b_real <= vetor(i);
		b_imag <= vetor(10 - i);
		a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
		b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
		sel_in <= "00101";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(a_real - b_real,16)) & 
						 std_logic_vector(to_signed(a_imag - b_imag),16);
			report "Erro no teste de subtração complexa" severity error;
	end loop;
	wait;
end process;

-- teste de multiplicação complexa
process
begin
	for i in 0 to 10 loop
		a_real <= i;
		a_imag <= i;
		b_real <= vetor(i);
		b_imag <= vetor(10 - i);
		a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
		b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
		sel_in <= "00110";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(((a_real * b_real) - (a_imag * b_imag)),16)) & 
						 std_logic_vector(to_signed(((a_real * b_imag) + (a_imag * b_real)),16));
			report "Erro no teste de multiplicação complexa" severity error;
	end loop;
	wait;
end process;

-- teste de divisão complexa
process
begin
	for i in 0 to 10 loop
		a_real <= i;
		a_imag <= i;
		b_real <= vetor(i);
		b_imag <= vetor(10 - i);
		a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
		b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
		sel_in <= "00111";

		divisor <= (b_real * b_real) + (b_imag * b_imag);
		dividendor_real <= (a_real * b_real) - (a_imag * (-b_imag));
		dividendor_imag <= (a_real * (-b_imag)) + (a_imag * b_real);

		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(dividendor_real / divisor,16)) & 
						 std_logic_vector(to_signed(dividendor_imag / divisor,16)); 
			report "Erro no teste de divisão complexa" severity error;
	end loop;
	wait;
end process;

-- teste módulo
process
begin
	for i in 0 to 10 loop
		sel_in <= "01000";
	end loop;
	wait;
end process;

-- teste conjugado
process
begin
	for i in 0 to 10 loop
		a_real <= i;
		a_imag <= vetor(i);
		a_in <= std_logic_vector(to_signed(i,32)) & std_logic_vector(to_signed(vetor(i),32));
		sel_in <= "01001";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i,32)) & 
						 std_logic_vector(to_signed(-vetor(i),32))
			report "Erro no teste de conjugado" severity error;
	end loop;
end process;

-- teste and

process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(20,32));
		sel_in <= "01010";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i and 20,32)) 
			report "Erro no teste de and" severity error;
	end loop;
	wait;
end process;

-- teste or
process
begin
	for i in 0 to 10 loop
		a_in <= std_logic_vector(to_signed(i,32));
		b_in <= std_logic_vector(to_signed(20,32));
		sel_in <= "01011";
		wait for OFFSET;
		assert out_ula = std_logic_vector(to_signed(i or 20,32)) 
			report "Erro no teste de or" severity error;
	end loop;
	wait;
end process;

end tb;
