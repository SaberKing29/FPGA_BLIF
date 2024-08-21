module ov5640_hdmi_bli_filter(    
    input                 sys_clk      ,  //ϵͳʱ��
    input                 sys_rst_n    ,  //ϵͳ��λ���͵�ƽ��Ч
    //����ͷ�ӿ�                       
    input                 cam_pclk     ,  //cmos ��������ʱ��
    input                 cam_vsync    ,  //cmos ��ͬ���ź�
    input                 cam_href     ,  //cmos ��ͬ���ź�
    input   [7:0]         cam_data     ,  //cmos ����
    output                cam_rst_n    ,  //cmos ��λ�źţ��͵�ƽ��Ч
    output                cam_pwdn     ,  //��Դ����ģʽѡ�� 0������ģʽ 1����Դ����ģʽ
    output                cam_scl      ,  //cmos SCCB_SCL��
    inout                 cam_sda      ,  //cmos SCCB_SDA��       
    // DDR3                            
    inout   [15:0]        ddr3_dq      ,  //DDR3 ����
    inout   [1:0]         ddr3_dqs_n   ,  //DDR3 dqs��
    inout   [1:0]         ddr3_dqs_p   ,  //DDR3 dqs��  
    output  [13:0]        ddr3_addr    ,  //DDR3 ��ַ   
    output  [2:0]         ddr3_ba      ,  //DDR3 banck ѡ��
    output                ddr3_ras_n   ,  //DDR3 ��ѡ��
    output                ddr3_cas_n   ,  //DDR3 ��ѡ��
    output                ddr3_we_n    ,  //DDR3 ��дѡ��
    output                ddr3_reset_n ,  //DDR3 ��λ
    output  [0:0]         ddr3_ck_p    ,  //DDR3 ʱ����
    output  [0:0]         ddr3_ck_n    ,  //DDR3 ʱ�Ӹ�
    output  [0:0]         ddr3_cke     ,  //DDR3 ʱ��ʹ��
    output  [0:0]         ddr3_cs_n    ,  //DDR3 Ƭѡ
    output  [1:0]         ddr3_dm      ,  //DDR3_dm
    output  [0:0]         ddr3_odt     ,  //DDR3_odt									                            
    //hdmi�ӿ�                           
    input                 hpdin        ,    
    output                tmds_clk_p   ,  // TMDS ʱ��ͨ��
    output                tmds_clk_n   ,
    output  [2:0]         tmds_data_p  ,  // TMDS ����ͨ��
    output  [2:0]         tmds_data_n  ,
    output                tmds_oen     ,  // TMDS ���ʹ��
    output                hpdout
    );     
                                
parameter  V_CMOS_DISP = 11'd768;                  //CMOS�ֱ���--��
parameter  H_CMOS_DISP = 11'd1024;                 //CMOS�ֱ���--��	
parameter  TOTAL_H_PIXEL = H_CMOS_DISP + 12'd1216; //CMOS�ֱ���--��
parameter  TOTAL_V_PIXEL = V_CMOS_DISP + 12'd504;    										   
							   
