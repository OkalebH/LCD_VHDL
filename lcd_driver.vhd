library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY lcd_driver IS
GENERIC (clk_divider: INTEGER := 100_000); --25MHz to 500Hz
PORT (rst, boton, clear: IN std_logic;
		en : in std_logic;
		sw : in std_logic_VECTOR(7 downto 0);
		RS, RW: OUT std_logic;
		E: out std_logic;
		DB: OUT std_logic_vector(7 DOWNTO 0));
END lcd_driver;

ARCHITECTURE lcd_driver of lcd_driver is
	type state is (FunctionSet1, FunctionSet2, FunctionSet3, FunctionSet4, 
						ClearDisplay, DisplayControl, EntryMode, WriteData1,wait1);
	signal s_reg, s_next : state;
begin
	process(en)
	begin
		if (en'event and en='1') then
			if(rst = '1')then
				s_reg <= FunctionSet1;
			else
				s_reg <= s_next;
			end if;
		end if;
	end process;
	
	process(s_reg, boton, sw, clear)
	--variable cont : integer range 0 to 100_000;
	begin
		s_next <= s_reg;
		case s_reg is
			when FunctionSet1 =>
				rs <= '0';
				rw <= '0';
				db <= x"38";
				
				s_next <= FunctionSet2;
			when FunctionSet2 =>
				rs <= '0';
				rw <= '0';
				db <= x"38";
				
				s_next <= FunctionSet3;
			when FunctionSet3 =>
				rs <= '0';
				rw <= '0';
				db <= x"38";
			
				s_next <= FunctionSet4; 
			when FunctionSet4 =>
				rs <= '0';
				rw <= '0';
				db <= x"38";
				
				s_next <= ClearDisplay;
			when ClearDisplay =>
				rs <= '0';
				rw <= '0';
				db <= x"01";
				s_next <= DisplayControl;
			when DisplayControl =>
				rs <= '0';
				rw <= '0';
				db <= x"0C";
				
				s_next <= EntryMode;
			when EntryMode => 
				rs <= '0';
				rw <= '0';
				db <= x"06";
				
				s_next <= WriteData1;
			when WriteData1 =>
				if boton = '1' then	
					rs <= '1';
					rw <= '0';
					db <= sw;					
					s_next <= wait1;
				elsif clear = '1' then
					s_next <= ClearDisplay;
				else
					rs <= '1';
					rw <= '0';					
					db <= x"41";
					s_next <= WriteData1;
				end if;
			when wait1 =>
				if boton = '0' then
					s_next <= WriteData1;
				end if;
		end case;
	end process;
	e <= en;
end lcd_driver;