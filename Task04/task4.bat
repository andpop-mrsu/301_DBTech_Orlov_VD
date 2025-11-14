#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм (без дубликатов, без пар с самим собой). Первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH pairs AS ( SELECT u1.name AS user1, u2.name AS user2, m.title AS movie FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON u1.id = r1.user_id JOIN users u2 ON u2.id = r2.user_id JOIN movies m ON m.id = r1.movie_id ) SELECT user1, user2, movie FROM pairs LIMIT 100;"
echo " "

echo "2. Найти 10 самых старых оценок от разных пользователей: фильм, пользователь, оценка, дата (ГГГГ-ММ-ДД)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH first_user_rating AS ( SELECT r.user_id, r.movie_id, r.rating, r.timestamp, ROW_NUMBER() OVER (PARTITION BY r.user_id ORDER BY r.timestamp ASC) AS rn FROM ratings r ) SELECT m.title AS movie, u.name AS user, fur.rating, DATE(fur.timestamp, 'unixepoch') AS review_date FROM first_user_rating fur JOIN users u ON u.id = fur.user_id JOIN movies m ON m.id = fur.movie_id WHERE fur.rn = 1 ORDER BY fur.timestamp ASC LIMIT 10;"
echo " "

echo "3. Все фильмы с максимальным и минимальным средним рейтингом; отсортировать по году и названию. В колонке \"Рекомендуем\" — Да/Нет."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH avg_r AS ( SELECT movie_id, AVG(rating) AS avg_rating FROM ratings GROUP BY movie_id ), ext AS ( SELECT (SELECT MAX(avg_rating) FROM avg_r) AS max_avg, (SELECT MIN(avg_rating) FROM avg_r) AS min_avg ) SELECT m.year, m.title, ROUND(a.avg_rating, 3) AS avg_rating, CASE WHEN a.avg_rating = (SELECT max_avg FROM ext) THEN 'Да' WHEN a.avg_rating = (SELECT min_avg FROM ext) THEN 'Нет' END AS 'Рекомендуем' FROM avg_r a JOIN movies m ON m.id = a.movie_id WHERE a.avg_rating IN ((SELECT max_avg FROM ext), (SELECT min_avg FROM ext)) ORDER BY m.year, m.title;"
echo " "

echo "4. Количество оценок и средняя оценка, которые дали мужчины за 2011–2014 годы."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) AS ratings_count, ROUND(AVG(r.rating), 3) AS avg_rating FROM ratings r JOIN users u ON u.id = r.user_id WHERE u.gender = 'male' AND DATE(r.timestamp, 'unixepoch') BETWEEN '2011-01-01' AND '2014-12-31';"
echo " "

echo "5. Список фильмов со средней оценкой и количеством пользователей, оценивших их. Отсортировать по году и названию. Первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.year, m.title, ROUND(AVG(r.rating), 3) AS avg_rating, COUNT(DISTINCT r.user_id) AS users_count FROM ratings r JOIN movies m ON m.id = r.movie_id GROUP BY m.id, m.year, m.title ORDER BY m.year, m.title LIMIT 20;"
echo " "

echo "6. Самый распространённый жанр фильма и количество фильмов в этом жанре (извлечь жанры из movies.genres)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split AS ( SELECT id AS movie_id, TRIM(SUBSTR(genres, 1, INSTR(genres || '|', '|') - 1)) AS genre, SUBSTR(genres || '|', INSTR(genres || '|', '|') + 1) AS rest FROM movies UNION ALL SELECT movie_id, TRIM(SUBSTR(rest, 1, INSTR(rest, '|') - 1)) AS genre, SUBSTR(rest, INSTR(rest, '|') + 1) AS rest FROM split WHERE rest <> '' ) SELECT genre, COUNT(DISTINCT movie_id) AS movies_count FROM split WHERE genre <> '' GROUP BY genre ORDER BY movies_count DESC, genre ASC LIMIT 1;"
echo " "

echo "7. 10 последних зарегистрированных пользователей в формате \"Фамилия Имя|Дата регистрации\"."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT TRIM(SUBSTR(u.name, INSTR(u.name, ' ') + 1)) || ' ' || SUBSTR(u.name, 1, INSTR(u.name, ' ') - 1) || '|' || u.register_date AS 'Фамилия Имя|Дата регистрации' FROM users u ORDER BY u.register_date DESC LIMIT 10;"
echo " "

echo "8. Рекурсивный CTE: дни недели, на которые приходился день рождения (10-31) по годам."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE years(y) AS ( SELECT 1990 UNION ALL SELECT y + 1 FROM years WHERE y < 2025 ), birthdays AS ( SELECT y AS year, DATE(y || '-10-31') AS d FROM years ) SELECT year, d AS date, CASE strftime('%w', d) WHEN '0' THEN 'Воскресенье' WHEN '1' THEN 'Понедельник' WHEN '2' THEN 'Вторник' WHEN '3' THEN 'Среда' WHEN '4' THEN 'Четверг' WHEN '5' THEN 'Пятница' WHEN '6' THEN 'Суббота' END AS weekday FROM birthdays ORDER BY year;"
echo " "
