module LFSR(key,key_next);
  input  [63:0] key;         // 输入原始密钥
  output [63:0] key_next;    // 输出下一个密钥

  wire   [18:0]x;            // lfsr1
  wire   [21:0]y;            // lfsr2
  wire   [22:0]z;            // lfsr3
  wire   [18:0]x_next;
  wire   [21:0]y_next;
  wire   [22:0]z_next;
  wire   majority;

  assign x=key[18:0];        // 低位是 x
  assign y=key[40:19];
  assign z=key[63:41];       // 高位是 z
  
  function [0:0] maj(input x,y,z);
    maj = x&y | x&z | y&z;   // 计算多数位
  endfunction

  function [18:0] lfsr1(input [19:0]in);
  begin
    case(in[19])
      0:lfsr1={in[17:0], in[18]^in[17]^in[16]^in[13]};   // 如果最高位为0，进行位运算
      1:lfsr1=in[18:0];      // 如果最高位为1，保持不变
    endcase
  end
  endfunction

  function [21:0] lfsr2(input [22:0]in);
  begin
    case(in[22])
      0:lfsr2={in[20:0], in[21]^in[20]};   // 如果最高位为0，进行位运算
      1:lfsr2=in[21:0];      // 如果最高位为1，保持不变
    endcase
  end
  endfunction

  function [22:0] lfsr3(input [23:0]in);
  begin
    case(in[23])
      0:lfsr3={in[21:0], in[22]^in[21]^in[20]^in[7]};   // 如果最高位为0，进行位运算
      1:lfsr3=in[22:0];      // 如果最高位为1，保持不变
    endcase
  end
  endfunction
  
  assign majority = maj(x[8],y[10],z[10]);   // 计算多数位
  assign x_next = lfsr1({majority^x[8], x[18:0]});  // 计算下一个 x
  assign y_next = lfsr2({majority^y[10], y[21:0]});  // 计算下一个 y
  assign z_next = lfsr3({majority^z[10], z[22:0]});  // 计算下一个 z
  assign key_next = {z_next,y_next,x_next};         // 组合下一个密钥，低位是 x，高位是 z
endmodule

module A51(key,plain,cipher,clk,krdy);
input  [63:0]key;            // 原始密钥
input  plain;                // 明文流
output cipher;               // 密文流
input  clk;                  // 系统时钟
input  krdy;                 // 原始密钥是否就绪

reg [63:0] kpre;             // 密钥寄存器
wire[63:0] knext;            // 下一个密钥
reg k;                       // 密文流的密钥

LFSR lfsr(kpre,knext);       // 调用 LFSR 模块

assign cipher=k^plain;       // 计算密文流的密钥

always @(posedge clk) begin
  if(krdy==1) begin           // 如果原始密钥已经就绪，则刷新密钥寄存器
    kpre <=key;
  end
  else begin                  // 如果原始密钥未就绪，则使用下一个密钥
    k = knext[18]^knext[40]^knext[63];   // 计算下一个密文流的密钥
    kpre <= knext;
  end
end

endmodule

