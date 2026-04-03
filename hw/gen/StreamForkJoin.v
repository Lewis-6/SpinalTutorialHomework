// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : StreamForkJoin
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module StreamForkJoin (
  input  wire          io_cmdA_valid,
  output wire          io_cmdA_ready,
  input  wire [31:0]   io_cmdA_payload,
  input  wire          io_cmdB_valid,
  output wire          io_cmdB_ready,
  input  wire [31:0]   io_cmdB_payload,
  output wire          io_rspMul_valid,
  input  wire          io_rspMul_ready,
  output wire [63:0]   io_rspMul_payload,
  output wire          io_rspXor_valid,
  input  wire          io_rspXor_ready,
  output wire [31:0]   io_rspXor_payload,
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   aReg;
  reg        [31:0]   bReg;
  reg                 mulPending;
  reg                 xorPending;
  wire                busy;
  wire                accept;
  wire                io_rspMul_fire;
  wire                io_rspXor_fire;

  assign busy = (mulPending || xorPending);
  assign accept = ((io_cmdA_valid && io_cmdB_valid) && (! busy));
  assign io_cmdA_ready = (io_cmdB_valid && (! busy));
  assign io_cmdB_ready = (io_cmdA_valid && (! busy));
  assign io_rspMul_valid = mulPending;
  assign io_rspMul_payload = (aReg * bReg);
  assign io_rspMul_fire = (io_rspMul_valid && io_rspMul_ready);
  assign io_rspXor_valid = xorPending;
  assign io_rspXor_payload = (aReg ^ bReg);
  assign io_rspXor_fire = (io_rspXor_valid && io_rspXor_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      aReg <= 32'h0;
      bReg <= 32'h0;
      mulPending <= 1'b0;
      xorPending <= 1'b0;
    end else begin
      if(accept) begin
        aReg <= io_cmdA_payload;
        bReg <= io_cmdB_payload;
        mulPending <= 1'b1;
        xorPending <= 1'b1;
      end
      if(io_rspMul_fire) begin
        mulPending <= 1'b0;
      end
      if(io_rspXor_fire) begin
        xorPending <= 1'b0;
      end
    end
  end


endmodule
