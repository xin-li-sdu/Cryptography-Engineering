`timescale 1ns / 1ps



module tb_grain128;

reg clk = 0;
reg rst = 0;
reg gen = 0;

reg [127:0] key = 128'h0123456789abcdef123456789abcdef0;
reg [95:0] iv   =  96'h0123456789abcdef12345678;



reg [127:0] keystream = 0;
reg [7:0] len = 0;
wire rdy,z;
wire [31:0] tag;

grain128 DUT (
    .clk(clk),
    .rst(rst),
    .key(key),
    .iv(iv),
    .gen(gen),
    .rdy(rdy),
    .z(z),
    .tag(tag)
);

initial begin
    #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0;
 #10 rst = 1;
    #10 rst = 0; 
#10 rst = 1;
    #10 rst = 0;

end

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


always @(posedge clk ) begin
    if (rdy == 1) begin
        if (len > 128) begin
            gen = 0;
        end
        else begin
            gen = 1;
            // keystream = {z,keystream[127:1]};
            keystream = {keystream[126:0],z};
            len = len + 1;
        end
    end
    
end

 initial begin
    $dumpfile("test_tb.vcd");
    $dumpvars;
  end

endmodule

