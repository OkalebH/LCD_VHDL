library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncing is
    Port ( clk, reset : in  STD_LOGIC;
			  sw : in STD_LOGIC;
           db : out  STD_LOGIC
			 );
end debouncing;

architecture Behavioral of debouncing is
CONSTANT N : integer := 2;--19; ---- 2^N * 20 ns = 10 ms
signal q_reg, q_next : unsigned(N-1 downto 0);
signal m_tick : std_logic;
type states is (zero, wait1_1, wait1_2, wait1_3, 
					 one, wait0_1, wait0_2, wait0_3
					 );
signal state_reg, state_next 	: states;
begin
process(clk)
begin
	if (clk'event and clk = '1') then
		q_reg <= q_next;
	end if;
end process;

q_next <= q_reg + 1;

m_tick <= '1' when q_reg = 0 else '0';

process(reset,clk)
begin
	if (reset = '1') then
		state_reg <= zero;
	elsif (clk'event and clk = '1') then
		state_reg <= state_next;
	end if;
end process;
-- next-state/output logic
process(state_reg, sw, m_tick)
begin
	state_next <= state_reg;
	db <= '0';
	case state_reg is
		when zero => 
			if sw = '1' then
				state_next <= wait1_1;
			end if;
		when wait1_1 =>
			if sw = '0' then
				state_next <= zero;
			else 
				if m_tick = '1' then
					state_next <= wait1_2;
				end if;
			end if;
		when wait1_2 =>
			if sw = '0' then
				state_next <= zero;
			else
				if m_tick = '1' then
					state_next <= wait1_3;
				end if;
			end if;
		when wait1_3 =>
			if sw = '0' then
				state_next <= zero;
			else
				if m_tick = '1' then
					state_next <= one;
				end if;
			end if;
		when one =>
			db <= '1';
			if sw = '0' then
				state_next <= wait0_1;
			end if;
		when wait0_1 =>
			db <= '1';
			if sw = '1' then
				state_next <= one;
			else 
				if (m_tick = '1') then
					state_next <= wait0_2;
				end if;
			end if;
		when wait0_2 =>
			db <= '1';
			if sw = '1' then
				state_next <= one;
			else
				if m_tick = '1' then 
					state_next <= wait0_3;
				end if;
			end if;
		when wait0_3 =>
			db <= '1';
			if sw = '1' then
				state_next <= one;
			else
				if m_tick = '1' then
					state_next <= zero;
				end if;
			end if;
	end case;
end process;
end Behavioral;

