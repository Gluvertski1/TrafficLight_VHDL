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
LIBRARY work;
USE ieee.std_logic_1164.ALL;
USE altera.altera_primitives_components.ALL;
USE compH.ALL;

ENTITY trafficlight IS 
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
END trafficlight;

ARCHITECTURE ckt OF trafficlight IS
	TYPE STATE_TYPE IS (State0, State1, State2, State3);			-- Defining the states
	ATTRIBUTE syn_encoding: string;
	ATTRIBUTE syn_encoding OF STATE_TYPE: type IS "safe, one-hot";				-- prevents hang up states. see ppt.
	SIGNAL state_reg:  STATE_TYPE;													-- state register
	SIGNAL state_next: STATE_TYPE;													-- state next
	SIGNAL w_clock1hz		: std_logic;												-- clock wire
	
BEGIN

-- defining the clock.
clk_div: entity compH.clockdivider1hz(a) 											-- using the new instantiation wire
PORT MAP( 
												clock_50Mhz => i_clk,					-- assigning clock to the board clock
												clock_10Hz => open,						-- tell Quartus these are left high
												clock_1MHz => open,
												clock_100KHz => open,
												clock_10KHz => open,
												clock_1KHz => open,
												clock_100Hz => open,
												clock_1Hz => w_clock1hz					-- divide down to one hz and assign to wire
												);
												
--BUFF1: global 				PORT MAP(												
--												a_in => w_clock1hz,
--												a_out => w_clock1hz1);

-- This is the State Register.
PROCESS(w_clock1hz, i_reset)
BEGIN
	IF (i_reset = '1') THEN												-- asynch reset
		state_reg <= State0;
	ELSIF(w_clock1hz'EVENT AND w_clock1hz = '1') THEN			-- new 1hz clock wire is the system clock for TF
		state_reg <= state_next;
	END IF;
END PROCESS;

PROCESS(state_reg, i_emer)
BEGIN
state_next <= state_reg; 					-- default back to same state
			o_NSG <= '0';						-- gets rid of inferred latches
			o_NSY <= '0';
			o_NSR <= '0';
			o_EWG <= '0';
			o_EWY <= '0';
			o_EWR <= '0';


	CASE state_reg IS
			WHEN State0 =>						
			o_EWR <= '1';							-- always on 
			IF(i_emer = '1') THEN			
			o_NSR <= '1';							-- if emer then turn on both reds others wise go into state?
			ELSE
			o_NSG <= '1';
			state_next <= State1;
			END IF;
		
			WHEN State1 =>
			o_EWR <= '1';
			IF(i_emer = '1') THEN			
			o_NSR <= '1';
			ELSE
			o_NSY <= '1';
			state_next <= State2;
			END IF;
			
			WHEN State2 =>
			o_NSR <= '1';
			IF(i_emer = '1') THEN			
			o_EWR <= '1';
			ELSE
			o_EWG <= '1';
			state_next <= State3;
			END IF;
			
			WHEN State3 =>
			o_NSR <= '1';
			IF(i_emer = '1') THEN			
			o_EWR <= '1';
			ELSE
			o_EWY <= '1';
			state_next <= State0;
			END IF;
		END CASE;
	END PROCESS;
END ckt;	
			