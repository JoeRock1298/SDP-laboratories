// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: tb_count.v
//
// Descripción: Este código Verilog implementa el código para el test bench del contador parametrizable correspondiente 
// a la subtarea 1 de la tarea 1.
// Se testean los casos:
//      - Reset
//		- ENABLE
//		- Count UP
//		- Count DOWN
//		- TC en ambas situacioones de conteo (UP/DOWN)
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

//´timescale <time_unit>/<time_precision>
`timescale 1ns/1ps

module tb_count ();

	localparam T = 20;
	
	reg CLK, RST_n;
	reg ENABLE, UP_DOWN;
	wire [4:0]  COUNT;
	wire TC;
	
	//instanciación del DUT (Device Under Test)
	contador #(.fin_cuenta(20)) i1 (.iCLK(CLK),
											  .iRST_n(RST_n),
											  .iENABLE (ENABLE),
											  .iUP_DOWN (UP_DOWN),
											  .oCOUNT (COUNT),
											  .oTC(TC));
	initial
		begin
			RST_n = 1'b0;
			CLK = 1'b0;
			ENABLE = 1'b0;
			UP_DOWN = 1'b0;
			$display("SIMULANDO!!!");
			//Esperamos 2 Periodos y desactivamos el reset
			#(T*2)
			RST_n = 1'b1;
			//Esperamos 2 Periodos y activamos el ENABLE y el conteo hacia arriba
			#(T*2)
			ENABLE = 1'b1;
			UP_DOWN = 1'b1;
			//Esperamos 24 Periodos de conteo y activamos el reset
			#(T*24)
			
			RST_n = 1'b0;
			#(T*2) //Esperamos 2 Periodos y desactivamos el RESET y contamos hacia abajo
			RST_n = 1'b1;
			UP_DOWN = 1'b0;
			
			#(T*24) //Esperamos 24 Periodos de conteo y activamos el RESET
			RST_n = 1'b0;
			
			#(T*2) //Esperamos 2 Periodos y desactivamos el RESET
			
			RST_n = 1'b1;
			#(T*2) //Esperamos 2 Periodos y desactivamos el ENABLE
			
			ENABLE = 1'b0;
			#(T*2)
			
			//Esperamos 2 Periodos y activamos el ENABLE y contamos hacia arriba
			ENABLE = 1'b1;
			UP_DOWN = 1'b1;
			#(T*2)
			//Esperamos 2 Periodos y contamos hacia abajo
			UP_DOWN = 1'b0;
			#(T*5)
			//Realizamos el conteo hacia abajo durante 5 Periodos 
			$display("Fin Simulación!!!");
			$stop;
		end
		
	always
		begin
			#(T/2) CLK <= ~CLK;
		end
		
endmodule
