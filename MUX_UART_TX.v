module MUX_UART_TX (
  input wire  [1:0]   sel,
  input wire          ser_data_mux,
  input wire          par_bit_mux,
  output reg          tx_out_mux
  );
  
  always @*
    begin
      case (sel)
         2'b00 :   //**********starting bit**********
                begin
                  tx_out_mux = 1'b0;
                end
         2'b01 :  //************stoping bit**********
                begin
                  tx_out_mux = 1'b1;
                end
         2'b10 :  //************serial data**********
                begin
                  tx_out_mux = ser_data_mux;
                end
         2'b11 :  //************parity bit***********
                begin
                  tx_out_mux = par_bit_mux;
                end
      endcase
    end
    
  endmodule
              
  
