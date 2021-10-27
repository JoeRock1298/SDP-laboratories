module registro7 (iCLK, iRST_n, iENABLE, iSR, oPR, oSR);
	
	input iCLK, iRST_n, iENABLE, iSR;
	output wire [6:0] oPR;
	output wire oSR;
	reg [6:0] x;
	
	always @ (posedge iCLK)
		begin
			if ( !iRST_n )
				begin
					x <= 0;
				end							
			else if ( iENABLE )
				begin
					x[6] <= iSR;
					x[5:0] <= oPR[6:1]; 
				end
		end
		
		assign oPR[6:0] = x[6:0];
		assign oSR = x[0];
		
endmodule
