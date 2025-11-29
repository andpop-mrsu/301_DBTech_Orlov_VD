-- 1. Добавление новых пользователей
INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES 
('Вадим Орлов', 'vadim.orlov@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Роман Пьянов', 'roman.pyanov@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Михаил Марьин', 'mikhail.marin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Михаил Родионов', 'mikhail.rodionov@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Лузин Максим', 'maxim.luzin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student'));


INSERT INTO movies (title, year)
VALUES 
('Дюна', 2021),
('Джокер', 2019),
('1917', 2019);


INSERT INTO movies_genres (movie_id, genre_id)
VALUES 
-- Дюна: Sci-Fi, Adventure, Drama
((SELECT id FROM movies WHERE title = 'Дюна'), 
 (SELECT id FROM genres WHERE name = 'Sci-Fi')),
((SELECT id FROM movies WHERE title = 'Дюна'), 
 (SELECT id FROM genres WHERE name = 'Adventure')),
((SELECT id FROM movies WHERE title = 'Дюна'), 
 (SELECT id FROM genres WHERE name = 'Drama')),

-- Джокер: Crime, Drama, Thriller
((SELECT id FROM movies WHERE title = 'Джокер'), 
 (SELECT id FROM genres WHERE name = 'Crime')),
((SELECT id FROM movies WHERE title = 'Джокер'), 
 (SELECT id FROM genres WHERE name = 'Drama')),
((SELECT id FROM movies WHERE title = 'Джокер'), 
 (SELECT id FROM genres WHERE name = 'Thriller')),

-- 1917: War, Drama, Thriller
((SELECT id FROM movies WHERE title = '1917'), 
 (SELECT id FROM genres WHERE name = 'War')),
((SELECT id FROM movies WHERE title = '1917'), 
 (SELECT id FROM genres WHERE name = 'Drama')),
((SELECT id FROM movies WHERE title = '1917'), 
 (SELECT id FROM genres WHERE name = 'Thriller'));

-- 4. Добавление отзывов от Вадима Орлова
INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = 'Дюна'), 5.0, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = 'Джокер'), 4.7, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = '1917'), 4.9, strftime('%s', 'now'));

-- 5. Добавление тегов
INSERT INTO tags (user_id, movie_id, tag, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = 'Дюна'), 'эпичная научная фантастика', strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = 'Джокер'), 'психологическая драма', strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'vadim.orlov@example.com'), 
 (SELECT id FROM movies WHERE title = '1917'), 'военная драма один кадр', strftime('%s', 'now'));

