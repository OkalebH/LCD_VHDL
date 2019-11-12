library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_MAIN is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           boton : in  STD_LOGIC;
           bot_clear : in  STD_LOGIC;
			  sw : in std_logic_vector(7 downto 0);
           en : out  STD_LOGIC;
           rs : out  STD_LOGIC;
           rw : out  STD_LOGIC;
           db : out  STD_LOGIC_VECTOR (7 downto 0));
end TOP_MAIN;

architecture Behavioral of TOP_MAIN is
COMPONENT debouncing
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		sw : IN std_logic;          
		db : OUT std_logic
		);
	END COMPONENT;
COMPONENT lcd_driver
	PORT(
		rst : IN std_logic;
		boton : IN std_logic;
		clear : IN std_logic;
		en : IN std_logic;
		sw : IN std_logic_vector(7 downto 0);          
		RS : OUT std_logic;
		RW : OUT std_logic;
		E : OUT std_logic;
		DB : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT timer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		tick : OUT std_logic
		);
	END COMPONENT;

	signal x_tick,x_boton,x_clear : std_logic;
	
begin
Inst_timer: timer PORT MAP(
		clk => clk,
		rst => rst,
		tick => x_tick
	);
BOTON_deb: debouncing PORT MAP(
		clk => clk,
		reset => rst,
		sw => boton,
		db => x_boton
	);
	CLEAR_deb: debouncing PORT MAP(
		clk => clk,
		reset => rst,
		sw => bot_clear,
		db => x_clear
	);
Inst_lcd_driver: lcd_driver PORT MAP(
		rst => rst,
		boton => x_boton,
		clear => x_clear,
		en => x_tick,
		sw => sw,
		RS => rs,
		RW => rw,
		E => en,
		DB => db
	);
	
end Behavioral;

