## Task02: ETL в SQLite (movies_rating.db)

### Требования
- **Python 3.8+**: `python3 --version`
- **SQLite 3**: `sqlite3 --version`
- macOS/Linux: после добавления файла в Git сделать `db_init.bat` исполняемым: `git update-index --chmod=+x Task02/db_init.bat`

### Что делает
- Генерирует `Task02/db_init.sql` со схемой и INSERT-запросами
- Создаёт/обновляет `Task02/movies_rating.db`, загружая SQL-скрипт

### Как запустить
1. Откройте терминал в корне репозитория
2. Выполните:
   ```bash
   ./Task02/db_init.bat
   ```

При первом запуске, если на Unix-подобных системах видите ошибку прав доступа, выполните:
```bash
git update-index --chmod=+x Task02/db_init.bat
```

### Создаваемые таблицы
- `movies(id, title, year, genres)`
- `ratings(id, user_id, movie_id, rating, timestamp)`
- `tags(id, user_id, movie_id, tag, timestamp)`
- `users(id, name, email, gender, register_date, occupation)`

Типы полей подобраны под исходные наборы данных. Если таблицы уже существуют, они удаляются и создаются заново.


