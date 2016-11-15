-- cpu.vhd: Simple 8-bit CPU (BrainFuck interpreter)
-- Copyright (C) 2011 Brno University of Technology,
--                    Faculty of Information Technology
-- Author(s): Zdenek Vasicek <vasicek AT fit.vutbr.cz>
--	           Petr Dvoracek <xdvora0n AT stud.fit.vutbr.cz>
--            Ten prvni zmineny byl liny a nedopsal behavioralni model... :)
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity cpu is
 port (
   CLK   : in std_logic;  -- hodinovy signal
   RESET : in std_logic;  -- asynchronni reset procesoru
   EN    : in std_logic;  -- povoleni cinnosti procesoru
 
   -- synchronni pamet ROM
   CODE_ADDR : out std_logic_vector(11 downto 0); -- adresa do pameti
   CODE_DATA : in std_logic_vector(7 downto 0);   -- CODE_DATA <- rom[CODE_ADDR] pokud CODE_EN='1'
   CODE_EN   : out std_logic;                     -- povoleni cinnosti
   
   -- synchronni pamet RAM
   DATA_ADDR  : out std_logic_vector(9 downto 0); -- adresa do pameti
   DATA_WDATA : out std_logic_vector(7 downto 0); -- mem[DATA_ADDR] <- DATA_WDATA pokud DATA_EN='1'
   DATA_RDATA : in std_logic_vector(7 downto 0);  -- DATA_RDATA <- ram[DATA_ADDR] pokud DATA_EN='1'
   DATA_RDWR  : out std_logic;                    -- cteni (0) / zapis (1)
   DATA_EN    : out std_logic;                    -- povoleni cinnosti
   
   -- vstupni port
   IN_DATA   : in std_logic_vector(7 downto 0);   -- IN_DATA <- stav klavesnice pokud IN_VLD='1' a IN_REQ='1'
   IN_VLD    : in std_logic;                      -- data platna
   IN_REQ    : out std_logic;                     -- pozadavek na vstup data
   
   -- vystupni port
   OUT_DATA : out  std_logic_vector(7 downto 0);  -- zapisovana data
   OUT_BUSY : in std_logic;                       -- LCD je zaneprazdnen (1), nelze zapisovat
   OUT_WE   : out std_logic                       -- LCD <- OUT_DATA pokud OUT_WE='1' a OUT_BUSY='0'
 );
end cpu;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of cpu is
 -- zde dopiste potrebne deklarace signalu
   type t_state is (init, fetch, decode, ptr_increment, ptr_decrement, act_increment, act_decrement,
		cnt_increment, cnt_decrement, putchar, getchar, halt, act_increment2, act_decrement2, putchar2,
		getchar2, cnt_increment2, cnt_increment3, cnt_increment4, cnt_decrement2, cnt_decrement3,        
		cnt_d5, cnt_increment5,
		cnt_decrement4, pc_increment		
		);
   signal present_state, next_state : t_state;
	signal pc_reg 	: std_logic_vector(11 downto 0);
	signal cnt_reg : std_logic_vector(7 downto 0);
	signal ptr_reg : std_logic_vector(9 downto 0);

	signal inc_pc 	: std_logic;
	signal dec_pc 	: std_logic;
	signal inc_cnt : std_logic;
	signal dec_cnt : std_logic;
	signal inc_ptr : std_logic;
	signal dec_ptr : std_logic;
	
	signal cnt_zero  : std_logic;
	signal data_zero : std_logic;
	
	signal sel_operation : std_logic_vector(1 downto 0);
	
begin

--------------
-- Registry --

pc_register: process(CLK, RESET, inc_pc, dec_pc)
begin 
	if RESET = '1' then
		pc_reg <= (others => '0');
	elsif CLK'event and CLK = '1' then
		if inc_pc = '1' then
			pc_reg <= pc_reg + 1;			
		elsif dec_pc = '1' then
			pc_reg <= pc_reg - 1;
		end if;
	end if;
end process;

cnt_register: process(CLK, RESET, inc_cnt, dec_cnt)
begin 
	if RESET = '1' then
		cnt_reg <= (others => '0');
	elsif CLK'event and CLK = '1' then
		if inc_cnt = '1' then
			cnt_reg <= cnt_reg + 1;			
		elsif dec_cnt = '1' then
			cnt_reg <= cnt_reg - 1;
		end if;
	end if;
end process;

ptr_register: process(CLK, RESET, inc_ptr, dec_ptr)
begin
	if RESET = '1' then
		ptr_reg <= (others => '0');
	elsif CLK'event and  CLK = '1' then
		if inc_ptr = '1' then
			ptr_reg <= ptr_reg + 1;
		elsif dec_ptr = '1' then
			ptr_reg <= ptr_reg - 1;
		end if;
	end if;
end process;


fsm_register: process(CLK, RESET)
begin
   if RESET = '1' then
      present_state <= init;
   elsif CLK'event AND CLK = '1' then
		if EN = '1' then
			present_state <= next_state;
		end if;
   end if; 
end process;

-- input
cnt_zero <= '1' when (cnt_reg = X"0") else '0';
data_zero <= '1' when (DATA_RDATA = X"0") else '0';

-- output

with sel_operation select
	DATA_WDATA <= IN_DATA when "00",
   (DATA_RDATA - 1) when "01",
   (DATA_RDATA + 1) when "10",
   "00000000"       when "11",	-- mozna by to slo zapsat others '0' ale nechtelo se mi :D
   "00000000"  when others;	-- mozna by to slo zapsat others '0' ale nechtelo se mi :D
					  

DATA_ADDR <= ptr_reg;

CODE_ADDR <= pc_reg;





