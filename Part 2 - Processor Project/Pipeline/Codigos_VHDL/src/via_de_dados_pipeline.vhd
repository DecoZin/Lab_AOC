-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Via de dados do processador_pipeline

library IEEE;
use IEEE.std_logic_1164.all;

entity via_de_dados_pipeline is
	generic (
		-- declare todos os tamanhos dos barramentos (sinais) das portas da sua via_dados_pipeline aqui.
		dp_ctrl_bus_width : natural := 7;	-- tamanho do barramento de controle da via de dados (DP) em bits
		alu_ctrl_width		: natural := 5;		-- tamanho do controle da alu
		data_width        : natural := 32;	-- tamanho do dado em bits
		pc_width          : natural := 7;		-- tamanho da entrada de endereços da MI ou MP em bits (memi.vhd)
		fr_addr_width     : natural := 5;		-- tamanho da linha de endereços do banco de registradores em bits
		ula_ctrl_width    : natural := 5;		-- tamanho da linha de controle da ULA
		instr_width       : natural := 32		-- tamanho da instrução em bits
	);
	port (
		-- declare todas as portas da sua via_dados_pipeline aqui.
		clock     : in std_logic;
		reset     : in std_logic;
		controle  : in std_logic_vector(dp_ctrl_bus_width - 1 downto 0);
		alu_ctrl  : in std_logic_vector((alu_ctrl_width-1) downto 0);
		instrucao : out std_logic_vector(instr_width - 1 downto 0);
		pc_out    : out std_logic_vector(pc_width - 1 downto 0);
		saida     : out std_logic_vector(data_width - 1 downto 0)
	);
end entity via_de_dados_pipeline;

