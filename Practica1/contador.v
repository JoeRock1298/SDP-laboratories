module contador (iCLK, iRST_n, iENABLE, iUP_DOWN, oCOUNT, oTC);

	parameter fin_cuenta = 20;
	
	`include "MathFun.vh"
	parameter n = CLogB2(fin_cuenta-1);
	
	input iCLK, iRST_n, iENABLE, iUP_DOWN;
	output reg [n-1:0] oCOUNT;
	output oTC;
	
	always @ (posedge iCLK)
		begin
		
			if ( !iRST_n )
				begin
					oCOUNT <= 0;							
				end
				
			
			else if ( iENABLE )

				if(iUP_DOWN)
				
					if ( oCOUNT == fin_cuenta-1)
						begin
							oCOUNT <= 0;				 
						end

					else
						begin
						oCOUNT <= oCOUNT + 1;			
						end
				else
				
					if ( oCOUNT == 0)
						begin
							oCOUNT <= fin_cuenta-1;								
						end

					else
						begin
						oCOUNT <= oCOUNT - 1;
						end
					
			else
				oCOUNT<=oCOUNT;

		end
		
		assign oTC =(oCOUNT == fin_cuenta-1)?1'b1:1'b0;
	
endmodule

