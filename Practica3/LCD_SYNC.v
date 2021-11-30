module LCD_SYNC(

	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [10:0] Columna, 
	output [9:0] Fila

);

	wire EN_VCOUNT; //Enable del VCOUNT que esta conectado al TC del HCOUNT
	wire TC_VCOUNT; //TC del VCOUNT que esta conectado a la puerta inversora del VD
	reg DENaux;
	
	contador #(.fin_cuenta(1056)) HCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(1'b1), .iUP_DOWN(1'b1), .oCOUNT(Columna), .oTC(EN_VCOUNT) );

	contador #(.fin_cuenta(525)) VCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(EN_VCOUNT), .iUP_DOWN(1'b1), .oCOUNT(Fila), .oTC(TC_VCOUNT) );

	assign HD = ~EN_VCOUNT;
	assign VD = ~TC_VCOUNT;
	assign GREST = RST_n;
	
	pll_ltm PLL (
		.inclk0   (CLK),   		//inclk0.clk
		.c0      (NCLK)         // c0.reset
	);
	
	always@(Fila, Columna)
		begin
			DENaux = 1;
			if(Columna >= 216 && Columna <= 1015 && Fila >= 35 && Fila <= 514)
				DENaux= 0;
			else
				DENaux = 1;
		
		end
		
	assign DEN = DENaux; 
	
endmodule