package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"main/api"
	"main/database/naudotojai"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	listenAddr := flag.String("listenaddr", ":8080", "api address")
	flag.Parse()

	username := os.Getenv("DBUSER")
	password := os.Getenv("DBPASS")
	dburl := os.Getenv("DBURL")
	dbtable := os.Getenv("DBTABLE")

	constr := fmt.Sprintf(
		"%s:%s@tcp(%s)/%s?allowNativePasswords=true&tls=true",
		username,
		password,
		dburl,
		dbtable,
	)

	db, err := sql.Open("mysql", constr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	queries := naudotojai.New(db)

	server := api.NewServer(*listenAddr, queries)
	log.Fatal(server.Start())
}
