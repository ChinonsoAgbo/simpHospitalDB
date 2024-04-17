CREATE TABLE abteilung (
  id                    BIGINT PRIMARY KEY, 
  bezeichnung           VARCHAR(255) 
);

CREATE TABLE station (
  id                    BIGINT PRIMARY KEY, 
  bezeichnung           VARCHAR(255) NOT NULL, 
  bettenzahl            BIGINT ,
  id_abteilung          BIGINT NOT NULL,

  CONSTRAINT fk_station_abteilung
    FOREIGN KEY (id_abteilung)
    REFERENCES abteilung(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE pflegekraft (
  id                    BIGINT PRIMARY KEY, 
  vorname               VARCHAR(255) NOT NULL, 
  nachname              VARCHAR(255) NOT NULL, 
  geburtsdatum          DATE NOT NULL, 
  id_station            BIGINT NOT NULL, 
  id_pflegekraftmanager BIGINT,

  CONSTRAINT fk_pflegekraft_station 
    FOREIGN KEY (id_station) 
    REFERENCES station(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT fk_pflegekraft_manager  
    FOREIGN KEY (id_pflegekraftmanager) 
    REFERENCES pflegekraft(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
); 

CREATE TABLE arzt (
  id                    BIGINT PRIMARY KEY,
  vorname               VARCHAR(255) NOT NULL, 
  nachname              VARCHAR(255) NOT NULL, 
  geburtsdatum          DATE NOT NULL, 
  akadgrad              VARCHAR(255), 
  id_arztmanager        BIGINT, 
  id_station            BIGINT NOT NULL, 
  id_abteilung          BIGINT NOT NULL, 

  CONSTRAINT fk_arzt_manager  
    FOREIGN KEY (id_arztmanager) 
    REFERENCES arzt(id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE,

  CONSTRAINT fk_arzt_station 
    FOREIGN KEY (id_station) 
    REFERENCES station(id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE,

  CONSTRAINT fk_arzt_abteilung
    FOREIGN KEY (id_abteilung)
    REFERENCES abteilung(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
); 

CREATE TABLE patient (
  id                    BIGINT PRIMARY KEY,
  vorname               VARCHAR(255) NOT NULL, 
  nachname              VARCHAR(255) NOT NULL, 
  geburtsdatum          DATE NOT NULL, 
  krankenkasse          VARCHAR(255) , 
  versicherungsnummer    VARCHAR(255) 
);

CREATE TABLE aufenthalt (
  id                    BIGINT PRIMARY KEY, 
  aufnahmedatum         DATE NOT NULL, 
  entlassdatum          DATE, 
  id_patient            BIGINT NOT NULL, 
  id_station            BIGINT NOT NULL, 

  CONSTRAINT fk_aufenthalt_patient
    FOREIGN KEY (id_patient)
    REFERENCES patient(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_aufenthalt_station
    FOREIGN KEY (id_station)
    REFERENCES station(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE befund (
  id                      BIGINT PRIMARY KEY,
  datum                   DATE NOT NULL, 
  zusammenfassung         VARCHAR(255) NOT NULL,
  id_arzt                 BIGINT NOT NULL, 
  id_patient              BIGINT NOT NULL,

  CONSTRAINT fk_befund_arzt 
    FOREIGN KEY (id_arzt)
    REFERENCES arzt(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

  CONSTRAINT fk_befund_patient
    FOREIGN KEY (id_patient)
    REFERENCES patient(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE untersuchungsverfahren (
  id                     BIGINT PRIMARY KEY,
  bezeichnnung           VARCHAR(255) NOT NULL, 
  id_unterVerfahren      BIGINT , 
  
  CONSTRAINT fk_untersuchungsverfahren_untersuchungsverfahren
    FOREIGN KEY(id_unterVerfahren)
    REFERENCES untersuchungsverfahren(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE untersuchungsergebnis (
  id                      BIGINT PRIMARY KEY , 
  ergebniszusammenfassung VARCHAR(255), 
  anforderungsdatum       DATE NOT NULL, 
  ergebnisdatum           DATE ,
  id_befund               BIGINT NOT NULL,
  id_untersuchungsverfahren BIGINT NOT NULL,

  CONSTRAINT fk_untersuchungsergebnis_befund
    FOREIGN KEY (id_befund)
    REFERENCES befund(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_untersuchungsergebnis_untersuchungsverfahren
    FOREIGN KEY (id_untersuchungsverfahren)
    REFERENCES untersuchungsverfahren(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE diagnose (
  id           BIGINT PRIMARY KEY , 
  icdcode      VARCHAR(255) NOT NULL,
  diagnosetext VARCHAR(255) NOT NULL
);

CREATE TABLE diagnosebefund (
  id_diagnose  BIGINT, 
  id_befund    BIGINT, 

  PRIMARY KEY (id_diagnose, id_befund),
  
  CONSTRAINT fk_diagnosebefund_diagnose
    FOREIGN KEY(id_diagnose)
    REFERENCES diagnose(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_diagnosebefund_befund
    FOREIGN KEY(id_befund)
    REFERENCES befund(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE labortest (
  id                       BIGINT PRIMARY KEY, 
  probenart                VARCHAR(255) NOT NULL, 
  normwert                 VARCHAR(255) NOT NULL,  
  
  CONSTRAINT fk_labortest_untersuchungsverfahren 
    FOREIGN KEY (id)
    REFERENCES untersuchungsverfahren(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE AppUntersuchungsverfahren (
  id           BIGINT PRIMARY KEY, 

  CONSTRAINT fk_appUntersuchungsverfahren_untersuchungsverfahren
    FOREIGN KEY (id)
    REFERENCES untersuchungsverfahren(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE KlinUntersuchungsverfahren (
  id             BIGINT PRIMARY KEY , 
  koerperregion  VARCHAR(255) NOT NULL, 

  CONSTRAINT fk_klinUntersuchungsverfahren_untersuchungsverfahren
    FOREIGN KEY (id)
    REFERENCES untersuchungsverfahren(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
