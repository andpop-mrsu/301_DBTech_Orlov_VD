PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- Удаление таблиц, если они существуют (в обратном порядке зависимостей)
DROP TABLE IF EXISTS completed_works;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS work_schedules;
DROP TABLE IF EXISTS master_services;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS car_categories;

-- Таблица категорий автомобилей
CREATE TABLE car_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- Таблица мастеров (работников)
CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    hire_date DATE NOT NULL DEFAULT (date('now')),
    dismissal_date DATE,
    revenue_percent REAL NOT NULL DEFAULT 0.0 CHECK (revenue_percent >= 0 AND revenue_percent <= 100),
    is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    CHECK (dismissal_date IS NULL OR dismissal_date >= hire_date)
);

-- Таблица услуг
CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    price REAL NOT NULL CHECK (price >= 0),
    car_category_id INTEGER NOT NULL,
    FOREIGN KEY (car_category_id) REFERENCES car_categories(id) ON DELETE RESTRICT
);

-- Таблица специализаций мастеров (многие ко многим)
CREATE TABLE master_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    UNIQUE(employee_id, service_id)
);

-- Таблица графика работы мастеров
CREATE TABLE work_schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    CHECK (end_time > start_time)
);

-- Таблица записей на работы
CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    client_name TEXT NOT NULL,
    client_phone TEXT,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

