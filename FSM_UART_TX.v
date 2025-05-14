module FSM_UART_TX (
  input wire            CLK, RST,
  input wire            valid_fsm,
  input wire            ser_done_fsm,
  input wire            par_EN_fsm,
  output reg            ser_EN_fsm,stor_EN_fsm,
  output reg            par_calc_EN_fsm,
  output reg            busy_fsm,
  output reg [1:0]      sel_fsm
  );
  
  localparam idle         = 3'b000,
             starting     = 3'b001,
             serialing    = 3'b010,
             parity        = 3'b011,
             stoping      = 3'b100;
             
      
reg [2:0] current_state, next_state;

always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        current_state <= idle;
      end
    else
      begin
        current_state <= next_state;
      end
  end
  
always @*
  begin
    
    busy_fsm          = 1'b0 ; 
    par_calc_EN_fsm   = 1'b0 ;
    ser_EN_fsm        = 1'b0 ; 
    stor_EN_fsm       = 1'b0 ;
    sel_fsm           = 2'b01;
    
    case (current_state)
      idle : 
            begin
              stor_EN_fsm       = 1'b1 ;
              par_calc_EN_fsm   = 1'b1 ;
              sel_fsm           = 2'b01;
              if(valid_fsm)
                begin
                  next_state = starting;
                end
              else
                begin
                  next_state = idle;
                end
            end
            
       starting : 
            begin
              busy_fsm          = 1'b1 ; 
              ser_EN_fsm        = 1'b1 ;
              sel_fsm           = 2'b00;
              next_state        = serialing;
            end
            
       serialing : 
            begin
              
              busy_fsm          = 1'b1 ;
              ser_EN_fsm        = 1'b1 ; 
              sel_fsm           = 2'b10;
              if(ser_done_fsm && par_EN_fsm)
                begin
                  next_state = parity;
                end
              else if(ser_done_fsm && !par_EN_fsm)
                begin
                  next_state = stoping;
                end
              else
                begin
                  next_state = serialing;
                end
            end
            
       parity : 
            begin
              sel_fsm         = 2'b11;
              busy_fsm        = 1'b1 ;
              next_state      = stoping;
            end
      
       stoping : 
            begin
              stor_EN_fsm       = 1'b1 ;
              par_calc_EN_fsm   = 1'b1 ;
              busy_fsm          = 1'b1 ; 
              sel_fsm           = 2'b01;
              if(valid_fsm)
                begin
                  next_state = starting;
                end
              else
                begin
                  next_state = idle;
                end
            end
            
       default : 
            begin
              sel_fsm           = 2'b01;
              busy_fsm          = 1'b0 ; 
              par_calc_EN_fsm   = 1'b0 ;
              ser_EN_fsm        = 1'b0 ; 
              stor_EN_fsm       = 1'b0 ;
              next_state        = idle;
            end
        endcase
    end 
  
    endmodule
