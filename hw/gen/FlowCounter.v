// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : FlowCounter
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module FlowCounter (
  input  wire          io_enable,
  output wire          io_state_valid,
  output wire [7:0]    io_state_payload,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    counter;
  reg        [1:0]    phase;
  wire                when_FlowStreamCounters_l23;

  assign io_state_payload = counter;
  assign io_state_valid = (phase == 2'b00);
  assign when_FlowStreamCounters_l23 = (phase == 2'b11);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter <= 8'h0;
      phase <= 2'b00;
    end else begin
      if(io_enable) begin
        counter <= (counter + 8'h01);
        if(when_FlowStreamCounters_l23) begin
          phase <= 2'b00;
        end else begin
          phase <= (phase + 2'b01);
        end
      end
    end
  end


endmodule
