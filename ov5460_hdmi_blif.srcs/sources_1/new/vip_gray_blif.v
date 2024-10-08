module vip_gray_blif(
    //时钟
    input       clk,  //50MHz
    input       rst_n,
    
    //处理前图像数据
    input wire      pe_frame_vsync,  //处理前图像数据场信号
    input wire      pe_frame_href,   //处理前图像数据行信号 
    input wire      pe_frame_clken,  //处理前图像数据输入使能效信号
    input wire  [7:0] pe_img_y,        //灰度数据             
    
    //处理后的图像数据
    output  reg       pos_frame_vsync, //处理后的图像数据场信号   
    output  reg       pos_frame_href,  //处理后的图像数据行信号  
    output  reg       pos_frame_clken, //处理后的图像数据输出使能效信号
    output  reg [7:0]  pos_img_y        //处理后的灰度数据           
);

//wire define
wire        matrix_frame_vsync;
wire        matrix_frame_href;
wire        matrix_frame_clken;

//  Generate 8Bit 3X3 Matrix
wire [7:0]  matrix_p11; //3X3 阵列输出
wire [7:0]  matrix_p12; 
wire [7:0]  matrix_p13;
wire [7:0]  matrix_p21; 
wire [7:0]  matrix_p22; 
wire [7:0]  matrix_p23;
wire [7:0]  matrix_p31; 
wire [7:0]  matrix_p32; 
wire [7:0]  matrix_p33;
wire [7:0]  mid_value;

//generate 8bit 3x3 matrix use vip_matrix_generate_3x3_8bit
vip_matrix_generate_3x3_8bit u_vip_matrix_generate_3x3_8bit(
    .clk        (clk), 
    .rst_n      (rst_n),
    
    //处理前图像数据
    .per_frame_vsync    (pe_frame_vsync),
    .per_frame_href     (pe_frame_href), 
    .per_frame_clken    (pe_frame_clken),
    .per_img_y          (pe_img_y),
    
    //处理后的图像数据
    .matrix_frame_vsync (matrix_frame_vsync),
    .matrix_frame_href  (matrix_frame_href),
    .matrix_frame_clken (matrix_frame_clken),
    //8bit 3x3 martix
    .matrix_p11         (matrix_p11),    
    .matrix_p12         (matrix_p12),    
    .matrix_p13         (matrix_p13),
    .matrix_p21         (matrix_p21),    
    .matrix_p22         (matrix_p22),    
    .matrix_p23         (matrix_p23),
    .matrix_p31         (matrix_p31),    
    .matrix_p32         (matrix_p32),    
    .matrix_p33         (matrix_p33)
);
//----------------------------------------------------------------------
reg             [7:0]           p11_minus_p22_abs;
reg             [7:0]           p21_minus_p22_abs;
reg             [7:0]           p31_minus_p22_abs;
reg             [7:0]           p12_minus_p22_abs;
reg             [7:0]           p22_minus_p22_abs;
reg             [7:0]           p32_minus_p22_abs;
reg             [7:0]           p13_minus_p22_abs;
reg             [7:0]           p23_minus_p22_abs;
reg             [7:0]           p33_minus_p22_abs;

//计算每个元素与中心元素的差值，并将中心元素赋值为0
always @(posedge clk)
begin
    if(matrix_p11 > matrix_p22)
        p11_minus_p22_abs <= matrix_p11 - matrix_p22;
    else
        p11_minus_p22_abs <= matrix_p22 - matrix_p11;
    
    if(matrix_p21 > matrix_p22)
        p21_minus_p22_abs <= matrix_p21 - matrix_p22;
    else
        p21_minus_p22_abs <= matrix_p22 - matrix_p21;
    
    if(matrix_p31 > matrix_p22)
        p31_minus_p22_abs <= matrix_p31 - matrix_p22;
    else
        p31_minus_p22_abs <= matrix_p22 - matrix_p31;
    
    if(matrix_p12 > matrix_p22)
        p12_minus_p22_abs <= matrix_p12 - matrix_p22;
    else
        p12_minus_p22_abs <= matrix_p22 - matrix_p12;
    
    p22_minus_p22_abs <= 8'b0;
    
    if(matrix_p32 > matrix_p22)
        p32_minus_p22_abs <= matrix_p32 - matrix_p22;
    else
        p32_minus_p22_abs <= matrix_p22 - matrix_p32;
    
    if(matrix_p13 > matrix_p22)
        p13_minus_p22_abs <= matrix_p13 - matrix_p22;
    else
        p13_minus_p22_abs <= matrix_p22 - matrix_p13;
    
    if(matrix_p23 > matrix_p22)
        p23_minus_p22_abs <= matrix_p23 - matrix_p22;
    else
        p23_minus_p22_abs <= matrix_p22 - matrix_p23;
    
    if(matrix_p33 > matrix_p22)
        p33_minus_p22_abs <= matrix_p33 - matrix_p22;
    else
        p33_minus_p22_abs <= matrix_p22 - matrix_p33;
