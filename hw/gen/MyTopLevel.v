// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : MyTopLevel
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module MyTopLevel (
  output wire          io_cnt_out_valid,
  input  wire          io_cnt_out_ready,
  output wire [31:0]   io_cnt_out_payload,
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   counter;
  wire                io_cnt_out_fire;

  assign io_cnt_out_valid = 1'b1;
  assign io_cnt_out_payload = counter;
  assign io_cnt_out_fire = (io_cnt_out_valid && io_cnt_out_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter <= 32'h0;
    end else begin
      if(io_cnt_out_fire) begin
        counter <= (counter + 32'h00000001);
      end
    end
  end


endmodule
