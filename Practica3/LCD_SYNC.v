// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: LCD_SYNC.v
//
// Descripción: Este código Verilog implementa los principales drivers de sincronización para una pantalla LCD.
// Corresponde con la subtarea 1 de la tarea 3. Sus funcionalidades son:
//      - RST_n, activo a nivel bajo, sincrono que se conectara al contador
//      - CLK, Reloj activo por flanco de subida
//      - NCLK, Salida de reloj clock a mitad de frecuencia
//		  - GREST, Salida del RST_n
//		  - HD, VD, Fin de cuenta horizontal y vertical
//		  - DEN, Flag del area de visualización
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 28/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module LCD_SYNC(

	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [10:0] Columna, 
	output [9:0] Fila

);

	wire EN_VCOUNT; //Enable del VCOUNT que esta conectado al TC del HCOUNT
	wire TC_VCOUNT; //TC del VCOUNT que esta conectado a la puerta inversora del VD
	reg DENaux;
	
	//Instancias de los contadores horizontal y vertical
	contador #(.fin_cuenta(1056)) HCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(1'b1), .iUP_DOWN(1'b1), .oCOUNT(Columna), .oTC(EN_VCOUNT) );

	contador #(.fin_cuenta(525)) VCOUNT(.iCLK(NCLK), .iRST_n(RST_n), .iENABLE(EN_VCOUNT), .iUP_DOWN(1'b1), .oCOUNT(Fila), .oTC(TC_VCOUNT) );

	assign HD = ~EN_VCOUNT;
	assign VD = ~TC_VCOUNT;
	assign GREST = RST_n;
	
	// Instacia del PLL
	pll_ltm PLL (
		.inclk0   (CLK),   		//inclk0.clk
		.c0      (NCLK)         // c0.reset
	);
	
	// Declaración de la salida DEN
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