architecture comportamento of via_de_dados_pipeline is

	-- declare todos os componentes que serão necessários na sua via_de_dados_pipeline a partir deste comentário
	component pc is
		generic (
			pc_width : natural := 7
		);
		port (
			entrada : in std_logic_vector(pc_width - 1 downto 0);
			saida   : out std_logic_vector(pc_width - 1 downto 0);
			clk     : in std_logic;
			we      : in std_logic;
			reset   : in std_logic
		);
	end component;

	component somador is
		generic (
			largura_dado : natural := 7
		);
		port (
			entrada_a : in std_logic_vector((largura_dado - 1) downto 0);
			entrada_b : in std_logic_vector((largura_dado - 1) downto 0);
			saida     : out std_logic_vector((largura_dado - 1) downto 0)
		);
	end component;

	component banco_registradores is
		generic (
			largura_dado : natural := 32;
			largura_ende : natural := 5
		);
		port (
			ent_rs_ende : in std_logic_vector((largura_ende - 1) downto 0);
			ent_rt_ende : in std_logic_vector((largura_ende - 1) downto 0);
			ent_rd_ende : in std_logic_vector((largura_ende - 1) downto 0);
			ent_rd_dado : in std_logic_vector((largura_dado - 1) downto 0);
			sai_rs_dado : out std_logic_vector((largura_dado - 1) downto 0);
			sai_rt_dado : out std_logic_vector((largura_dado - 1) downto 0);
			clk,we          : in std_logic
		);
	end component;

	component ula is
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
	end component;

	component mux21 is
		generic (
			largura_dado : natural := 32
		);
		port (
			dado_ent_0, dado_ent_1 : in std_logic_vector((largura_dado - 1) downto 0);
			sele_ent               : in std_logic;
			dado_sai               : out std_logic_vector((largura_dado - 1) downto 0)
		);
	end component;

	component and_port is
		port (
			entrada1  :   in std_logic;
			entrada2  :   in std_logic;
      saida     :   out std_logic
		);
	end component;
	
	component extensor is
		generic (
			largura_dado  : natural := 12;  
			largura_saida : natural := 32
		);
		port (
			entrada_Rs : in std_logic_vector((largura_dado - 1) downto 0); 		
			saida      : out std_logic_vector((largura_saida - 1) downto 0)
		);
	end component;

	component memd is
		generic (
        number_of_words : natural := 512; -- número de words que a sua memória é capaz de armazenar
        MD_DATA_WIDTH   : natural := 32;        -- tamanho da palavra em bits
        MD_ADDR_WIDTH   : natural := 9         -- tamanho do endereco da memoria de dados em bits
    );
    port (
        clk							: in std_logic;
        reset           : in std_logic;
        mem_write				: in std_logic; --sinais do controlador
        write_data_mem	: in std_logic_vector(MD_DATA_WIDTH - 1 downto 0);
        adress_mem			: in std_logic_vector(MD_ADDR_WIDTH - 1 downto 0);
        read_data_mem		: out std_logic_vector(MD_DATA_WIDTH - 1 downto 0)
    );
	end component;
	
	component memi is
		generic (
			INSTR_WIDTH   : natural := 32; -- tamanho da instrucaoo em numero de bits
			MI_ADDR_WIDTH : natural := 7  -- tamanho do endereco da memoria de instrucoes em numero de bits
		);
		port (
			--clk       : in std_logic;
			reset     : in std_logic;
			Endereco  : in std_logic_vector(MI_ADDR_WIDTH - 1 downto 0);
			Instrucao : out std_logic_vector(INSTR_WIDTH - 1 downto 0)
		);
	end component;

    --Registradores Pipeline
    component reg_decode is
		generic (
        largura_dado : natural := 32;
        pc_width     : natural :=  7
      );
      port (
        entrada_instrucao  : in std_logic_vector((largura_dado - 1) downto 0);
	      pc_next_in         : in std_logic_vector((pc_width     - 1) downto 0);
        WE, clk, reset     : in std_logic;
        saida_instrucao    : out std_logic_vector((largura_dado - 1) downto 0);
	      pc_next_out        : out std_logic_vector((pc_width     - 1) downto 0)
      );
	end component;


  component reg_execute is
    generic (
      largura_dado  : natural := 32;
      largura_banco : natural := 5
    );
    port (
      addr_in        : in std_logic_vector((largura_dado - 1) downto 0);
      data_in        : in std_logic_vector((largura_dado - 1) downto 0);
      RegWriteE      : in std_logic;
      MemtoRegE      : in std_logic;
      MemWriteE      : in std_logic;
      --BranchE        : in std_logic;
      reg_dst_in     : in std_logic_vector((largura_banco - 1) downto 0);
      
      WE, clk, reset : in std_logic;
      
      addr_out       : out std_logic_vector((largura_dado - 1) downto 0);
      data_out       : out std_logic_vector((largura_dado - 1) downto 0);
      reg_dst_out    : out std_logic_vector((largura_banco - 1) downto 0);
      RegWriteM      : out std_logic;
      MemtoRegM      : out std_logic;
      MemWriteM      : out std_logic
      --BranchM        : out std_logic
    );
	end component;


  -- component reg_writeback is
  --   generic (
  --       largura_dado  : natural := 32;
  --       largura_banco : natural := 5
  --   );
  --   port (
  --       addr_in        : in std_logic_vector((largura_dado - 1) downto 0);
  --       data_in        : in std_logic_vector((largura_dado - 1) downto 0);

  --       RegWriteM      : in std_logic;
  --       MemtoRegM      : in std_logic;

  --       reg_dst_in     : in std_logic_vector((largura_banco - 1) downto 0);
  --       WE, clk, reset : in std_logic;
  --       addr_out       : out std_logic_vector((largura_dado - 1) downto 0);
  --       data_out       : out std_logic_vector((largura_dado - 1) downto 0);

  --       RegWriteW      : out std_logic;
  --       MemtoRegW      : out std_logic;
  --       reg_dst_out    : out std_logic_vector((largura_banco - 1) downto 0)
	-- );
	-- end component;


  --Mux Forward
  component mux31 is
    generic (
      largura_dado : natural := 32
    );
    port (
      dado_ent_0, dado_ent_1, dado_ent_2 : in  std_logic_vector((largura_dado - 1) downto 0);
      sele_ent                           : in  std_logic_vector(1 downto 0);
      dado_sai                           : out std_logic_vector((largura_dado - 1) downto 0)
    );
	end component;

  --HazardUnit
  component hazard is
    port (
		rs1E : in std_logic_vector(4 downto 0);  --Endereço Rs (R_source1)
		rs2E : in std_logic_vector(4 downto 0);  --Endereço Rt (R_source2)
	  
		--Sinais de controle que vão para memd e Banco de registradores
		RegWriteM  : in std_logic; 
		RegWriteW : in std_logic;
	
		--Enderenço que vão ser escrito na memoria (Saído MuxDst)
		AddrRdM : in std_logic_vector(4 downto 0);
		AddrRdW : in std_logic_vector(4 downto 0);

    -- Branch
    branch : in std_logic;
	
		--Controle do MUX AE e BE
		forwardAE,forwardBE : out  std_logic_vector(1 downto 0);

    -- Controle de Stall para Branch
    flushD : out std_logic
	
	  );
  end component;


	-- Declare todos os sinais auxiliares que serão necessários na sua via_de_dados_pipeline a partir deste comentário.
	-- Você só deve declarar sinais auxiliares se estes forem usados como "fios" para interligar componentes.
	-- Os sinais auxiliares devem ser compatíveis com o mesmo tipo (std_logic, std_logic_vector, etc.) e o mesmo tamanho dos sinais dos portos dos
	-- componentes onde serão usados.
	-- Veja os exemplos abaixo:

	signal aux_pc_jump    : std_logic_vector(pc_width - 1 downto 0);
	signal aux_pc_next    : std_logic_vector(pc_width - 1 downto 0);
	signal aux_pc_nextE   : std_logic_vector(pc_width - 1 downto 0);
	signal aux_pc_mux     : std_logic_vector(pc_width - 1 downto 0);
	signal aux_pc_reg     : std_logic_vector(pc_width - 1 downto 0);
	signal aux_novo_pc    : std_logic_vector(pc_width - 1 downto 0);
	signal aux_pc_out     : std_logic_vector(pc_width - 1 downto 0);

	signal aux_instruncao    : std_logic_vector(31 downto 0);
  signal aux_meminstruncao : std_logic_vector(31 downto 0);
	
	signal aux_read_rs    : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_read_rt    : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_write_rdE  : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_write_rdM  : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_write_rdW  : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_rd_ins     : std_logic_vector(fr_addr_width - 1 downto 0);
	signal aux_imm        : std_logic_vector(11 downto 0);
	signal aux_imm_ext    : std_logic_vector(data_width - 1 downto 0);

	signal aux_data_in      : std_logic_vector(data_width - 1 downto 0);
	signal aux_data_outrs   : std_logic_vector(data_width - 1 downto 0);
	signal aux_data_outrtE  : std_logic_vector(data_width - 1 downto 0);
	signal aux_data_outrtM  : std_logic_vector(data_width - 1 downto 0);
	
	
	signal aux_alu2_in      : std_logic_vector(data_width - 1 downto 0);
	signal aux_alu_outE     : std_logic_vector(data_width - 1 downto 0);
  signal aux_alu_outM     : std_logic_vector(data_width - 1 downto 0);
	signal aux_alu_outW     : std_logic_vector(data_width - 1 downto 0);
	signal aux_alu_outb     : std_logic;
	signal aux_mem_outM     : std_logic_vector(data_width - 1 downto 0);
	signal aux_mem_outW     : std_logic_vector(data_width - 1 downto 0);
	signal aux_branch_ctrl  : std_logic;
	signal aux_we_pc        : std_logic;

	signal aux_forwardAE  : std_logic_vector(data_width - 1 downto 0);
	signal aux_forwardBE  : std_logic_vector(data_width - 1 downto 0);


  -- Controle
  signal aux_ALUCtrlE    : std_logic_vector(ula_ctrl_width - 1 downto 0);
  signal aux_datatoregE  : std_logic;
  signal aux_data_writeE : std_logic;
  signal aux_branch      : std_logic;
  signal aux_aluselE     : std_logic;
  signal aux_rsgdstE     : std_logic;
  signal aux_reg_writeE  : std_logic;
  signal aux_jumpenableE : std_logic;

  signal aux_reg_writeM  : std_logic;
  signal aux_datatoregM  : std_logic;
  signal aux_data_writeM : std_logic;

  signal aux_reg_writeW  : std_logic;
  signal aux_datatoregW  : std_logic;

	signal aux_ctrl_forwardAE  : std_logic_vector(1 downto 0);
  signal aux_ctrl_forwardBE  : std_logic_vector(1 downto 0);

  signal resetD : std_logic;
  signal aux_flushD : std_logic;

