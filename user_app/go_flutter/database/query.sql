-- name: GetShops :many
SELECT * FROM parduotuve;

-- name: GetInformation :one
SELECT * FROM produktas
LEFT JOIN gamintojas ON produktas.fk_gamintojas_id=gamintojas.id
LEFT JOIN parduotuve ON produktas.fk_parduotuve_id=parduotuve.id
WHERE parduotuve.pavadinimas = ? AND
produktas.bruksninis_kodas = ?
LIMIT 1;
