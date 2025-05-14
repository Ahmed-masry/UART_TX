`timescale 1us/1ps
module UART_TX_tb();
  
  parameter CLOCK_PERIOD    = 8.68;
  parameter DATA_WIDTH      = 8;
  
  reg                     CLK_tb, RST_tb;
  reg                     PAR_EN_tb, PAR_TYP_tb;
  reg                     DATA_Valid_tb;
  reg [DATA_WIDTH-1:0]    P_DATA_tb;
  wire                    busy_tb;
  wire                    TX_OUT_tb;
  
  
////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////
  UART_TX 
  #(.DATA_WIDTH(DATA_WIDTH)) DUT(
  .CLK(CLK_tb),
  .RST(RST_tb),
  .PAR_EN(PAR_EN_tb),
  .PAR_TYP(PAR_TYP_tb),
  .DATA_Valid(DATA_Valid_tb),
  .P_DATA(P_DATA_tb),
  .busy(busy_tb),
  .TX_OUT(TX_OUT_tb)
  );  
    
    ////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(CLOCK_PERIOD/2) CLK_tb = ~CLK_tb;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial 
  begin
    $dumpfile("UART_TX.vcd");
    $dumpvars;
    
    initialize();
    reset();
    //do_op(par_typ,par_en,data);
    //check(exp_out,test_num)
    //**********testcase 1 >>>>>> even parity*************
    do_op(1'b1,1'b1,8'b1010_0101);
    check(11'b1_0_1010_0101_0,'b1);
    
    //**********testcase 2 >>>>>> odd parity**************
    do_op(1'b0,1'b1,8'b1010_0101);
    check(11'b1_1_1010_0101_0,'b10);
    
    //**********testcase 3 >>>>>> no parity***************
    do_op(1'b1,1'b0,8'b1010_0101);
    check(11'b11_1010_0101_0,'b11);
    reset();
    
    //*****testcase 4 >>>>>> some test corner cases*********
    //**********no result in the tanscript******************
    PAR_EN_tb        =1'b0;
    PAR_TYP_tb       =1'b0;
    DATA_Valid_tb    =1'b1;
    P_DATA_tb        = 'b1011_0110;
    #(CLOCK_PERIOD)
    DATA_Valid_tb    =1'b0;
    #(5*CLOCK_PERIOD)
    P_DATA_tb        = 'b1000_0010;
    DATA_Valid_tb    =1'b1;
    #(CLOCK_PERIOD)
    DATA_Valid_tb    =1'b0;
    
    reset(); 
    #(10*CLOCK_PERIOD)
    $stop;

  end
////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

task initialize;
  begin
    CLK_tb           =1'b0;
    RST_tb           =1'b0;
    PAR_EN_tb        =1'b0;
    PAR_TYP_tb       =1'b0;
    DATA_Valid_tb    =1'b0;
    P_DATA_tb        = 'b0;
  end
endtask

task reset;
    begin
      RST_tb = 1'b1;
      #(CLOCK_PERIOD)
      RST_tb = 1'b0;
      #(CLOCK_PERIOD)
      RST_tb = 1'b1;
    end
endtask

task do_op;
input parity_tybe;
input parity_enable;
input [DATA_WIDTH-1:0] data;  
  begin
    PAR_EN_tb        = parity_enable;
    PAR_TYP_tb       = parity_tybe;
    P_DATA_tb        = data;
    DATA_Valid_tb    = 1'b1;
  end
endtask

task check;
  input [10:0]   exp_out;
  input [3:0]    oper;
  reg   [10:0]   gen_out;
  integer        k;
  begin
    
    @(posedge busy_tb);
    #2;
    DATA_Valid_tb    = 1'b0;
    P_DATA_tb        =  'b0;
    for (k = 0; k < 11; k = k+1)
       begin
          
          gen_out[k] = TX_OUT_tb;
          #(CLOCK_PERIOD);
       end

  if(gen_out == exp_out)
    begin
			$display("Test Case %d is succeeded",oper);
		end
	else
		begin
			$display("Test Case %d is failed", oper);
		end
  end
endtask
      
endmodule
