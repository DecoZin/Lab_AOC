library ieee;
use ieee.std_logic_1164.all;

--Só tem Forward
entity HazardUnit is
  port (
    instrucao : in std_logic_vector(31 downto 0);

    -- Execute
    RegWEN_exe : in std_logic; 
    rs1E, rs2E : in std_logic_vector(4 downto 0);
    -- Memory
    RegWriteM  : in std_logic;
    WriteRegE, WriteRegM : in std_logic_vector(32 downto 0);

    -- Writeback
    RegWriteW : in std_logic;
    WriteRegW : in std_logic_vector(32 downto 0);

    forwardAE,ForwardBE : out  std_logic_vector(1 downto 0)

  );
end HazardUnit;

architecture Behavioral of HazardUnit is
  begin
    
    process(RegWEN_exe, RegWriteM, WriteRegE, WriteRegM, RegWriteW, WriteRegW) is
      begin
        --ForwardAE
        if ((rs1E /= "00000") and (rs1E = WriteRegM) and (RegWriteM = '1') ) then
            ForwardAE <= "10";
        elsif ((rs1E /= "00000") and (rs1E = WriteRegW) and (RegWriteW = '1')) then
            ForwardAE <= "01";
        else ForwardAE <= "00";
        end if;
        
        --ForwardBE
        if ((rs2E /= "00000") and (rs2E = WriteRegM) and (RegWriteM = '1')) then
          ForwardBE <= "10";
        elsif ((rs2E /= "00000") and (rs2E = WriteRegW)and (RegWriteW = '1')) then
            ForwardBE <= "01";
        else ForwardBE <= "00";
        end if;

    end process;

end Behavioral;
