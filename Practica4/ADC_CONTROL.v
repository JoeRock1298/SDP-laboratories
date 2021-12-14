
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

	//contador del ADC_DCLK_CNT TC 
	contador #(.fin_cuenta(ADC_DCLK_CNT)) ADC_CNT1 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(dclk) );

	//contador del ADC_DCLK_CNT TC
	contador #(.fin_cuenta(ADC_DCLK_CNT/2)) ADC_CNT1_HALF (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(half_dclk) );

	//contador del ADC_DCLK_CNT TC
	contador #(.fin_cuenta(80)) ADC_CNT_80 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(dclk), .iUP_DOWN(1), .oCOUNT(count_80), .oTC(fin_80) );

	//Generador ADC_DCLK
	assign oADC_DCLK = count_80[0];

	//Generador ADC_DIN
	always @(posedge trans_en) begin
		
		if (!iRST_n) begin
			ADC_DIN = 0;
		end 
		
		else

			begin
			case (count_80)
				0|1:   ADC_DIN = X_CONTROL[7];
				2|3:   ADC_DIN = X_CONTROL[6]; 
				4|5:   ADC_DIN = X_CONTROL[5];
				6|7:   ADC_DIN = X_CONTROL[4];
				8|9:   ADC_DIN = X_CONTROL[3];
				10|11: ADC_DIN = X_CONTROL[2];
				12|13: ADC_DIN = X_CONTROL[1];
				14|15: ADC_DIN = X_CONTROL[0];
				
				32|33:   ADC_DIN = Y_CONTROL[7];
				34|35:   ADC_DIN = Y_CONTROL[6]; 
				36|37:   ADC_DIN = Y_CONTROL[5];
				38|39:   ADC_DIN = Y_CONTROL[4];
				40|41:   ADC_DIN = Y_CONTROL[3];
				42|43: ADC_DIN = Y_CONTROL[2];
				44|45: ADC_DIN = Y_CONTROL[1];
				46|47: ADC_DIN = Y_CONTROL[0];
			
				default: ADC_DIN = 0;
			endcase
		end

					
		
		


	end 

	
	
	
endmodule
