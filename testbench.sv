/*
 *
 * Starter Testbench for EECS 498/598 HW2
 * 
 * You can use this testbench to test your Edit-Distance systolic array
 * accelerator. Your design must at least pass these tests in order to
 * be considered for grading. Grading will use an expanded set of test 
 * cases that are secret.
 * 
 */

`include "constants.vh"

module testbench();


   /////////////////////////
   //  Global Decls
   /////////////////////////
   
   logic clk;
   logic rst;

   logic [`CHAR_WIDTH-1:0] query [`QUERY_LEN-1:0];
   logic [`CHAR_WIDTH-1:0] reference [`REF_MAX_LEN-1:0];       
   
   logic                   start;
   logic                   done = 0;
   logic [9:0]             reference_length; 
   logic [`DATA_WIDTH-1:0] result;    

   // instantiate accelerator
   edit_distance ed(.clk(clk),
                    .rst(rst),
                    .query(query),
                    .reference(reference),
                    .reference_length(reference_length),
                    .start(start),
                    .result(result),
                    .done(done));   
   

   /////////////////////////
   //  Helper Tasks
   /////////////////////////
   task run_test(string test_id,
                 input [`CHAR_WIDTH-1:0] test_query [`QUERY_LEN-1:0], 
                 input [`CHAR_WIDTH-1:0] test_reference [`REF_MAX_LEN-1:0],
                 input [9:0]             test_reference_len,
                 input [`DATA_WIDTH-1:0] expected_result);
      
      query = test_query;
      reference = test_reference;
      reference_length = test_reference_len;
      
      // reset edit distance accelerator
      rst = 1'b1;
      @(posedge clk)
        @(posedge clk)
          rst = 1'b0;
      
      // start the accelerator!
      start = 1'b1;

      
      // Call your own verification task here if you please
      /*
       software_edit_distance(.clk(clk),
       .rst(rst),
       .start(start),
       .query(query),
       .reference(reference),
       .reference_length(reference_length),
       .done(done),
       .result(result));
       */
      
      // wait for test to finish
      while(done == 1'b0) begin
         @(posedge clk);
      end
      
      // check to see if the score matches the expectation
      if(result == expected_result) begin
         $display("Test\t%d\t\tPASSED!", test_id);
      end else begin
         $display("Test\t%d\t\tFAILED! result = %d expected = %d", test_id, result, expected_result);
      end
      
   endtask
   
   
   always begin
      #5
        clk = ~clk;
   end
   

   initial begin

      
      
      // initialize constants
      start = 1'b0;
      
      // init control signals
      clk = 1'b0;
      rst = 1'b1;
      
      #10
         
        // reset for two clock cycles
        @(posedge clk)
          @(posedge clk)

            rst = 1'b0;
      start = 1'b1;
      
      @(posedge clk)
        @(posedge clk)
      
      
          $display("////////////////////////////////////////////////");
      $display("//          Running HW2 Testbench             //");
      $display("////////////////////////////////////////////////");
      run_test("Exact Match", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGTACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGTACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               101, 
               0);

      run_test("Substitution", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGTACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGAACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               101, 
               1);
      
      run_test("Insertion", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGTACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               "TTACATCTTGAAAATCTAGTCGTCTCTCTCAGTTCCAGGCGGTAAGCCGAGGTACGGATAAAACTTCTCGAACAATCCGCCGGAGCGACAGATAGCCTCTAA", 
               102, 
               1);
      
      run_test("Deletion", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               100, 
               1);

      run_test("2 Substitutions", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGGGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGACAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               101, 
               2);

      run_test("2 Insertions", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               "CTGGTCCAACTGTATTAAGATAAATTGAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTGCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               103, 
               2);

      run_test("2 Deletions", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               99, 
               2);
      
      run_test("1 Insertion 1 Deletion", 
               "CTGGTCCAACTGTATTAAGATAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCAGGAGTCTG", 
               "CTGGTCCAACTGTATTAAGATGAAATTAAGCGACGGGGCCGTCTCTGCTGAAGTCGCCCTGTGGTTGGTCAAGGTAGCTAACTTACGGTCGGCGGAGTCTG", 
               101, 
               2);

      run_test("1 Random Same Length ", 
               "GTTTAATTCGACAAACGGGACTTGTCACCTGTCCTCATAGCTTGCAAACTACTCTATTGGTACCGTCTTGGTCATGTGCTAAGGACCGGGCGCGTCTGGAT", 
               "GGCCGTGACAAGCTTCGACGTGCAGTTGCCTTTTTGAGCCACAATCCGGGCCTCTTGGACAAGCCGCTGTGTAACGCCGAGTAGCCCGTGTCGAGACAATC", 
               101, 
               53);

      run_test("2 Random Same Length ", 
               "TGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGC", 
               "TTAAACACTACCAGTACTGAGCGGATTGTAACGAGACAGGGAGCATTGCCAGAGACAGATCCCGGCTTCGAGCGATCTATCGTCTATTGCAATAGATAGAC", 
               101, 
               58); 
      
      run_test("1 Long Reference ", 
               "TGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGC", 
               "TGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGCTGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGC", 
               202, 
               101); 
      
      run_test("2 Long Reference ", 
               "TTAAACACTACCAGTACTGAGCGGATTGTAACGAGACAGGGAGCATTGCCAGAGACAGATCCCGGCTTCGAGCGATCTATCGTCTATTGCAATAGATAGAC", 
               "TGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGCTGATGATCCAGGGGGCTGCATAATTAACTCAGGCTCTTATTTTATAAGTGATAAGTGCTGGTATCCTAGATAGGCCTGGTCCCAATATCTCTTCGCGCAGC", 
               202, 
               121);              
      

      $finish;
      
   end

endmodule
