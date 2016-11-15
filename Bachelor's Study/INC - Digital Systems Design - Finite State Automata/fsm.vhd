-- fsm.vhd: Finite State Machine
-- Author(s): Petr Dvoracek, xdvora0n
--
library ieee;
use ieee.std_logic_1164.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity fsm is
port(
   CLK         : in  std_logic;
   RESET       : in  std_logic;

   -- Input signals
   KEY         : in  std_logic_vector(15 downto 0);
   CNT_OF      : in  std_logic;

   -- Output signals
   FSM_CNT_CE  : out std_logic;
   FSM_MX_MEM  : out std_logic;
   FSM_MX_LCD  : out std_logic;
   FSM_LCD_WR  : out std_logic;
   FSM_LCD_CLR : out std_logic
);
end entity fsm;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of fsm is
   -- signal second_code : std_logic := '0';
   type t_state is (FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINETH, TENTH, LAST, 
                    THIRDb, FOURTHb, FIFTHb, SIXTHb, SEVENTHb, EIGHTHb, NINETHb, TENTHb,
                    BAD_MESSAGE, OK_MESSAGE, BAD_CODE, FINISH);
   signal present_state, next_state : t_state;

begin

-- -------------------------------------------------------
sync_logic : process(RESET, CLK)
begin
   if (RESET = '1') then
      present_state <= FIRST;
   elsif (CLK'event AND CLK = '1') then
      present_state <= next_state;
   end if;
end process sync_logic;


-- Nepouzit signal znacici druhy kod.
-- -------------------------------------------------------
next_state_logic : process(present_state, KEY, CNT_OF)
begin
   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FIRST =>
      next_state <= FIRST;
      if (KEY(1) = '1') then
         next_state <= SECOND;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when SECOND =>
      next_state <= SECOND;
      if (KEY(7) = '1') then
         next_state <= THIRD;
      elsif (KEY(0) = '1') then
         next_state <= THIRDb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when THIRD =>
      next_state <= THIRD;
      if (KEY(9) = '1') then
         next_state <= FOURTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when THIRDb =>
      next_state <= THIRDb;
      if (KEY(4) = '1') then
         next_state <= FOURTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FOURTH =>
      next_state <= FOURTH;
      if (KEY(0) = '1') then
         next_state <= FIFTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FOURTHb =>
      next_state <= FOURTHb;
      if (KEY(4) = '1') then
         next_state <= FIFTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FIFTH =>
      next_state <= FIFTH;
      if (KEY(7) = '1') then
         next_state <= SIXTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FIFTHb =>
      next_state <= FIFTHb;
      if (KEY(2) = '1') then
         next_state <= SIXTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when SIXTH =>
      next_state <= SIXTH;
      if (KEY(5) = '1') then
         next_state <= SEVENTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when SIXTHb =>
      next_state <= SIXTHb;
      if (KEY(8) = '1') then
         next_state <= SEVENTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when SEVENTH =>
      next_state <= SEVENTH;
      if (KEY(7) = '1') then
         next_state <= EIGHTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when SEVENTHb =>
      next_state <= SEVENTHb;
      if (KEY(7) = '1') then
         next_state <= EIGHTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when EIGHTH =>
      next_state <= EIGHTH;
      if (KEY(4) = '1')then
         next_state <= NINETH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when EIGHTHb =>
      next_state <= EIGHTHb;
      if (KEY(5) = '1')then
         next_state <= NINETHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when NINETH =>
      next_state <= NINETH;
      if (KEY(0) = '1') then
         next_state <= TENTH;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when NINETHb =>
      next_state <= NINETHb;
      if (KEY(9) = '1') then
         next_state <= TENTHb;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when TENTH =>
      next_state <= TENTH;
      if (KEY(9) = '1') then
         next_state <= LAST;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when TENTHb =>
      next_state <= TENTHb;
      if (KEY(6) = '1') then
         next_state <= LAST;
      elsif (KEY(15) = '1') then
         next_state <= BAD_MESSAGE; 
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when LAST =>
      next_state <= LAST;
      if (KEY(15) = '1') then
         next_state <= OK_MESSAGE;
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when BAD_CODE =>
      next_state <= BAD_CODE;
      if (KEY(15) = '1') then
         next_state <= BAD_MESSAGE;
      elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= BAD_CODE;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when BAD_MESSAGE =>
      next_state <= BAD_MESSAGE;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when OK_MESSAGE =>
      next_state <= OK_MESSAGE;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      next_state <= FINISH;
      if (KEY(15) = '1') then
         next_state <= FIRST; 
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
      next_state <= FIRST;
   end case;
end process next_state_logic;

-- -------------------------------------------------------
output_logic : process(present_state, KEY)
begin
   FSM_CNT_CE     <= '0';
   FSM_MX_MEM     <= '0';
   FSM_MX_LCD     <= '0';
   FSM_LCD_WR     <= '0';
   FSM_LCD_CLR    <= '0';

   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when BAD_MESSAGE =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';		
   -- - - - - - - - - - - - - - - - - - - - - - -
   when OK_MESSAGE =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';
      FSM_MX_MEM     <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      if (KEY(15) = '1') then
         FSM_LCD_CLR    <= '1';
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
      if (KEY(14 downto 0) /= "000000000000000") then
         FSM_LCD_WR     <= '1';
      end if;
      if (KEY(15) = '1') then
         FSM_LCD_CLR    <= '1';
      end if;
   end case;
end process output_logic;

end architecture behavioral;

