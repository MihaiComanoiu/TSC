/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter
 *
 * An error can be injected into the design by invoking compilation with
 * the option:  +define+FORCE_LOAD_ERROR
 *
 **********************************************************************/

module instr_register(tb_ifc.DUT i_tbifc);
import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
// (input  logic          clk,
//  input  logic          load_en,
//  input  logic          reset_n,
//  input  operand_t      operand_a,
//  input  operand_t      operand_b,
//  input  opcode_t       opcode,
//  input  address_t      write_pointer,
//  input  address_t      read_pointer,
//  output instruction_t  instruction_word
// );
  // timeunit 1ns/1ns;

  instruction_t  iw_reg [0:31];  // an array of instruction_word structures

  operand_r rezultat;

  // write to the register
  always@(posedge i_tbifc.clk, negedge i_tbifc.reset_n)   // write into register
    if (!i_tbifc.reset_n) begin
      foreach (iw_reg[i])
        iw_reg[i] = '{i_tbifc.opcode:ZERO,default:0};  // reset to all zeros
    end
    else if (i_tbifc.load_en) begin
      case(i_tbifc.opcode)
        PASSA: rezultat = i_tbifc.operand_a;
        PASSB: rezultat = i_tbifc.operand_b;
        ADD:   rezultat = i_tbifc.operand_a + i_tbifc.operand_b;
        SUB:   rezultat = i_tbifc.operand_a - i_tbifc.operand_b;
        MULT:  rezultat = i_tbifc.operand_a * i_tbifc.operand_b;
        DIV:   rezultat = i_tbifc.operand_a / i_tbifc.operand_b;
        MOD:   rezultat = i_tbifc.operand_a % i_tbifc.operand_b;
      endcase

      iw_reg[i_tbifc.write_pointer] = '{i_tbifc.opcode, i_tbifc.operand_a, i_tbifc.operand_b, rezultat};
    end

  // read from the register
  assign i_tbifc.instruction_word = iw_reg[i_tbifc.read_pointer];  // continuously read from register

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force i_tbifc.operand_b = i_tbifc.operand_a; // cause wrong value to be loaded into operand_b
end
`endif

endmodule: instr_register
