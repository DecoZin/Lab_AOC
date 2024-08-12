library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity interrupt_ctl is
  generic (
    RESET_ACTIVE_LEVEL : std_logic := '1' --# Asynch. reset control level
  );
  port (
    --# {{clocks|}}
    Clock : in std_logic; --# System clock
    Reset : in std_logic; --# Asynchronous reset
    Enable: in std_logic; --# Enable interrupts

    --# {{control|}}
    Int_mask      : in std_logic_vector(1 downto 0);  --# Set bits correspond to active interrupts
    Int_request   : in std_logic_vector(1 downto 0);  --# Controls used to activate new interrupts
    Acknowledge   : in std_logic;  --# Clear the active interupt
    Clear_pending : in std_logic   --# Clear all pending interrupts
    
    Pending       : out std_logic_vector(1 downto 0); --# Set bits indicate which interrupts are pending
    Current       : out std_logic_vector(1 downto 0); --# Single set bit for the active interrupt
    Interrupt     : out std_logic; --# Flag indicating when an interrupt is pending
  );
end entity;

architecture rtl of interrupt_ctl is
  signal pending_loc, current_loc : std_logic_vector(Int_request'range);
  signal interrupt_loc : std_logic;

  -- Priority decoder
  -- Input is a vector of all pending interrupts. Result is a vector with just the
  -- highest priority interrupt bit set.
  function priority_decode(pending : std_logic_vector) return std_logic_vector is
    variable result : std_logic_vector(pending'range);
    variable or_chain : std_logic;
  begin

   -- Lowest bit has highest priority
    result(pending'low) := pending(pending'low);
    or_chain := result(pending'low);

    -- Loop through looking for the highest priority interrupt that is pending
    for i in pending'low + 1 to pending'high loop
      if pending(i) = '1' and or_chain = '0' then
        result(i) := '1';
      else
        result(i) := '0';
      end if;

      or_chain := or_chain or pending(i);
    end loop;

    return result;
  end function;

  -- OR-reduce for compatability with VHDL-93
  function or_reduce(vec: std_logic_vector) return std_logic is
    variable or_chain : std_logic;
  begin
    or_chain := '0';
    for i in vec'range loop
      or_chain := or_chain or vec(i);
    end loop;

    return or_chain;
  end function;

begin

  ic: process(Clock, Reset) is
    variable clear_int_n, pending_v, current_v : std_logic_vector(pending'range);
    variable interrupt_v : std_logic;
  begin
    assert Int_request'length >= 2
      report "Interrupt priority decoder must have at least two inputs"
      severity failure;

    assert Int_mask'length = Int_request'length
      report "Int_mask length must match Int_request" severity failure;

    assert Pending'length = Int_request'length
      report "Pending length must match Int_request" severity failure;

    assert Current'length = Int_request'length
      report "Current length must match Int_request" severity failure;


    if Reset = RESET_ACTIVE_LEVEL then
      pending_loc <= (others => '0');
      current_loc <= (others => '0');
      interrupt_loc <= '0';
    elsif rising_edge(Clock) then

      if Clear_pending = '1' then -- Clear all
        clear_int_n := (others => '0');
      elsif Acknowledge = '1' then -- Clear the pending interrupt
        clear_int_n := not current_loc;
      else -- Clear nothing
        clear_int_n := (others => '1');
      end if;

      -- Keep track of pending interrupts while disabling inactive interrupts
      -- and clearing acknowledged interrupts.
      pending_v := (Int_request or pending_loc) and Int_mask and clear_int_n;
      pending_loc <= pending_v;

      -- Determine the active interrupt from among those pending
      current_v := priority_decode(pending_v);

      -- Flag when any active interrupt is pending
      interrupt_v := or_reduce(current_v);
      interrupt_loc <= interrupt_v;

      if interrupt_loc = '0' or (interrupt_loc = '1' and Acknowledge = '1') then
        -- Update current interrupt
        current_loc <= current_v;
      end if;

    end if;
  end process;

  Current <= current_loc;
  Pending <= pending_loc;
  Interrupt <= interrupt_loc;
end architecture;
