// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: contador.v
//
// Descripción: Este código Verilog realiza la visualización de una imagen correspondiente a la subtarea 3 de la tarea 3.
// Sus funcionalidades son:
//      - RST_n, activo a nivel alto, sincrono
//      - iCLK, Reloj activo por flanco de subida
//      - GREST, un reset global
//		  - NCLK, señal de reloj hacia la pantalla
//      - HD, VD señales de sincronismo horizontal y vertical, respectivamente
//		  - DEN, habilitación visualizacion en la pantalla 
//		  - [7:0] R, G, B, salida que indica el color a representar
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
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
	assign G = (DatosIN[10:5] << 2) | DatosIN[10:9];  
	assign R = (DatosIN[15:11] << 3) | DatosIN[15:13];
		
	
endmodule