-- Таблица выполненных работ
CREATE TABLE completed_works (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    completion_datetime DATETIME NOT NULL DEFAULT (datetime('now')),
    actual_price REAL NOT NULL CHECK (actual_price >= 0),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

-- Вставка тестовых данных

-- Категории автомобилей
INSERT INTO car_categories (id, name, description) VALUES (1, 'Легковой', 'Легковые автомобили');
INSERT INTO car_categories (id, name, description) VALUES (2, 'Грузовой', 'Грузовые автомобили');
INSERT INTO car_categories (id, name, description) VALUES (3, 'Мотоцикл', 'Мотоциклы и скутеры');
INSERT INTO car_categories (id, name, description) VALUES (4, 'Внедорожник', 'Внедорожники и кроссоверы');

-- Мастера
INSERT INTO employees (id, first_name, last_name, phone, hire_date, dismissal_date, revenue_percent, is_active) VALUES 
(1, 'Иван', 'Петров', '+7-900-123-45-67', '2020-01-15', NULL, 25.0, 1);
INSERT INTO employees (id, first_name, last_name, phone, hire_date, dismissal_date, revenue_percent, is_active) VALUES 
(2, 'Сергей', 'Сидоров', '+7-900-234-56-78', '2019-03-20', NULL, 30.0, 1);
INSERT INTO employees (id, first_name, last_name, phone, hire_date, dismissal_date, revenue_percent, is_active) VALUES 
(3, 'Алексей', 'Козлов', '+7-900-345-67-89', '2021-06-10', '2023-12-31', 28.0, 0);
INSERT INTO employees (id, first_name, last_name, phone, hire_date, dismissal_date, revenue_percent, is_active) VALUES 
(4, 'Дмитрий', 'Иванов', '+7-900-456-78-90', '2022-02-01', NULL, 27.5, 1);
INSERT INTO employees (id, first_name, last_name, phone, hire_date, dismissal_date, revenue_percent, is_active) VALUES 
(5, 'Михаил', 'Смирнов', '+7-900-567-89-01', '2020-11-05', NULL, 26.0, 1);

-- Услуги
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(1, 'Замена масла', 30, 1500.0, 1);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(2, 'Замена масла', 45, 2000.0, 2);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(3, 'Замена масла', 20, 800.0, 3);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(4, 'Замена масла', 35, 1800.0, 4);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(5, 'Замена тормозных колодок', 60, 3000.0, 1);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(6, 'Замена тормозных колодок', 90, 4500.0, 2);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(7, 'Замена тормозных колодок', 45, 2000.0, 3);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(8, 'Замена тормозных колодок', 75, 3500.0, 4);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(9, 'Диагностика двигателя', 90, 2500.0, 1);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(10, 'Диагностика двигателя', 120, 3500.0, 2);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(11, 'Диагностика двигателя', 60, 1500.0, 3);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(12, 'Диагностика двигателя', 100, 3000.0, 4);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(13, 'Шиномонтаж', 40, 2000.0, 1);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(14, 'Шиномонтаж', 60, 3000.0, 2);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(15, 'Шиномонтаж', 30, 1200.0, 3);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(16, 'Шиномонтаж', 50, 2500.0, 4);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(17, 'Ремонт подвески', 120, 5000.0, 1);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(18, 'Ремонт подвески', 180, 8000.0, 2);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(19, 'Ремонт подвески', 90, 3500.0, 3);
INSERT INTO services (id, name, duration_minutes, price, car_category_id) VALUES 
(20, 'Ремонт подвески', 150, 6000.0, 4);

-- Специализации мастеров
INSERT INTO master_services (employee_id, service_id) VALUES (1, 1);  -- Иван - замена масла легковой
INSERT INTO master_services (employee_id, service_id) VALUES (1, 5);  -- Иван - замена тормозных колодок легковой
INSERT INTO master_services (employee_id, service_id) VALUES (1, 9);   -- Иван - диагностика легковой
INSERT INTO master_services (employee_id, service_id) VALUES (1, 13); -- Иван - шиномонтаж легковой
INSERT INTO master_services (employee_id, service_id) VALUES (1, 17); -- Иван - ремонт подвески легковой

INSERT INTO master_services (employee_id, service_id) VALUES (2, 2);  -- Сергей - замена масла грузовой
INSERT INTO master_services (employee_id, service_id) VALUES (2, 6);  -- Сергей - замена тормозных колодок грузовой
INSERT INTO master_services (employee_id, service_id) VALUES (2, 10); -- Сергей - диагностика грузовой
INSERT INTO master_services (employee_id, service_id) VALUES (2, 14); -- Сергей - шиномонтаж грузовой
INSERT INTO master_services (employee_id, service_id) VALUES (2, 18); -- Сергей - ремонт подвески грузовой

INSERT INTO master_services (employee_id, service_id) VALUES (3, 3);  -- Алексей - замена масла мотоцикл
INSERT INTO master_services (employee_id, service_id) VALUES (3, 7);  -- Алексей - замена тормозных колодок мотоцикл
INSERT INTO master_services (employee_id, service_id) VALUES (3, 11); -- Алексей - диагностика мотоцикл
INSERT INTO master_services (employee_id, service_id) VALUES (3, 15); -- Алексей - шиномонтаж мотоцикл

INSERT INTO master_services (employee_id, service_id) VALUES (4, 4);  -- Дмитрий - замена масла внедорожник
INSERT INTO master_services (employee_id, service_id) VALUES (4, 8);  -- Дмитрий - замена тормозных колодок внедорожник
INSERT INTO master_services (employee_id, service_id) VALUES (4, 12); -- Дмитрий - диагностика внедорожник
INSERT INTO master_services (employee_id, service_id) VALUES (4, 16); -- Дмитрий - шиномонтаж внедорожник
INSERT INTO master_services (employee_id, service_id) VALUES (4, 20); -- Дмитрий - ремонт подвески внедорожник

INSERT INTO master_services (employee_id, service_id) VALUES (5, 1);  -- Михаил - замена масла легковой
INSERT INTO master_services (employee_id, service_id) VALUES (5, 5);  -- Михаил - замена тормозных колодок легковой
INSERT INTO master_services (employee_id, service_id) VALUES (5, 13); -- Михаил - шиномонтаж легковой
INSERT INTO master_services (employee_id, service_id) VALUES (5, 4);  -- Михаил - замена масла внедорожник
INSERT INTO master_services (employee_id, service_id) VALUES (5, 16); -- Михаил - шиномонтаж внедорожник

-- График работы мастеров (0=Понедельник, 6=Воскресенье)
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(1, 0, '09:00', '18:00');  -- Иван - Понедельник
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(1, 1, '09:00', '18:00');  -- Иван - Вторник
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(1, 2, '09:00', '18:00');  -- Иван - Среда
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(1, 3, '09:00', '18:00');  -- Иван - Четверг
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(1, 4, '09:00', '18:00');  -- Иван - Пятница

INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(2, 1, '10:00', '19:00');  -- Сергей - Вторник
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(2, 2, '10:00', '19:00');  -- Сергей - Среда
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(2, 3, '10:00', '19:00');  -- Сергей - Четверг
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(2, 4, '10:00', '19:00');  -- Сергей - Пятница
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(2, 5, '10:00', '19:00');  -- Сергей - Суббота

INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(4, 0, '08:00', '17:00');  -- Дмитрий - Понедельник
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(4, 1, '08:00', '17:00');  -- Дмитрий - Вторник
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(4, 2, '08:00', '17:00');  -- Дмитрий - Среда
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(4, 3, '08:00', '17:00');  -- Дмитрий - Четверг
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(4, 4, '08:00', '17:00');  -- Дмитрий - Пятница

INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(5, 2, '11:00', '20:00');  -- Михаил - Среда
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(5, 3, '11:00', '20:00');  -- Михаил - Четверг
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(5, 4, '11:00', '20:00');  -- Михаил - Пятница
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(5, 5, '11:00', '20:00');  -- Михаил - Суббота
INSERT INTO work_schedules (employee_id, day_of_week, start_time, end_time) VALUES 
(5, 6, '11:00', '20:00');  -- Михаил - Воскресенье

-- Записи на работы
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(1, 1, 1, '2024-01-15 10:00', 'completed', 'Петр Сидоров', '+7-900-111-22-33');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(2, 1, 5, '2024-01-15 14:00', 'completed', 'Мария Иванова', '+7-900-222-33-44');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(3, 2, 2, '2024-01-16 11:00', 'completed', 'Александр Петров', '+7-900-333-44-55');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(4, 4, 4, '2024-01-17 09:00', 'completed', 'Елена Козлова', '+7-900-444-55-66');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(5, 5, 1, '2024-01-18 12:00', 'scheduled', 'Дмитрий Смирнов', '+7-900-555-66-77');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(6, 1, 13, '2024-01-19 10:00', 'scheduled', 'Ольга Новикова', '+7-900-666-77-88');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(7, 2, 10, '2024-01-20 13:00', 'scheduled', 'Игорь Волков', '+7-900-777-88-99');
INSERT INTO appointments (id, employee_id, service_id, appointment_datetime, status, client_name, client_phone) VALUES 
(8, 4, 8, '2024-01-16 15:00', 'cancelled', 'Анна Белова', '+7-900-888-99-00');

-- Выполненные работы
INSERT INTO completed_works (appointment_id, employee_id, service_id, completion_datetime, actual_price) VALUES 
(1, 1, 1, '2024-01-15 10:30', 1500.0);
INSERT INTO completed_works (appointment_id, employee_id, service_id, completion_datetime, actual_price) VALUES 
(2, 1, 5, '2024-01-15 15:00', 3000.0);
INSERT INTO completed_works (appointment_id, employee_id, service_id, completion_datetime, actual_price) VALUES 
(3, 2, 2, '2024-01-16 11:45', 2000.0);
INSERT INTO completed_works (appointment_id, employee_id, service_id, completion_datetime, actual_price) VALUES 
(4, 4, 4, '2024-01-17 09:35', 1800.0);
-- Работа без записи (выполнена напрямую)
INSERT INTO completed_works (appointment_id, employee_id, service_id, completion_datetime, actual_price) VALUES 
(NULL, 5, 13, '2024-01-18 11:40', 2000.0);

COMMIT;

