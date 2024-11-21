DROP VIEW v_sessionsGroupedByDay;

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
		WHEN unixepoch(trackedHoursPerDay) > unixepoch(plannedHours) THEN STRFTIME('%H:%M:%S', unixepoch(trackedHoursPerDay) - unixepoch(plannedHours), 'unixepoch')
		WHEN unixepoch(trackedHoursPerDay) < unixepoch(plannedHours) THEN '-' || STRFTIME('%H:%M:%S', unixepoch(plannedHours) - unixepoch(trackedHoursPerDay), 'unixepoch')
		ELSE '00:00:00'
	END [DiffTime],
	(unixepoch(trackedHoursPerDay) - unixepoch(plannedHours)) [DiffSeconds]
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
	) sub2;


DROP VIEW v_sessionsGroupedByDay_Split;

CREATE VIEW v_sessionsGroupedByDay_Split AS
SELECT 
	date,
	dayOfWeek,
	sessions,
	trackedHoursTime,
	plannedHoursTime,
	CASE 
		WHEN DiffSeconds > 0 THEN DiffTime
		ELSE null
	END [DiffPositive],
	CASE 
		WHEN DiffSeconds <= 0 THEN DiffTime
		ELSE null
	END [DiffNegative]
FROM
	v_sessionsGroupedByDay;


DROP VIEW v_mainReport;

CREATE VIEW v_mainReport AS
SELECT
	'Today' [Intervall],
	
	SUBSTR('000' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(trackedHoursSeconds) % 60), -2) [tracked],
	
	SUBSTR('000' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(plannedHoursSeconds) % 60), -2) [planned],
	
	SUBSTR('000' || ((SUM(DiffSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(DiffSeconds) % 60), -2) [Diff]
	
FROM
	v_sessionsGroupedByDay
WHERE
	STRFTIME('%Y-%m-%d', date) = STRFTIME('%Y-%m-%d', date())

UNION ALL

SELECT
	'This Week' [Intervall],
	
	SUBSTR('000' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(trackedHoursSeconds) % 60), -2) [tracked],
	
	SUBSTR('000' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(plannedHoursSeconds) % 60), -2) [planned],
	
	SUBSTR('000' || ((SUM(DiffSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(DiffSeconds) % 60), -2) [Diff]
	
FROM
	v_sessionsGroupedByDay
WHERE
	STRFTIME('%Y-%W', date) = STRFTIME('%Y-%W', date())
	
UNION ALL

SELECT
	'This Month' [Intervall],
	
	SUBSTR('000' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(trackedHoursSeconds) % 60), -2) [tracked],
	
	SUBSTR('000' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(plannedHoursSeconds) % 60), -2) [planned],
	
	SUBSTR('000' || ((SUM(DiffSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(DiffSeconds) % 60), -2) [Diff]
	
FROM
	v_sessionsGroupedByDay
WHERE
	STRFTIME('%Y-%m', date) = STRFTIME('%Y-%m', date())
	
UNION ALL

SELECT
	'This Quarter' [Intervall],
	
	SUBSTR('000' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(trackedHoursSeconds) % 60), -2) [tracked],
	
	SUBSTR('000' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(plannedHoursSeconds) % 60), -2) [planned],
	
	SUBSTR('000' || ((SUM(DiffSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(DiffSeconds) % 60), -2) [Diff]
	
FROM
	v_sessionsGroupedByDay
WHERE
	STRFTIME('%Y', date) = STRFTIME('%Y', date())
	AND (STRFTIME('%m', date) / 3) + 1 = (STRFTIME('%m', date()) / 3) + 1
	
UNION ALL

SELECT
	'This Year' [Intervall],
	
	SUBSTR('000' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(trackedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(trackedHoursSeconds) % 60), -2) [tracked],
	
	SUBSTR('000' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(plannedHoursSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(plannedHoursSeconds) % 60), -2) [planned],
	
	SUBSTR('000' || ((SUM(DiffSeconds) % (60 * 60 * 24 * 31)) / (60 * 60 * 24)), -3)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60 * 24)) / (60 * 60)), -2)
	|| ':' ||
	SUBSTR('00' || ((SUM(DiffSeconds) % (60 * 60)) / 60), -2)
	|| ':' ||
	SUBSTR('00' || (SUM(DiffSeconds) % 60), -2) [Diff]
	
FROM
	v_sessionsGroupedByDay
WHERE
	STRFTIME('%Y', date) = STRFTIME('%Y', date())