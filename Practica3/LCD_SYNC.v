module LCD_SYNC(

	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [13:0] Columnas, 
	output [13:0] Filas

);

	wire EN_VCOUNT; //Enable del VCOUNT que esta conectado al TC del HCOUNT
	wire TC_VCOUNT; //TC del VCOUNT que esta conectado a la puerta inversora del VD
	
	contador #(.fin_cuenta(1056)) HCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(1), .iUP_DOWN(1), .oCOUNT(Columna), .oTC(EN_VCOUNT));

	contador #(.fin_cuenta(525)) VCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(EN_vCOUNT), .iUP_DOWN(1), .oCOUNT(Fila), .oTC(TC_COUNT));

	assign HD = ~EN_VCOUNT;
	assign vD = ~TC_COUNT;

	pll_ltm_0002 PLL (
		.refclk   (CLK),   //  refclk.clk
		.rst      (RST_n),      //   reset.reset
		.outclk_0 (NCLK), // outclk0.clk
	);
	
	
	
	

endmodule