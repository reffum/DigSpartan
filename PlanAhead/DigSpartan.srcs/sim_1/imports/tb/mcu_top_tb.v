//-----------------------------------------------------------------------------
// testbench.v
//-----------------------------------------------------------------------------

`timescale 1 ps / 100 fs

// START USER CODE (Do not remove this line)

// User: Put your directives here. Code in this
//       section will not be overwritten.

// END USER CODE (Do not remove this line)

module testbench
  (
  );

  // START USER CODE (Do not remove this line)

  // User: Put your signals here. Code in this
  //       section will not be overwritten.

  // END USER CODE (Do not remove this line)

  real CLK_PERIOD = 40000.000000;
  real RESET_LENGTH = 640000;

  // Internal signals

  reg CLK;
  reg RESET;

  mcu
    dut (
      .RESET ( RESET ),
      .CLK ( CLK )
    );

  // Clock generator for CLK

  initial
    begin
      CLK = 1'b0;
      forever #(CLK_PERIOD/2.00)
        CLK = ~CLK;
    end

  // Reset Generator for RESET

  initial
    begin
      RESET = 1'b0;
      #(RESET_LENGTH) RESET = ~RESET;
    end

  // START USER CODE (Do not remove this line)

  // User: Put your stimulus here. Code in this
  //       section will not be overwritten.

  // END USER CODE (Do not remove this line)

endmodule

