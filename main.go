package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"time"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func main() {
	date, err := time.Parse(time.RFC3339Nano, "2022-02-17T17:00:00Z")
	if err != nil {
		panic(err)
	}
	fmt.Println("genesis time", date)

	csv_file, _ := os.Open("double-double-1/accounts/accounts.csv")
	r := csv.NewReader(csv_file)
	denom := "ustars"
	total := sdk.NewCoin(denom, sdk.ZeroInt())

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		amount, ok := sdk.NewIntFromString(record[1])
		if !ok {
			panic(fmt.Sprintf("invalid amount %s", record[1]))
		}
		address := record[0]
		total = total.Add(sdk.NewCoin(denom, amount))
		cmd := exec.Command("starsd",
			"add-genesis-account", address, sdk.NewCoin(denom, amount).String(),
			"--home", "tmp/stargaze",
		)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err = cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
	}

	fmt.Println("--Supply--")

	fmt.Println("total", total.Amount.Quo(sdk.NewInt(1_000_000)).String())

}
