
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
	assign oADC_DCLK = (iRST_n)?count_80[0]:0;
	
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
						(count_80 == 0 || count_80 == 1)? count_80:7'bx:     ADC_DIN = X_CONTROL[7];
						(count_80 == 2 || count_80 == 3)? count_80:7'bx:     ADC_DIN = X_CONTROL[6]; 
						(count_80 == 4 || count_80 == 5)? count_80:7'bx:     ADC_DIN = X_CONTROL[5];
						(count_80 == 6 || count_80 == 7)? count_80:7'bx:     ADC_DIN = X_CONTROL[4];
						(count_80 == 8 || count_80 == 9)? count_80:7'bx:     ADC_DIN = X_CONTROL[3];
						(count_80 == 10 || count_80 == 11)? count_80:7'bx:   ADC_DIN = X_CONTROL[2];
						(count_80 == 12 || count_80 == 13)? count_80:7'bx:   ADC_DIN = X_CONTROL[1];
						(count_80 == 14 || count_80 == 15)? count_80:7'bx:   ADC_DIN = X_CONTROL[0];
				
						(count_80 == 32 || count_80 == 33)? count_80:7'bx:   ADC_DIN = Y_CONTROL[7];
						(count_80 == 34 || count_80 == 35)? count_80:7'bx:   ADC_DIN = Y_CONTROL[6]; 
						(count_80 == 36 || count_80 == 37)? count_80:7'bx:   ADC_DIN = Y_CONTROL[5];
						(count_80 == 38 || count_80 == 39)? count_80:7'bx:   ADC_DIN = Y_CONTROL[4];
						(count_80 == 40 || count_80 == 41)? count_80:7'bx:   ADC_DIN = Y_CONTROL[3];
						(count_80 == 42 || count_80 == 43)? count_80:7'bx: 	ADC_DIN = Y_CONTROL[2];
						(count_80 == 44 || count_80 == 45)? count_80:7'bx: 	ADC_DIN = Y_CONTROL[1];
						(count_80 == 46 || count_80 == 47)? count_80:7'bx: 	ADC_DIN = Y_CONTROL[0];
			
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
