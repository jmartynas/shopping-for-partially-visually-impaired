package api

import (
	"main/database/naudotojai"
	"net/http"
)

type Server struct {
	listenAddr string
	dbConn     *naudotojai.Queries
}

var ServerInfo *Server

func NewServer(listenAddr string, dbConn *naudotojai.Queries) *Server {
	return &Server{
		listenAddr: listenAddr,
		dbConn:     dbConn,
	}
}

func (s *Server) Start() error {
	ServerInfo = s
	http.HandleFunc("/shop_list", MakeHTTPHandler(GetShops))
	http.HandleFunc("/get_image", MakeHTTPHandler(GetImage))
	return http.ListenAndServe(s.listenAddr, nil)
}
