# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_AXI_MEM_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_MEM_DATA_INTERLEAVING" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_MEM_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_MEM_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_MEM_LEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_REG_LEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_MEM_AR_FIFO_ADDR_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_MEM_AW_FIFO_ADDR_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_MEM_RDAT_FIFO_ADDR_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_MEM_WDAT_FIFO_ADDR_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_RX_FIFO_ADDR_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DPRAM_MACRO" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DPRAM_MACRO_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INIT_CLOCK_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INIT_DRIVE_STRENGTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH { PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH } {
	# Procedure called to update C_AXI_MEM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH { PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_MEM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING { PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING } {
	# Procedure called to update C_AXI_MEM_DATA_INTERLEAVING when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING { PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING } {
	# Procedure called to validate C_AXI_MEM_DATA_INTERLEAVING
	return true
}

proc update_PARAM_VALUE.C_AXI_MEM_DATA_WIDTH { PARAM_VALUE.C_AXI_MEM_DATA_WIDTH } {
	# Procedure called to update C_AXI_MEM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MEM_DATA_WIDTH { PARAM_VALUE.C_AXI_MEM_DATA_WIDTH } {
	# Procedure called to validate C_AXI_MEM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_MEM_ID_WIDTH { PARAM_VALUE.C_AXI_MEM_ID_WIDTH } {
	# Procedure called to update C_AXI_MEM_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MEM_ID_WIDTH { PARAM_VALUE.C_AXI_MEM_ID_WIDTH } {
	# Procedure called to validate C_AXI_MEM_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_MEM_LEN_WIDTH { PARAM_VALUE.C_AXI_MEM_LEN_WIDTH } {
	# Procedure called to update C_AXI_MEM_LEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MEM_LEN_WIDTH { PARAM_VALUE.C_AXI_MEM_LEN_WIDTH } {
	# Procedure called to validate C_AXI_MEM_LEN_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_ADDR_WIDTH { PARAM_VALUE.C_AXI_REG_ADDR_WIDTH } {
	# Procedure called to update C_AXI_REG_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_ADDR_WIDTH { PARAM_VALUE.C_AXI_REG_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_REG_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_BASEADDR { PARAM_VALUE.C_AXI_REG_BASEADDR } {
	# Procedure called to update C_AXI_REG_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_BASEADDR { PARAM_VALUE.C_AXI_REG_BASEADDR } {
	# Procedure called to validate C_AXI_REG_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_DATA_WIDTH { PARAM_VALUE.C_AXI_REG_DATA_WIDTH } {
	# Procedure called to update C_AXI_REG_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_DATA_WIDTH { PARAM_VALUE.C_AXI_REG_DATA_WIDTH } {
	# Procedure called to validate C_AXI_REG_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_HIGHADDR { PARAM_VALUE.C_AXI_REG_HIGHADDR } {
	# Procedure called to update C_AXI_REG_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_HIGHADDR { PARAM_VALUE.C_AXI_REG_HIGHADDR } {
	# Procedure called to validate C_AXI_REG_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_ID_WIDTH { PARAM_VALUE.C_AXI_REG_ID_WIDTH } {
	# Procedure called to update C_AXI_REG_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_ID_WIDTH { PARAM_VALUE.C_AXI_REG_ID_WIDTH } {
	# Procedure called to validate C_AXI_REG_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_REG_LEN_WIDTH { PARAM_VALUE.C_AXI_REG_LEN_WIDTH } {
	# Procedure called to update C_AXI_REG_LEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_REG_LEN_WIDTH { PARAM_VALUE.C_AXI_REG_LEN_WIDTH } {
	# Procedure called to validate C_AXI_REG_LEN_WIDTH
	return true
}

proc update_PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS } {
	# Procedure called to update C_MEM_AR_FIFO_ADDR_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS } {
	# Procedure called to validate C_MEM_AR_FIFO_ADDR_BITS
	return true
}

proc update_PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS } {
	# Procedure called to update C_MEM_AW_FIFO_ADDR_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS } {
	# Procedure called to validate C_MEM_AW_FIFO_ADDR_BITS
	return true
}

proc update_PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS } {
	# Procedure called to update C_MEM_RDAT_FIFO_ADDR_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS } {
	# Procedure called to validate C_MEM_RDAT_FIFO_ADDR_BITS
	return true
}

proc update_PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS } {
	# Procedure called to update C_MEM_WDAT_FIFO_ADDR_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS { PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS } {
	# Procedure called to validate C_MEM_WDAT_FIFO_ADDR_BITS
	return true
}

proc update_PARAM_VALUE.C_RX_FIFO_ADDR_BITS { PARAM_VALUE.C_RX_FIFO_ADDR_BITS } {
	# Procedure called to update C_RX_FIFO_ADDR_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_RX_FIFO_ADDR_BITS { PARAM_VALUE.C_RX_FIFO_ADDR_BITS } {
	# Procedure called to validate C_RX_FIFO_ADDR_BITS
	return true
}

proc update_PARAM_VALUE.DPRAM_MACRO { PARAM_VALUE.DPRAM_MACRO } {
	# Procedure called to update DPRAM_MACRO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DPRAM_MACRO { PARAM_VALUE.DPRAM_MACRO } {
	# Procedure called to validate DPRAM_MACRO
	return true
}

