#!/bin/bash

sqlite3 Task03/movies_rating.db < Task03/db_init.sql

echo "-- 1. TOP-10 фильмов с оценками (по дате и названию) --"
echo "Таблица: Фильм | Год | ID"
sqlite3 Task03/movies_rating.db -box -echo "SELECT m.title AS Film, m.year AS Year, m.id AS MovieID FROM movies m INNER JOIN ratings r ON r.movie_id = m.id GROUP BY m.id, m.title, m.year HAVING COUNT(r.id)>0 ORDER BY m.year ASC, m.title ASC LIMIT 10;"
echo " "

echo "-- 2. 5 пользователей, чьи фамилии начинаются на A (по дате регистрации) --"
echo "ФИО | Емейл | Дата регистрации | Пол | Должность"
sqlite3 Task03/movies_rating.db -box -echo "SELECT name AS User, email AS Email, register_date AS Registered, gender AS Sex, occupation AS Occupation FROM users WHERE name GLOB 'A*' ORDER BY register_date ASC LIMIT 5;"
echo " "

echo "-- 3. TOP-50 рейтингов (имя эксперта, фильм, год, оценка, дата оценки) --"
sqlite3 Task03/movies_rating.db -box -echo "SELECT u.name AS Expert, m.title AS Film, m.year AS Year, r.rating AS Rate, strftime('%Y-%m-%d', r.timestamp, 'unixepoch') AS Rated_On FROM ratings r, users u, movies m WHERE r.user_id = u.id AND r.movie_id = m.id ORDER BY u.name, m.title, r.rating LIMIT 50;"
echo " "

echo "-- 4. Список фильмов с тегами (TOP-40, с сортировкой) --"
sqlite3 Task03/movies_rating.db -box -echo "SELECT m.title AS Film, m.year, t.tag AS Tag, u.name AS WhoTagged FROM tags t LEFT JOIN movies m ON t.movie_id = m.id LEFT JOIN users u ON t.user_id = u.id ORDER BY m.year, m.title, t.tag LIMIT 40;"
echo " "

echo "-- 5. Самые свежие фильмы (макс. год выпуска, всё из этого года) --"
sqlite3 Task03/movies_rating.db -box -echo "SELECT m.title, m.year FROM movies m WHERE m.year = (SELECT year FROM movies ORDER BY year DESC LIMIT 1) ORDER BY m.title ASC;"
echo " "

echo "-- 6. Драмы после 2005, понравившиеся женщинам (>=4.5). Количество оценок, сортировка --"
sqlite3 Task03/movies_rating.db -box -echo "SELECT m.title, m.year, COUNT(*) AS NumHighRatings FROM movies m JOIN ratings r ON r.movie_id = m.id JOIN users u ON u.id = r.user_id WHERE m.genres LIKE '%Drama%' AND m.year > 2005 AND u.gender = 'female' AND r.rating >= 4.5 GROUP BY m.title, m.year ORDER BY m.year, m.title;"
echo " "

echo "-- 7. Количество регистраций по годам, и годы максимум/минимум --"
sqlite3 Task03/movies_rating.db -box -echo "SELECT SUBSTR(register_date,1,4) AS Yr, COUNT(id) AS RegCount FROM users GROUP BY Yr ORDER BY RegCount DESC;"
echo " "
echo "Max регистрации:"
sqlite3 Task03/movies_rating.db -box -echo "SELECT SUBSTR(register_date,1,4) AS YrMax, COUNT(id) AS RegCount FROM users GROUP BY YrMax ORDER BY RegCount DESC LIMIT 1;"
echo " "
echo "Min регистрации:"
sqlite3 Task03/movies_rating.db -box -echo "SELECT SUBSTR(register_date,1,4) AS YrMin, COUNT(id) AS RegCount FROM users GROUP BY YrMin ORDER BY RegCount ASC LIMIT 1;"
echo " "
