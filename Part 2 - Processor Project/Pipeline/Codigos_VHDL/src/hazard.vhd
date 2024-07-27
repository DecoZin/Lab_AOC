library ieee;
use ieee.std_logic_1164.all;

--Só tem Forward
entity hazard is
  port (
    rs1E : in std_logic_vector(4 downto 0);  --Endereço Rs (R_source1)
    rs2E : in std_logic_vector(4 downto 0);  --Endereço Rt (R_source2)
  
    --Sinais de controle que vão para memd e Banco de registradores
    RegWriteM  : in std_logic; 
    RegWriteW : in std_logic;

    --Enderenço que vão ser escrito na memoria (Saído MuxDst)
    AddrRdM : in std_logic_vector(4 downto 0);
    AddrRdW : in std_logic_vector(4 downto 0);

    --Controle do MUX AE e BE
    forwardAE,forwardBE : out  std_logic_vector(1 downto 0)

  );
end hazard;

architecture Behavioral of hazard is
  begin
    
    process(RegWriteM,RegWriteW,rs1E,rs2E,AddrRdM,RegWriteW) is
      begin
        --ForwardAE
        if ((rs1E /= "00000") and (rs1E = AddrRdM) and (RegWriteM = '1') ) then
          forwardAE <= "01";
        elsif ((rs1E /= "00000") and (rs1E = AddrRdW) and (RegWriteW = '1')) then
          forwardAE <= "10";
        else forwardAE <= "00";
        end if;
        
        --ForwardBE
        if ((rs2E /= "00000") and (rs2E = AddrRdM) and (RegWriteM = '1')) then
          forwardBE <= "01";
        elsif ((rs2E /= "00000") and (rs2E = AddrRdW) and (RegWriteW = '1')) then
          forwardBE <= "10";
        else forwardBE <= "00";
        end if;

    end process;

end Behavioral;
