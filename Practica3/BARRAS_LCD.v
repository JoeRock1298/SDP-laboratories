// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: contador.v
//
// Descripción: Este código Verilog realiza la visualización de una imagen correspondiente a la subtarea 2 de la tarea 3.
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
module BARRAS_LCD(
	input CLK, RST_n,
	output NCLK, GREST, HD, VD, DEN,
	output [7:0] R, G, B
	);
	
	wire [9:0 ]Filas;
	wire [10:0] Columnas;
	reg [7:0] Roux, Goux, Boux;
	
	LCD_SYNC control_LCD (.CLK(CLK),
								.RST_n(RST_n),
								.NCLK(NCLK),
								.GREST(GREST),
								.HD(HD),
								.VD(VD),
								.DEN(DEN),
								.Columna(Columnas),
								.Fila(Filas));
	
	
	always @(Columnas)
		begin
			if(Columnas>=216 && Columnas<315)
				begin
					Roux = 8'd255;
					Goux = 8'd255;
					Boux = 8'd255;
				end
			
			if(Columnas>=315 && Columnas<414)
				begin
					Roux = 8'd255;
					Goux = 8'd255;
					Boux = 8'd51;
				end	
			
			
			if(Columnas>=414 && Columnas<513)
				begin
					Roux = 8'd51;
					Goux = 8'd255;
					Boux = 8'd255;
				end
				
			
			if(Columnas>=513 && Columnas<612)
				begin
					Roux = 8'd51;
					Goux = 8'd255;
					Boux = 8'd51;
				end
				
			if(Columnas>=612 && Columnas<711)
				begin
					Roux = 8'd255;
					Goux = 8'd51;
					Boux = 8'd255;
				end
				
			if(Columnas>=711 && Columnas<810)
				begin
					Roux = 8'd255;
					Goux = 8'd51;
					Boux = 8'd51;
				end
				
			if(Columnas>=810 && Columnas<909)
				begin
					Roux = 8'd51;
					Goux = 8'd51;
					Boux = 8'd255;
				end
				
			if(Columnas>=909 && Columnas<=1015)
				begin
					Roux = 8'd0;
					Goux = 8'd0;
					Boux = 8'd0;
				end
		
		
		end
		
		assign R = Roux;
		assign G = Goux;
		assign B = Boux;
	
endmodule