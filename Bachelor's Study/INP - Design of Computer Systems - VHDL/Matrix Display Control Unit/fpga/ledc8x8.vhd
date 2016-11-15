----------------------------------------------------------------------------------
-- Predmet:  Navrh pocitacovych systemu (INP)
-- Projekt:  Rizeni maticoveho displaye
-- Student:  Petr Dvoracek
-- Popis:    Periodicke blikani inicialu meho jmena na maticovem displayi.
-- 
-- Nazev souboru:     ledc8x8.vhd
-- Posledni upravy:   11.rijen 2011
-- Datum vytvoreni:   11.rijen 2011
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ledc8x8 is
    Port (
           RESET : in  STD_LOGIC;
           SMCLK : in  STD_LOGIC;
           ROW : out  STD_LOGIC_VECTOR (7 downto 0);
           LED : out  STD_LOGIC_VECTOR (7 downto 0)
			);
end ledc8x8;

architecture Behavioral of ledc8x8 is
	signal cnt : std_logic_vector (21 downto 0) := (others => '0');
	signal ce : std_logic := '0';
	signal switch : std_logic := '0';
	signal rows : std_logic_vector (7 downto 0) := "01111111";
	signal ledky : std_logic_vector (7 downto 0) := "00000000";
begin
	ctrl_cnt: process(SMCLK, RESET)
	begin
		if RESET = '1' then 
			cnt <= (others => '0');	
		elsif SMCLK'event and SMCLK = '1' then
			if cnt = "1111111111111111111111" then
				cnt <= (others => '0');
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
	ce <= '1' when cnt(7 downto 0) = "11111111" else '0';
	switch <= '1' when cnt(21) = '1' else '0';

	row_cnt: process(SMCLK, RESET, ce)
	begin
		if RESET = '1' then
			rows <= "01111111"; -- 0 is active rows, 1 is unactive rows!!!
		elsif SMCLK'event and SMCLK = '1' then
			if ce = '1' then
				rows <= rows(0) & rows(7 downto 1); -- 1st: 01111111; 2nd: 10111111; 8th: 11111110; 9th = 1st;
			end if;
		end if;
	end process;
	ROW <= rows;
	
	dec: process(rows)
	begin                
		case rows is                 
			when "01111111" => ledky <= "00000000";  
			when "10111111" => ledky <= "11101110";  
			when "11011111" => ledky <= "10011001";  
			when "11101111" => ledky <= "10011001";  
			when "11110111" => ledky <= "11101001";  
			when "11111011" => ledky <= "10001001";  
			when "11111101" => ledky <= "10001110";  
			when "11111110" => ledky <= "00000000";  
			when others => ledky <= "11111111"; -- chyba :)
		end case;
	end process;
	
	LED <= ledky when switch='1' else "00000000";
end Behavioral;

