CREATE TABLE plannedHours (
    id INT PRIMARY KEY,
    dayOfWeek INT NOT NULL,
    plannedHours FLOAT NOT NULL
);

CREATE TABLE sites (
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE trackedHours (
    id INT PRIMARY KEY,
    startedAt INT NOT NULL,
    stoppedAt INT NOT NULL,
    site INT NOT NULL,
    createdAt INT NOT NULL,
    updatedAt INT,

    FOREIGN KEY(site) REFERENCES sites(id)
);


CREATE VIEW v_TrackedHours AS
SELECT
    strftime('%u', startedAt) [dayOfWeek],
    (stoppedAt - startedAt) [diff]
FROM
    trackedHoursy