`timescale 1ns /1ns

module A51_tb;
  reg  Plain;
  reg  [63:0] Key;
  wire Cipher;
  reg  Krdy;
  reg clk;  
  initial begin  
    clk = 0;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk; 
    #10 clk = ~clk;  
  end  

  A51 A51_in_tb(Key,Plain,Cipher,clk,Krdy);

  initial begin
    Key  ={32'b00001111000101010111000111001001,
          32'b10101111011111110110011110011000};
    Krdy =1;
    #20 Krdy = 0;
  end

  initial begin
    Plain=1;
    #30 Plain=~Plain;
    #20 Plain=~Plain;
    #20 Plain=~Plain;
    #20 Plain=~Plain;
    #20 Plain=~Plain;
    #20 Plain=~Plain;
  end
  
  

  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
  end


endmodule