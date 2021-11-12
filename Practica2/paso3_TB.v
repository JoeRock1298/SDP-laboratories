// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso3_TB.v
//
// Descripción: Este código Verilog implementa el documento de TestBench para el paso 2 de la subtarea 3 de la tarea 2.
// Aquí se comprobará el funcionamiento del FSM de Mealy para el control de la velocidad del juego de luces
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Enable activo a nivel lto
//      - Salidas del contador y del terminal count
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module paso3_TB ( );
    //definicion de parametros
    localparam T = 2;
    parameter mod = 50; // para tener una frecuencia de 1 MHz, para visualizar el resultado más rápido
    localparam countT = T*mod;

    // definicion de variables
	reg CLK, RST_n, ENABLE, MODE;
    reg [1:0] in;
    wire [7:0] LEDG, LEDR;

    //instanciación de los DUT (Device Under Test)
    paso3 #(.mod(mod)) dut(.iCLK(CLK), 
									.iRST_n(RST_n), 
									.iENABLE(ENABLE), 
									.iMODE(MODE), 
									.iKEY1(in[0]), 
									.iKEY2(in[1]),
									.oLEDG(LEDG), 
									.oLEDR(LEDR));

    //Declaring tasks for test
    task increase ();
		begin
			repeat(2)
			begin
				@(negedge CLK ) 
					in = 2'b10;
			end
			@(negedge CLK ) 
				in = 2'b00;
		end
	endtask

	task decrease();
		begin
			repeat(2)
			begin
				@(negedge CLK ) 
				in = 2'b01;
			end
			@(negedge CLK ) 
				in = 2'b00;
		end
	endtask

    task rst( );
		begin
			repeat(2)
			begin
				@(negedge CLK ) 
				RST_n = 1'b0;
			end
			@(negedge CLK ) 
			RST_n = 1'b1;
		end
	endtask

    initial 
        begin
			CLK = 1'b0;
			ENABLE = 0;
			in = 0;
			MODE = 0;
			RST_n = 1'b0;
			$display("SIMULANDO!!!");

			// Testing all situations
			#(T*2)
			RST_n = 1'b1;
			ENABLE = 1'b1;
         MODE = 1'b1;
         #(T*2)
         repeat (17)increase(); #(countT*2)
         rst();
         MODE = 1'b0;
         #(T*2)
         repeat(4) decrease(); #(countT*2)
         ENABLE = 0;
         increase();
         #(T*2)
         decrease();
			#(T*2)
         $display("Fin Simulación!!!");
			$stop;
        end

    always
		begin
			#(T/2) CLK <= ~CLK;
		end

endmodule
