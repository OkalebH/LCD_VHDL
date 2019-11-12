library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end timer;

architecture Behavioral of timer is
signal s_next, s_reg : unsigned(16 downto 0);
constant limite : integer := 100_000;
signal tk_reg, tk_next : std_logic;
begin
process(clk,rst)
begin
	if rst = '1' then
		s_reg <= (others => '0');
		tk_reg <= '0';
	elsif clk'event and clk = '1' then
		s_reg <= s_next;
		tk_reg <= tk_next;
	end if;
end process;

s_next <= (others => '0') when s_reg = limite else s_reg + 1;
tk_next <= not tk_reg when s_reg = limite else tk_reg;
tick <= tk_reg;


end Behavioral;