end

wire            [9:0]           similary_p11_p22;      // 存储 p11 与 p22 之间的相似度
wire            [9:0]           similary_p21_p22;      // 存储 p21 与 p22 之间的相似度
wire            [9:0]           similary_p31_p22;      // 存储 p31 与 p22 之间的相似度
wire            [9:0]           similary_p12_p22;      // 存储 p12 与 p22 之间的相似度
wire            [9:0]           similary_p22_p22;      // 存储 p22 与 p22 之间的相似度
wire            [9:0]           similary_p32_p22;      // 存储 p23 与 p22 之间的相似度
wire            [9:0]           similary_p13_p22;      // 存储 p31 与 p22 之间的相似度
wire            [9:0]           similary_p23_p22;      // 存储 p32 与 p22 之间的相似度
wire            [9:0]           similary_p33_p22;      // 存储 p33 与 p22 之间的相似度

Similary_LUT u0_Similary_LUT
(
   .Pre_Data    (p11_minus_p22_abs  ),    // 输入 p11 与 p22 的差值的绝对值
   .Post_Data   (similary_p11_p22   )     //输出 p11 与 p22 之间的相似度
);

Similary_LUT u1_Similary_LUT
(
   .Pre_Data    (p21_minus_p22_abs  ),
   .Post_Data   (similary_p21_p22   )
);

Similary_LUT u2_Similary_LUT
(
   .Pre_Data    (p31_minus_p22_abs  ),
   .Post_Data   (similary_p31_p22   )
);

Similary_LUT u3_Similary_LUT
(
   .Pre_Data    (p12_minus_p22_abs  ),
   .Post_Data   (similary_p12_p22   )
);

Similary_LUT u4_Similary_LUT
(
   .Pre_Data    (p22_minus_p22_abs  ),
   .Post_Data   (similary_p22_p22   )
);

Similary_LUT u5_Similary_LUT
(
   .Pre_Data    (p32_minus_p22_abs  ),
   .Post_Data   (similary_p32_p22   )
);

Similary_LUT u6_Similary_LUT
(
   .Pre_Data    (p13_minus_p22_abs  ),
   .Post_Data   (similary_p13_p22   )
);

Similary_LUT u7_Similary_LUT
(
   .Pre_Data    (p23_minus_p22_abs  ),
   .Post_Data   (similary_p23_p22   )
);

Similary_LUT u8_Similary_LUT
(
   .Pre_Data    (p33_minus_p22_abs  ),
   .Post_Data   (similary_p33_p22   )
);
//----------------------------------------------------------------------
//      [g11,g12,g13]   [109,115,109]
//  g = [g21,g22,g23] = [115,122,115]
//      [g31,g32,g33]   [109,115,109]

//定义一个3*3的高斯矩阵
//  | 109  115  109 |
//  | 115  122  115 |
//  | 109  115  109 |
localparam g11 = 7'd109;
localparam g12 = 7'd115;
localparam g13 = 7'd109;
localparam g21 = 7'd115;
localparam g22 = 7'd122;
localparam g23 = 7'd115;
localparam g31 = 7'd109;
localparam g32 = 7'd115;
localparam g33 = 7'd109;

reg             [16:0]          s11_mult_g11;
reg             [16:0]          s12_mult_g21;
reg             [16:0]          s13_mult_g31;
reg             [16:0]          s11_mult_g12;
reg             [16:0]          s12_mult_g22;
reg             [16:0]          s13_mult_g32;
reg             [16:0]          s11_mult_g13;
reg             [16:0]          s12_mult_g23;
reg             [16:0]          s13_mult_g33;
reg             [16:0]          s21_mult_g11;
reg             [16:0]          s22_mult_g21;
reg             [16:0]          s23_mult_g31;
reg             [16:0]          s21_mult_g12;
reg             [16:0]          s22_mult_g22;
reg             [16:0]          s23_mult_g32;
reg             [16:0]          s21_mult_g13;
reg             [16:0]          s22_mult_g23;
reg             [16:0]          s23_mult_g33;
reg             [16:0]          s31_mult_g11;
reg             [16:0]          s32_mult_g21;
reg             [16:0]          s33_mult_g31;
reg             [16:0]          s31_mult_g12;
reg             [16:0]          s32_mult_g22;
reg             [16:0]          s33_mult_g32;
reg             [16:0]          s31_mult_g13;
reg             [16:0]          s32_mult_g23;
reg             [16:0]          s33_mult_g33;

