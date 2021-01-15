-- Jared Day
-- 11/6/2017

-- Traffic Light Problem 1-8 (Mealy - Emergency). Create State Machine in VHDL. Use 1Hz internal clock
-- from Georgia Tech clock divider. User VHDL hierarchy (new way) for top level (not schematic diagram). 
-- Force recovery from hang-up states by using the "Safe" attributein your VHDL code [ see my VHDL lecture 
-- part 3 "FSM and FSMD" and also the two Altera State Machine files (ASU-Learn Course Materials Section) I 
-- extracted from the Quartus II Manual and Handbook].

LIBRARY ieee;
LIBRARY altera;
LIBRARY compH;
USE ieee.std_logic_1164.ALL;
USE altera.altera_primitives_components.ALL;
USE compH.ALL;

ENTITY traflight2 IS 
PORT( 
		i_emer	: IN std_logic;			-- emergency input
		i_clk		: IN std_logic;			-- the system clock
		i_reset	: IN std_logic;			-- reset
		o_NSG		: OUT std_logic;			-- North South Green
		o_NSY		: OUT std_logic;			-- North South Yellow
		o_NSR		: OUT std_logic;			-- North South Red
		o_EWG		: OUT std_logic;			-- East West Green
		o_EWY 	: OUT std_logic;			-- East West Yellow
		o_EWR		: OUT std_logic			-- East West Red
		);
END traflight2;

ARCHITECTURE ckt OF traflight2 IS
	TYPE STATE_TYPE IS (State0, State1, State2, State3, State4);
	SIGNAL state_reg:  STATE_TYPE;
	SIGNAL state_next: STATE_TYPE;
	SIGNAL w_clock1hz, w_clock1hz1		: std_logic;
BEGIN

-- defining the clock.
clk_div: clockdivider1hz PORT MAP( 
												clock_50Mhz => i_clk,
												clock_10Hz => open,
												clock_1MHz => open,
												clock_100KHz => open,
												clock_10KHz => open,
												clock_1KHz => open,
												clock_100Hz => open,
												clock_1Hz => w_clock1hz
												);
												
BUFF1: global 				PORT MAP(												
												a_in => w_clock1hz,
												a_out => w_clock1hz1);

-- This is the State Register.
PROCESS(w_clock1hz1, i_reset, i_emer)
BEGIN
	IF (i_reset = '1') THEN
	   state_reg <= State0;
	ELSIF(i_emer = '1') THEN
		state_reg <= State4;
	ELSIF(w_clock1hz1'EVENT AND w_clock1hz1 = '1') THEN
		state_reg <= state_next;	
	ELSE -- do nothing
	END IF;
END PROCESS;

PROCESS(state_reg)
BEGIN
state_next <= state_reg; 					-- default back to same state
			o_NSG <= '0';						
			o_NSY <= '0';
			o_NSR <= '0';
			o_EWG <= '0';
			o_EWY <= '0';
			o_EWR <= '0';

	CASE state_reg IS
		WHEN State0 =>
			o_NSG <= '1';						
			o_EWR <= '1';
			state_next <= State0;

		
			WHEN State1 =>
			o_NSY <= '1';
			o_EWR <= '1';
			state_next <= State1;

			
			WHEN State2 =>
			o_NSR <= '1';
			o_EWG <= '1';
			state_next <= State2;

			
			WHEN State3 =>
			o_NSR <= '1';
			o_EWY <= '1';
			state_next <= State3;

			
			WHEN State4 =>
			o_NSR <= '1';
			o_EWR <= '1';
			state_next <= state_reg;
		END CASE;
	END PROCESS;
END ckt;	
			