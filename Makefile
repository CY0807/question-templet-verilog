.DEFAULT_GOAL := wave
USE_TOOLS := 1
TOOLS_IS_BASIC := 1
DIRS := $(shell find ./utils -maxdepth 3 -type d)
INC := ./ $(foreach dir,$(DIRS),$(wildcard $(dir)/*.v)) Top.v tb_Top.v
INC_BASIC := ./ Top.v tb_Top.v ./utils/fifo_sync/Fifo_Sync.v ./utils/ram_simple/Ram.v

OUT = ./gen/wave

build:
	mkdir -p gen
ifeq ($(USE_TOOLS),1)
    ifeq ($(TOOLS_IS_BASIC),1)
	iverilog -o $(OUT) -y $(INC_BASIC)
    else
	iverilog -o $(OUT) -y $(INC)
    endif
else
	iverilog -o $(OUT) -y ./ Top.v tb_Top.v
endif
	vvp -n $(OUT) -lxt2
	mv wave.vcd ./gen/wave.vcd

wave: build
	gtkwave ./gen/wave.vcd

.PHONY : clean build wave

clean:
	-rm -r ./gen/ 2>/dev/null
