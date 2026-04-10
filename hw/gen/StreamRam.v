// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : StreamRam
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module StreamRam (
  input  wire          io_write_valid,
  output wire          io_write_ready,
  input  wire [7:0]    io_write_payload_address,
  input  wire [31:0]   io_write_payload_data,
  input  wire          io_readCmd_valid,
  output wire          io_readCmd_ready,
  input  wire [7:0]    io_readCmd_payload,
  output wire          io_readRsp_valid,
  input  wire          io_readRsp_ready,
  output wire [31:0]   io_readRsp_payload,
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   mem_spinal_port1;
  wire       [31:0]   _zz_mem_port;
  reg                 readInFlight;
  reg                 readValid;
  reg        [31:0]   readData;
  wire                io_write_fire;
  wire                io_readCmd_fire;
  wire       [31:0]   memReadData;
  wire                io_readRsp_fire;
  reg [31:0] mem [0:255];

  assign _zz_mem_port = io_write_payload_data;
  always @(posedge clk) begin
    if(io_write_fire) begin
      mem[io_write_payload_address] <= _zz_mem_port;
    end
  end

  always @(posedge clk) begin
    if(io_readCmd_fire) begin
      mem_spinal_port1 <= mem[io_readCmd_payload];
    end
  end

  assign io_write_ready = 1'b1;
  assign io_write_fire = (io_write_valid && io_write_ready);
  assign io_readCmd_ready = ((! readInFlight) && ((! readValid) || io_readRsp_ready));
  assign io_readCmd_fire = (io_readCmd_valid && io_readCmd_ready);
  assign memReadData = mem_spinal_port1;
  assign io_readRsp_fire = (io_readRsp_valid && io_readRsp_ready);
  assign io_readRsp_valid = readValid;
  assign io_readRsp_payload = readData;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      readInFlight <= 1'b0;
      readValid <= 1'b0;
      readData <= 32'h0;
    end else begin
      if(io_readCmd_fire) begin
        readInFlight <= 1'b1;
      end
      if(readInFlight) begin
        readData <= memReadData;
        readValid <= 1'b1;
        readInFlight <= 1'b0;
      end
      if(io_readRsp_fire) begin
        readValid <= 1'b0;
      end
    end
  end


endmodule
