/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc (input logic clk, input logic test_clk);
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // ADD CODE TO DECLARE THE INTERFACE SIGNALS
  logic reset_n;
  logic          load_en;
  opcode_t       opcode;
  operand_t      operand_a, operand_b;
  address_t      write_pointer, read_pointer;
  instruction_t  instruction_word;

  modport TEST (
    input test_clk,
          load_en,
          reset_n,
          operand_a,
          operand_b,
          opcode,
          write_pointer,
          read_pointer,
    output instruction_word
  );
  modport DUT (
    output clk,
           load_en,
           reset_n,
           operand_a,
           operand_b,
           opcode,
           write_pointer,
           read_pointer,
    input  instruction_word
  );


endinterface: tb_ifc

