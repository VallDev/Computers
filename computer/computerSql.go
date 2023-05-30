package computer

import (
	"database/sql"
	"fmt"
	"log"
	"strconv"

	// I can use that important library to use the controller I need to get connected to database
	// _ deletes the error obtained by go for dont use that library
	"context"

	_ "github.com/go-sql-driver/mysql"
)

func CreateConnection() (*sql.DB, error) {
	connectionString := "root:sskeyBas1212.@tcp(192.168.0.10:3306)/my_computers"
	db, err := sql.Open("mysql", connectionString)
	if err != nil {
		panic(err)
	}

	db.SetMaxOpenConns(5)

	err = db.Ping()
	if err != nil {
		return nil, err
	}

	return db, nil

}

func GetComputerByIdSql(ctx context.Context, db *sql.DB, idc string) error {

	comp := NewEmptyComputer()

	idANum, err := strconv.Atoi(idc)
	if err != nil {
		panic(err)
	}

	query := `SELECT * FROM computer WHERE id = ?`

	row := db.QueryRowContext(ctx, query, idANum)

	var id int
	var board, cpu_type, ram_amount, gpu, disk_amount, disk_type, optic_disk, os, monitor_resolution string

	err = row.Scan(&id, &board, &cpu_type, &ram_amount, &gpu, &disk_amount, &disk_type, &optic_disk, &os, &monitor_resolution)
	if err != nil {
		return err
	}

	log.Println("ROW", id, cpu_type, ram_amount, gpu, disk_amount, disk_type, os, monitor_resolution)

	comp.Id = id
	comp.Board = board
	comp.Cpu = cpu_type
	comp.DiskAmount = disk_amount
	comp.DiskType = disk_type
	comp.Gpu = gpu
	comp.OpticDisk = optic_disk
	comp.Os = os
	comp.RamAmount = ram_amount
	comp.MonitorResolution = monitor_resolution

	computer = &comp

	return nil
}

func getAllComputers(ctx context.Context, db *sql.DB) error {

	computers = computersAux

	query := `SELECT * FROM computer`

	rows, err := db.QueryContext(ctx, query)
	if err != nil {
		return err
	}

	for rows.Next() {
		computerAA := NewEmptyComputer()

		err = rows.Scan(&computerAA.Id, &computerAA.Cpu, &computerAA.RamAmount, &computerAA.DiskAmount, &computerAA.DiskType, &computerAA.Board, &computerAA.Gpu, &computerAA.OpticDisk, &computerAA.Os, &computerAA.MonitorResolution)
		if err != nil {
			return err
		}

		log.Println(computerAA)
		computers = append(computers, &computerAA)

	}

	return nil

}

func addOneComputer(ctx context.Context, db *sql.DB) error {

	queryAdd := `INSERT INTO computer(board, cpu_type, ram_amount, gpu, disk_amount, disk_type, optic_disk, os, monitor_resolution)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := db.ExecContext(ctx, queryAdd, computer.Board, computer.Cpu, computer.DiskAmount, computer.DiskType, computer.Gpu, computer.MonitorResolution, computer.OpticDisk, computer.Os, computer.RamAmount)
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	fmt.Println("INSERT ID: ", id)

	return nil
}
