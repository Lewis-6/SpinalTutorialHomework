// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : StreamForkJoinCcTop
// Git hash  : 7d98c83b3cdf70382342972c64e297530851e7df

`timescale 1ns/1ps

module StreamForkJoinCcTop (
  input  wire          io_clockB,
  input  wire          io_resetB,
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

  wire                core_io_cmdA_ready;
  wire                core_io_cmdB_ready;
  wire                core_io_rspMul_valid;
  wire       [63:0]   core_io_rspMul_payload;
  wire                core_io_rspXor_valid;
  wire       [31:0]   core_io_rspXor_payload;

  StreamForkJoinCc core (
    .io_cmdA_valid     (io_cmdA_valid               ), //i
    .io_cmdA_ready     (core_io_cmdA_ready          ), //o
    .io_cmdA_payload   (io_cmdA_payload[31:0]       ), //i
    .io_cmdB_valid     (io_cmdB_valid               ), //i
    .io_cmdB_ready     (core_io_cmdB_ready          ), //o
    .io_cmdB_payload   (io_cmdB_payload[31:0]       ), //i
    .io_rspMul_valid   (core_io_rspMul_valid        ), //o
    .io_rspMul_ready   (io_rspMul_ready             ), //i
    .io_rspMul_payload (core_io_rspMul_payload[63:0]), //o
    .io_rspXor_valid   (core_io_rspXor_valid        ), //o
    .io_rspXor_ready   (io_rspXor_ready             ), //i
    .io_rspXor_payload (core_io_rspXor_payload[31:0]), //o
    .clk               (clk                         ), //i
    .reset             (reset                       ), //i
    .io_clockB         (io_clockB                   )  //i
  );
  assign io_cmdA_ready = core_io_cmdA_ready;
  assign io_cmdB_ready = core_io_cmdB_ready;
  assign io_rspMul_valid = core_io_rspMul_valid;
  assign io_rspMul_payload = core_io_rspMul_payload;
  assign io_rspXor_valid = core_io_rspXor_valid;
  assign io_rspXor_payload = core_io_rspXor_payload;

endmodule

module StreamForkJoinCc (
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
  input  wire          reset,
  input  wire          io_clockB
);

  wire                core_io_cmdA_ready;
  wire                core_io_cmdB_ready;
  wire                core_io_rspMul_valid;
  wire       [63:0]   core_io_rspMul_payload;
  wire                core_io_rspXor_valid;
  wire       [31:0]   core_io_rspXor_payload;
  wire                mulFifo_io_push_ready;
  wire                mulFifo_io_pop_valid;
  wire       [63:0]   mulFifo_io_pop_payload;
  wire       [4:0]    mulFifo_io_pushOccupancy;
  wire       [4:0]    mulFifo_io_popOccupancy;
  wire                mulFifo_reset_synchronized_1;
  wire                xorFifo_io_push_ready;
  wire                xorFifo_io_pop_valid;
  wire       [31:0]   xorFifo_io_pop_payload;
  wire       [4:0]    xorFifo_io_pushOccupancy;
  wire       [4:0]    xorFifo_io_popOccupancy;

  StreamForkJoin core (
    .io_cmdA_valid     (io_cmdA_valid               ), //i
    .io_cmdA_ready     (core_io_cmdA_ready          ), //o
    .io_cmdA_payload   (io_cmdA_payload[31:0]       ), //i
    .io_cmdB_valid     (io_cmdB_valid               ), //i
    .io_cmdB_ready     (core_io_cmdB_ready          ), //o
    .io_cmdB_payload   (io_cmdB_payload[31:0]       ), //i
    .io_rspMul_valid   (core_io_rspMul_valid        ), //o
    .io_rspMul_ready   (mulFifo_io_push_ready       ), //i
    .io_rspMul_payload (core_io_rspMul_payload[63:0]), //o
    .io_rspXor_valid   (core_io_rspXor_valid        ), //o
    .io_rspXor_ready   (xorFifo_io_push_ready       ), //i
    .io_rspXor_payload (core_io_rspXor_payload[31:0]), //o
    .clk               (clk                         ), //i
    .reset             (reset                       )  //i
  );
  StreamFifoCC mulFifo (
    .io_push_valid        (core_io_rspMul_valid         ), //i
    .io_push_ready        (mulFifo_io_push_ready        ), //o
    .io_push_payload      (core_io_rspMul_payload[63:0] ), //i
    .io_pop_valid         (mulFifo_io_pop_valid         ), //o
    .io_pop_ready         (io_rspMul_ready              ), //i
    .io_pop_payload       (mulFifo_io_pop_payload[63:0] ), //o
    .io_pushOccupancy     (mulFifo_io_pushOccupancy[4:0]), //o
    .io_popOccupancy      (mulFifo_io_popOccupancy[4:0] ), //o
    .clk                  (clk                          ), //i
    .reset                (reset                        ), //i
    .io_clockB            (io_clockB                    ), //i
    .reset_synchronized_1 (mulFifo_reset_synchronized_1 )  //o
  );
  StreamFifoCC_1 xorFifo (
    .io_push_valid        (core_io_rspXor_valid         ), //i
    .io_push_ready        (xorFifo_io_push_ready        ), //o
    .io_push_payload      (core_io_rspXor_payload[31:0] ), //i
    .io_pop_valid         (xorFifo_io_pop_valid         ), //o
    .io_pop_ready         (io_rspXor_ready              ), //i
    .io_pop_payload       (xorFifo_io_pop_payload[31:0] ), //o
    .io_pushOccupancy     (xorFifo_io_pushOccupancy[4:0]), //o
    .io_popOccupancy      (xorFifo_io_popOccupancy[4:0] ), //o
    .clk                  (clk                          ), //i
    .reset                (reset                        ), //i
    .io_clockB            (io_clockB                    ), //i
    .reset_synchronized_1 (mulFifo_reset_synchronized_1 )  //i
  );
  assign io_cmdA_ready = core_io_cmdA_ready;
  assign io_cmdB_ready = core_io_cmdB_ready;
  assign io_rspMul_valid = mulFifo_io_pop_valid;
  assign io_rspMul_payload = mulFifo_io_pop_payload;
  assign io_rspXor_valid = xorFifo_io_pop_valid;
  assign io_rspXor_payload = xorFifo_io_pop_payload;

endmodule

module StreamFifoCC_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [31:0]   io_pop_payload,
  output wire [4:0]    io_pushOccupancy,
  output wire [4:0]    io_popOccupancy,
  input  wire          clk,
  input  wire          reset,
  input  wire          io_clockB,
  input  wire          reset_synchronized_1
);

  reg        [31:0]   ram_spinal_port1;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire       [4:0]    _zz_pushCC_pushPtrGray;
  wire       [3:0]    _zz_ram_port;
  wire       [31:0]   _zz_ram_port_1;
  wire       [4:0]    _zz_popCC_popPtrGray;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  wire                io_push_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                _zz_io_pushOccupancy_2;
  wire                _zz_io_pushOccupancy_3;
  reg        [4:0]    popCC_popPtr;
  (* keep , syn_keep *) wire       [4:0]    popCC_popPtrPlus /* synthesis syn_keep = 1 */ ;
  wire       [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_addressGen_valid;
  reg                 popCC_addressGen_ready;
  wire       [3:0]    popCC_addressGen_payload;
  wire                popCC_empty;
  wire                popCC_addressGen_fire;
  wire                popCC_readArbitation_valid;
  wire                popCC_readArbitation_ready;
  wire       [3:0]    popCC_readArbitation_payload;
  reg                 popCC_addressGen_rValid;
  reg        [3:0]    popCC_addressGen_rData;
  wire                when_Stream_l477;
  wire                popCC_readPort_cmd_valid;
  wire       [3:0]    popCC_readPort_cmd_payload;
  wire       [31:0]   popCC_readPort_rsp;
  wire                popCC_addressGen_toFlowFire_valid;
  wire       [3:0]    popCC_addressGen_toFlowFire_payload;
  wire                popCC_readArbitation_translated_valid;
  wire                popCC_readArbitation_translated_ready;
  wire       [31:0]   popCC_readArbitation_translated_payload;
  wire                popCC_readArbitation_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    popCC_ptrToPush;
  reg        [4:0]    popCC_ptrToOccupancy;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  wire                _zz_io_popOccupancy_2;
  wire                _zz_io_popOccupancy_3;
  reg [31:0] ram [0:15];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[3:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtr >>> 1'b1);
  assign _zz_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge io_clockB) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC popToPushGray_buffercc (
    .io_dataIn  (popToPushGray[4:0]                    ), //i
    .io_dataOut (popToPushGray_buffercc_io_dataOut[4:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_4 pushToPopGray_buffercc (
    .io_dataIn            (pushToPopGray[4:0]                    ), //i
    .io_dataOut           (pushToPopGray_buffercc_io_dataOut[4:0]), //o
    .io_clockB            (io_clockB                             ), //i
    .reset_synchronized_1 (reset_synchronized_1                  )  //i
  );
  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = (pushCC_popPtrGray[2] ^ _zz_io_pushOccupancy_2);
  assign _zz_io_pushOccupancy_2 = (pushCC_popPtrGray[3] ^ _zz_io_pushOccupancy_3);
  assign _zz_io_pushOccupancy_3 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_3,{_zz_io_pushOccupancy_2,{_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,(pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy)}}}});
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_popPtrGray = (_zz_popCC_popPtrGray ^ popCC_popPtr);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign popCC_addressGen_valid = (! popCC_empty);
  assign popCC_addressGen_payload = popCC_popPtr[3:0];
  assign popCC_addressGen_fire = (popCC_addressGen_valid && popCC_addressGen_ready);
  always @(*) begin
    popCC_addressGen_ready = popCC_readArbitation_ready;
    if(when_Stream_l477) begin
      popCC_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l477 = (! popCC_readArbitation_valid);
  assign popCC_readArbitation_valid = popCC_addressGen_rValid;
  assign popCC_readArbitation_payload = popCC_addressGen_rData;
  assign popCC_readPort_rsp = ram_spinal_port1;
  assign popCC_addressGen_toFlowFire_valid = popCC_addressGen_fire;
  assign popCC_addressGen_toFlowFire_payload = popCC_addressGen_payload;
  assign popCC_readPort_cmd_valid = popCC_addressGen_toFlowFire_valid;
  assign popCC_readPort_cmd_payload = popCC_addressGen_toFlowFire_payload;
  assign popCC_readArbitation_translated_valid = popCC_readArbitation_valid;
  assign popCC_readArbitation_ready = popCC_readArbitation_translated_ready;
  assign popCC_readArbitation_translated_payload = popCC_readPort_rsp;
  assign io_pop_valid = popCC_readArbitation_translated_valid;
  assign popCC_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = popCC_readArbitation_translated_payload;
  assign popCC_readArbitation_fire = (popCC_readArbitation_valid && popCC_readArbitation_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = (popCC_pushPtrGray[2] ^ _zz_io_popOccupancy_2);
  assign _zz_io_popOccupancy_2 = (popCC_pushPtrGray[3] ^ _zz_io_popOccupancy_3);
  assign _zz_io_popOccupancy_3 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_io_popOccupancy_3,{_zz_io_popOccupancy_2,{_zz_io_popOccupancy_1,{_zz_io_popOccupancy,(popCC_pushPtrGray[0] ^ _zz_io_popOccupancy)}}}} - popCC_ptrToOccupancy);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_ptrToPush;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge io_clockB or posedge reset_synchronized_1) begin
    if(reset_synchronized_1) begin
      popCC_popPtr <= 5'h0;
      popCC_addressGen_rValid <= 1'b0;
      popCC_ptrToPush <= 5'h0;
      popCC_ptrToOccupancy <= 5'h0;
    end else begin
      if(popCC_addressGen_fire) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
      if(popCC_addressGen_ready) begin
        popCC_addressGen_rValid <= popCC_addressGen_valid;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToPush <= popCC_popPtrGray;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToOccupancy <= popCC_popPtr;
      end
    end
  end

  always @(posedge io_clockB) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

module StreamFifoCC (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [63:0]   io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [63:0]   io_pop_payload,
  output wire [4:0]    io_pushOccupancy,
  output wire [4:0]    io_popOccupancy,
  input  wire          clk,
  input  wire          reset,
  input  wire          io_clockB,
  output wire          reset_synchronized_1
);

  reg        [63:0]   ram_spinal_port1;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire                reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire       [4:0]    _zz_pushCC_pushPtrGray;
  wire       [3:0]    _zz_ram_port;
  wire       [63:0]   _zz_ram_port_1;
  wire       [4:0]    _zz_popCC_popPtrGray;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  wire                io_push_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                _zz_io_pushOccupancy_2;
  wire                _zz_io_pushOccupancy_3;
  wire                reset_asyncAssertSyncDeassert;
  wire                reset_synchronized;
  reg        [4:0]    popCC_popPtr;
  (* keep , syn_keep *) wire       [4:0]    popCC_popPtrPlus /* synthesis syn_keep = 1 */ ;
  wire       [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_addressGen_valid;
  reg                 popCC_addressGen_ready;
  wire       [3:0]    popCC_addressGen_payload;
  wire                popCC_empty;
  wire                popCC_addressGen_fire;
  wire                popCC_readArbitation_valid;
  wire                popCC_readArbitation_ready;
  wire       [3:0]    popCC_readArbitation_payload;
  reg                 popCC_addressGen_rValid;
  reg        [3:0]    popCC_addressGen_rData;
  wire                when_Stream_l477;
  wire                popCC_readPort_cmd_valid;
  wire       [3:0]    popCC_readPort_cmd_payload;
  wire       [63:0]   popCC_readPort_rsp;
  wire                popCC_addressGen_toFlowFire_valid;
  wire       [3:0]    popCC_addressGen_toFlowFire_payload;
  wire                popCC_readArbitation_translated_valid;
  wire                popCC_readArbitation_translated_ready;
  wire       [63:0]   popCC_readArbitation_translated_payload;
  wire                popCC_readArbitation_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    popCC_ptrToPush;
  reg        [4:0]    popCC_ptrToOccupancy;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  wire                _zz_io_popOccupancy_2;
  wire                _zz_io_popOccupancy_3;
  reg [63:0] ram [0:15];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[3:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtr >>> 1'b1);
  assign _zz_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge io_clockB) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC popToPushGray_buffercc (
    .io_dataIn  (popToPushGray[4:0]                    ), //i
    .io_dataOut (popToPushGray_buffercc_io_dataOut[4:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_1 reset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn  (reset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut (reset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .io_clockB  (io_clockB                                        ), //i
    .reset      (reset                                            )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_2 pushToPopGray_buffercc (
    .io_dataIn          (pushToPopGray[4:0]                    ), //i
    .io_dataOut         (pushToPopGray_buffercc_io_dataOut[4:0]), //o
    .io_clockB          (io_clockB                             ), //i
    .reset_synchronized (reset_synchronized                    )  //i
  );
  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = (pushCC_popPtrGray[2] ^ _zz_io_pushOccupancy_2);
  assign _zz_io_pushOccupancy_2 = (pushCC_popPtrGray[3] ^ _zz_io_pushOccupancy_3);
  assign _zz_io_pushOccupancy_3 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_3,{_zz_io_pushOccupancy_2,{_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,(pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy)}}}});
  assign reset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign reset_synchronized = reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_popPtrGray = (_zz_popCC_popPtrGray ^ popCC_popPtr);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign popCC_addressGen_valid = (! popCC_empty);
  assign popCC_addressGen_payload = popCC_popPtr[3:0];
  assign popCC_addressGen_fire = (popCC_addressGen_valid && popCC_addressGen_ready);
  always @(*) begin
    popCC_addressGen_ready = popCC_readArbitation_ready;
    if(when_Stream_l477) begin
      popCC_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l477 = (! popCC_readArbitation_valid);
  assign popCC_readArbitation_valid = popCC_addressGen_rValid;
  assign popCC_readArbitation_payload = popCC_addressGen_rData;
  assign popCC_readPort_rsp = ram_spinal_port1;
  assign popCC_addressGen_toFlowFire_valid = popCC_addressGen_fire;
  assign popCC_addressGen_toFlowFire_payload = popCC_addressGen_payload;
  assign popCC_readPort_cmd_valid = popCC_addressGen_toFlowFire_valid;
  assign popCC_readPort_cmd_payload = popCC_addressGen_toFlowFire_payload;
  assign popCC_readArbitation_translated_valid = popCC_readArbitation_valid;
  assign popCC_readArbitation_ready = popCC_readArbitation_translated_ready;
  assign popCC_readArbitation_translated_payload = popCC_readPort_rsp;
  assign io_pop_valid = popCC_readArbitation_translated_valid;
  assign popCC_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = popCC_readArbitation_translated_payload;
  assign popCC_readArbitation_fire = (popCC_readArbitation_valid && popCC_readArbitation_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = (popCC_pushPtrGray[2] ^ _zz_io_popOccupancy_2);
  assign _zz_io_popOccupancy_2 = (popCC_pushPtrGray[3] ^ _zz_io_popOccupancy_3);
  assign _zz_io_popOccupancy_3 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_io_popOccupancy_3,{_zz_io_popOccupancy_2,{_zz_io_popOccupancy_1,{_zz_io_popOccupancy,(popCC_pushPtrGray[0] ^ _zz_io_popOccupancy)}}}} - popCC_ptrToOccupancy);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_ptrToPush;
  assign reset_synchronized_1 = reset_synchronized;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge io_clockB or posedge reset_synchronized) begin
    if(reset_synchronized) begin
      popCC_popPtr <= 5'h0;
      popCC_addressGen_rValid <= 1'b0;
      popCC_ptrToPush <= 5'h0;
      popCC_ptrToOccupancy <= 5'h0;
    end else begin
      if(popCC_addressGen_fire) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
      if(popCC_addressGen_ready) begin
        popCC_addressGen_rValid <= popCC_addressGen_valid;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToPush <= popCC_popPtrGray;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToOccupancy <= popCC_popPtr;
      end
    end
  end

  always @(posedge io_clockB) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

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

module BufferCC_4 (
  input  wire [4:0]    io_dataIn,
  output wire [4:0]    io_dataOut,
  input  wire          io_clockB,
  input  wire          reset_synchronized_1
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    buffers_0;
  (* async_reg = "true" *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge io_clockB or posedge reset_synchronized_1) begin
    if(reset_synchronized_1) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

//BufferCC_3 replaced by BufferCC

module BufferCC_2 (
  input  wire [4:0]    io_dataIn,
  output wire [4:0]    io_dataOut,
  input  wire          io_clockB,
  input  wire          reset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    buffers_0;
  (* async_reg = "true" *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge io_clockB or posedge reset_synchronized) begin
    if(reset_synchronized) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_1 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          io_clockB,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge io_clockB or posedge reset) begin
    if(reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC (
  input  wire [4:0]    io_dataIn,
  output wire [4:0]    io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [4:0]    buffers_0;
  (* async_reg = "true" *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
