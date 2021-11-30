module IMAGEN_LCD(
	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [7:0] R, G, B
	);

 
	wire [10:0] Columnas; 
	wire [9:0] Filas; 
	wire NCLKaux;
	
	`include "MathFun.vh"
	parameter n = CLogB2(800-1);
	
	parameter m = CLogB2(480-1);
	
	localparam p
	
	LCD_SYNC control_LCD (.CLK(CLK),
								.RST_n(RST_n),
								.NCLK(NCLK),
								.GREST(GREST),
								.HD(HD),
								.VD(VD),
								.DEN(DEN),
								.Columna(Columnas),
								.Fila(Filas));
	
	always@(Columnas, Filas)
	begin
		
		
	
	end
	

	
	
	
endmodule