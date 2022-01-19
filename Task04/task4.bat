#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT u1.name AS Name_1, u2.name AS Name_2, u1.title FROM (SELECT users.name, movies.title FROM ratings INNER JOIN users ON ratings.user_id = users.id INNER JOIN movies ON ratings.movie_id = movies.id) AS u1 JOIN (SELECT users.name, movies.title FROM ratings INNER JOIN users ON ratings.user_id = users.id INNER JOIN movies ON ratings.movie_id = movies.id) AS u2 ON u1.title=u2.title WHERE u1.name<u2.name ORDER BY u1.title, u1.name, u2.name;
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.title, users.name, ratings.rating, DATE(ratings.timestamp, 'unixepoch') FROM (movies JOIN ratings ON movies.id=ratings.movie_id JOIN users ON users.id=ratings.user_id) GROUP BY users.name ORDER BY DATE(ratings.timestamp, 'unixepoch') DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT T.title, T.'year', CASE WHEN  T.max_r = T.avg_r THEN 'Да' ELSE 'Нет' END AS 'Рекомендуем' FROM (SELECT movies.title, movies.'year', AVG(ratings.rating) AS avg_r, MAX(AVG(ratings.rating)) OVER() AS max_r, MIN(AVG(ratings.rating)) OVER() AS min_r FROM (ratings JOIN movies ON ratings.movie_id = movies.id) GROUP BY ratings.movie_id) AS T WHERE avg_r = max_r OR avg_r = min_r ORDER BY T.'year', T.title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*), AVG(ratings.rating) FROM (users JOIN ratings ON users.id=ratings.user_id) WHERE (users.gender='female' AND DATE(ratings.timestamp, 'unixepoch')>='2010-01-01' AND DATE(ratings.timestamp, 'unixepoch')<'2012-01-01');"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.title, movies.'year', AVG(ratings.rating), RANK () over(ORDER BY AVG(ratings.rating) DESC) AS 'Place in the rating' FROM (movies JOIN ratings ON movies.id=ratings.movie_id) GROUP BY movies.id ORDER BY movies.'year', movies.title LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT SUBSTRING(users.name, INSTR(users.name, ' ')+1) ||' '|| SUBSTRING(users.name, 1, INSTR(users.name, ' ')-1) AS Name, users.register_date FROM users ORDER BY register_date DESC LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10. "
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE mult_table(res, kol) AS (SELECT '1x1=1', 1 UNION ALL SELECT CAST(kol / 10 + 1 AS TEXT) || 'x' || CAST(kol %% 10 + 1 AS TEXT) || '=' || CAST((kol / 10 + 1) * (kol %% 10 + 1) AS TEXT), kol + 1 FROM mult_table LIMIT 100) SELECT res FROM mult_table;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE kinds_of_genres(genres, str) AS (SELECT '', movies.genres || '|' FROM movies UNION ALL SELECT SUBSTRING(str, 0, INSTR(str, '|')), SUBSTRING(genres, INSTR(genres, '|') + 1) FROM kinds_of_genres WHERE str != '') SELECT genres FROM kinds_of_genres WHERE genres != '' GROUP BY genres;"