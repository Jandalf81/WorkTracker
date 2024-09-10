INSERT INTO plannedHours (id, dayofWeek, plannedHours) VALUES
(1, 1, 8.0),
(2, 2, 8.0),
(3, 3, 8.0),
(4, 4, 8.0),
(5, 5, 5.0);

INSERT INTO sites (id, name) VALUES
(1, 'Büro'),
(2, 'Home Office');

INSERT INTO trackedHours (id, startedAt, stoppedAt, site, createdAt) VALUES
(1, 1725868383, 1725883498, 1, 1725883498), 
(2, 1725885377, 1725901356, 1, 1725901356),
(3, 1725955002, 1725969756, 1, 1725969756)