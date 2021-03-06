--------------------------------------------------------------------------------
-- PROJECT: SIMPLE UART FOR FPGA
--------------------------------------------------------------------------------
-- AUTHORS: Jakub Cabal <jakubcabal@gmail.com>
-- LICENSE: The MIT License, please read LICENSE file
-- WEBSITE: https://github.com/jakubcabal/uart-for-fpga
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_PARITY is
    Generic (
        DATA_WIDTH : integer := 8
    );
    Port (
        PARITY_TYPE : in  std_logic_vector(1 downto 0); -- type of parity: -0: "none", 01: "odd", 11: "even"
        DATA_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        PARITY_OUT  : out std_logic
    );
end entity;

architecture RTL of UART_PARITY is

    signal parity : std_logic := '0';
begin

    -- -------------------------------------------------------------------------
    -- PARITY BIT GENERATOR
    -- -------------------------------------------------------------------------

    parity_generator :
    process (DATA_IN)
        variable parity_temp : std_logic;
    begin
        parity_temp := '0';
        for i in DATA_IN'range loop
            parity_temp := parity_temp XOR DATA_IN(i);
        end loop;
        parity <= parity_temp;
    end process;

    process (parity, PARITY_TYPE)
    begin
        case PARITY_TYPE is
            when "11"   => PARITY_OUT <= parity;
            when "01"   => PARITY_OUT <= NOT parity;
            when others => PARITY_OUT <= '0';
        end case;
    end process;

end architecture;
