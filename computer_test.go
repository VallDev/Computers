package main

import (
	"Computers/computer"
	"testing"
)

func TestNewEmptyComputer(t *testing.T) {

	comp := computer.NewEmptyComputer()

	if comp.Board != "" || comp.Cpu != "" || comp.DiskAmount != "" || comp.DiskType != "" || comp.Gpu != "" ||
		comp.Id != 0 || comp.MonitorResolution != "" || comp.OpticDisk != "" || comp.Os != "" || comp.RamAmount != "" {

		t.Errorf("Expected new computer empty, but got: %v", comp)
	}
}

func TestSliceOfStrings(t *testing.T) {

	comp := computer.NewEmptyComputer()
	compSlice := comp.SliceOfStrings()

	if len(compSlice) != 9 {
		t.Errorf("Expected the slice of computers with length: 9, but got: %v", len(compSlice))
	}

	if compSlice[2] != "RAM: " {
		t.Errorf("Expected RAM in third position of slice, but got: %v", compSlice[2])
	}

	//7
	if compSlice[5] != "Operative System: " {
		t.Errorf("Expected Operative System  in 8 position of slice, but got: %v", compSlice[5])
	}
}

func TestToString(t *testing.T) {

	comp := computer.NewEmptyComputer()
	compString := comp.ToString()

	if compString == "" {
		t.Errorf("Expected a string with content, but got: %v ", compString)
	}
}
