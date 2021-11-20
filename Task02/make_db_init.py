import csv 
import re

data_base = open('db_init.sql', 'w+')

tables = ['movies', 'ratings', 'tags', 'users']

for i in range(len(tables)):
    data_base.write(f'drop table if exists {tables[i]};\n')

data_base.write(
    'create table movies(\n'
    '\tid int primary key,\n'
    '\ttitle text,\n'
    '\tyear int,\n'
    '\tgenres text\n'
    ');\n'
    '\n')

data_base.write('insert into movies(id, title, year, genres) values\n')

movies_file = open('movies.csv', 'r')
all_movies = ""
reader = csv.DictReader(movies_file)
for film in reader:
    title = film['title'].replace('"', '""').replace("'", "''")
    year = (lambda res: res.group(0) if res is not None else 'null')(re.search(r'\d{4}', film['title']))
    all_movies += f"({film['movieId']}, '{title}', {year}, '{film['genres']}'),\n"
data_base.write(f'\n{all_movies[:-2]};\n\n')
movies_file.close()

data_base.write(
    'create table ratings(\n'
    '\tid int primary key,\n'
    '\tuser_id int,\n'
    '\tmovie_id int,\n'
    '\trating float,\n'
    '\ttimestamp int\n'
    ');\n'
    '\n')

data_base.write('insert into ratings(id, user_id, movie_id, rating, timestamp) values\n')

ratings_file = open('ratings.csv')
all_ratings = ""
reader = csv.DictReader(ratings_file)
id = 1
for rating_row in reader:
    timestamp = rating_row['timestamp']
    all_ratings += f"({id}, {rating_row['userId']}, {rating_row['movieId']}, {rating_row['rating']}, {rating_row['timestamp']}),\n"
    id += 1
data_base.write(f'\n{all_ratings[:-2]};\n\n')
ratings_file.close()

data_base.write(
    'create table tags(\n'
    '\tid int primary key,\n'
    '\tuser_id int,\n'
    '\tmovie_id int,\n'
    '\ttag text,\n'
    '\ttimestamp int\n'
    ');\n'
    '\n')

data_base.write('insert into tags(id, user_id, movie_id, tag, timestamp) values\n')
tags_file = open('tags.csv')
all_tags = ""
reader = csv.DictReader(tags_file)
id = 1
for tag_row in reader:
    tag = tag_row['tag'].replace('"', '""').replace("'", "''")
    all_tags += f"({id}, {tag_row['userId']}, {tag_row['movieId']}, '{tag}', {tag_row['timestamp']}),\n"
    id += 1
data_base.write(f'\n{all_tags[:-2]};\n\n')
tags_file.close()

data_base.write(
    'create table users(\n'
    '\tid int primary key,\n'
    '\tname text,\n'
    '\temail text,\n'
    '\tgender text,\n'
    '\tregister_date text,\n'
    '\toccupation text\n'
    ');\n'
    '\n')

data_base.write('insert into users(id, name, email, gender, register_date, occupation) values\n')
user_file = open('users.txt')
all_users = ""
for user in user_file.readlines():
    user = user.rstrip().replace('"', '""').replace("'", "''").split('|')
    all_users += f"({user[0]}, '{user[1]}', '{user[2]}', '{user[3]}', '{user[4]}', '{user[5]}'),\n"
data_base.write(f'\n{all_users[:-2]};')
user_file.close()

data_base.close()
