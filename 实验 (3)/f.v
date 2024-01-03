`timescale 1ns/100ps

module f(
	input 			CLK, 				// 时钟信号
	input 			F_EN, 				// F_EN使能信号
	
	input 	[31:0]	X0,					// 输入X0
	input 	[31:0] 	X1,					// 输入X1
	input 	[31:0]	X2,					// 输入X2
	input 	[31:0] 	X3,					// 输入X3
	input 	[31:0] 	RK,					// 轮密钥RK
	output 	[31:0]	Y1,					// 输出Y1
	output 	[31:0]	Y2,					// 输出Y2
	output 	[31:0]	Y3,					// 输出Y3
	output 	[31:0]	Y4 					// 输出Y4
);
	wire	[31:0] 	wire_xor;				// 异或结果的中间信号
	wire	[31:0]	wire_t_func;			// T函数的中间信号
	wire	[31:0]  wire_L_func;			// L函数的中间信号
	wire 	[31:0]	wire_result_Y4;			// Y4的中间信号
	
	S_BOX t_sbox1(CLK, wire_xor[31:24], wire_t_func[31:24]);  // 实例化S_BOX模块用于计算t_sbox1
	S_BOX t_sbox2(CLK, wire_xor[23:16], wire_t_func[23:16]); // 实例化S_BOX模块用于计算t_sbox2
	S_BOX t_sbox3(CLK, wire_xor[15:8], wire_t_func[15:8]);   // 实例化S_BOX模块用于计算t_sbox3
	S_BOX t_sbox4(CLK, wire_xor[7:0], wire_t_func[7:0]);     // 实例化S_BOX模块用于计算t_sbox4

	assign wire_xor =  X1 ^ X2 ^ X3 ^ RK;  // 计算异或结果
	assign wire_L_func = ( ( wire_t_func ^ {wire_t_func[29:0], wire_t_func[31:30]}) 
								^ ({wire_t_func[21:0], wire_t_func[31:22]} ^ {wire_t_func[13:0], wire_t_func[31:14]})) 
							    ^ {wire_t_func[7:0], wire_t_func[31:8]};  // 计算L函数结果
	assign wire_result_Y4 = X0 ^ wire_L_func;  // 计算Y4结果
					
	assign Y1 = (F_EN == 1'b1) ? X1 : X0;  // 根据F_EN使能信号选择输出Y1
	assign Y2 = (F_EN == 1'b1) ? X2 : X1;  // 根据F_EN使能信号选择输出Y2
	assign Y3 = (F_EN == 1'b1) ? X3 : X2;  // 根据F_EN使能信号选择输出Y3
	assign Y4 = (F_EN == 1'b1) ? wire_result_Y4 : X3;  // 根据F_EN使能信号选择输出Y4

endmodule


module rk(
	input 	CLK, 					// 输入时钟信号
	input 	Frk_EN,				// 输入使能信号
	input 	[31:0] 	CK,			// 输入密钥
	input 	[31:0]	X0,			// 输入数据 X0
	input 	[31:0] 	X1,			// 输入数据 X1
	input 	[31:0]	X2,			// 输入数据 X2
	input 	[31:0] 	X3,			// 输入数据 X3
				
	output 	[31:0]	Y1,			// 输出数据 Y1
	output 	[31:0]	Y2,			// 输出数据 Y2
	output 	[31:0]	Y3,			// 输出数据 Y3
	output 	[31:0]	Y4			// 输出数据 Y4
);
	wire	[31:0] 	wire_xor;			// 中间变量，用于存储异或运算结果
	wire	[31:0]	wire_t_func;		// 中间变量，用于存储S_BOX模块输出
	wire	[31:0]  wire_L_func;		// 中间变量，用于存储L函数计算结果
	wire	[31:0]	wire_result_Y4;	// 中间变量，用于存储Y4的计算结果

	S_BOX t_sbox1(CLK, wire_xor[31:24], wire_t_func[31:24]);  	// 实例化S_BOX模块1
	S_BOX t_sbox2(CLK, wire_xor[23:16], wire_t_func[23:16]);  	// 实例化S_BOX模块2
	S_BOX t_sbox3(CLK, wire_xor[15:8], wire_t_func[15:8]);   	// 实例化S_BOX模块3
	S_BOX t_sbox4(CLK, wire_xor[7:0], wire_t_func[7:0]);     	// 实例化S_BOX模块4

	assign wire_xor =  X1 ^ X2 ^ X3 ^ CK;	// 计算异或运算结果
	assign wire_L_func = (wire_t_func ^ {wire_t_func[18:0], wire_t_func[31:19]}) ^ {wire_t_func[8:0], wire_t_func[31:9]};	// 计算L函数结果
	assign wire_result_Y4 = X0 ^ wire_L_func;	// 计算Y4结果

	assign Y1 = (Frk_EN == 1'b1) ? X1 : X0;	// 根据使能信号选择输出数据Y1
	assign Y2 = (Frk_EN == 1'b1) ? X2 : X1;	// 根据使能信号选择输出数据Y2
	assign Y3 = (Frk_EN == 1'b1) ? X3 : X2;	// 根据使能信号选择输出数据Y3
	assign Y4 = (Frk_EN == 1'b1) ? wire_result_Y4 : X3;	// 根据使能信号选择输出数据Y4

endmodule
