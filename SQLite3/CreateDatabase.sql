CREATE TABLE plannedHours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dayOfWeek INT NOT NULL,
    plannedHours INT NOT NULL
);

CREATE TABLE sites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE workType (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE trackedHours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    startedAt TEXT NOT NULL,
    stoppedAt TEXT NOT NULL,
    site INT NOT NULL,
    workType INT NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT,

    FOREIGN KEY(site) REFERENCES sites(id)
);


CREATE VIEW v_TrackedHours AS
SELECT
    sub.date,
    CASE sub.dayOfWeek
        WHEN '1' THEN 'Mo'
        WHEN '2' THEN 'Di'
		WHEN '3' THEN 'Mi'
		WHEN '4' THEN 'Do'
		WHEN '5' THEN 'Fr'
		WHEN '6' THEN 'Sa'
		WHEN '0' THEN 'So'
    END [dayOfWeek],
	COUNT(*) [blocks],
	STRFTIME('%H:%M:%S', SUM(sub.diffSeconds), 'unixepoch') [trackedHoursPerDay],
	COALESCE(plannedHours.plannedHours, '0:00:00') [plannedHours]
FROM (
    SELECT
		STRFTIME('%Y-%m-%d', startedAt) [date],
		(STRFTIME('%w', startedAt)) [dayOfWeek],
		STRFTIME('%s', stoppedAt) - STRFTIME('%s', startedAt) [diffSeconds]
	FROM
		trackedHours
    ) sub
	LEFT OUTER JOIN plannedHours ON sub.dayOfWeek = plannedHours.dayOfWeek
GROUP BY
    sub.date,
    sub.dayOfWeek,
    plannedHours.plannedHours