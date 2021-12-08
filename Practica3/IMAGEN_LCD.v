module IMAGEN_LCD(
	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [7:0] R, G, B
	);

 	// Definition of the local parameters
	`include "MathFun.vh"
	localparam x = CLogB2(400-1);//9
	localparam y = CLogB2(240-1);//8
	localparam p = CLogB2((400*240*16)-1);//(21) corresponding a 400x240 pixels image of 16 bits
	

	// Defition of the auxiliar variables
	wire [10:0] Columnas; 
	wire [9:0] Filas; 
	wire [p-1:0]Address;
	reg [x-1:0] posX;
	reg [y-1:0] posY;
	wire NCLKaux;
	wire DatosIN;
	
	LCD_SYNC control_LCD (.CLK(CLK),
								.RST_n(RST_n),
								.NCLK(NCLK),
								.GREST(GREST),
								.HD(HD),
								.VD(VD),
								.DEN(DEN),
								.Columna(Columnas),
								.Fila(Filas));
	
	//Defining Direccionamiento
	always@(Columnas, Filas)
	begin
		if(Columnas >= 216 && Columnas <= 1015 && Filas >= 35 && Filas <= 514)
		begin
			posX = (Columnas - 216) >> 1;
			posY = (Filas - 35) >> 1;
		end	
	end
	
	assign Address = {posY,posX};
		
	//ROM_image ROM_image_inst (
	//						.address(Address),
	//						.clock(NCLK),
	//						.q(DatosIN)
	//						);
	//assing B = (DatosIN[4:0] << 3) | DatosIN[4:2];
	//assing G = (DatosIN[10:5] << 2) | DatosIN[10:9];  //¿Cuando se coge una parte de un array los pone en la posicion 0?
	//assing R = (DatosIN[15:11] << 3) | DatosIN[15:12];
		
	
endmodule