-- Fill gaps in a sparse feed with the last known value per sensor (last observation carried forward).
-- IGNORE NULLS makes last_value skip the gaps; a sensor with no earlier reading stays NULL
-- instead of borrowing a value from another sensor.
SELECT
    sensor_id,
    reading_ts,
    temperature AS raw_temperature,
    last_value(temperature IGNORE NULLS) OVER (
        PARTITION BY sensor_id
        ORDER BY reading_ts
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS filled_temperature
FROM sensor_readings
ORDER BY sensor_id, reading_ts
