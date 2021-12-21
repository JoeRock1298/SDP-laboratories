
module ADC_CONTROL(
					iCLK,
					iRST_n,
					oADC_DIN,
					oADC_DCLK,
					oSCEN,
					iADC_DOUT,
					iADC_BUSY,
					iADC_PENIRQ_n,
					oX_COORD,
					oY_COORD
					);

	parameter SYSCLK_FRQ	= 50000000;
	parameter ADC_DCLK_FRQ	= 70000;
	parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);
	localparam X_CONTROL = 8'b10010010;
	localparam Y_CONTROL = 8'b11010010;

	input			iCLK;
	input			iRST_n;
	input			iADC_DOUT;
	input			iADC_PENIRQ_n;
	input			iADC_BUSY;
	output			oADC_DIN;	
	output			oADC_DCLK;
	output			oSCEN;
	output	[11:0]	oX_COORD;
	output	[11:0]	oY_COORD;


	//Wires
	wire trans_en, trans_eof, half_dclk, dclk, fin_80;  
	wire [6:0] count_80;
	
	reg ADC_DIN;
	reg [11:0]	X_COORDaux, Y_COORDaux;

	//contador del ADC_DCLK_CNT TC 
	contador #(.fin_cuenta(ADC_DCLK_CNT)) ADC_CNT1 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(dclk) );

	//contador del ADC_DCLK_CNT/2 TC
	contador #(.fin_cuenta(ADC_DCLK_CNT/2)) ADC_CNT1_HALF (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(half_dclk) );

	//contador del ADC_DCLK_CNT TC
	contador #(.fin_cuenta(80)) ADC_CNT_80 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(dclk), .iUP_DOWN(1), .oCOUNT(count_80), .oTC(fin_80) );

	//Generador ADC_DCLK
	assign oADC_DCLK = (iCLK && iRST_n)?count_80[0]:0;
	
	//FSM
	FSM Control (.CLK(iCLK), .fin_80(fin_80), .RST_n(iRST_n), .dclk(dclk), .ADC_PENIRQ_n(iADC_PENIRQ_n), .ADC_CS(oSCEN), .Ena_Trans(trans_en), .Fin_Trans(trans_eof)  );

	//Generador ADC_DIN
	always @(posedge iCLK) 
	begin
		
		if (!iRST_n) 
			ADC_DIN = 0;
		
		else
			if(trans_en)
			begin
			
					case (count_80)
						0|1:     ADC_DIN = X_CONTROL[7];
						2|3:     ADC_DIN = X_CONTROL[6]; 
						4|5:     ADC_DIN = X_CONTROL[5];
						6|7:     ADC_DIN = X_CONTROL[4];
						8|9:     ADC_DIN = X_CONTROL[3];
						10|11:   ADC_DIN = X_CONTROL[2];
						12|13:   ADC_DIN = X_CONTROL[1];
						14|15:   ADC_DIN = X_CONTROL[0];
				
						32|33:   ADC_DIN = Y_CONTROL[7];
						34|35:   ADC_DIN = Y_CONTROL[6]; 
						36|37:   ADC_DIN = Y_CONTROL[5];
						38|39:   ADC_DIN = Y_CONTROL[4];
						40|41:   ADC_DIN = Y_CONTROL[3];
						42|43: 	ADC_DIN = Y_CONTROL[2];
						44|45: 	ADC_DIN = Y_CONTROL[1];
						46|47: 	ADC_DIN = Y_CONTROL[0];
			
						default: ADC_DIN = 0;
					endcase
			end
	end
		
	assign oADC_DIN = ADC_DIN;
		
		
		//Generador ADC_DOUT
	always @(posedge iCLK) 
	begin
		
		if (!iRST_n) 
		begin
			X_COORDaux = 0;
			Y_COORDaux = 0;
			
		end 
		
		else
		
			if(trans_en && half_dclk)
			begin
			
			
				case (count_80)
					18|19:   X_COORDaux[11] = iADC_DOUT;
					20|21:   X_COORDaux[10] = iADC_DOUT;
					22|23:   X_COORDaux[9] = iADC_DOUT;
					24|25:   X_COORDaux[8] = iADC_DOUT;
					26|27:   X_COORDaux[7] = iADC_DOUT;
					28|29:   X_COORDaux[6] = iADC_DOUT;
					30|31:   X_COORDaux[5] = iADC_DOUT;
					32|33: 	X_COORDaux[4] = iADC_DOUT;
					34|35: 	X_COORDaux[3] = iADC_DOUT;
					36|37: 	X_COORDaux[2] = iADC_DOUT;
					38|39: 	X_COORDaux[1] = iADC_DOUT;
					40|41: 	X_COORDaux[0] = iADC_DOUT;
				
					50|51:   Y_COORDaux[11] = iADC_DOUT;
					52|53:   Y_COORDaux[10] = iADC_DOUT;
					54|55:   Y_COORDaux[9] = iADC_DOUT;
					56|57:   Y_COORDaux[8] = iADC_DOUT;
					58|59:   Y_COORDaux[7] = iADC_DOUT;
					60|61:   Y_COORDaux[6] = iADC_DOUT;
					62|63:   Y_COORDaux[5] = iADC_DOUT;
					64|65: 	Y_COORDaux[4] = iADC_DOUT;
					66|67: 	Y_COORDaux[3] = iADC_DOUT;
					68|69: 	Y_COORDaux[2] = iADC_DOUT;
					70|71: 	Y_COORDaux[1] = iADC_DOUT;
					72|73: 	Y_COORDaux[0] = iADC_DOUT;
			
				default:
					begin
					
						X_COORDaux = X_COORDaux;
						Y_COORDaux = Y_COORDaux;
					
					end
			endcase
			end
	end
		
		assign oX_COORD = X_COORDaux;
		assign oY_COORD = Y_COORDaux;

				
	
endmodule
