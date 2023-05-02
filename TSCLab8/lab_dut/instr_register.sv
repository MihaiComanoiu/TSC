module instr_register
import instr_register_pkg::*;
(
//   input  logic         clk,
//  input  logic         load_en,
//  input  logic         reset_n,
//  input  operand_t     operand_a,
//  input  operand_t     operand_b,
//  input  opcode_t      opcode,
//  input  address_t     write_pointer,
//  input  address_t     read_pointer,
//  output instruction_t instruction_word
tb_ifc.DUT i_tb_ifc
);
  

  // timeunit 1ns/1ns;
  operand_res rezultat;
  instruction_t iw_reg[0:31];

  // Write to the register
  always @(posedge i_tb_ifc.clk, negedge i_tb_ifc.reset_n) 
    if (!i_tb_ifc.reset_n) begin
      foreach (iw_reg[i]) 
        iw_reg[i] <= '{opc:ZERO, op_a:0, op_b:0, rezultat:0};
    end
    else if (i_tb_ifc.load_en) begin
        case (i_tb_ifc.opcode)
          ZERO: rezultat<=0;
          ADD: rezultat <= i_tb_ifc.operand_a-i_tb_ifc.operand_b;  //am pus - in loc de +
          PASSA: rezultat <= i_tb_ifc.operand_a;
          PASSB:rezultat<= i_tb_ifc.operand_a;                     //am pus a in loc de b
          SUB: rezultat <= i_tb_ifc.operand_a-i_tb_ifc.operand_b;
          MULT: rezultat <= i_tb_ifc.operand_a*i_tb_ifc.operand_b;
          DIV: rezultat <= i_tb_ifc.operand_a/i_tb_ifc.operand_b;
          MOD: rezultat <= i_tb_ifc.operand_a%i_tb_ifc.operand_b;
          default: rezultat<=0;
        endcase

        iw_reg[i_tb_ifc.write_pointer] <= '{i_tb_ifc.opcode, i_tb_ifc.operand_a, i_tb_ifc.operand_b,rezultat};
        
      end



  // Read from the register
  assign i_tb_ifc.instruction_word = iw_reg[i_tb_ifc.read_pointer];

  // Inject a functional bug for verification
`ifdef FORCE_LOAD_ERROR
initial begin
  force operand_b = operand_a;
end
`endif

endmodule: instr_register
