// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso2_TB.v
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

module paso2_TB ();
    //definicion de parametros
    localparam T = 2;
	 localparam n = 4;
	 
    // definicion de variables
	reg CLK, RST_n;
	reg [1:0] in;
   wire [3:0] COUNT;
	wire TC;
	wire [1:0] out;
	
	//instanciación de los DUT (Device Under Test)
	paso2 i1(.iCLK(CLK), 
				.iRST_n(RST_n), 
				.iKEY1(in[0]), 
				.iKEY2(in[1]),
				.oCOUNT(COUNT),
				.oTC(TC),
				.out(out));

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

	task rst();
		repeat(2)
		begin
			@(negedge CLK ) 
			RST_n = 0;
		end
	endtask

	task random();
		begin
			// increase to be in state 1 but then change it to both KEY pressed
			in = 2'b10;
			#(T)
			in = 2'b11;
			#(T*2) 
			//then decrasing to be in state 2 but then activating the reset
			in = 2'b01;
			#(T)
			rst();
			#(T)
			RST_n = 1'b1;
		end
	endtask

    initial 
        begin
         RST_n = 1'b0;
			CLK = 1'b0;
			$display("SIMULANDO!!!");

			// Testing all situations
			#(T*2)
			RST_n = 1'b1;
			repeat(18) decrease();
			#(T*2)
			increase();
			#(T*2)
			rst();
			#(T*2)
			RST_n = 1'b1;
			random();
			#(T*2)
         $display("Fin Simulación!!!");
			$stop;
        end

    always
		begin
			#(T/2) CLK <= ~CLK;
		end

endmodule
