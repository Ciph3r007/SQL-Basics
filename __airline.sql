USE airline;

SELECT flight_id, passenger_id, CONCAT(first_name, ' ', last_name) as full_name
FROM passengers JOIN tickets USING (passenger_id) JOIN routes USING (ticket_id) JOIN flights USING (flight_id)
WHERE flight_id = 1;