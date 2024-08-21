`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 10:29:17
// Design Name: 
// Module Name: Similary_LUT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//Sigma_r = 0.300000
module Similary_LUT
(
   input		[7:0]	Pre_Data,
   output	reg	[9:0]	Post_Data
);

always@(*)
begin
	case(Pre_Data)
	8'h00 : Post_Data = 10'h3FF; 
	8'h01 : Post_Data = 10'h3FE; 
	8'h02 : Post_Data = 10'h3FE; 
	8'h03 : Post_Data = 10'h3FE; 
	8'h04 : Post_Data = 10'h3FD; 
	8'h05 : Post_Data = 10'h3FC; 
	8'h06 : Post_Data = 10'h3FB; 
	8'h07 : Post_Data = 10'h3FA; 
	8'h08 : Post_Data = 10'h3F9; 
	8'h09 : Post_Data = 10'h3F7; 
	8'h0A : Post_Data = 10'h3F6; 
	8'h0B : Post_Data = 10'h3F4; 
	8'h0C : Post_Data = 10'h3F2; 
	8'h0D : Post_Data = 10'h3F0; 
	8'h0E : Post_Data = 10'h3EE; 
	8'h0F : Post_Data = 10'h3EB; 
	8'h10 : Post_Data = 10'h3E8; 
	8'h11 : Post_Data = 10'h3E6; 
	8'h12 : Post_Data = 10'h3E3; 
	8'h13 : Post_Data = 10'h3DF; 
	8'h14 : Post_Data = 10'h3DC; 
	8'h15 : Post_Data = 10'h3D9; 
	8'h16 : Post_Data = 10'h3D5; 
	8'h17 : Post_Data = 10'h3D1; 
	8'h18 : Post_Data = 10'h3CD; 
	8'h19 : Post_Data = 10'h3C9; 
	8'h1A : Post_Data = 10'h3C5; 
	8'h1B : Post_Data = 10'h3C1; 
	8'h1C : Post_Data = 10'h3BC; 
	8'h1D : Post_Data = 10'h3B8; 
	8'h1E : Post_Data = 10'h3B3; 
	8'h1F : Post_Data = 10'h3AE; 
	8'h20 : Post_Data = 10'h3A9; 
	8'h21 : Post_Data = 10'h3A4; 
	8'h22 : Post_Data = 10'h39E; 
	8'h23 : Post_Data = 10'h399; 
	8'h24 : Post_Data = 10'h393; 
	8'h25 : Post_Data = 10'h38E; 
	8'h26 : Post_Data = 10'h388; 
	8'h27 : Post_Data = 10'h382; 
	8'h28 : Post_Data = 10'h37C; 
	8'h29 : Post_Data = 10'h376; 
	8'h2A : Post_Data = 10'h36F; 
	8'h2B : Post_Data = 10'h369; 
	8'h2C : Post_Data = 10'h363; 
	8'h2D : Post_Data = 10'h35C; 
	8'h2E : Post_Data = 10'h355; 
	8'h2F : Post_Data = 10'h34F; 
	8'h30 : Post_Data = 10'h348; 
	8'h31 : Post_Data = 10'h341; 
	8'h32 : Post_Data = 10'h33A; 
	8'h33 : Post_Data = 10'h333; 
	8'h34 : Post_Data = 10'h32B; 
	8'h35 : Post_Data = 10'h324; 
	8'h36 : Post_Data = 10'h31D; 
	8'h37 : Post_Data = 10'h316; 
	8'h38 : Post_Data = 10'h30E; 
	8'h39 : Post_Data = 10'h307; 
	8'h3A : Post_Data = 10'h2FF; 
	8'h3B : Post_Data = 10'h2F7; 
	8'h3C : Post_Data = 10'h2F0; 
	8'h3D : Post_Data = 10'h2E8; 
	8'h3E : Post_Data = 10'h2E0; 
	8'h3F : Post_Data = 10'h2D8; 
	8'h40 : Post_Data = 10'h2D0; 
	8'h41 : Post_Data = 10'h2C9; 
	8'h42 : Post_Data = 10'h2C1; 
	8'h43 : Post_Data = 10'h2B9; 
	8'h44 : Post_Data = 10'h2B1; 
	8'h45 : Post_Data = 10'h2A9; 
	8'h46 : Post_Data = 10'h2A1; 
	8'h47 : Post_Data = 10'h299; 
	8'h48 : Post_Data = 10'h290; 
	8'h49 : Post_Data = 10'h288; 
	8'h4A : Post_Data = 10'h280; 
	8'h4B : Post_Data = 10'h278; 
	8'h4C : Post_Data = 10'h270; 
	8'h4D : Post_Data = 10'h268; 
	8'h4E : Post_Data = 10'h260; 
	8'h4F : Post_Data = 10'h258; 
	8'h50 : Post_Data = 10'h250; 
	8'h51 : Post_Data = 10'h248; 
	8'h52 : Post_Data = 10'h23F; 
	8'h53 : Post_Data = 10'h237; 
	8'h54 : Post_Data = 10'h22F; 
	8'h55 : Post_Data = 10'h227; 
	8'h56 : Post_Data = 10'h21F; 
	8'h57 : Post_Data = 10'h217; 
	8'h58 : Post_Data = 10'h20F; 
	8'h59 : Post_Data = 10'h207; 
	8'h5A : Post_Data = 10'h200; 
	8'h5B : Post_Data = 10'h1F8; 
	8'h5C : Post_Data = 10'h1F0; 
	8'h5D : Post_Data = 10'h1E8; 
	8'h5E : Post_Data = 10'h1E0; 
	8'h5F : Post_Data = 10'h1D9; 
	8'h60 : Post_Data = 10'h1D1; 
	8'h61 : Post_Data = 10'h1C9; 
	8'h62 : Post_Data = 10'h1C2; 
	8'h63 : Post_Data = 10'h1BA; 
	8'h64 : Post_Data = 10'h1B3; 
	8'h65 : Post_Data = 10'h1AB; 
	8'h66 : Post_Data = 10'h1A4; 
	8'h67 : Post_Data = 10'h19D; 
	8'h68 : Post_Data = 10'h196; 
	8'h69 : Post_Data = 10'h18E; 
	8'h6A : Post_Data = 10'h187; 
	8'h6B : Post_Data = 10'h180; 
	8'h6C : Post_Data = 10'h179; 
	8'h6D : Post_Data = 10'h172; 
	8'h6E : Post_Data = 10'h16B; 
	8'h6F : Post_Data = 10'h165; 
	8'h70 : Post_Data = 10'h15E; 
	8'h71 : Post_Data = 10'h157; 
	8'h72 : Post_Data = 10'h151; 
	8'h73 : Post_Data = 10'h14A; 
	8'h74 : Post_Data = 10'h144; 
	8'h75 : Post_Data = 10'h13D; 
	8'h76 : Post_Data = 10'h137; 
	8'h77 : Post_Data = 10'h131; 
	8'h78 : Post_Data = 10'h12A; 
	8'h79 : Post_Data = 10'h124; 
	8'h7A : Post_Data = 10'h11E; 
	8'h7B : Post_Data = 10'h118; 
	8'h7C : Post_Data = 10'h113; 
	8'h7D : Post_Data = 10'h10D; 
	8'h7E : Post_Data = 10'h107; 
	8'h7F : Post_Data = 10'h101; 
	8'h80 : Post_Data = 10'h0FC; 
	8'h81 : Post_Data = 10'h0F6; 
	8'h82 : Post_Data = 10'h0F1; 
	8'h83 : Post_Data = 10'h0EC; 
	8'h84 : Post_Data = 10'h0E6; 
	8'h85 : Post_Data = 10'h0E1; 
	8'h86 : Post_Data = 10'h0DC; 
	8'h87 : Post_Data = 10'h0D7; 
	8'h88 : Post_Data = 10'h0D2; 
	8'h89 : Post_Data = 10'h0CD; 
	8'h8A : Post_Data = 10'h0C9; 
	8'h8B : Post_Data = 10'h0C4; 
	8'h8C : Post_Data = 10'h0BF; 
	8'h8D : Post_Data = 10'h0BB; 
	8'h8E : Post_Data = 10'h0B6; 
	8'h8F : Post_Data = 10'h0B2; 
	8'h90 : Post_Data = 10'h0AD; 
	8'h91 : Post_Data = 10'h0A9; 
	8'h92 : Post_Data = 10'h0A5; 
	8'h93 : Post_Data = 10'h0A1; 
	8'h94 : Post_Data = 10'h09D; 
	8'h95 : Post_Data = 10'h099; 
	8'h96 : Post_Data = 10'h095; 
	8'h97 : Post_Data = 10'h091; 
	8'h98 : Post_Data = 10'h08E; 
	8'h99 : Post_Data = 10'h08A; 
	8'h9A : Post_Data = 10'h086; 
	8'h9B : Post_Data = 10'h083; 
	8'h9C : Post_Data = 10'h07F; 
	8'h9D : Post_Data = 10'h07C; 
	8'h9E : Post_Data = 10'h079; 
	8'h9F : Post_Data = 10'h075; 
	8'hA0 : Post_Data = 10'h072; 
	8'hA1 : Post_Data = 10'h06F; 
	8'hA2 : Post_Data = 10'h06C; 
	8'hA3 : Post_Data = 10'h069; 
	8'hA4 : Post_Data = 10'h066; 
	8'hA5 : Post_Data = 10'h063; 
	8'hA6 : Post_Data = 10'h061; 
	8'hA7 : Post_Data = 10'h05E; 
	8'hA8 : Post_Data = 10'h05B; 
	8'hA9 : Post_Data = 10'h059; 
	8'hAA : Post_Data = 10'h056; 
	8'hAB : Post_Data = 10'h054; 
	8'hAC : Post_Data = 10'h051; 
	8'hAD : Post_Data = 10'h04F; 
	8'hAE : Post_Data = 10'h04C; 
	8'hAF : Post_Data = 10'h04A; 
	8'hB0 : Post_Data = 10'h048; 
	8'hB1 : Post_Data = 10'h046; 
	8'hB2 : Post_Data = 10'h044; 
	8'hB3 : Post_Data = 10'h042; 
	8'hB4 : Post_Data = 10'h040; 
	8'hB5 : Post_Data = 10'h03E; 
	8'hB6 : Post_Data = 10'h03C; 
	8'hB7 : Post_Data = 10'h03A; 
	8'hB8 : Post_Data = 10'h038; 
	8'hB9 : Post_Data = 10'h036; 
	8'hBA : Post_Data = 10'h035; 
	8'hBB : Post_Data = 10'h033; 
	8'hBC : Post_Data = 10'h031; 
	8'hBD : Post_Data = 10'h030; 
	8'hBE : Post_Data = 10'h02E; 
	8'hBF : Post_Data = 10'h02D; 
	8'hC0 : Post_Data = 10'h02B; 
	8'hC1 : Post_Data = 10'h02A; 
	8'hC2 : Post_Data = 10'h029; 
	8'hC3 : Post_Data = 10'h027; 
	8'hC4 : Post_Data = 10'h026; 
	8'hC5 : Post_Data = 10'h025; 
	8'hC6 : Post_Data = 10'h023; 
	8'hC7 : Post_Data = 10'h022; 
	8'hC8 : Post_Data = 10'h021; 
	8'hC9 : Post_Data = 10'h020; 
	8'hCA : Post_Data = 10'h01F; 
	8'hCB : Post_Data = 10'h01E; 
	8'hCC : Post_Data = 10'h01D; 
	8'hCD : Post_Data = 10'h01C; 
	8'hCE : Post_Data = 10'h01B; 
	8'hCF : Post_Data = 10'h01A; 
	8'hD0 : Post_Data = 10'h019; 
	8'hD1 : Post_Data = 10'h018; 
	8'hD2 : Post_Data = 10'h017; 
	8'hD3 : Post_Data = 10'h016; 
	8'hD4 : Post_Data = 10'h015; 
	8'hD5 : Post_Data = 10'h015; 
	8'hD6 : Post_Data = 10'h014; 
	8'hD7 : Post_Data = 10'h013; 
	8'hD8 : Post_Data = 10'h012; 
	8'hD9 : Post_Data = 10'h012; 
	8'hDA : Post_Data = 10'h011; 
	8'hDB : Post_Data = 10'h010; 
	8'hDC : Post_Data = 10'h010; 
	8'hDD : Post_Data = 10'h00F; 
	8'hDE : Post_Data = 10'h00F; 
	8'hDF : Post_Data = 10'h00E; 
	8'hE0 : Post_Data = 10'h00E; 
	8'hE1 : Post_Data = 10'h00D; 
	8'hE2 : Post_Data = 10'h00D; 
	8'hE3 : Post_Data = 10'h00C; 
	8'hE4 : Post_Data = 10'h00C; 
	8'hE5 : Post_Data = 10'h00B; 
	8'hE6 : Post_Data = 10'h00B; 
	8'hE7 : Post_Data = 10'h00A; 
	8'hE8 : Post_Data = 10'h00A; 
	8'hE9 : Post_Data = 10'h009; 
	8'hEA : Post_Data = 10'h009; 
	8'hEB : Post_Data = 10'h009; 
	8'hEC : Post_Data = 10'h008; 
	8'hED : Post_Data = 10'h008; 
	8'hEE : Post_Data = 10'h008; 
	8'hEF : Post_Data = 10'h007; 
	8'hF0 : Post_Data = 10'h007; 
	8'hF1 : Post_Data = 10'h007; 
	8'hF2 : Post_Data = 10'h006; 
	8'hF3 : Post_Data = 10'h006; 
	8'hF4 : Post_Data = 10'h006; 
	8'hF5 : Post_Data = 10'h006; 
	8'hF6 : Post_Data = 10'h005; 
	8'hF7 : Post_Data = 10'h005; 
	8'hF8 : Post_Data = 10'h005; 
	8'hF9 : Post_Data = 10'h005; 
	8'hFA : Post_Data = 10'h004; 
	8'hFB : Post_Data = 10'h004; 
	8'hFC : Post_Data = 10'h004; 
	8'hFD : Post_Data = 10'h004; 
	8'hFE : Post_Data = 10'h004; 
	8'hFF : Post_Data = 10'h003; 
	endcase
end

endmodule