library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Master_tb is
--  Port ( );
end Master_tb;

architecture Behavioral of Master_tb is

    ---Parallel inputs
    signal CLK_SYSn          :   STD_LOGIC                       := '0';
    signal DCLKIO_INT        :   STD_LOGIC                       := '0';
    signal I_DAC_I           :   STD_LOGIC_VECTOR (13 downto 0)  := (others => '0');
    signal Q_DAC_I           :   STD_LOGIC_VECTOR (13 downto 0)  := (others => '0'); 
    
    ---SPI inputs
    signal SCLK              :   STD_LOGIC                       := '0';
    signal Data_In           :   STD_LOGIC_VECTOR (39 downto 0)  := (others => '0');
    signal Start             :   STD_LOGIC                       := '0';
    
    ---SPI outputs
    signal CS_n              :   STD_LOGIC;
    signal RW_CTL            :   STD_LOGIC;

    ---SPI bidirection
    signal SDIO              :   STD_LOGIC;

    ---internal signals
    signal SCLK_Start        :   STD_LOGIC                       := '0';

    ---Clock period defenition
    constant CLK_SYS_periodn :   TIME                            := 8NS;
    constant SCLK_period     :   TIME                            := 40NS;
begin
    ---
---Instantiate UUT
uut: entity work.Master PORT MAP (
        CLK_SYSn        => CLK_SYSn,
        I_DAC_I         => I_DAC_I,
        Q_DAC_I         => Q_DAC_I,
        SCLK            => SCLK, 
        Data_In         => Data_In,
        Start           => Start,
        CS_n            => CS_n,
        RW_CTL          => RW_CTL,
        SDIO            => SDIO
        );

    ---SCLK start generator for generate SCLK
    sclk_start_pro : process
    begin
        sclk_start <= '0', '1' after 00596ns, '0' after 01216ns, '1' after 01596ns, '0' after 02216ns,
                           '1' after 02716ns, '0' after 03656ns, '1' after 03996ns, '0' after 04956ns,
                           '1' after 05556ns, '0' after 06816ns, '1' after 07196ns, '0' after 08476ns,
                           '1' after 08576ns, '0' after 10456ns, '1' after 10956ns, '0' after 12536ns;
    wait;
    end process sclk_start_pro;
    ---

    ---SCLK generate
    sclk_pro: process
    begin
        if (sclk_start = '1') then
            sclk <='0';
            wait for sclk_period/2;
            sclk <='1';
            wait for sclk_period/2;
        else
            sclk <= '0';
            wait until sclk_start = '1';
        end if;      
    end process SCLK_Pro;
    ---
    
    ---Start generator for start transporting
    start_pro: process
    begin
    start <= '0', '1' after 00490ns, '0' after 00530ns, '1' after 01490ns, '0' after 01530ns, '1' after 02610ns,
                  '0' after 02650ns, '1' after 03890ns, '0' after 03930ns, '1' after 04940ns, '0' after 04980ns,
                  '1' after 07090ns, '0' after 07130ns, '1' after 08770ns, '0' after 08810ns, '1' after 10850ns,
                  '0' after 10890ns; 
        wait;
    end process start_pro;
    ---

    ---data in generates for IFIRST = 1 & IRISING = 0
    data_in_pro: process
    begin
        data_in <= "0000001000100100000000000000000000000000",
                   "1000001000100100000000000000000000000000" after 01500ns,
                   "0010001000100100101000100000000000000000" after 02620ns,
                   "1010001000100100101000100000000000000000" after 03880ns,
                   "0100001000100100110111001010001000000000" after 05460ns,
                   "1100001000100100110111001010001000000000" after 07120ns,
                   "0110001000100100010010011101110010100010" after 08760ns,
                   "1110001000100100010010011101110010100010" after 10840ns;
        wait;    
    end process data_in_pro;
    ---

    ---SDIO in or out cheker
    sdio <= 'Z' when RW_CTL = '0' else '1',                      '0' after sclk_period,
                                       '1' after sclk_period*2,  '0' after sclk_period*6,
                                       '1' after sclk_period*8,  '0' after sclk_period*11,
                                       '1' after sclk_period*13, '0' after sclk_period*17,
                                       '1' after sclk_period*20, '0' after sclk_period*21,
                                       '1' after sclk_period*22, '0' after sclk_period*26,
                                       '1' after sclk_period*28, '0' after sclk_period*30;
        
    ---CLK_SYSn generator for main clock of FPGA
    CLK_SYSn_Pro : PROCESS
    begin
        clk_sysn <= '0';
        wait for (CLK_SYS_periodn/2);
        clk_sysn <= '1';
        wait for (CLK_SYS_periodn/2);
    end process CLK_SYSn_Pro;
    ---

    ---IDAC Data samples
    I_DAC_I_pro: process
    begin
        I_DAC_I <= "00000000000000" after 284ns,
                   "00000000000101" after 292ns,
                   "00000000001011" after 300ns,
                   "00000000111111" after 308ns,
                   "00000000101010" after 316ns,
                   "00000000000010" after 324ns,
                   "00000001110000" after 332ns,
                   "00000001100011" after 340ns,
                   "00000000111010" after 348ns,
                   "00001110100010" after 356ns,
                   "00000001111101" after 364ns,
                   "00000000111000" after 372ns,
                   "00000000001110" after 380ns,
                   "00000110011001" after 388ns,
                   "00000000000001" after 396ns,
                   "00000000000011" after 404ns,
                   "00000000000100" after 412ns,
                   "00000000000110" after 420ns,
                   "00000000000111" after 428ns,
                   "00000000001000" after 436ns,
                   "00000000001001" after 444ns,
                   "00000000001010" after 452ns,
                   "00000000001100" after 460ns,
                   "00000000001101" after 468ns,
                   "00000000001111" after 476ns,
                   "00000000010000" after 484ns,
                   "00000000010001" after 492ns,
                   "00000000010010" after 500ns,
                   "00000000010011" after 508ns,
                   "00000000010100" after 516ns,
                   "00000000010101" after 524ns,
                   "00000000010110" after 532ns,
                   "00000000010111" after 540ns,
                   "00000000011000" after 548ns,
                   "00000000011001" after 556ns,
                   "00000000011010" after 564ns,
                   "00000000011011" after 572ns,
                   "00000000011100" after 580ns,
                   "00000000011101" after 588ns,
                   "00000000011110" after 596ns,
                   "00000000011111" after 604ns,
                   "00000000100000" after 612ns,
                   "00000000100001" after 620ns,
                   "00000000100010" after 628ns,
                   "00000000100011" after 636ns,
                   "00000000100100" after 644ns,
                   "00000000100101" after 652ns,
                   "00000000100110" after 660ns,
                   "00000000100111" after 668ns,
                   "00000000101000" after 676ns,
                   "00000000101001" after 684ns,
                   "00000000101011" after 692ns,
                   "00000000101100" after 700ns,
                   "00000000101101" after 708ns,
                   "00000000101110" after 716ns,
                   "00000000101111" after 724ns,
                   "00000000110000" after 732ns,
                   "00000000110001" after 740ns;
        wait;
    end process I_DAC_I_pro;
    ---

    ---QDAD Data samples
    Q_DAC_I_pro: process
    begin
        Q_DAC_I <= "00000000111111" after 284ns,
                   "00000000001111" after 292ns,
                   "00000000000111" after 300ns,
                   "00000000000000" after 308ns,
                   "00000111111111" after 316ns,
                   "00001111001010" after 324ns,
                   "00001111110001" after 332ns,
                   "00000111111110" after 340ns,
                   "00000111111100" after 348ns,
                   "00000111111001" after 356ns,
                   "00000111111010" after 364ns,
                   "00000111110111" after 372ns,
                   "00000111110011" after 380ns,
                   "00000111110111" after 388ns,
                   "00000111101111" after 396ns,
                   "00000111011111" after 404ns,
                   "00000110111111" after 412ns,
                   "00000101111111" after 420ns,
                   "00000100111111" after 428ns,
                   "00000110011111" after 436ns,
                   "00000111001111" after 444ns,
                   "00000111100111" after 452ns,
                   "00000111110011" after 460ns,
                   "00000111111000" after 468ns,
                   "00000111110001" after 476ns,
                   "00000111100011" after 484ns,
                   "00000111000111" after 492ns,
                   "00000110001111" after 500ns,
                   "00000100011111" after 508ns,
                   "00000100000111" after 516ns,
                   "00000110000111" after 524ns,
                   "00000111000011" after 532ns,
                   "00000111100001" after 540ns,
                   "00000111110000" after 548ns,
                   "00000111100000" after 556ns,
                   "00000111000001" after 564ns,
                   "00000110000011" after 572ns,
                   "00000100000111" after 580ns,
                   "00000100000011" after 588ns,
                   "00001111111000" after 596ns,
                   "00001111111100" after 604ns,
                   "00001111111000" after 612ns,
                   "00001111110000" after 620ns,
                   "00001111100000" after 628ns,
                   "00001111000000" after 636ns,
                   "00001110000000" after 644ns,
                   "00001100000000" after 652ns,
                   "00001000000000" after 660ns,
                   "00001000000011" after 668ns,
                   "00001000000111" after 676ns,
                   "00001000001111" after 684ns,
                   "00001000011111" after 692ns,
                   "00001000111111" after 700ns,
                   "00001001111111" after 708ns,
                   "00001011111111" after 716ns,
                   "00001100000001" after 724ns,
                   "00001100000011" after 732ns,
                   "00001100000111" after 740ns;
        wait;      
    end process Q_DAC_I_pro;
     
end Behavioral;
