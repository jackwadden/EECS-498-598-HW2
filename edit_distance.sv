/*
 * 
 * A systolic array implementation to compute the Edit Distance string scoring metric
 *
 */
 
`include "constants.vh"

module edit_distance(input clk,
                     input rst,
                     input start,
                     input [`CHAR_WIDTH-1:0] query [`QUERY_LEN-1:0],
                     input [`CHAR_WIDTH-1:0] reference [`REF_MAX_LEN-1:0],
                     input [9:0] reference_length,
                     output logic [`DATA_WIDTH-1:0] result,
                     output logic done);

   
   // ADD YOUR CODE HERE
   

   // Also feel free to add create additional modules/files
   
endmodule
