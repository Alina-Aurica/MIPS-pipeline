----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2022 06:27:31 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG
    Port( btn: IN STD_LOGIC;
          clk: IN STD_LOGIC;
          en: OUT STD_LOGIC);
end component;

component SSD
     Port( dig : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

--component RF
--    Port ( clk : in STD_LOGIC;
--           ra1 : in STD_LOGIC_VECTOR (3 downto 0);
--           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
--           wa : in STD_LOGIC_VECTOR (3 downto 0);
--           wd : in STD_LOGIC_VECTOR (15 downto 0);
--           wen : in STD_LOGIC;
--           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
--           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
--end component;

--component RAM
--    Port ( clk : in STD_LOGIC;
--           we : in STD_LOGIC;
--           en : in STD_LOGIC;
--           addr : in STD_LOGIC_VECTOR (7 downto 0);
--           di : in STD_LOGIC_VECTOR (15 downto 0);
--           do : out STD_LOGIC_VECTOR (15 downto 0));
--end component;

component IF_comp 
    Port ( en : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           JAdr : in STD_LOGIC_VECTOR (15 downto 0);
           BAdr : in STD_LOGIC_VECTOR (15 downto 0);
           PC1 : inout STD_LOGIC_VECTOR (15 downto 0);
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           PCSrc: in STD_LOGIC;
           Jump: in STD_LOGIC);
end component;

component ID_comp
    Port ( clk: in STD_LOGIC;
           en: in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegW : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           rt: inout STD_LOGIC_VECTOR (2 downto 0);
           rd: inout STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wa : inout STD_LOGIC_VECTOR (2 downto 0);
           ExtOp : in STD_LOGIC;
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa: out STD_LOGIC);
end component;

component UC is
     Port (instr: in STD_LOGIC_VECTOR (15 downto 0);
         RegDst: out STD_LOGIC := '0';
         ExtOp: out STD_LOGIC := '0';
         ALUSrc: out STD_LOGIC := '0';
         Branch: out STD_LOGIC := '0';
         Jump: out STD_LOGIC := '0';
         ALUOp: out STD_LOGIC_VECTOR (2 downto 0) := "000";
         MemWrite: out STD_LOGIC := '0';
         MemtoReg: out STD_LOGIC := '0';
         RegWrite: out STD_LOGIC := '0');
end component;

component ALU is
    Port ( rt: inout STD_LOGIC_VECTOR (2 downto 0);
           rd: inout STD_LOGIC_VECTOR (2 downto 0);
           RegDst: in STD_LOGIC;
           MuxDst: inout STD_LOGIC_VECTOR (2 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           ALURez : inout STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end component;

component MEM is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal cnt: STD_LOGIC_VECTOR (15 downto 0);
signal en: STD_LOGIC;
signal rst: STD_LOGIC;
signal en1: STD_LOGIC;
--type Rom_type is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
--signal ROM: Rom_type := (b"000_001_010_101_0_000", b"000_101_100_011_0_001", b"000_011_111_110_0_010", b"000_101_100_010_0_011", b"000_111_001_011_0_100", b"000_111_110_010_0_101", b"000_011_101_001_0_110", b"000_010_110_100_0_111", b"001_011_010_0000100", b"010_100_011_0000010", b"011_101_100_0000111", b"100_100_001_0000011", b"101_010_100_0000110", b"110_011_010_0000100", others => b"111_0000000001100");
signal R_D: STD_LOGIC_VECTOR(15 downto 0);
signal wd: STD_LOGIC_VECTOR(15 downto 0);
signal rd1: STD_LOGIC_VECTOR(15 downto 0);
signal rd2: STD_LOGIC_VECTOR(15 downto 0);
signal ALURez: STD_LOGIC_VECTOR(15 downto 0);
signal di: STD_LOGIC_VECTOR(15 downto 0);
signal do: STD_LOGIC_VECTOR(15 downto 0);
signal PC1: STD_LOGIC_VECTOR(15 downto 0);
signal Instr: STD_LOGIC_VECTOR(15 downto 0);
signal SMux: STD_LOGIC_VECTOR(15 downto 0);
signal RegDst: STD_LOGIC;
signal ExtOp: STD_LOGIC;
signal ExtImm: STD_LOGIC_VECTOR(15 downto 0);
signal func: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;
signal RegW: STD_LOGIC;
signal digits: STD_LOGIC_VECTOR (15 downto 0);

signal MemData: STD_LOGIC_VECTOR (15 downto 0);

signal ALUSrc: STD_LOGIC;
signal Branch: STD_LOGIC;
signal Jump: STD_LOGIC;
signal ALUOp: STD_LOGIC_VECTOR (2 downto 0);
signal MemWrite: STD_LOGIC;
signal MemtoReg: STD_LOGIC;
signal RegWrite: STD_LOGIC;
signal Zero: STD_LOGIC;
signal Ext_func: STD_LOGIC_VECTOR (15 downto 0);
signal Ext_sa: STD_LOGIC_VECTOR (15 downto 0);
signal PCSrc: STD_LOGIC;
signal JAddr: STD_LOGIC_VECTOR (15 downto 0);
signal BAddr: STD_LOGIC_VECTOR (15 downto 0);
signal MuxDst: STD_LOGIC_VECTOR (2 downto 0);
signal rt: STD_LOGIC_VECTOR (2 downto 0);
signal rd: STD_LOGIC_VECTOR (2 downto 0);
signal wa: STD_LOGIC_VECTOR (2 downto 0);

signal enable: STD_LOGIC;

signal if_id_in: STD_LOGIC_VECTOR(31 downto 0);
signal if_id_out: STD_LOGIC_VECTOR(31 downto 0);
signal instr_ID: STD_LOGIC_VECTOR(15 downto 0);
signal PC_ID: STD_LOGIC_VECTOR(15 downto 0);

signal id_ex_in: STD_LOGIC_VECTOR(82 downto 0);
signal id_ex_out: STD_LOGIC_VECTOR(82 downto 0);
signal WB_EX: STD_LOGIC_VECTOR(1 downto 0);
signal M_EX: STD_LOGIC_VECTOR(1 downto 0);
signal EX: STD_LOGIC_VECTOR(4 downto 0); -- trebuie modificat acolo unde a fost ex
signal PC_EX: STD_LOGIC_VECTOR(15 downto 0);
signal rd1_EX: STD_LOGIC_VECTOR(15 downto 0);
signal rd2_EX: STD_LOGIC_VECTOR(15 downto 0);
signal ExtImm_EX: STD_LOGIC_VECTOR(15 downto 0);
signal func_sa_EX: STD_LOGIC_VECTOR(3 downto 0);
signal rt_EX: STD_LOGIC_VECTOR(2 downto 0);
signal rd_EX: STD_LOGIC_VECTOR(2 downto 0);

signal ex_mem_in: STD_LOGIC_VECTOR(55 downto 0);
signal ex_mem_out: STD_LOGIC_VECTOR(55 downto 0);
signal WB_mem: STD_LOGIC_VECTOR(1 downto 0);
signal M_mem: STD_LOGIC_VECTOR(1 downto 0);
signal BAddr_mem: STD_LOGIC_VECTOR(15 downto 0);
signal ALURez_mem: STD_LOGIC_VECTOR(15 downto 0);
signal rd2_mem: STD_LOGIC_VECTOR(15 downto 0);
signal MuxDst_mem: STD_LOGIC_VECTOR(2 downto 0);
signal ZERO_mem: STD_LOGIC;

signal mem_wb_in: STD_LOGIC_VECTOR(36 downto 0);
signal mem_wb_out: STD_LOGIC_VECTOR(36 downto 0);
signal WB_wb: STD_LOGIC_VECTOR(1 downto 0);
signal rd_wb: STD_LOGIC_VECTOR(15 downto 0);
signal MuxDst_wb: STD_LOGIC_VECTOR(2 downto 0);
signal ALURez_wb: STD_LOGIC_VECTOR(15 downto 0);

--signal A: STD_LOGIC_VECTOR (15 downto 0);
--signal A1: STD_LOGIC_VECTOR (15 downto 0);
--signal B: STD_LOGIC_VECTOR (15 downto 0);
--signal Add: STD_LOGIC_VECTOR (15 downto 0);
--signal Dif: STD_LOGIC_VECTOR (15 downto 0);
--signal Shright: STD_LOGIC_VECTOR (15 downto 0);
--signal Shleft: STD_LOGIC_VECTOR (15 downto 0);
--signal dig: STD_LOGIC_VECTOR (15 downto 0);

begin
-- led <= sw;
-- an <= btn(3 downto 0);
-- cat <= (others => '0');

leg1: MPG port map (btn(0), clk, en);
leg2: SSD port map (digits, clk, an, cat);
leg3: MPG port map (btn(1), clk, rst);
leg11: MPG port map (btn(0), clk, enable);
--leg4: RF port map (clk, cnt(3 downto 0), cnt(3 downto 0), cnt(3 downto 0), wd, en1, rd1, rd2);
--leg5: RAM port map (clk, en1, '1', cnt(7 downto 0), di, do);

leg6: IF_comp port map (en, clk, rst, JAddr, BAddr_mem, PC1, Instr, PCSrc, Jump);  
leg7: ID_comp port map (clk, en, instr_ID, WB_wb(0), rd1, rd2, rt, rd, wd, MuxDst_wb, ExtOp, ExtImm, func, sa); 
leg8: UC port map (instr_ID, RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
leg9: ALU port map (rt_EX, rd_Ex, EX(0), MuxDst, rd1_EX, rd2_EX, ExtImm_EX, EX(1), func_sa_EX(3), func_sa_EX(2 downto 0), EX(4 downto 2), ALURez, Zero);
leg10: MEM port map (clk, M_mem(1), ALURez_mem, rd2_mem, MemData);

PCSrc <= M_mem(0) AND Zero_mem;

process(WB_wb(1))
begin
    --if MemWrite = '1' then
        if WB_wb(1) = '1' then
            wd <= rd_wb;
        else
            wd <= ALURez_wb;
        end if;
    --end if;
end process;

JAddr <= PC_ID(15 downto 13) & instr_ID(12 downto 0);
BAddr <= PC_EX + ExtImm_EX;

process(sw(7), PC1, Instr)
begin
    if sw(7) = '1' then
        SMux <= PC1;
    else
        SMux <= Instr;
    end if;
end process;

--wd <= rd1 + rd2;

Ext_func <= "0000000000000" & func;
Ext_sa <= "000000000000000" & sa;

process(sw(7 downto 5))
begin
    case SW(7 downto 5) is
        when "000" => digits <= PC1 - 1;
        when "001" => digits <= Instr;
        when "010" => digits <= rd1;
        when "011" => digits <= rd2;
        when "100" => digits <= ExtImm;
        when "101" => digits <= ALURez;
        when "110" => digits <= MemData;
        when others => digits <= wd;
    end case;
end process;

--with sw(7 downto 5) select
    --digits <= Instr when "000", PC1 when "001", rd1 when "010", rd2 when "011", wd when "100", ExtImm when "101", Ext_func when "110", Ext_sa when "111", (others => 'X') when others;
 
led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

if_id_in(15 downto 0) <= Instr;
if_id_in(31 downto 16) <= PC1;
process(clk, enable)
begin
    
    if rising_edge(clk) then
        if enable = '1' then
            if_id_out(15 downto 0) <= if_id_in(15 downto 0);
            if_id_out(31 downto 16) <= if_id_in(31 downto 16);
        end if;
    end if;
    
end process;
instr_ID <= if_id_out(15 downto 0);
PC_ID <= if_id_out(31 downto 16);

id_ex_in(1 downto 0) <= MemtoReg & RegWrite;
id_ex_in(3 downto 2) <= MemWrite & Branch;
id_ex_in(8 downto 4) <= ALUOp & ALUSrc & RegDst;
id_ex_in(24 downto 9) <= PC_ID;
id_ex_in(40 downto 25) <= rd1;
id_ex_in(56 downto 41) <= rd2;
id_ex_in(72 downto 57) <= ExtImm;
id_ex_in(76 downto 73) <= instr_ID(3 downto 0);
id_ex_in(79 downto 77)<= instr_ID(9 downto 7);
id_ex_in(82 downto 80)<= instr_ID(6 downto 4);
process(clk, enable)
begin

    if rising_edge(clk) then
        if enable = '1' then
            id_ex_out(1 downto 0) <= id_ex_in(1 downto 0);
            id_ex_out(3 downto 2) <= id_ex_in(3 downto 2);
            id_ex_out(8 downto 4) <= id_ex_in(8 downto 4);
            id_ex_out(24 downto 9) <= id_ex_in(24 downto 9);
            id_ex_out(40 downto 25) <= id_ex_in(40 downto 25);
            id_ex_out(56 downto 41) <= id_ex_in(56 downto 41);
            id_ex_out(72 downto 57) <= id_ex_in(72 downto 57);
            id_ex_out(76 downto 73) <= id_ex_in(76 downto 73);
            id_ex_out(79 downto 77)<= id_ex_in(79 downto 77);
            id_ex_out(82 downto 80)<= id_ex_in(82 downto 80);
        end if;
    end if;
    
end process;
WB_EX <= id_ex_out(1 downto 0);
M_EX <= id_ex_out(3 downto 2);
EX <= id_ex_out(8 downto 4);
PC_EX <= id_ex_out(24 downto 9);
rd1_EX <= id_ex_out(40 downto 25);
rd2_EX <= id_ex_out(56 downto 41);
ExtImm_EX <= id_ex_out(72 downto 57);
func_sa_EX <= id_ex_out(76 downto 73);
rt_EX <= id_ex_out(79 downto 77);
rd_EX <= id_ex_out(82 downto 80);


ex_mem_in(1 downto 0) <= WB_EX;
ex_mem_in(3 downto 2) <= M_EX;
ex_mem_in(19 downto 4) <= BAddr;
ex_mem_in(20) <= Zero;
ex_mem_in(36 downto 21) <= ALURez;
ex_mem_in(52 downto 37) <= rd2_EX;
ex_mem_in(55 downto 53) <= MuxDst;
process(clk, enable)
begin
    if rising_edge(clk) and enable = '1' then
        ex_mem_out(1 downto 0) <= ex_mem_in(1 downto 0);
        ex_mem_out(3 downto 2) <= ex_mem_in(3 downto 2);
        ex_mem_out(19 downto 4) <= ex_mem_in(19 downto 4);
        ex_mem_out(20) <= ex_mem_in(20);
        ex_mem_out(36 downto 21) <= ex_mem_in(36 downto 21);
        ex_mem_out(52 downto 37) <= ex_mem_in(52 downto 37);
        ex_mem_out(55 downto 53) <= ex_mem_in(55 downto 53);
    end if;
end process;
WB_mem <= ex_mem_out(1 downto 0);
M_mem <= ex_mem_out(3 downto 2);
BAddr_mem <= ex_mem_out(19 downto 4);
Zero_mem <= ex_mem_out(20);
ALURez_mem <= ex_mem_out(36 downto 21);
rd2_mem <= ex_mem_out(52 downto 37);
MuxDst_mem <= ex_mem_out(55 downto 53);

mem_wb_in (1 downto 0) <= WB_mem;
mem_wb_in (17 downto 2) <= MemData;
mem_wb_in (33 downto 18) <= ALURez_mem;
mem_wb_in (36 downto 34) <= MuxDst_mem;
process(clk, enable)
begin
    if rising_edge(clk) and enable = '1' then
        mem_wb_out (1 downto 0) <= mem_wb_in(1 downto 0);
        mem_wb_out (17 downto 2) <= mem_wb_in(17 downto 2);
        mem_wb_out (33 downto 18) <= mem_wb_in(33 downto 18);
        mem_wb_out (36 downto 34) <= mem_wb_in(36 downto 34);
    end if;
end process;
WB_wb <= mem_wb_out(1 downto 0);
rd_wb <= mem_wb_out(17 downto 2);
ALURez_wb <= mem_wb_out(33 downto 18);
MuxDst_wb <= mem_wb_out(36 downto 34);


process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            if sw(0) = '1' then
                cnt <= cnt + 1;
                else 
                cnt <= cnt - 1;
            end if;
        end if;
     end if;
end process;

--A <= x"000" & Sw(3 downto 0);
--B <= x"000" & Sw(7 downto 4);
--Add <= A + B;
--Dif <= A - B;
--A1 <= "00000000" & Sw(7 downto 0);
--Shright <= "00" & A1(15 downto 2);
--Shleft <= A1(13 downto 0) & "00";

--process(cnt(15), cnt(14))
--begin
--    if cnt(15 downto 14) = "00" then 
--        dig <= Add;
--    elsif cnt(15 downto 14) = "01" then
--        dig <= Dif;
--    elsif cnt(15 downto 14) = "10" then
--        dig <= Shright;
--    elsif cnt(15 downto 14) = "11" then 
--        dig <= Shleft;
--    end if;
--end process;

--R_D <= ROM(conv_integer(cnt));

--wd <= rd1+rd2;

--di<=do(13 downto 0)& "00";

--process(sw(7), PC1, Instr)
--begin
--    if sw(7) = '1' then
--        SMux <= PC1;
--    else
--        SMux <= Instr;
--    end if;
--end process;
 
end Behavioral;
