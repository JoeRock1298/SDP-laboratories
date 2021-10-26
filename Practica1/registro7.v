module registro7 (iCLK, iRST_n, iENABLE, iSR, oPR, oSR);
	input iCLK, iRST_n, iENABLE, iSR;
	output [6:0] oPR;
	output oSR; 
	reg [6:0] out_pivot;
	always @ (posedge iCLK)
		begin
			if ( !iRST_n )
				begin
					out_pivot <= 0;
				end							
			else if ( iENABLE )
				begin
					out_pivot[5:0] <= out_pivot[6:1];
					out_pivot[6] <= iSR;
				end
		end
	assign oSR = out_pivot[0];
	assign oPR = out_pivot;
endmodule