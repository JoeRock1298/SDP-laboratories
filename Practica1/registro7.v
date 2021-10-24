module registro7 (iCLK, iRST_n, iENABLE, iSR, oPR, oSR);
	input iCLK, iRST_n, iENABLE, iSR;
	output reg [6:0] oPR;
	output oSR;
	always @ (posedge iCLK)
		begin
			if ( !iRST_n )
					oPR <= 0;							
			else if ( iENABLE )
				begin
				oPR[5:0] <= oPR[6:1];
				oPR[6] <= iSR;
				end
		end
	assign oSR = (iRST_n)?oPR[0]:0;
endmodule