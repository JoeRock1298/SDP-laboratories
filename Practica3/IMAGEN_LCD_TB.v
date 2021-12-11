// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: IMAGEN_LCD_TB.v
//
// Descripción: Este código Verilog implementa el documento de TestBench para la subtarea 3 de la tarea 3.
// Aquí se comprobará el funcionamiento de la visualización de una imagen guardada en una memoria ROM.
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Se simulará un frame para comprobar el correcto funcionamiento de los contadores mediante una task
//		  - Se generá un documento de texto que nos permitirá comprobar la simulación de forma visual mediante un emulador
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 7/12/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module IMAGEN_LCD_TB ();
    //definicion de parametros
   localparam T = 2;
  
    // definicion de variables
	reg CLK, RST_n;
	wire [7:0] R, G, B;
	wire NCLK, GREST, HD, VD, DEN;
		
	//instanciación de los DUT (Device Under Test)
	IMAGEN_LCD dut2(.CLK(CLK),
				  .RST_n(RST_n),
				  .NCLK(NCLK),
				  .GREST(GREST),
				  .HD(HD),
				  .VD(VD),
				  .DEN(DEN),
				  .R(R),
				  .G(G),
				  .B(B));

	integer fd;
	event cierraFichero;
	
	initial 
        begin
         RST_n = 1'b0;
			CLK = 1'b0;
			$display("SIMULANDO!!!");
			#(10*T)
			RST_n = 1'b1;
	
	
	@(posedge VD);
	
		$display("Fin de la simulacion\n");
		-> cierraFichero;
		#10;
		$stop;
	end
		
	initial begin
		fd=$fopen("IMAGEN.txt","w");
		@(cierraFichero);
		disable guardaFichero;
		$display("Cierro Fichero");
		$fclose(fd);
	end
	
	initial forever begin: guardaFichero
		@(posedge CLK)
		$fwrite(fd, "%0t ps: %b %b %b %b %b %b\n", $time, HD, VD,DEN,R,G,B);
	end
				  

    always
		begin
			#(T/2) CLK <= ~CLK;
		end

endmodule