-- radic
controller: process(present_state, CODE_DATA, IN_VLD, OUT_BUSY, DATA_RDATA, cnt_zero, data_zero)
begin
	DATA_RDWR <= '0';
	DATA_EN <= '0';
   OUT_DATA <= (others => '0');
	CODE_EN <= '0';

	IN_REQ  <= '0';

	OUT_WE  <= '0';
	sel_operation <= "00";

	inc_ptr <= '0';
	dec_ptr <= '0';
	inc_cnt <= '0';
	dec_cnt <= '0';
	inc_pc  <= '0';
	dec_pc  <= '0';

	
	case present_state is
		when init =>
			next_state <= fetch;
		when fetch =>
			CODE_EN <= '1';
			next_state <= decode;
		when decode =>
			case CODE_DATA is
				when X"3E" =>
					next_state <= ptr_increment;
				when X"3C" =>
					next_state <= ptr_decrement;
				when X"2B" =>
					next_state <= act_increment;
				when X"2D" =>
					next_state <= act_decrement;
				when X"5B" =>
					next_state <= cnt_increment;
				when X"5D" =>
					next_state <= cnt_decrement;
				when X"2E" =>
					next_state <= putchar;
				when X"2C" =>
					next_state <= getchar;
				when X"00" =>
					next_state <= halt;
				when others =>
					next_state <= pc_increment;
			end case;

		-- >
		when ptr_increment =>
			inc_ptr <= '1';
			inc_pc <= '1';
			next_state <= fetch;

		-- <
		when ptr_decrement =>
			dec_ptr <= '1';
			inc_pc <= '1';
			next_state <= fetch;

		-- +
		when act_increment =>
			DATA_EN   <= '1';
			sel_operation <= "10";
			next_state <= act_increment2;
		when act_increment2 =>
			sel_operation <= "10";
			DATA_EN   <= '1';
			DATA_RDWR <= '1';
			inc_pc 	 <= '1';
			next_state <= fetch;

		-- -
		when act_decrement =>
			DATA_EN   <= '1';
			sel_operation <= "01";
			next_state <= act_decrement2;
		when act_decrement2 =>
			sel_operation <= "01";
			DATA_EN   <= '1';
			DATA_RDWR <= '1';
			inc_pc 	 <= '1';
			next_state <= fetch;
		
		-- .
		when putchar =>
			DATA_EN    <= '1';
			next_state <= putchar2;
		when putchar2 =>
			if OUT_BUSY = '0' then		
        OUT_DATA <= DATA_RDATA;	
				OUT_WE	 <= '1';
				inc_pc    <= '1';
				next_state <= fetch;
			else
				next_state <= putchar2;
			end if;

		-- ,
		when getchar =>
			IN_REQ <= '1';
			next_state <= getchar2;
		when getchar2 =>
			if IN_VLD = '1' then
				DATA_EN <= '1';
				DATA_RDWR <= '1';
				inc_pc <= '1';
				next_state <= fetch;
			else
				next_state <= getchar2;
			end if;
	 
	
		-- [
		when cnt_increment =>
			inc_pc <= '1';
			DATA_EN <= '1';
			next_state <= cnt_increment2;
		when cnt_increment2 =>
			if data_zero = '1' then
				inc_cnt <= '1';
				next_state <= cnt_increment3;
			else
				next_state <= fetch;
			end if;
			
		-- while(cntzero == true)	
		when cnt_increment3 =>
			if cnt_zero = '1' then   -- jsou data nulova?
				next_state <= fetch;  -- end
				--	inc_cnt <= '1';
			else
				CODE_EN <= '1';		 -- continue
				next_state <= cnt_increment4;
			end if;
			
		when cnt_increment4 =>
		   next_state <= cnt_increment5;
		   if CODE_DATA = X"5B" then    -- [
				inc_cnt <= '1';
			elsif CODE_DATA = X"5D" then -- ]
				dec_cnt <= '1';
			elsif CODE_DATA = X"00" then -- NULL
				next_state <= halt;		  -- Damn programmer
			else
				null;
			end if;
		
		when cnt_increment5 =>
			next_state <= cnt_increment3;
			inc_pc <= '1';
			
			
		
		-- ]
		when cnt_decrement =>
			DATA_EN <= '1';  -- byvalo tu code_en.... zabralo to tri hodiny debuggingu :D :D :D  // testy 1 2 3 s tim projely.... used 5th test + brainfuck debugger... :D
			next_state <= cnt_decrement2;
		when cnt_decrement2 =>
			if data_zero = '1' then
				inc_pc <= '1';
				next_state <= fetch;
			else
				dec_pc <= '1';
				inc_cnt <= '1';
				next_state <= cnt_decrement3;
			end if;
		
		-- cyklime
		when cnt_decrement3 =>
			if cnt_zero = '1' then
				next_state <= fetch;
			else
				CODE_EN <= '1';
				next_state <= cnt_decrement4;
			end if;                      
			
		when cnt_decrement4 =>
			if CODE_DATA = X"5B" then
				dec_cnt <= '1';
			elsif CODE_DATA = X"5D" then
				inc_cnt <= '1';
			end if;                   
			next_state <=cnt_d5;
		when cnt_d5 =>
			if cnt_zero = '1' then
				inc_pc <= '1';
			else
				dec_pc <= '1';
			end if;
			next_state <= cnt_decrement3; 	
	
		-- NULL
		when halt =>
			next_state <= halt;
		
		-- others (komentare neobsahujici ridici znaky)
		when pc_increment =>
			inc_pc <= '1';
			next_state <= fetch;
			
		when others =>
			inc_pc <= '1';
			next_state <= fetch;
	end case;
end process;


end behavioral;

-- End of file: cpu.vhd --