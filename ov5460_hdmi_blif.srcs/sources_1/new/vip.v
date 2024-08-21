module vip(
    //module clock
    input           clk               ,  // 时钟信号
    input           rst_n             ,  // 复位信号（低有效）

    //图像处理前的数据接口
    input           pre_frame_vsync   ,
    input           pre_frame_hsync   ,
    input           pre_frame_de      ,
    input    [15:0] pre_rgb           ,
    input    [10:0] xpos              ,
    input    [10:0] ypos              ,

    //图像处理后的数据接口
    output          post_frame_vsync  ,   // 场同步信号
    output          post_frame_hsync  ,   // 行同步信号
    output          post_frame_de     ,   // 数据输入使能
    output   [15:0] post_rgb              // RGB565颜色数据

);

//wire define
wire   [ 7:0]         img_y;
wire   [ 7:0]         post_img_y;
wire   [15:0]         post_rgb;
wire                  post_frame_vsync;
wire                  post_frame_hsync;
wire                  post_frame_de;
wire                  pe_frame_vsync;
wire                  pe_frame_href;
wire                  pe_frame_clken;

//*****************************************************
//**                    main code
//*****************************************************

assign  post_rgb = {post_img_y[7:3],post_img_y[7:2],post_img_y[7:3]};

//RGB转YCbCr模块
rgb2ycbcr u_rgb2ycbcr(
    //module clock
    .clk             (clk    ),            // 时钟信号
    .rst_n           (rst_n  ),            // 复位信号（低有效）
    //图像处理前的数据接口
    .pre_frame_vsync (pre_frame_vsync),    // vsync信号
    .pre_frame_hsync (pre_frame_hsync),    // href信号
    .pre_frame_de    (pre_frame_de   ),    // data enable信号
    .img_red         (pre_rgb[15:11] ),
    .img_green       (pre_rgb[10:5 ] ),
    .img_blue        (pre_rgb[ 4:0 ] ),
    //图像处理后的数据接口
    .post_frame_vsync(pe_frame_vsync),     // vsync信号
    .post_frame_hsync(pe_frame_href),      // href信号
    .post_frame_de   (pe_frame_clken),     // data enable信号
    .img_y           (img_y),              //灰度数据
    .img_cb          (),
    .img_cr          ()
);

//灰度图中值滤波
//vip_gray_median_filter u_vip_gray_median_filter(
//    .clk    (clk),   
//    .rst_n  (rst_n), 
//    
//   //处理前图像数据
//  .pe_frame_vsync (pe_frame_vsync),      // vsync信号
//  .pe_frame_href  (pe_frame_href),       // href信号
//  .pe_frame_clken (pe_frame_clken),      // data enable信号
//  .pe_img_y       (img_y),
//  
//  //处理后的图像数据
//  .pos_frame_vsync (post_frame_vsync),   // vsync信号
//  .pos_frame_href  (post_frame_hsync),   // href信号
//  .pos_frame_clken (post_frame_de),      // data enable信号
//  .pos_img_y       (post_img_y)          //中值滤波后的灰度数据
//);


//灰度图双边滤波
vip_gray_blif u_vip_gray_blif(
    
    .clk    (clk),   
    .rst_n  (rst_n), 
    
    //处理前图像数据
    .pe_frame_vsync (pe_frame_vsync),      // vsync信号
    .pe_frame_href  (pe_frame_href),       // href信号
    .pe_frame_clken (pe_frame_clken),      // data enable信号
    .pe_img_y       (img_y),
    
    //处理后的图像数据
    .pos_frame_vsync (post_frame_vsync),   // vsync信号
    .pos_frame_href  (post_frame_hsync),   // href信号
    .pos_frame_clken (1'b1),      // data enable信号
    .pos_img_y       (post_img_y)          //中值滤波后的灰度数据

    );
endmodule
