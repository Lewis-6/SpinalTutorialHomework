// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : StreamToRamRecorder
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module StreamToRamRecorder (
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [31:0]   io_input_payload,
  input  wire          io_readValid,
  input  wire [7:0]    io_readAddress,
  output wire [31:0]   io_readData,
  output wire [8:0]    io_writtenCount,
  output wire          io_full,
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   mem_spinal_port1;
  wire       [7:0]    _zz_mem_port;
  wire       [31:0]   _zz_mem_port_1;
  wire                _zz_mem_port_2;
  reg        [8:0]    writeCount;
  wire                full;
  wire                io_input_fire;
  reg [31:0] mem [0:255];

  assign _zz_mem_port = writeCount[7:0];
  assign _zz_mem_port_1 = io_input_payload;
  assign _zz_mem_port_2 = 1'b1;
  always @(posedge clk) begin
    if(_zz_mem_port_2) begin
      mem[_zz_mem_port] <= _zz_mem_port_1;
    end
  end

  always @(posedge clk) begin
    if(io_readValid) begin
      mem_spinal_port1 <= mem[io_readAddress];
    end
  end

  assign full = (writeCount == 9'h100);
  assign io_input_ready = (! full);
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign io_readData = mem_spinal_port1;
  assign io_writtenCount = writeCount;
  assign io_full = full;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      writeCount <= 9'h0;
    end else begin
      if(io_input_fire) begin
        writeCount <= (writeCount + 9'h001);
      end
    end
  end


endmodule