always @(posedge clk)
begin
    s11_mult_g11 <= similary_p11_p22 * g11;
    s12_mult_g21 <= similary_p12_p22 * g21;
    s13_mult_g31 <= similary_p13_p22 * g31;
    s11_mult_g12 <= similary_p11_p22 * g12;
    s12_mult_g22 <= similary_p12_p22 * g22;
    s13_mult_g32 <= similary_p13_p22 * g32;
    s11_mult_g13 <= similary_p11_p22 * g13;
    s12_mult_g23 <= similary_p12_p22 * g23;
    s13_mult_g33 <= similary_p13_p22 * g33;
    s21_mult_g11 <= similary_p21_p22 * g11;
    s22_mult_g21 <= similary_p22_p22 * g21;
    s23_mult_g31 <= similary_p23_p22 * g31;
    s21_mult_g12 <= similary_p21_p22 * g12;
    s22_mult_g22 <= similary_p22_p22 * g22;
    s23_mult_g32 <= similary_p23_p22 * g32;
    s21_mult_g13 <= similary_p21_p22 * g13;
    s22_mult_g23 <= similary_p22_p22 * g23;
    s23_mult_g33 <= similary_p23_p22 * g33;
    s31_mult_g11 <= similary_p31_p22 * g11;
    s32_mult_g21 <= similary_p32_p22 * g21;
    s33_mult_g31 <= similary_p33_p22 * g31;
    s31_mult_g12 <= similary_p31_p22 * g12;
    s32_mult_g22 <= similary_p32_p22 * g22;
    s33_mult_g32 <= similary_p33_p22 * g32;
    s31_mult_g13 <= similary_p31_p22 * g13;
    s32_mult_g23 <= similary_p32_p22 * g23;
    s33_mult_g33 <= similary_p33_p22 * g33;
end

//----------------------------------------------------------------------
reg             [18:0]          weight11;
reg             [18:0]          weight12;
reg             [18:0]          weight13;
reg             [18:0]          weight21;
reg             [18:0]          weight22;
reg             [18:0]          weight23;
reg             [18:0]          weight31;
reg             [18:0]          weight32;
reg             [18:0]          weight33;

always @(posedge clk)
begin
    weight11 <= s11_mult_g11 + s12_mult_g21 + s13_mult_g31;
    weight12 <= s11_mult_g12 + s12_mult_g22 + s13_mult_g32;
    weight13 <= s11_mult_g13 + s12_mult_g23 + s13_mult_g33;
    weight21 <= s21_mult_g11 + s22_mult_g21 + s23_mult_g31;
    weight22 <= s21_mult_g12 + s22_mult_g22 + s23_mult_g32;
    weight23 <= s21_mult_g13 + s22_mult_g23 + s23_mult_g33;
    weight31 <= s31_mult_g11 + s32_mult_g21 + s33_mult_g31;
    weight32 <= s31_mult_g12 + s32_mult_g22 + s33_mult_g32;
    weight33 <= s31_mult_g13 + s32_mult_g23 + s33_mult_g33;
end

//----------------------------------------------------------------------
reg             [20:0]          weight_sum_tmp1;
reg             [20:0]          weight_sum_tmp2;
reg             [20:0]          weight_sum_tmp3;
reg             [22:0]          weight_sum;

always @(posedge clk)
begin
    weight_sum_tmp1 <= weight11 + weight12 + weight13;
    weight_sum_tmp2 <= weight21 + weight22 + weight23;
    weight_sum_tmp3 <= weight31 + weight32 + weight33;
    weight_sum      <= weight_sum_tmp1 + weight_sum_tmp2 + weight_sum_tmp3;
end

//----------------------------------------------------------------------
//  lag 2 clocks signal sync
// 定义18位宽的寄存器，用于在不同时钟域之间同步信号
reg             [18:0]          weight11_r1;
reg             [18:0]          weight12_r1;
reg             [18:0]          weight13_r1;
reg             [18:0]          weight21_r1;
reg             [18:0]          weight22_r1;
reg             [18:0]          weight23_r1;
reg             [18:0]          weight31_r1;
reg             [18:0]          weight32_r1;
reg             [18:0]          weight33_r1;
reg             [18:0]          weight11_r2;
reg             [18:0]          weight12_r2;
reg             [18:0]          weight13_r2;
reg             [18:0]          weight21_r2;
reg             [18:0]          weight22_r2;
reg             [18:0]          weight23_r2;
reg             [18:0]          weight31_r2;
reg             [18:0]          weight32_r2;
reg             [18:0]          weight33_r2;

