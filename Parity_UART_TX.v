module Parity_UART_TX 
#(parameter DATA_WIDTH=8)(
  input wire                    CLK,
  input wire                    EN_par,
  input wire                    valid_par,
  input wire                    type_par,
  input wire [DATA_WIDTH-1:0]   data_par,
  output reg                    out_par
  );
  
  always @(posedge CLK)
    begin 
      
      if (EN_par && valid_par)
        begin
          if (type_par) //EVEN PARITY
            begin
              out_par <=  ^data_par; 
            end
          else          // ODD PARITY
            begin
              out_par <= ~^data_par;
            end
        end
          else
            begin
              out_par <= out_par;
            end
        
    end
endmodule
      
  
  
