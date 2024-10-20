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

CREATE TABLE session (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    startedAt TEXT NOT NULL,
    stoppedAt TEXT NOT NULL,
    site INT NOT NULL,
    workType INT NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NULL,

    FOREIGN KEY(site) REFERENCES sites(id),
    FOREIGN KEY(workType) REFERENCES workType(id)
);


CREATE VIEW v_sessionsGroupedByDay AS
SELECT 
	date,
	dayOfWeek,
	sessions,
	trackedHoursPerDay [trackedHoursTime],
	STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) [trackedHoursSeconds],
	plannedHours [plannedHoursTime],
	STRFTIME('%s', '1970-01-01 ' || plannedHours) [plannedHoursSeconds],
	CASE
		WHEN STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) > STRFTIME('%s', '1970-01-01 ' || plannedHours) THEN STRFTIME('%H:%M:%S', STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) - STRFTIME('%s', '1970-01-01 ' || plannedHours), 'unixepoch')
		WHEN STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) < STRFTIME('%s', '1970-01-01 ' || plannedHours) THEN "-" || STRFTIME('%H:%M:%S', STRFTIME('%s', '1970-01-01 ' || plannedHours) - STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay), 'unixepoch')
		ELSE '00:00:00'
	END [DiffTime],
	CASE
		WHEN STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) > STRFTIME('%s', '1970-01-01 ' || plannedHours) THEN STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) - STRFTIME('%s', '1970-01-01 ' || plannedHours)
		WHEN STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay) < STRFTIME('%s', '1970-01-01 ' || plannedHours) THEN "-" || STRFTIME('%s', '1970-01-01 ' || plannedHours) - STRFTIME('%s', '1970-01-01 ' || trackedHoursPerDay)
		ELSE '00:00:00'
	END [DiffSeconds]
FROM
	(
		SELECT
			sub1.date,
			CASE sub1.dayOfWeek
				WHEN '1' THEN 'Mo'
				WHEN '2' THEN 'Di'
				WHEN '3' THEN 'Mi'
				WHEN '4' THEN 'Do'
				WHEN '5' THEN 'Fr'
				WHEN '6' THEN 'Sa'
				WHEN '0' THEN 'So'
			END [dayOfWeek],
			COUNT(*) [sessions],
			STRFTIME('%H:%M:%S', SUM(sub1.diffSeconds), 'unixepoch') [trackedHoursPerDay],
			COALESCE(plannedHours.plannedHours, '00:00:00') [plannedHours]
		FROM (
			SELECT
				STRFTIME('%Y-%m-%d', startedAt) [date],
				(STRFTIME('%w', startedAt)) [dayOfWeek],
				STRFTIME('%s', stoppedAt) - STRFTIME('%s', startedAt) [diffSeconds]
			FROM
				session
			) sub1
			LEFT OUTER JOIN plannedHours ON sub1.dayOfWeek = plannedHours.dayOfWeek
		GROUP BY
			sub1.date,
			sub1.dayOfWeek,
			plannedHours.plannedHours
	) sub2