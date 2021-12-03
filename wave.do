onerror {resume}
quietly set dataset_list [list sim vsim2 vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Regs -expand sim:/TOP_tb/mips/regfile/rf
add wave -noupdate {sim:/TOP_tb/mips/regfile/rf[2]}
add wave -noupdate -expand -group PC sim:/TOP_tb/mips/PC_F
add wave -noupdate -expand -group PC sim:/TOP_tb/mips/PC_D
add wave -noupdate -expand -group PC sim:/TOP_tb/mips/PC_E
add wave -noupdate -expand -group PC sim:/TOP_tb/mips/PC_M
add wave -noupdate -expand -group PC sim:/TOP_tb/mips/PC_out
add wave -noupdate -expand -group Predictor -label access sim:/TOP_tb/mips/branch_target_predictor_buffer/access
add wave -noupdate -expand -group Predictor -label {entry_addr (address to look for >>2)} sim:/TOP_tb/mips/branch_target_predictor_buffer/entry_addr
add wave -noupdate -expand -group Predictor -label found sim:/TOP_tb/mips/branch_target_predictor_buffer/found
add wave -noupdate -expand -group Predictor -label {entries[]} sim:/TOP_tb/mips/branch_target_predictor_buffer/entries
add wave -noupdate -expand -group Predictor -label update sim:/TOP_tb/mips/branch_target_predictor_buffer/update
add wave -noupdate -expand -group Predictor -label update_PC_from sim:/TOP_tb/mips/branch_target_predictor_buffer/branchUpdatePC
add wave -noupdate -expand -group Predictor -label update_PC_target sim:/TOP_tb/mips/branch_target_predictor_buffer/branchUpdateTarget
add wave -noupdate sim:/TOP_tb/mips/isBranchTakenD
add wave -noupdate sim:/TOP_tb/mips/RF_ReadData1_D
add wave -noupdate sim:/TOP_tb/mips/RF_ReadData2_D
add wave -noupdate sim:/TOP_tb/mips/AdependB
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/PC_E
add wave -noupdate -expand -group ForwardAD -label {ForwardAD = (RsD != 0) && ( ((RsD == WriteRegM) && RegWriteM && (RsD != RtD))   || ((RsD == WriteRegE) && RegWriteE) )} sim:/TOP_tb/mips/ForwardAD
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/RegWriteE
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/RtD
add wave -noupdate -expand -group ForwardAD -radix decimal sim:/TOP_tb/mips/RsD
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/RtE
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/RsE
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/RegWriteM
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/WriteRegE
add wave -noupdate -expand -group ForwardAD sim:/TOP_tb/mips/WriteRegM
add wave -noupdate sim:/TOP_tb/mips/ForwardBD
add wave -noupdate sim:/TOP_tb/mips/RF_ReadData1_D2
add wave -noupdate sim:/TOP_tb/mips/RF_ReadData2_D2
add wave -noupdate sim:/TOP_tb/mips/is_bneD
add wave -noupdate sim:/TOP_tb/mips/is_beqD
add wave -noupdate sim:/TOP_tb/mips/isBranchTakenE
add wave -noupdate sim:/TOP_tb/mips/is_bneE
add wave -noupdate sim:/TOP_tb/mips/is_beqE
add wave -noupdate -expand -group {branching PC at each stage} sim:/TOP_tb/mips/branching_addressF
add wave -noupdate -expand -group {branching PC at each stage} sim:/TOP_tb/mips/branching_addressD
add wave -noupdate -expand -group {branching PC at each stage} sim:/TOP_tb/mips/branching_addressE
add wave -noupdate -expand -group {branching PC at each stage} sim:/TOP_tb/mips/branching_addressM
add wave -noupdate sim:/TOP_tb/mips/FD_nEN
add wave -noupdate sim:/TOP_tb/mips/FD_CLR
add wave -noupdate sim:/TOP_tb/mips/DE_CLR
add wave -noupdate sim:/TOP_tb/mips/false_increment
add wave -noupdate sim:/TOP_tb/mips/false_predict
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/clk
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/In1
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/In2
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/ALUout
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALUoutM2
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/write_dataD2
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/Func
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/BB
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/S
add wave -noupdate -expand -group ALU2 sim:/TOP_tb/mips/ALU2/cout
add wave -noupdate sim:/TOP_tb/mips/PC_E
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/In1
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/In2
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/ALUout
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/Func
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/Out_selectW
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/MemtoReg_out
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALUoutM
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/write_dataD
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/BB
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/S
add wave -noupdate -expand -group ALU1 sim:/TOP_tb/mips/ALU/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
configure wave -valuecolwidth 88
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1029 ns} {1210 ns}
