package computer

import (
	"strings"
)

type Computer struct {
	Id                int
	Board             string
	Cpu               string
	RamAmount         string
	Gpu               string
	DiskAmount        string
	DiskType          string
	OpticDisk         string
	Os                string
	MonitorResolution string
}

var computers []*Computer = []*Computer{}

var computer *Computer = &Computer{}

// var computerAux *Computer = &Computer{}
var computersAux []*Computer = []*Computer{}

func NewEmptyComputer() Computer {
	return Computer{
		Id:                0,
		Cpu:               "",
		RamAmount:         "",
		DiskAmount:        "",
		DiskType:          "",
		Board:             "",
		Gpu:               "",
		OpticDisk:         "",
		Os:                "",
		MonitorResolution: "",
	}
}

func (c Computer) SliceOfStrings() []string {
	var computersStrings []string
	computersStrings = append(computersStrings, ("Board: " + c.Board))
	computersStrings = append(computersStrings, ("CPU: " + c.Cpu))
	computersStrings = append(computersStrings, ("RAM: " + c.RamAmount))
	computersStrings = append(computersStrings, ("GPU: " + c.Gpu))
	computersStrings = append(computersStrings, ("Disk Amount: " + c.DiskAmount))
	computersStrings = append(computersStrings, ("Disk Type: " + c.DiskType))
	computersStrings = append(computersStrings, ("Optic Disk: " + c.OpticDisk))
	computersStrings = append(computersStrings, ("Operative System: " + c.Os))
	computersStrings = append(computersStrings, ("Monitor Resolution: " + c.MonitorResolution + " || "))

	return computersStrings
}

func (c Computer) ToString() string {
	return strings.Join(c.SliceOfStrings(), "\n")
}
