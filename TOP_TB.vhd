LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP_MAIN
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         boton : IN  std_logic;
         bot_clear : IN  std_logic;
         sw : IN  std_logic_vector(7 downto 0);
         en : OUT  std_logic;
         rs : OUT  std_logic;
         rw : OUT  std_logic;
         db : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal boton : std_logic := '0';
   signal bot_clear : std_logic := '0';
   signal sw : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal en : std_logic;
   signal rs : std_logic;
   signal rw : std_logic;
   signal db : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP_MAIN PORT MAP (
          clk => clk,
          rst => rst,
          boton => boton,
          bot_clear => bot_clear,
          sw => sw,
          en => en,
          rs => rs,
          rw => rw,
          db => db
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1';
		wait for 20 ns;
		rst <= '0';
		wait for 2850 ns;
		boton <= '1';
		sw <= x"41";
		wait for 230 ns;
		boton <= '0';
      wait;
   end process;

END;
