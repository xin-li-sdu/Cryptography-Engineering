module h_x
(
    input s8,
    input s13,
    input s20,
    input s42,
    input s60,
    input s79,
    input s95,
    input b12,
    input b95,
    output ho
);

// 通过一系列逻辑操作计算输出ho
assign ho = (b12 & s8) ^ (s13 & s20) ^ (b95 & s42) ^ (s60 & s79) ^ (b12 & s95 & b95);

endmodule

module feedback_linear
(
    input s0,
    input s7,
    input s38,
    input s70,
    input s81,
    input s96,
    output lfb
);

// 通过异或逻辑操作计算输出lfb
assign lfb = s0 ^ s7 ^ s38 ^ s70 ^ s81 ^ s96;

endmodule

module feedback_non_linear
(
    input b0,
    input b26,
    input b56,
    input b91,
    input b96,
    input b3,
    input b67,
    input b11,
    input b13,
    input b17,
    input b18,
    input b27,
    input b59,
    input b40,
    input b48,
    input b61,
    input b65,
    input b68,
    input b84,
    output nfb
);

// 通过一系列异或和与逻辑操作计算输出nfb
assign nfb = b0 ^ b26 ^ b56 ^ b91 ^ b96 ^ (b3 & b67) ^ (b11 & b13) ^ (b17 & b18) ^ (b27 & b59) ^ (b40 & b48) ^ (b61 & b65) ^ (b68 & b84); 

endmodule


module grain128 
(
    input clk,
    input rst,
    input [127:0] key,
    input [95:0] iv,
    input gen,
    output reg rdy,
    output z,
    output [31:0] tag
);

localparam INIT = 0;
localparam RDY  = 1;

reg [127:0] s;            //LFSR 线性反馈移位寄存器
reg [127:0] b;            //NFSR 非线性反馈移位寄存器
reg curr_state = INIT;
reg next_state = INIT;
reg [7:0] cnt  = 0;       //Counter 计数器
reg m          = 1;       //Mode 模式选择

wire f,g,h;               //用于存储反馈模块的输出
wire nfb, lfb;            //用于存储非线性反馈和线性反馈的输出
wire mo;                  //MUX out 多路选择器输出
wire y;                   //y
wire [127:0] key_in;      //Flipped key 翻转后的密钥
wire [95:0] iv_in;        //Flipped iv 翻转后的初始化向量

// 实例化反馈模块
feedback_linear FB_L (s[0], s[7], s[38], s[70], s[81], s[96], f);
feedback_non_linear FB_N (b[0], b[26], b[56], b[91], b[96], b[3], b[67], b[11], b[13], b[17], b[18], b[27], b[59], b[40], b[48], b[61], b[65], b[68], b[84], g);
h_x HX (s[8], s[13], s[20], s[42], s[60], s[79], s[95], b[12], b[95], h);

// 计算mo
assign mo  = m & y;
// 计算lfb和nfb
assign lfb = f ^ mo;
assign nfb = g ^ mo ^ s[0];
// 计算y
assign y   = h ^ s[93] ^ b[2] ^ b[15] ^ b[36] ^ b[45] ^ b[64] ^ b[73] ^ b[89];
// 输出z等于y
assign z   = y;

assign tag = 0;

// 生成翻转后的初始化向量
generate
    genvar i;
    for (i = 0; i < 96; i = i + 1) begin
        assign iv_in[i] = iv[95-i];
    end
endgenerate

// 生成翻转后的密钥
generate
    genvar j;
    for(j = 0; j < 128; j = j + 1) begin
        assign key_in[j] = key[127-j];
    end
endgenerate

always @(posedge clk) begin
    if (rst) begin
        curr_state <= INIT;
        s          <= {{32{1'b1}},iv_in};
        b          <= key_in;
        cnt        <= 0;
    end
    else begin
        curr_state <= next_state;
    end
    
    case (curr_state)
        INIT : begin
            m   <= 1;
            rdy <= 0;
            if (cnt == 255) begin
                next_state <= RDY;
            end
            else begin
                next_state <= INIT;
                cnt        <= cnt + 1;
            end
            s = {lfb, s[127:1]};
            b = {nfb, b[127:1]};
        end
        RDY : begin
            rdy <= 1;
            m   <= 0;

            if (gen && rdy) begin
                s = {lfb, s[127:1]};
                b = {nfb, b[127:1]};
            end
            next_state <= RDY;
        end
    endcase
end
endmodule