//wire define                          
wire         clk_50m                   ;  //50mhzʱ��
wire         locked                    ;  //ʱ�������ź�
wire         rst_n                     ;  //ȫ�ָ�λ 								    
wire         i2c_exec                  ;  //I2C����ִ���ź�
wire  [23:0] i2c_data                  ;  //I2CҪ���õĵ�ַ������(��8λ��ַ,��8λ����)          
wire         cam_init_done             ;  //����ͷ��ʼ�����
wire         i2c_done                  ;  //I2C�Ĵ�����������ź�
wire         i2c_dri_clk               ;  //I2C����ʱ��								    
wire         wr_en                     ;  //DDR3������ģ��дʹ��
wire  [15:0] wr_data                   ;  //DDR3������ģ��д����
wire         rdata_req                 ;  //DDR3������ģ���ʹ��
wire  [15:0] rd_data                   ;  //DDR3������ģ�������
wire         cmos_frame_valid          ;  //������Чʹ���ź�
wire         init_calib_complete       ;  //DDR3��ʼ�����init_calib_complete
wire         sys_init_done             ;  //ϵͳ��ʼ�����(DDR��ʼ��+����ͷ��ʼ��)
wire         clk_200m                  ;  //ddr3�ο�ʱ��
wire         cmos_frame_vsync          ;  //���֡��Ч��ͬ���ź�
wire         lcd_de                    ;  //LCD ��������ʹ��
wire         cmos_frame_href           ;  //���֡��Ч��ͬ���ź� 
wire  [27:0] app_addr_rd_min           ;  //��DDR3����ʼ��ַ
wire  [27:0] app_addr_rd_max           ;  //��DDR3�Ľ�����ַ
wire  [7:0]  rd_bust_len               ;  //��DDR3�ж�����ʱ��ͻ������
wire  [27:0] app_addr_wr_min           ;  //дDDR3����ʼ��ַ
wire  [27:0] app_addr_wr_max           ;  //дDDR3�Ľ�����ַ
wire  [7:0]  wr_bust_len               ;  //��DDR3��д����ʱ��ͻ������
wire  [10:0]  pixel_xpos               ;  //���ص������
wire  [10:0]  pixel_ypos               ;  //���ص�������   
wire         lcd_clk                   ;  //��Ƶ������LCD ����ʱ��
wire  [12:0] h_disp                    ;  //LCD��ˮƽ�ֱ���
wire  [12:0] v_disp                    ;  //LCD����ֱ�ֱ���     
wire  [10:0] h_pixel                   ;  //����ddr3��ˮƽ�ֱ���        
wire  [10:0] v_pixel                   ;  //����ddr3������ֱ�ֱ��� 
wire  [15:0] lcd_id                    ;  //LCD����ID��
wire  [27:0] ddr3_addr_max             ;  //����DDR3������д��ַ 
wire         i2c_rh_wl                 ;  //I2C��д�����ź�             
wire  [7:0]  i2c_data_r                ;  //I2C������ 
wire  [12:0] total_h_pixel             ;  //ˮƽ�����ش�С 
wire  [12:0] total_v_pixel             ;  //��ֱ�����ش�С
wire  [2:0]  tmds_data_p               ;  // TMDS ����ͨ��
wire  [2:0]  tmds_data_n               ;
wire  [15:0] post_rgb                  ;  //������ͼ������
wire         post_frame_vsync          ;  //�����ĳ��ź�
wire         post_frame_de             ;  //������������Чʹ�� 

//*****************************************************
//**                    main code
//*****************************************************

//��ʱ�������������λ�����ź�
assign  rst_n = sys_rst_n & locked;

//ϵͳ��ʼ����ɣ�DDR3��ʼ�����
assign  sys_init_done = init_calib_complete;

 //ov5640 ����
ov5640_dri u_ov5640_dri(
    .clk               (clk_50m),
    .rst_n             (rst_n),

    .cam_pclk          (cam_pclk ),
    .cam_vsync         (cam_vsync),
    .cam_href          (cam_href ),
    .cam_data          (cam_data ),
    .cam_rst_n         (cam_rst_n),
    .cam_pwdn          (cam_pwdn ),
    .cam_scl           (cam_scl  ),
    .cam_sda           (cam_sda  ),
    
    .capture_start     (init_calib_complete),
    .cmos_h_pixel      (H_CMOS_DISP),
    .cmos_v_pixel      (V_CMOS_DISP),
    .total_h_pixel     (TOTAL_H_PIXEL),
    .total_v_pixel     (TOTAL_V_PIXEL),
    .cmos_frame_vsync  (cmos_frame_vsync),
    .cmos_frame_href   (cmos_frame_href),
    .cmos_frame_valid  (cmos_frame_valid),
    .cmos_frame_data   (wr_data)
    );   

 //ͼ����ģ��
vip u_vip(
    //module clock
    .clk              (cam_pclk),          // ʱ���ź�
    .rst_n            (rst_n ),            // ��λ�źţ�����Ч��
    //ͼ����ǰ�����ݽӿ�
    .pre_frame_vsync  (cmos_frame_vsync),
    .pre_frame_hsync  (cmos_frame_href),
    .pre_frame_de     (cmos_frame_valid),
    .pre_rgb          (wr_data),
    .xpos             (pixel_xpos),
    .ypos             (pixel_ypos),
    //ͼ���������ݽӿ�
    .post_frame_vsync (post_frame_vsync),  // �����ĳ��ź�
    .post_frame_hsync ( ),                 // ���������ź�
    .post_frame_de    (post_frame_de),     // ������������Чʹ�� 
    .post_rgb         (post_rgb)           // ������ͼ������

);  

