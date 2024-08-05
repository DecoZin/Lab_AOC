-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Unidade de controle ciclo único (look-up table) do processador
-- puramente combinacional
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- unidade de controle
entity unidade_de_controle_ciclo_unico is
    generic (
        INSTR_WIDTH       : natural := 32;
        OPCODE_WIDTH      : natural := 5;
        DP_CTRL_BUS_WIDTH : natural := 7;
        ULA_CTRL_WIDTH    : natural := 5
    );
    port (
        instrucao : in std_logic_vector(INSTR_WIDTH - 1 downto 0);          -- instrução
        controle  : out std_logic_vector(DP_CTRL_BUS_WIDTH - 1 downto 0);    -- controle da via
        alu_ctrl  : out std_logic_vector(ULA_CTRL_WIDTH - 1 downto 0)       -- Controle da ALU
    );
end unidade_de_controle_ciclo_unico;

architecture beh of unidade_de_controle_ciclo_unico is
    -- As linhas abaixo não produzem erro de compilação no Quartus II, mas no Modelsim (GHDL) produzem.	
    --signal inst_aux : std_logic_vector (INSTR_WIDTH-1 downto 0);			-- instrucao
    --signal opcode   : std_logic_vector (OPCODE_WIDTH-1 downto 0);			-- opcode
    --signal ctrl_aux : std_logic_vector (DP_CTRL_BUS_WIDTH-1 downto 0);		-- controle

    signal inst_aux : std_logic_vector (31 downto 0); -- instrucao
    signal opcode   : std_logic_vector (4 downto 0);  -- opcode
    signal ctrl_aux : std_logic_vector (6 downto 0);  -- controle
    signal ctrl_ula : std_logic_vector (4 downto 0);  -- controle da alu

begin
    inst_aux <= instrucao;
    -- A linha abaixo não produz erro de compilação no Quartus II, mas no Modelsim (GHDL) produz.	
    --	opcode <= inst_aux (INSTR_WIDTH-1 downto INSTR_WIDTH-OPCODE_WIDTH);
    opcode <= inst_aux (31 downto 27);

    process (opcode)
    begin
        case opcode is
                -- ADD	
            when "00001" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00000";
            
                -- ADDI	
            when "00010" =>
                ctrl_aux <= "0101000";
                ctrl_ula <= "00000";
            
                -- SUB	
            when "00011" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00001";
            
                -- MUL	
            when "00100" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00010";
            
                -- DIV
            when "00101" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00011";
            
                -- AND	
            when "00110" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "01010";
            
                -- OR	
            when "00111" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "01011";
            
                -- ANDI	
            when "01000" =>
                ctrl_aux <= "0101000";
                ctrl_ula <= "01010";
            
                -- SLL	
            when "01001" =>
                ctrl_aux <= "0101000";
                ctrl_ula <= "01100";
            
                -- SRL	
            when "01010" =>
                ctrl_aux <= "0101000";
                ctrl_ula <= "01101";
            
                -- LW	
            when "01011" =>
                ctrl_aux <= "0101001";
                ctrl_ula <= "00000";
            
                -- SW	
            when "01100" =>
                ctrl_aux <= "0001010";
                ctrl_ula <= "00000";
            
                -- DIVC	
            when "01101" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00111";
            
                -- BEQ	
            when "01110" =>
                ctrl_aux <= "0000100";
                ctrl_ula <= "01110";
            
                -- BLT	
            when "01111" =>
                ctrl_aux <= "0000100";
                ctrl_ula <= "10000";
            
                -- BGT	
            when "10000" =>
                ctrl_aux <= "0000100";
                ctrl_ula <= "01111";
            
                -- JMP	
            when "10001" =>
                ctrl_aux <= "1001000";
                ctrl_ula <= "00000";
            
                -- JAL	
            when "10010" =>
                ctrl_aux <= "1110000";
                ctrl_ula <= "00000";
            
                -- ADDC	
            when "10011" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00100";
            
                -- SUBC	
            when "10100" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00101";
            
                -- MULC	
            when "10101" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "00110";
            
                -- ABS	
            when "10110" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "01000";
            
                -- CONJ	
            when "10111" =>
                ctrl_aux <= "0100000";
                ctrl_ula <= "01001";
            
            when others =>
                ctrl_aux <= (others => '0');
                ctrl_ula <= (others => '0');
        end case;
    end process;
    controle <= ctrl_aux;
    alu_ctrl <= ctrl_ula;
    
end beh;