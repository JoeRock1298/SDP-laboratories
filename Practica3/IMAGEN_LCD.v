// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: IMAGEN_LCD.v
//
// Descripción: Este código Verilog implementa la visualización de una imagen guardada en una memoria ROM.
// Corresponde con la subtarea 3 de la tarea 3. Sus funcionalidades son:
//      - RST_n, activo a nivel bajo, sincrono que se conectara al contador
//      - CLK, Reloj activo por flanco de subida
//      - NCLK, Salida de reloj clock a mitad de frecuencia
//		  - GREST, Salida del RST_n
//		  - HD, VD, Fin de cuenta horizontal y vertical
//		  - DEN, Flag del area de visualización
//		  - Direccionamiento XY con duplicado de pixeles para ajustar a la pantalla el tamaño de la imagen 
//		  - Memoria ROM de 240x(2^9) palabras con una q de 16 bits
//		  - RGB, de 24 bits obtenido del RGB de 16 bits de la imagen guardada en memoria
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 7/12/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module IMAGEN_LCD(
	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [7:0] R, G, B
	);

 	// Definition of the local parameters
	`include "MathFun.vh"
	localparam x = CLogB2(400-1);//9
	localparam y = CLogB2(240-1);//8
	
	//(17) corresponding a 400x240 pixels image but, since a row has 2^x we need more words.
	localparam p = CLogB2((240*512)-1);
	

	// Defition of the auxiliar variables
	wire [10:0] Columnas; 
	wire [9:0] Filas; 
	wire [p-1:0]Address;
	wire [15:0] DatosIN; //16bits image data
	reg [x-1:0] posX;
	reg [y-1:0] posY;
	
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
	
	//ROM image instantiation
	ROM_image	ROM_image_inst (.address(Address),
										 .clock(NCLK),
										 .q(DatosIN));
	
	//16 to 24 bit RGB converter
	assign B = (DatosIN[4:0] << 3) | DatosIN[4:2];
	assign G = (DatosIN[10:5] << 2) | DatosIN[10:9];  //¿Cuando se coge una parte de un array los pone en la posicion 0? Si
	assign R = (DatosIN[15:11] << 3) | DatosIN[15:13];
		
	
endmodule