module Serializer_UART_TX
#(parameter DATA_WIDTH = 8 )(

input wire                    CLK, RST,
input wire                    valid_ser,
input wire                    EN_ser, EN_stor,
input wire [DATA_WIDTH-1:0]   data_in_ser,
output wire                   done_ser,
output reg                    out_ser
);

reg [DATA_WIDTH-1:0] data;        //shift_rigster

reg [3:0]            counter;     //counter 

always @(posedge CLK, negedge RST)
  begin
    
    //***********reset operation************
    if(!RST)             
      begin
        data     <=  'b0;
        out_ser  <= 1'b0;
      end
      
    //***********storing operation************  
    else if(valid_ser && EN_stor)
      begin
        data     <= data_in_ser;
      end
      
    //***********serialization operation************  
    else if (EN_ser && !done_ser)
      begin
            {data[DATA_WIDTH-2:0],out_ser}     <= data;
             data[DATA_WIDTH-1]                <= 1'b0;
      end
    
    //***********else************  
    else
      begin
        data      <=  data;
      end
  end  

// *********counter to count the time needed to out the data************   
always @(posedge CLK, negedge RST)
  begin
    if(!RST || EN_stor )
      begin
        counter <= 'b0;
      end            
    else if(!done_ser && EN_ser)
      begin
        counter <= counter + 1;
      end
    else 
      begin
        counter <= 'b0;
      end
        
  end
  
assign done_ser    =(counter == (DATA_WIDTH));  
endmodule
    
        







