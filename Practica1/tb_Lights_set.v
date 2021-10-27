// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: tb_count.v
//
// Descripción: Este código Verilog implementa el código para el test bench del juego de luces correspondiente 
// a la subtarea 3 de la tarea 1.
// Se testean los casos:
//    - Reset
//		- ENABLE
//		- Funcionalidad
// *La simulación requiere demasiado tiempo (se simulan alrededor de 12 segundos a paso de 1ps)
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
//
// -------------------------------------------------------------------------------------------------------------------------
//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module tb_Lights_set ();

	localparam T = 2;
	
	reg CLK, RST_n;
	reg ENABLE;
	wire [7:0]  out;
	
	//instanciación del DUT (Device Under Test)
	Lights_set DUT1 (.iCLK(CLK),
						  .iRST_n(RST_n),
						  .iENABLE (ENABLE),
						  .LEDS_out (out));
	initial
		begin
			RST_n = 1'b0;
			CLK = 1'b0;
			ENABLE = 1'b0;
			$display("SIMULANDO!!!");
			//Esperamos 2*20ns
			#(T*2)
			RST_n = 1'b1;
			//Esperamos 2*20ns
			#(T*2)
			ENABLE = 1'b1;
			//Esperamos 2*20ns
			#(T*180000000)
			$display("3.5s!!!");
			RST_n = 1'b0;
			#(T*2)
			RST_n = 1'b1;
			#(T*18000000)
			ENABLE = 1'b0;
			#(T*18000)
			ENABLE = 1'b1;
			#(T*180000000)
			
			$display("Fin Simulación!!!");
			$stop;
		end
		
	always
		begin
			#(T/2) CLK <= ~CLK;
		end
		
endmodule											  
											  