// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : MyCounter
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module MyCounter (
  input  wire          io_enable,
  output wire [3:0]    io_state,
  output wire          io_overflow,
  input  wire          clk,
  input  wire          reset
);

  reg        [3:0]    counter;
  reg                 overflow;
  wire       [3:0]    maxValue;

  assign maxValue = 4'b1111;
  assign io_state = counter;
  assign io_overflow = overflow;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter <= 4'b0000;
      overflow <= 1'b0;
    end else begin
      if(io_enable) begin
        overflow <= (counter == maxValue);
        counter <= (counter + 4'b0001);
      end
    end
  end


endmodule
