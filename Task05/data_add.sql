INSERT INTO users(name, surname, email, gender, register_date, occupation_id) VALUES
("Alexandra", "Chernova", "alexandra_chernova@mail.ru", "female", DATE("now"), (SELECT id FROM occupations WHERE occupations.title = "student"));

INSERT INTO users(name, surname, email, gender, register_date, occupation_id) VALUES
("Daniil", "Osipov", "daniil_osipov@mail.ru", "male", DATE("now"), (SELECT id FROM occupations WHERE occupations.title = "student"));

INSERT INTO users(name, surname, email, gender, register_date, occupation_id) VALUES
("Ilya", "Vidyaykin", "ilya_vidyaykin@mail.ru", "male", DATE("now"), (SELECT id FROM occupations WHERE occupations.title = "student"));

INSERT INTO users(name, surname, email, gender, register_date, occupation_id) VALUES
("Darya", "Gladysheva", "darya_gladysheva@mail.ru", "female", DATE("now"), (SELECT id FROM occupations WHERE occupations.title = "student"));

INSERT INTO users(name, surname, email, gender, register_date, occupation_id) VALUES
("Irina", "Guskova", "irina_guskova@mail.ru", "female", DATE("now"), (SELECT id FROM occupations WHERE occupations.title = "student"));

INSERT INTO movies(title, year) VALUES("Major Thunder", 2021);
INSERT INTO ratings(user_id, movie_id, rating, "timestamp") VALUES((SELECT id FROM users WHERE users.email = "alexandra_chernova@mail.ru"), (SELECT id FROM movies WHERE movies.title = "Major Thunder" and movies.year = 2021), 3.6, strftime('%s','now'));

INSERT INTO movies(title, year) VALUES("Dune", 2021);
INSERT INTO ratings(user_id, movie_id, rating, "timestamp") VALUES((SELECT id FROM users WHERE users.email = "alexandra_chernova@mail.ru"), (SELECT id FROM movies WHERE movies.title = "Dune" and movies.year = 2021), 4.5, strftime('%s','now'));

INSERT INTO movies(title, year) VALUES("Venom2", 2021);
INSERT INTO ratings(user_id, movie_id, rating, "timestamp") VALUES((SELECT id FROM users WHERE users.email = "alexandra_chernova@mail.ru"), (SELECT id FROM movies WHERE movies.title = "Venom2" and movies.year = 2021), 5, strftime('%s','now'));