always @(posedge clk)
begin
    // 将时钟域1的权重数据复制到时钟域1的副本中
    weight11_r1 <= weight11;
    weight12_r1 <= weight12;
    weight13_r1 <= weight13;
    weight21_r1 <= weight21;
    weight22_r1 <= weight22;
    weight23_r1 <= weight23;
    weight31_r1 <= weight31;
    weight32_r1 <= weight32;
    weight33_r1 <= weight33;
    // 将时钟域1的权重副本数据复制到时钟域2的副本中
    weight11_r2 <= weight11_r1;
    weight12_r2 <= weight12_r1;
    weight13_r2 <= weight13_r1;
    weight21_r2 <= weight21_r1;
    weight22_r2 <= weight22_r1;
    weight23_r2 <= weight23_r1;
    weight31_r2 <= weight31_r1;
    weight32_r2 <= weight32_r1;
    weight33_r2 <= weight33_r1;
end
//----------------------------------------------------------------------
reg             [9:0]           norm_weight11;
reg             [9:0]           norm_weight12;
reg             [9:0]           norm_weight13;
reg             [9:0]           norm_weight21;
reg             [9:0]           norm_weight22;
reg             [9:0]           norm_weight23;
reg             [9:0]           norm_weight31;
reg             [9:0]           norm_weight32;
reg             [9:0]           norm_weight33;

