library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_ula is
end entity;

architecture rtl of tb_ula is

	component ula is
	port (
		entrada_a	:	in	std_logic_vector(31 downto 0);
		entrada_b	:	in	std_logic_vector(31 downto 0);
		seletor		:	in	std_logic_vector( 4 downto 0);
		saida     :	out	std_logic_vector(31 downto 0)
		);
	end component;

	signal a_in				:	std_logic_vector(31 downto 0);
	signal b_in				:	std_logic_vector(31 downto 0);
	signal sel_in			:	std_logic_vector( 4 downto 0);
	signal out_ula    : std_logic_vector(31 downto 0);

	function sqrt_function (x : integer) return integer is
		begin
			return integer(real(sqrt(real(x))));
		end function;
		
	-- signal flag_read_data  	: std_logic:='0';
	-- signal flag_write      	: std_logic:='0';

	-- file   arquivo_entrada 	: text open read_mode  is "data_in.txt";
	-- file   arquivo_saida1  	: text open write_mode is "saida1.txt";
	-- file   arquivo_saida2  	: text open write_mode is "saida2.txt";

	constant OFFSET     		: time := 10 ns;
	constant OFFSET_WRITE   : time := 12 ns;
	constant MEIO_OFFSET    : time := 5 ns;

	type vetor_int is array (integer range <>) of integer;
	signal vetor  : vetor_int (0 to 10) := (0, 1, 2, 10, 20, 500, -1, -2, -10, -20, -500);
	
