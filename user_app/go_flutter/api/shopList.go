package api

import (
	"context"
	"main/database/naudotojai"
	"net/http"
)

type Shop struct {
	Pavadinimas string `json:"name"`
	Nuotrauka   string `json:"image"`
}

func GetShops(w http.ResponseWriter, r *http.Request) error {
	if r.Method != http.MethodGet {
		return apiError{Err: "invalid method", Status: http.StatusMethodNotAllowed}
	}

	data, err := ServerInfo.dbConn.GetShops(context.TODO())
	if err != nil {
		return err
	}

	shops := convertToJson(data)

	return writeJSON(
		w,
		http.StatusOK,
		shops,
	)
}

func convertToJson(data []naudotojai.Parduotuve) []Shop {
	var shops []Shop
	for i := 0; i < len(data); i++ {
		shops = append(shops, Shop{Pavadinimas: data[i].Pavadinimas, Nuotrauka: data[i].Nuotrauka})
	}
	return shops
}