begin

	-- A partir deste comentário faça associações necessárias das entradas declaradas na entidade da sua via_dados_pipeline com
	-- os sinais que você acabou de definir.
	-- Veja os exemplos abaixo:
	aux_read_rs   <= aux_instruncao(26 downto 22);  -- OP OP OP OP RD RD RD RD RS RS RS RS RT RT RT RT
	aux_read_rt   <= aux_instruncao(21 downto 17);  -- OP OP OP OP RD RD RD RD RS RS RS RS RT RT RT RT
	aux_rd_ins    <= aux_instruncao(16 downto 12); -- OP OP OP OP RD RD RD RD RS RS RS RS RT RT RT RT
	aux_imm       <= aux_instruncao(11 downto  0);

	instrucao <= aux_instruncao;

	-- Bits de controle para cada entrada
	aux_ALUCtrlE    <= alu_ctrl;  
	aux_datatoregE  <= controle(0);	
	aux_data_writeE <= controle(1);
	aux_branch      <= controle(2);
	aux_aluselE     <= controle(3);
	aux_rsgdstE     <= controle(4);
	aux_reg_writeE  <= controle(5);  
	aux_jumpenableE <= controle(6);
	
	saida	<= aux_alu_outM;
	pc_out	<= aux_pc_out;

	-- A partir deste comentário instancie todos o componentes que serão usados na sua via_de_dados_pipeline.
	-- A instanciação do componente deve começar com um nome que você deve atribuir para a referida instancia seguido de : e seguido do nome
	-- que você atribuiu ao componente.
	-- Depois segue o port map do referido componente instanciado.
	-- Para fazer o port map, na parte da esquerda da atribuição "=>" deverá vir o nome de origem da porta do componente e na parte direita da
	-- atribuição deve aparecer um dos sinais ("fios") que você definiu anteriormente, ou uma das entradas da entidade via_de_dados_pipeline,
	-- ou ainda uma das saídas da entidade via_de_dados_pipeline.
	-- Veja os exemplos de instanciação a seguir:

	instancia_mux1 : component mux21
		generic map(
			largura_dado => 7
		)
		port map(
			dado_ent_0 => aux_pc_next,
			dado_ent_1 => aux_pc_jump,
			sele_ent   => aux_branch_ctrl,
			dado_sai   => aux_pc_mux
		);
	
	aux_pc_reg <= aux_data_outrs (6 downto 0);

	instancia_mux2 : component mux21
		generic map(
			largura_dado => 7
		)
		port map(
			dado_ent_0 => aux_pc_mux,
			dado_ent_1 => aux_pc_reg,
			sele_ent   => aux_jumpenableE,
			dado_sai   => aux_novo_pc
		);

	instancia_pc : component pc
		port map(
			entrada	=> aux_novo_pc,
			saida		=> aux_pc_out,
			clk			=> clock,
			we			=> '1',
			reset		=> reset
		);

	instancia_somadorPC : component somador
		port map(
			entrada_a => aux_pc_out,
			entrada_b => "0000001",
			saida	    => aux_pc_next
		);

  instancia_somadorBranch : component somador
		port map(
			entrada_a => aux_pc_nextE,
			entrada_b => aux_imm(6 downto 0),
			saida			=> aux_pc_jump
		);


	instancia_instructionMem : component memi
		port map(
			reset     => reset,
			Endereco  => aux_pc_out,
			Instrucao => aux_meminstruncao
		);

	instancia_banco_registradores : component banco_registradores
		port map(
			ent_rs_ende => aux_read_rs,
			ent_rt_ende => aux_read_rt,
			ent_rd_ende => aux_write_rdM,
			ent_rd_dado => aux_data_in,
			sai_rs_dado => aux_data_outrs,
			sai_rt_dado => aux_data_outrtE,
			clk         => clock,
			we			=> aux_reg_writeE
		);

	instancia_muxDst : component mux21
		generic map(
			largura_dado => 5
		)
		port map(
			dado_ent_0 => aux_rd_ins,
			dado_ent_1 => "00000", ---Endereço de ra
			sele_ent   => aux_rsgdstE,
			dado_sai   => aux_write_rdE
	   );

	instancia_extensor : component extensor
		port map(
			entrada_Rs => aux_imm,		
			saida      => aux_imm_ext
		);

	instancia_muxALU : component mux21
		generic map(
			largura_dado => 32
		)
		port map(
			dado_ent_0 => aux_forwardBE,
			dado_ent_1 => aux_imm_ext,
			sele_ent   => aux_aluselE,
			dado_sai   => aux_alu2_in
		);

	instancia_ula1 : component ula
  		port map(
			entrada_a => aux_forwardAE,
			entrada_b => aux_alu2_in,
			seletor	  => aux_ALUCtrlE,
			saida	  => aux_alu_outE
 		);

	aux_alu_outb <= aux_alu_outE(0);

	instancia_and : component and_port
		port map(
			entrada1	=> aux_alu_outb,
			entrada2	=> aux_branch,
			saida			=> aux_branch_ctrl 
 		);


	instancia_dataMem : component memd
		port map(
			clk					    => clock,
      reset           => reset,
			mem_write 			=> aux_data_writeM,
			write_data_mem  => aux_data_outrtM,
			adress_mem 			=> aux_alu_outM(8 downto 0),
			read_data_mem		=> aux_mem_outM
		);

	instancia_muxDatatoReg : component mux21
		port map(
			dado_ent_0 => aux_alu_outM,
			dado_ent_1 => aux_mem_outM,
			sele_ent   => aux_datatoregM,
			dado_sai   => aux_data_in
	   );

     resetD <= reset or aux_flushD;

    --Pipeline
  instancia_regDecode : component reg_decode
    port map(                 
      entrada_instrucao  => aux_meminstruncao,    
      pc_next_in         => aux_pc_next,    
      WE                 => '1',
      clk                => clock,
      reset              => resetD,       
      saida_instrucao    => aux_instruncao,
      pc_next_out        => aux_pc_nextE    
    );


  instancia_regExecute : component reg_execute
    port map(
      addr_in        => aux_alu_outE,
      data_in        => aux_data_outrtE, 
      RegWriteE      => aux_reg_writeE, 
      MemtoRegE      => aux_datatoregE, 
      MemWriteE      => aux_data_writeE, 
      reg_dst_in     => aux_write_rdE, 
      WE             => '1', 
      clk            => clock, 
      reset          => reset, 
      addr_out       => aux_alu_outM, 
      data_out       => aux_data_outrtM, 
      reg_dst_out    => aux_write_rdM, 
      RegWriteM      => aux_reg_writeM, 
      MemtoRegM      => aux_datatoregM, 
      MemWriteM      => aux_data_writeM
    );
		
  -- instancia_regWriteback : component reg_writeback
  --   port map(
  --     addr_in         => aux_mem_outM,
  --     data_in         => aux_alu_outM,
  --     RegWriteM       => aux_reg_writeM,
  --     MemtoRegM       => aux_datatoregM,
  --     reg_dst_in      => aux_write_rdM,
  --     WE              => '1',
  --     clk             => clock,
  --     reset           => reset,
  --     addr_out        => aux_mem_outW,
  --     data_out        => aux_alu_outW,
  --     RegWriteW       => aux_reg_writeW,
  --     MemtoRegW       => aux_datatoregW,
  --     reg_dst_out     => aux_write_rdW 		
  --   );
		
		
		instancia_ForwardAE : component mux31
			port map(
				dado_ent_0   => aux_data_outrs,
				dado_ent_1   => aux_data_in,
				dado_ent_2   => aux_data_in,
				sele_ent     => aux_ctrl_forwardAE,     
				dado_sai     => aux_forwardAE                     
			);
		
		instancia_ForwardBE : component mux31
			port map(
				dado_ent_0   => aux_data_outrtE,
				dado_ent_1   => aux_data_in,
				dado_ent_2   => aux_data_in,
				sele_ent     => aux_ctrl_forwardBE,     
				dado_sai     => aux_forwardBE                      
			);
		
		instancia_HazardUnit : component hazard
			port map(
				rs1E         => aux_read_rs,
				rs2E         => aux_read_rt,
				RegWriteM    => aux_reg_writeM, 
				RegWriteW    => aux_reg_writeM,
				AddrRdM      => aux_write_rdM,
				AddrRdW      => aux_write_rdM,
				branch       => aux_branch_ctrl,
				forwardAE    => aux_ctrl_forwardAE,
				forwardBE    => aux_ctrl_forwardBE,
        flushD       => aux_flushD
			  );


end architecture comportamento;