begin
	alu_inst:  ula 
	port map (
		entrada_a => a_in, 
		entrada_b => b_in, 
		seletor => sel_in, 
		saida => out_ula
		);
		
		-- teste de adicao
	process
  	variable a_real   : integer := 0;
	  variable a_imag   : integer := 0;
	  variable b_real   : integer := 0;
	  variable b_imag   : integer := 0;
    variable divisor  : integer := 0;
    variable dividendor_real  : integer := 0;
    variable dividendor_imag  : integer := 0;
    variable div_result_real : integer := 0;
    variable div_result_imag : integer := 0;
    variable aux_op    : std_logic_vector(31 downto 0) := x"00000000";
    variable aux_op_64 : std_logic_vector(63 downto 0) := x"0000000000000000";

	begin
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "00000";
      wait for MEIO_OFFSET;			
      assert out_ula = std_logic_vector(to_signed(i+vetor(i),32)) 
        report "Erro no teste de adicao" 
        severity error;
      wait for MEIO_OFFSET;
		end loop;
		wait for OFFSET;

	-- teste de subtracao
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "00001";
			wait for MEIO_OFFSET;
			assert out_ula = std_logic_vector(to_signed(i-vetor(i),32)) 
        report "Erro no teste de subtracao" 
        severity error;
      wait for MEIO_OFFSET;
		end loop;
		wait for OFFSET;

	-- teste de multiplicacao	
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "00010";
      wait for MEIO_OFFSET;			
			assert out_ula = std_logic_vector(to_signed(i*vetor(i),32)) 
        report "Erro no teste de multiplicacao. Result: "   & integer'image(to_integer(signed(out_ula))) & 
                                              " Expected: " & integer'image(i*vetor(i))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste de divisao
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "00011";
      wait for MEIO_OFFSET;			
      if vetor(i) = 0 then
        assert out_ula = x"FFFFFFFF" 
          report "Erro no teste de divisao. Result:   " & integer'image(to_integer(signed(out_ula))) & 
                                          " Expected: " & integer'image(-1)                         
          severity error;
      else
        assert out_ula = std_logic_vector(to_signed(i/vetor(i),32)) 
          report "Erro no teste de divisao. Result:   " & integer'image(to_integer(signed(out_ula))) & 
                                          " Expected: " & integer'image(i/vetor(i))                    
          severity error;
      wait for MEIO_OFFSET;			
      end if ;
		end loop;
		wait for OFFSET;

	-- teste de adicao complexa
		for i in 0 to 10 loop
			a_real := i;
			a_imag := i;
			b_real := vetor(i);
			b_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
			b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
			sel_in <= "00100";
      wait for MEIO_OFFSET;			
			assert out_ula(31 downto 16) = std_logic_vector(to_signed(i + vetor(i), 16)) 
        report "Erro no teste de adicao complexa, parte Real. Result: "   & integer'image(to_integer(signed(out_ula(31 downto 16)))) & 
                                                            " Expected: " & integer'image(i + vetor(i))
        severity error;
			assert out_ula(15 downto  0) = std_logic_vector(to_signed(i + vetor(i), 16)) 
        report "Erro no teste de adicao complexa, parte Imaginaria. Result: "   & integer'image(to_integer(signed(out_ula(15 downto  0)))) & 
                                                                  " Expected: " & integer'image(i + vetor(i))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste de subtracao complexa
		for i in 0 to 10 loop
			a_real := i;
			a_imag := i;
			b_real := vetor(i);
			b_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
			b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
			sel_in <= "00101";
      wait for MEIO_OFFSET;			
			assert out_ula(31 downto 16) = std_logic_vector(to_signed(i - vetor(i), 16)) 
        report "Erro no teste de subtracao complexa, parte Real. Result: " & integer'image(to_integer(signed(out_ula(31 downto 16)))) & 
                                                             " Expected: "  & integer'image(i - vetor(i))
        severity error;
			assert out_ula(15 downto  0) = std_logic_vector(to_signed(i - vetor(i), 16)) 
        report "Erro no teste de subtracao complexa, parte Imaginaria. Result: " & integer'image(to_integer(signed(out_ula(15 downto  0)))) & 
                                                                   " Expected: "  & integer'image(i - vetor(i))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste de multiplicacao complexa
		for i in 0 to 10 loop
			a_real := i;
			a_imag := i;
			b_real := vetor(i);
			b_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
			b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
			sel_in <= "00110";
      wait for MEIO_OFFSET;			
			assert out_ula(31 downto 16) = std_logic_vector(to_signed((i * vetor(i)) - (i * vetor(i)), 16)) 
        report "Erro no teste de multiplicacao complexa, parte Real. Result: " & integer'image(to_integer(signed(out_ula(31 downto 16)))) & 
                                                             " Expected: "  & integer'image((i * vetor(i)) - (i * vetor(i)))
        severity error;
			assert out_ula(15 downto  0) = std_logic_vector(to_signed((i * vetor(i)) + (i * vetor(i)), 16)) 
        report "Erro no teste de multiplicacao complexa, parte Imaginaria. Result: " & integer'image(to_integer(signed(out_ula(15 downto  0)))) & 
                                                                   " Expected: "  & integer'image((i * vetor(i)) + (i * vetor(i)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste de divisao complexa
		for i in 0 to 10 loop
			a_real := i;
			a_imag := i;
			b_real := vetor(i);
			b_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
			b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
			sel_in <= "00111";

			divisor := (b_real * b_real) + (b_imag * b_imag);
			dividendor_real := (a_real * b_real) - (a_imag * (-b_imag));
			dividendor_imag := (a_real * (-b_imag)) + (a_imag * b_real);
      if (divisor = 0) then
        div_result_real :=  -1;
        div_result_imag :=  -1;
      else
        div_result_real := dividendor_real/divisor;
        div_result_imag := dividendor_imag/divisor;
      end if;

      wait for MEIO_OFFSET;		
			assert out_ula(31 downto 16) = std_logic_vector(to_signed(div_result_real, 16))
        report "Erro no teste de Divisao complexa, parte Real. Result: " & integer'image(to_integer(signed(out_ula(31 downto 16)))) & 
                                                             " Expected: "  & integer'image(div_result_real)
        severity error;
			assert out_ula(15 downto  0) = std_logic_vector(to_signed(div_result_imag, 16)) 
        report "Erro no teste de Divisao complexa, parte Imaginaria. Result: " & integer'image(to_integer(signed(out_ula(15 downto  0)))) & 
                                                                   " Expected: "  & integer'image(div_result_imag)
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste módulo
		for i in 0 to 10 loop
			a_real := i;
			a_imag := i;
			b_real := vetor(i);
			b_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(a_real,16)) & std_logic_vector(to_signed(a_imag,16));
			b_in <= std_logic_vector(to_signed(b_real,16)) & std_logic_vector(to_signed(b_imag,16));
			sel_in <= "01000";
      wait for MEIO_OFFSET;			
			assert out_ula(31 downto 16) = std_logic_vector(to_signed(sqrt_function(a_real*a_real + a_imag*a_imag),16))
				report "Erro no teste de modulo complexa. Result: " & integer'image(to_integer(signed(out_ula(31 downto  16)))) & 
                                              " Expected: "  & integer'image(sqrt_function(a_real*a_real + a_imag*a_imag))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste conjugado
		for i in 0 to 10 loop
			a_real := i;
			a_imag := vetor(i);
			a_in <= std_logic_vector(to_signed(i,16)) & std_logic_vector(to_signed(vetor(i),16));
			sel_in <= "01001";
      wait for MEIO_OFFSET;			
			assert out_ula = std_logic_vector(to_signed(i,16)) & 
							std_logic_vector(to_signed(-vetor(i),16))
				report "Erro no teste de conjugado" 
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste and
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
      sel_in <= "01010";
      aux_op := std_logic_vector(to_signed(i,32)) and std_logic_vector(to_signed(vetor(i),32));
      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de and. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste or
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "01011";
      aux_op := std_logic_vector(to_signed(i,32)) or std_logic_vector(to_signed(vetor(i),32));
      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de or. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste SLL
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "01100";
      if (vetor(i) > 0) then
        if (to_signed(vetor(i), 32) > 32) then
        aux_op := x"00000000";
        else
          aux_op_64 := std_logic_vector(to_signed(i,32) * (2 ** vetor(i)));
          aux_op    := aux_op_64(31 downto 0);
        end if;
      else
        if (-(to_signed(vetor(i), 32)) > 32) then
        aux_op := x"00000000";
        else
          aux_op := std_logic_vector(to_signed(i,32) / (2 ** (-vetor(i))));
          -- aux_op    := aux_op_64(31 downto 0);
        end if;
      end if;
      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de or. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste SRL
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "01101";
      if (vetor(i) < 0) then
        if (to_signed(vetor(i), 32) < -32) then
        aux_op := x"00000000";
        else
          aux_op_64 := std_logic_vector(to_signed(i,32) * (2 ** (-vetor(i))));
          aux_op    := aux_op_64(31 downto 0);
        end if;
      else
        if (to_signed(vetor(i), 32) > 32) then
        aux_op := x"00000000";
        else
          aux_op := std_logic_vector(to_signed(i,32) / (2 ** vetor(i)));
          -- aux_op    := aux_op_64(31 downto 0);
        end if;
      end if;
      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de or. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;


	-- teste =
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "01110";
			if (a_in = b_in) then
				aux_op := x"FFFFFFFF";
			else
				aux_op := x"00000000";
			end if; 

      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de igual. Result: " & integer'image(to_integer(signed(out_ula))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste >
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "01111";

			if (a_in > b_in) then
				aux_op := x"FFFFFFFF";
			else
				aux_op := x"00000000";
			end if; 

      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de maior que. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait for OFFSET;

	-- teste <
		for i in 0 to 10 loop
			a_in <= std_logic_vector(to_signed(i,32));
			b_in <= std_logic_vector(to_signed(vetor(i),32));
			sel_in <= "10000";

			if (a_in < b_in) then
				aux_op := x"FFFFFFFF";
			else
				aux_op := x"00000000";
			end if; 

      wait for MEIO_OFFSET;			
			assert out_ula = aux_op
				report "Erro no teste de menor que. Result: " & integer'image(to_integer(signed(out_ula(31 downto  0)))) & 
                                              " Expected: " & integer'image(to_integer(signed(aux_op)))
        severity error;
      wait for MEIO_OFFSET;			
		end loop;
		wait;
	end process;

end rtl;
