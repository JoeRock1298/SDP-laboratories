// Autor: Jose Luis Rocabado Rocha
//Fecha: 26/10/2021

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
			//Esperamos 2*20ns
			#(T*2)
			RST_n = 1'b1;
			//Esperamos 2*20ns
			#(T*2)
			ENABLE = 1'b1;
			UP_DOWN = 1'b1;
			//Esperamos 2*20ns
			#(T*24)
			
			RST_n = 1'b0;
			#(T*2)
			RST_n = 1'b1;
			UP_DOWN = 1'b0;
			#(T*24)
			RST_n = 1'b0;
			#(T*2)
			
			RST_n = 1'b1;
			#(T*2)
			
			ENABLE = 1'b0;
			#(T*2)
			
			
			ENABLE = 1'b1;
			UP_DOWN = 1'b1;
			#(T*2)
			
			UP_DOWN = 1'b0;
			#(T*5)
			$display("Fin Simulación!!!");
			$stop;
		end
		
	always
		begin
			#(T/2) CLK <= ~CLK;
		end
		
endmodule
