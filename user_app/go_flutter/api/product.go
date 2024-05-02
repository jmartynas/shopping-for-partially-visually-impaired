package api

import (
	"context"
	"errors"
	"main/database/naudotojai"
	"net/http"
	"strings"
)

type Product struct {
	Pavadinimas            string `json:"pavadinimas"`
	Kaina                  string `json:"kaina"`
	Kategorija             string `json:"kategorija"`
	Sudetis                string `json:"sudetis"`
	Maistingumas           string `json:"maistingumas"`
	PagaminimoData         string `json:"pagaminimo_data"`
	GaliojimoPabaigos_data string `json:"galiojimo_pabaigos_data"`
	Pavadinimas_2          string `json:"gamintojo_pavadinimas"`
	KilmesSalis            string `json:"kilmes_salis"`
}

func Information(w http.ResponseWriter, r *http.Request) error {
	if r.Method != http.MethodGet {
		return apiError{Err: "invalid method", Status: http.StatusMethodNotAllowed}
	}

	query := r.URL.Query()
	var args naudotojai.GetInformationParams
	args.Pavadinimas = strings.Split(query.Get("shop_name"), ".")[0]
	args.BruksninisKodas = query.Get("barcode")

	data, err := ServerInfo.dbConn.GetInformation(context.TODO(), args)
	if err != nil {
		return errors.New("Nėra šios prekės informacijos")
	}

	product := Product{
		Pavadinimas:            data.Pavadinimas,
		Kaina:                  data.Kaina,
		Kategorija:             data.Kategorija,
		Sudetis:                data.Sudetis,
		Maistingumas:           data.Maistingumas,
		PagaminimoData:         data.PagaminimoData,
		GaliojimoPabaigos_data: data.GaliojimoPabaigosData,
		Pavadinimas_2:          data.Pavadinimas_2.String,
		KilmesSalis:            data.KilmesSalis.String,
	}

	return writeJSON(
		w,
		http.StatusOK,
		product,
	)
}