proc update_PARAM_VALUE.DPRAM_MACRO_TYPE { PARAM_VALUE.DPRAM_MACRO_TYPE } {
	# Procedure called to update DPRAM_MACRO_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DPRAM_MACRO_TYPE { PARAM_VALUE.DPRAM_MACRO_TYPE } {
	# Procedure called to validate DPRAM_MACRO_TYPE
	return true
}

proc update_PARAM_VALUE.INIT_CLOCK_HZ { PARAM_VALUE.INIT_CLOCK_HZ } {
	# Procedure called to update INIT_CLOCK_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INIT_CLOCK_HZ { PARAM_VALUE.INIT_CLOCK_HZ } {
	# Procedure called to validate INIT_CLOCK_HZ
	return true
}

proc update_PARAM_VALUE.INIT_DRIVE_STRENGTH { PARAM_VALUE.INIT_DRIVE_STRENGTH } {
	# Procedure called to update INIT_DRIVE_STRENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INIT_DRIVE_STRENGTH { PARAM_VALUE.INIT_DRIVE_STRENGTH } {
	# Procedure called to validate INIT_DRIVE_STRENGTH
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_MEM_ID_WIDTH { MODELPARAM_VALUE.C_AXI_MEM_ID_WIDTH PARAM_VALUE.C_AXI_MEM_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MEM_ID_WIDTH}] ${MODELPARAM_VALUE.C_AXI_MEM_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_MEM_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_MEM_ADDR_WIDTH PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MEM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_MEM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_MEM_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_MEM_DATA_WIDTH PARAM_VALUE.C_AXI_MEM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MEM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_MEM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_MEM_LEN_WIDTH { MODELPARAM_VALUE.C_AXI_MEM_LEN_WIDTH PARAM_VALUE.C_AXI_MEM_LEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MEM_LEN_WIDTH}] ${MODELPARAM_VALUE.C_AXI_MEM_LEN_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING { MODELPARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING}] ${MODELPARAM_VALUE.C_AXI_MEM_DATA_INTERLEAVING}
}

proc update_MODELPARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS { MODELPARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS}] ${MODELPARAM_VALUE.C_MEM_AW_FIFO_ADDR_BITS}
}

proc update_MODELPARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS { MODELPARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS}] ${MODELPARAM_VALUE.C_MEM_AR_FIFO_ADDR_BITS}
}

proc update_MODELPARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS { MODELPARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS}] ${MODELPARAM_VALUE.C_MEM_WDAT_FIFO_ADDR_BITS}
}

proc update_MODELPARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS { MODELPARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS}] ${MODELPARAM_VALUE.C_MEM_RDAT_FIFO_ADDR_BITS}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_ID_WIDTH { MODELPARAM_VALUE.C_AXI_REG_ID_WIDTH PARAM_VALUE.C_AXI_REG_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_ID_WIDTH}] ${MODELPARAM_VALUE.C_AXI_REG_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_REG_ADDR_WIDTH PARAM_VALUE.C_AXI_REG_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_REG_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_REG_DATA_WIDTH PARAM_VALUE.C_AXI_REG_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_REG_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_LEN_WIDTH { MODELPARAM_VALUE.C_AXI_REG_LEN_WIDTH PARAM_VALUE.C_AXI_REG_LEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_LEN_WIDTH}] ${MODELPARAM_VALUE.C_AXI_REG_LEN_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_BASEADDR { MODELPARAM_VALUE.C_AXI_REG_BASEADDR PARAM_VALUE.C_AXI_REG_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_BASEADDR}] ${MODELPARAM_VALUE.C_AXI_REG_BASEADDR}
}

proc update_MODELPARAM_VALUE.C_AXI_REG_HIGHADDR { MODELPARAM_VALUE.C_AXI_REG_HIGHADDR PARAM_VALUE.C_AXI_REG_HIGHADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_REG_HIGHADDR}] ${MODELPARAM_VALUE.C_AXI_REG_HIGHADDR}
}

proc update_MODELPARAM_VALUE.C_RX_FIFO_ADDR_BITS { MODELPARAM_VALUE.C_RX_FIFO_ADDR_BITS PARAM_VALUE.C_RX_FIFO_ADDR_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_RX_FIFO_ADDR_BITS}] ${MODELPARAM_VALUE.C_RX_FIFO_ADDR_BITS}
}

proc update_MODELPARAM_VALUE.DPRAM_MACRO { MODELPARAM_VALUE.DPRAM_MACRO PARAM_VALUE.DPRAM_MACRO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DPRAM_MACRO}] ${MODELPARAM_VALUE.DPRAM_MACRO}
}

proc update_MODELPARAM_VALUE.DPRAM_MACRO_TYPE { MODELPARAM_VALUE.DPRAM_MACRO_TYPE PARAM_VALUE.DPRAM_MACRO_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DPRAM_MACRO_TYPE}] ${MODELPARAM_VALUE.DPRAM_MACRO_TYPE}
}

proc update_MODELPARAM_VALUE.INIT_CLOCK_HZ { MODELPARAM_VALUE.INIT_CLOCK_HZ PARAM_VALUE.INIT_CLOCK_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INIT_CLOCK_HZ}] ${MODELPARAM_VALUE.INIT_CLOCK_HZ}
}

proc update_MODELPARAM_VALUE.INIT_DRIVE_STRENGTH { MODELPARAM_VALUE.INIT_DRIVE_STRENGTH PARAM_VALUE.INIT_DRIVE_STRENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INIT_DRIVE_STRENGTH}] ${MODELPARAM_VALUE.INIT_DRIVE_STRENGTH}
}

