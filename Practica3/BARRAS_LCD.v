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