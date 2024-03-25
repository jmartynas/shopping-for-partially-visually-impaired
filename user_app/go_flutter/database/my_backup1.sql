DROP TABLE IF EXISTS gamintojas;
CREATE TABLE gamintojas (
  id bigint NOT NULL AUTO_INCREMENT,
  pavadinimas varchar(255) NOT NULL,
  kilmes_salis varchar(255) NOT NULL,
  PRIMARY KEY (id)
);
DROP TABLE IF EXISTS parduotuve;
CREATE TABLE parduotuve (
  id bigint NOT NULL AUTO_INCREMENT,
  pavadinimas varchar(255) NOT NULL,
  nuotrauka varchar(255) NOT NULL,
  PRIMARY KEY (id)
);
DROP TABLE IF EXISTS produktas;
CREATE TABLE produktas (
  id bigint NOT NULL AUTO_INCREMENT,
  bruksninis_kodas varchar(255) NOT NULL,
  pavadinimas varchar(255) NOT NULL,
  kaina varchar(255) NOT NULL,
  kategorija varchar(255) NOT NULL,
  sudetis varchar(255) NOT NULL,
  maistingumas varchar(255) NOT NULL,
  pagaminimo_data date NOT NULL,
  galiojimo_pabaigos_data date NOT NULL,
  fk_parduotuve_id bigint NOT NULL,
  fk_gamintojas_id bigint NOT NULL,
  PRIMARY KEY (id),
  KEY fk_parduotuve_id (fk_parduotuve_id),
  KEY fk_gamintojas_id (fk_gamintojas_id),
  CONSTRAINT FOREIGN KEY (fk_parduotuve_id) REFERENCES parduotuve (id),
  CONSTRAINT FOREIGN KEY (fk_gamintojas_id) REFERENCES gamintojas (id)
);