always @(posedge clk)
begin
    norm_weight11 <= {weight11_r2,10'b0}/weight_sum;//拼接操作，将W_r2矩阵拼接成20位位宽，再除以总权重
    norm_weight12 <= {weight12_r2,10'b0}/weight_sum;
    norm_weight13 <= {weight13_r2,10'b0}/weight_sum;
    norm_weight21 <= {weight21_r2,10'b0}/weight_sum;
    norm_weight22 <= {weight22_r2,10'b0}/weight_sum;
    norm_weight23 <= {weight23_r2,10'b0}/weight_sum;
    norm_weight31 <= {weight31_r2,10'b0}/weight_sum;
    norm_weight32 <= {weight32_r2,10'b0}/weight_sum;
    norm_weight33 <= {weight33_r2,10'b0}/weight_sum;
end
//----------------------------------------------------------------------
//  lag 6 clocks signal sync
// 定义时钟域同步所需的延迟量
localparam C_CLK_LATENCY = 6;

// 用于同步的信号和移位寄存器
reg     [C_CLK_LATENCY-1:0]     matrix_img_vsync_r1;
reg     [C_CLK_LATENCY-1:0]     matrix_img_href_r1;
//reg     [C_CLK_LATENCY-1:0]     matrix_edge_flag_r1;
reg     [7:0]                   matrix_p11_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p12_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p13_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p21_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p22_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p23_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p31_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p32_r1       [0:C_CLK_LATENCY-1];
reg     [7:0]                   matrix_p33_r1       [0:C_CLK_LATENCY-1];

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        // 复位状态下，将同步信号和移位寄存器清零
        matrix_img_vsync_r1 <= {C_CLK_LATENCY{1'b0}};
        matrix_img_href_r1  <= {C_CLK_LATENCY{1'b0}};
//        matrix_edge_flag_r1 <= {C_CLK_LATENCY{1'b0}};
    end
    else
    begin
        // 非复位状态下，通过左移和更新操作同步信号
        matrix_img_vsync_r1 <= {matrix_img_vsync_r1[C_CLK_LATENCY-2:0],matrix_frame_vsync};
        matrix_img_href_r1  <= {matrix_img_href_r1[C_CLK_LATENCY-2:0],matrix_frame_href};
 //       matrix_edge_flag_r1 <= {matrix_edge_flag_r1[C_CLK_LATENCY-2:0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

always @(posedge clk)
begin : shift_reg
    integer i;
    for(i = 0; i < C_CLK_LATENCY-1; i = i + 1)
    begin
       // 移位操作，将移位寄存器中的值传递给下一个位置
        matrix_p11_r1[i+1] <= matrix_p11_r1[i];
        matrix_p21_r1[i+1] <= matrix_p21_r1[i];
        matrix_p31_r1[i+1] <= matrix_p31_r1[i];
        matrix_p12_r1[i+1] <= matrix_p12_r1[i];
        matrix_p22_r1[i+1] <= matrix_p22_r1[i];
        matrix_p32_r1[i+1] <= matrix_p32_r1[i];
        matrix_p13_r1[i+1] <= matrix_p13_r1[i];
        matrix_p23_r1[i+1] <= matrix_p23_r1[i];
        matrix_p33_r1[i+1] <= matrix_p33_r1[i];
    end
        // 将新的值存储到移位寄存器的第一个位置
        matrix_p11_r1[0] <= matrix_p11;
        matrix_p21_r1[0] <= matrix_p21;
        matrix_p31_r1[0] <= matrix_p31;
        matrix_p12_r1[0] <= matrix_p12;
        matrix_p22_r1[0] <= matrix_p22;
        matrix_p32_r1[0] <= matrix_p32;
        matrix_p13_r1[0] <= matrix_p13;
        matrix_p23_r1[0] <= matrix_p23;
        matrix_p33_r1[0] <= matrix_p33;
end

//----------------------------------------------------------------------
reg             [17:0]          mult_p11_w11;
reg             [17:0]          mult_p21_w21;
reg             [17:0]          mult_p31_w31;
reg             [17:0]          mult_p12_w12;
reg             [17:0]          mult_p22_w22;
reg             [17:0]          mult_p32_w32;
reg             [17:0]          mult_p13_w13;
reg             [17:0]          mult_p23_w23;
reg             [17:0]          mult_p33_w33;

always @(posedge clk)
begin
    mult_p11_w11 <= matrix_p11_r1[C_CLK_LATENCY-1] * norm_weight11;
    mult_p21_w21 <= matrix_p21_r1[C_CLK_LATENCY-1] * norm_weight21;
    mult_p31_w31 <= matrix_p31_r1[C_CLK_LATENCY-1] * norm_weight31;
    mult_p12_w12 <= matrix_p12_r1[C_CLK_LATENCY-1] * norm_weight12;
    mult_p22_w22 <= matrix_p22_r1[C_CLK_LATENCY-1] * norm_weight22;
    mult_p32_w32 <= matrix_p32_r1[C_CLK_LATENCY-1] * norm_weight32;
    mult_p13_w13 <= matrix_p13_r1[C_CLK_LATENCY-1] * norm_weight13;
    mult_p23_w23 <= matrix_p23_r1[C_CLK_LATENCY-1] * norm_weight23;
    mult_p33_w33 <= matrix_p33_r1[C_CLK_LATENCY-1] * norm_weight33;
end

//----------------------------------------------------------------------
reg             [17:0]          sum_result_tmp1;
reg             [17:0]          sum_result_tmp2;
reg             [17:0]          sum_result_tmp3;
reg             [17:0]          sum_result;

always @(posedge clk)
begin
    sum_result_tmp1 <= mult_p11_w11 + mult_p21_w21 + mult_p31_w31;
    sum_result_tmp2 <= mult_p12_w12 + mult_p22_w22 + mult_p32_w32;
    sum_result_tmp3 <= mult_p13_w13 + mult_p23_w23 + mult_p33_w33;
    sum_result      <= sum_result_tmp1 + sum_result_tmp2 + sum_result_tmp3;
end

//----------------------------------------------------------------------
//  lag 3 clocks signal sync
//时钟域信号同步

reg             [2:0]       matrix_img_vsync_r2;
reg             [2:0]       matrix_img_href_r2;
reg             [2:0]       matrix_edge_flag_r2;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r2 <= 3'b0;
        matrix_img_href_r2  <= 3'b0;
        matrix_edge_flag_r2 <= 3'b0;
    end
    else
    begin
        matrix_img_vsync_r2 <= {matrix_img_vsync_r2[1:0],matrix_img_vsync_r1[C_CLK_LATENCY-1]};
        matrix_img_href_r2  <= {matrix_img_href_r2[1:0],matrix_img_href_r1[C_CLK_LATENCY-1]};
//        matrix_edge_flag_r2 <= {matrix_edge_flag_r2[1:0],matrix_edge_flag_r1[C_CLK_LATENCY-1]};
    end
end

reg             [7:0]           matrix_p22_r2   [0:2];

always @(posedge clk)
begin
    matrix_p22_r2[0] <= matrix_p22_r1[C_CLK_LATENCY-1];
    matrix_p22_r2[1] <= matrix_p22_r2[0];
    matrix_p22_r2[2] <= matrix_p22_r2[1];
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk)
begin
    if(matrix_edge_flag_r2[2] == 1'b1)
        pos_img_y <= matrix_p22_r2[2];
    else
        pos_img_y <= sum_result[17:10] + sum_result[9];
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        pos_frame_vsync <= 1'b0;
        pos_frame_href  <= 1'b0;
    end
    else
    begin
        pos_frame_vsync <= matrix_img_vsync_r2[2];
        pos_frame_href  <= matrix_img_href_r2[2];
    end
end


endmodule