ddr3_top u_ddr3_top (
    .clk_200m            (clk_200m),                  //ϵͳʱ��
    .sys_rst_n           (rst_n),                     //��λ,����Ч
    .sys_init_done       (sys_init_done),             //ϵͳ��ʼ�����
    .init_calib_complete (init_calib_complete),       //ddr3��ʼ������ź�    
    //ddr3�ӿ��ź�       
    .app_addr_rd_min     (28'd0),                     //��DDR3����ʼ��ַ
    .app_addr_rd_max     (V_CMOS_DISP*H_CMOS_DISP),   //��DDR3�Ľ�����ַ
    .rd_bust_len         (H_CMOS_DISP[10:3]),         //��DDR3�ж�����ʱ��ͻ������
    .app_addr_wr_min     (28'd0),                     //дDDR3����ʼ��ַ
    .app_addr_wr_max     (V_CMOS_DISP*H_CMOS_DISP),   //дDDR3�Ľ�����ַ
    .wr_bust_len         (H_CMOS_DISP[10:3]),         //��DDR3��д����ʱ��ͻ������   
    // DDR3 IO�ӿ�              
    .ddr3_dq             (ddr3_dq),                   //DDR3 ����
    .ddr3_dqs_n          (ddr3_dqs_n),                //DDR3 dqs��
    .ddr3_dqs_p          (ddr3_dqs_p),                //DDR3 dqs��  
    .ddr3_addr           (ddr3_addr),                 //DDR3 ��ַ   
    .ddr3_ba             (ddr3_ba),                   //DDR3 banck ѡ��
    .ddr3_ras_n          (ddr3_ras_n),                //DDR3 ��ѡ��
    .ddr3_cas_n          (ddr3_cas_n),                //DDR3 ��ѡ��
    .ddr3_we_n           (ddr3_we_n),                 //DDR3 ��дѡ��
    .ddr3_reset_n        (ddr3_reset_n),              //DDR3 ��λ
    .ddr3_ck_p           (ddr3_ck_p),                 //DDR3 ʱ����
    .ddr3_ck_n           (ddr3_ck_n),                 //DDR3 ʱ�Ӹ�  
    .ddr3_cke            (ddr3_cke),                  //DDR3 ʱ��ʹ��
    .ddr3_cs_n           (ddr3_cs_n),                 //DDR3 Ƭѡ
    .ddr3_dm             (ddr3_dm),                   //DDR3_dm
    .ddr3_odt            (ddr3_odt),                  //DDR3_odt
    //�û�                                            
    .ddr3_read_valid     (1'b1),                      //DDR3 ��ʹ��
    .ddr3_pingpang_en    (1'b1),                      //DDR3 ƹ�Ҳ���ʹ��
    .wr_clk              (cam_pclk),                  //дʱ��
    .wr_load             (post_frame_vsync),          //����Դ�����ź�   
	.datain_valid        (post_frame_de),             //������Чʹ���ź�
    .datain              (post_rgb),                  //��Ч���� 
    .rd_clk              (pixel_clk),                 //��ʱ�� 
    .rd_load             (rd_vsync),                  //���Դ�����ź�    
    .dataout             (rd_data),                   //rfifo�������
    .rdata_req           (rdata_req)                  //������������   
     );                    

 clk_wiz_0 u_clk_wiz_0
   (
    // Clock out ports
    .clk_out1              (clk_200m),     
    .clk_out2              (clk_50m),
    .clk_out3              (pixel_clk_5x),
    .clk_out4              (pixel_clk),
    // Status and control signals
    .reset                 (1'b0), 
    .locked                (locked),       
   // Clock in ports
    .clk_in1               (sys_clk)
    );     
 
//HDMI������ʾģ��    
hdmi_top u_hdmi_top(
    .pixel_clk            (pixel_clk),
    .pixel_clk_5x         (pixel_clk_5x),    
    .sys_rst_n            (sys_init_done & rst_n),
    //hdmi�ӿ�
    .hpdin                (hpdin),                     
    .tmds_clk_p           (tmds_clk_p),    // TMDS ʱ��ͨ��
    .tmds_clk_n           (tmds_clk_n),
    .tmds_data_p          (tmds_data_p),   // TMDS ����ͨ��
    .tmds_data_n          (tmds_data_n),
    .tmds_oen             (tmds_oen),      // TMDS ���ʹ��
    .hpdout               (hpdout),
    //�û��ӿ� 
    .video_vs             (rd_vsync),      //HDMI���ź�  
    .h_disp               (h_disp),        //HDMI��ˮƽ�ֱ���
    .v_disp               (v_disp),        //HDMI����ֱ�ֱ���   
    .pixel_xpos           (pixel_xpos),    //���ص������
    .pixel_ypos           (pixel_ypos),          
    .data_in              (rd_data),       //�������� 
    .data_req             (rdata_req)      //������������   
);   

endmodule