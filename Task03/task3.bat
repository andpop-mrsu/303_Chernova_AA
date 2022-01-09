#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT distinct m.id, m.title, m.year, m.genres from movies m join ratings r on m.id = r.movie_id order by year, title limit 10;"
echo " "

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * from users where name like '%% A%%' order by register_date limit 5;"
echo " "


echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT users.name, movies.title, movies.year, rating, date(timestamp, 'unixepoch') as rating_date from ratings inner join users on users.id = user_id inner join movies on movies.id = movie_id order by users.name, movies.title, rating limit 50;"
echo " "

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.*, tags.tag from movies inner join tags on tags.movie_id = movies.id order by year, title, tag limit 40;"
echo " "


echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * from movies where year = (select max(year) from movies);"
echo " "

echo "6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, count(case m.title when m.title then 1 else null end) from movies m join  ratings r on m.id = r.movie_id join users u on r.user_id = u.id where year > 2005 and genres like '%%Drama%%' and gender == 'female' and r.rating >= 4.5 group by title order by year, title;"
echo " "


echo "7. Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году. Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT strftime('%Y', register_date) as year, count(strftime('%Y', register_date)) as count from users group by year"
sqlite3 movies_rating.db -box -echo "SELECT year, max(count) as max from (SELECT strftime('%Y', register_date) as year, count(strftime('%%Y', register_date)) as count from users group by year)"
sqlite3 movies_rating.db -box -echo "SELECT year, min(count) as min from (SELECT strftime('%Y', register_date) as year, count(strftime('%%Y', register_date)) as count from users group by year)"