// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : StreamCounter
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module StreamCounter (
  input  wire          io_enable,
  output wire          io_state_valid,
  input  wire          io_state_ready,
  output wire [7:0]    io_state_payload,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    nextValue;
  reg        [7:0]    payload;
  reg                 valid;
  reg        [1:0]    phase;
  wire                io_state_fire;
  wire                io_state_isStall;
  wire                when_FlowStreamCounters_l52;
  wire                when_FlowStreamCounters_l57;

  assign io_state_valid = valid;
  assign io_state_payload = payload;
  assign io_state_fire = (io_state_valid && io_state_ready);
  assign io_state_isStall = (io_state_valid && (! io_state_ready));
  assign when_FlowStreamCounters_l52 = (io_enable && (! io_state_isStall));
  assign when_FlowStreamCounters_l57 = (phase == 2'b11);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      nextValue <= 8'h0;
      payload <= 8'h0;
      valid <= 1'b0;
      phase <= 2'b00;
    end else begin
      if(io_state_fire) begin
        valid <= 1'b0;
      end
      if(when_FlowStreamCounters_l52) begin
        payload <= nextValue;
        nextValue <= (nextValue + 8'h01);
        valid <= (phase == 2'b00);
        if(when_FlowStreamCounters_l57) begin
          phase <= 2'b00;
        end else begin
          phase <= (phase + 2'b01);
        end
      end
    end
  end


endmodule
