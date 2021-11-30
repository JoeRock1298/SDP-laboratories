// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: paso1_TB.v
//
// Descripción: Este código Verilog implementa el documento de TestBench para el paso 1 de la subtarea 3 de la tarea 2.
// Aquí se comprobará el funcionamiento del juego de luces (medvedev más contador 10 Hz)
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Enable activo a nivel lto
//      - Salida [7:0] correspondiente al estado de los LED's
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

//´timescale <time_unit>/<time_precision>
`timescale 10ns/10ns

module BARRAS_LCD_TB ();
    //definicion de parametros
   localparam T = 2;
  
    // definicion de variables
	reg CLK, RST_n;
   wire [7:0] R, G, B;  
	wire NCLK, GREST, HD, VD, DEN;
	
	//instanciación de los DUT (Device Under Test)
	BARRAS_LCD dut1(.CLK(CLK),
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
		fd=$fopen("vga.txt","w");
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