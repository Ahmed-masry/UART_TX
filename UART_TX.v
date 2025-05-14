module UART_TX
  #(parameter DATA_WIDTH = 8)(
  input wire                     CLK, RST,
  input wire                     PAR_EN, PAR_TYP,
  input wire                     DATA_Valid,
  input wire [DATA_WIDTH-1:0]    P_DATA,
  output wire                    busy,
  output wire                    TX_OUT
  );

wire         par_calc_EN;  
wire         ser_data;
wire         par_bit;
wire         ser_done,ser_EN,stor_EN;
wire [1:0]   mux_sel;

FSM_UART_TX m0(
.CLK(CLK),
.RST(RST),
.par_EN_fsm(PAR_EN),
.valid_fsm(DATA_Valid),
.ser_done_fsm(ser_done),
.ser_EN_fsm(ser_EN),
.stor_EN_fsm(stor_EN),
.par_calc_EN_fsm(par_calc_EN),
.busy_fsm(busy),
.sel_fsm(mux_sel)
);

Parity_UART_TX 
#(.DATA_WIDTH(DATA_WIDTH)) m1(
.CLK(CLK),
.EN_par(par_calc_EN),
.valid_par(DATA_Valid),
.type_par(PAR_TYP),
.data_par(P_DATA),
.out_par(par_bit)
);

Serializer_UART_TX
#(.DATA_WIDTH(DATA_WIDTH)) m2(
.CLK(CLK),
.RST(RST),
.valid_ser(DATA_Valid),
.EN_ser(ser_EN),
.EN_stor(stor_EN),
.data_in_ser(P_DATA),
.done_ser(ser_done),
.out_ser(ser_data)
);

MUX_UART_TX m3(
.sel(mux_sel),
.ser_data_mux(ser_data),
.par_bit_mux(par_bit),
.tx_out_mux(TX_OUT)
);


endmodule