// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: contador.v
//
// Descripción: Este código Verilog realiza la visualización de una imagen correspondiente a la subtarea 4 de la tarea 3.
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

module CARACTERES_LCD(
    input CLK, RST_n,
    output NCLK,GREST, HD, VD, DEN,
    output [7:0] R, G, B
);

    //Variables que esta conectadad al modulo LCD_SYNC
    wire  [9:0] Filas;      
    wire [10:0] Columnas;  
    wire  [8:0] DireccionROM;
    wire [5:0] Caracter; 
	 wire  [7:0] Datos;
	 wire Sel_color;
    reg outMUX;
	 reg [7:0] Roux, Goux, Boux;
	 reg [5:0] car_aux  = 6'o01;

    LCD_SYNC control_caracteres(.CLK(CLK),
										  .RST_n(RST_n),
										  .NCLK(NCLK),
										  .GREST(GREST),
										  .HD(HD),
										  .VD(VD),
										  .DEN(DEN),
										  .Columna(Columnas),
										  .Fila(Filas));
    //Bloque CHAR_ROM
    //En cada actualizacion de las filas cambia el valor de la direccion de la ROM
	 assign DireccionROM = {Caracter, Filas[4:2]};
	 
    ROM_char    ROM_char_inst (.address (DireccionROM),
										 .clock (NCLK),
										 .q (Datos));
    
    //Multiplexor con los datos de salida de la memoria ROM y la columna
    //Datos es la entrada del Multiplexor
    //La direccion esta marcada por las columnas[2:0]
    always @(Columnas) begin
            case (Columnas[4:2])
                3'b000:  outMUX = Datos[7];
                3'b001:  outMUX = Datos[6];
                3'b010:  outMUX = Datos[5];
                3'b011:  outMUX = Datos[4];
                3'b100:  outMUX = Datos[3];
                3'b101:  outMUX = Datos[2];
                3'b110:  outMUX = Datos[1];
                3'b111:  outMUX = Datos[0];
                default: outMUX = 0;
            endcase
				// imprimir varios caracteres
				if (Columnas[5] == 0)
					car_aux = 6'o12;
				else
					car_aux = 6'o22;
                   
        end
    
	 
	 assign Caracter = car_aux;
	 assign Sel_color = outMUX; 

    //SELECT_COLOR
    always @(Sel_color) begin
        case (Sel_color)
            1'b0: 
					begin
						Roux = 8'd255;
                  Goux = 8'd255;
                  Boux = 8'd51;
					end
            1'b1: 
					begin
						Roux = 8'd51;
                  Goux = 8'd51;
                  Boux = 8'd255;
					end
            default: 
					begin
						Roux = 8'd0; 
						Goux = 8'd0;
						Boux = 8'd0;
					end
        endcase
    end
      
	assign R = Roux;
	assign G = Goux;
	assign B = Boux;
 
endmodule
