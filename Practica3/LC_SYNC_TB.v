// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: LCD_SYNC_TB.v
//
// Descripción: Este código Verilog implementa el documento de TestBench de la subtarea 1 de la tarea 3.
//      - Funciona a flanco positivo del reloj de 25MHz
//      - Reset sincrono y activo a nivel alto
//      - Enable activo a nivel alto
//      - Salida [10:0] correspondiente a las columnas
//      - Salida [9:0] correspondiente a las filas
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module LC_SYNC_TB ();
    //definicion de parametros
   localparam T = 2;
  
    // definicion de variables
	reg CLK, RST_n;
   wire [10:0] Columnas; 
	wire [9:0] Filas; 
	wire NCLK, GREST, HD, VD, DEN;
	
	//instanciación de los DUT (Device Under Test)
	LCD_SYNC dut1(.CLK(CLK),
				  .RST_n(RST_n),
				  .NCLK(NCLK),
				  .GREST(GREST),
				  .HD(HD),
				  .VD(VD),
				  .DEN(DEN),
				  .Columna(Columnas),
				  .Fila(Filas));

	//Declaracion de tareas	
	task fin();
		
		@(negedge VD)
			begin 
			#(T/2)
			$display("Fin Simulación!!!");
			$stop;
		
			end
			
	endtask
	
    initial 
        begin
         RST_n = 1'b0;
			CLK = 1'b0;
			$display("SIMULANDO!!!");
			#(10*T)
			RST_n = 1'b1;
			fin();
			
        end

    always
		begin
			#(T/2) CLK <= ~CLK;
		end

endmodule