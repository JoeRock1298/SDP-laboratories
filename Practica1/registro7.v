module registro7 (iCLK, iRST_n, iENABLE, iSR, oPR, oSR);
	input iCLK, iRST_n, iENABLE, iSR;
	output reg [6:0] oPR;
	//output reg oSR; //option B
	output oSR;
	always @ (posedge iCLK)
		begin
			if ( !iRST_n )
					oPR <= 0;
					//oSR <= 0;							
			else if ( iENABLE )
				begin
				//oSR <= oPR[0];
				oPR[5:0] <= oPR[6:1];
				oPR[6] <= iSR;
				end
		end
	//comment this in case we need option B
	assign oSR = (iRST_n)?oPR[0]:0;
endmodule