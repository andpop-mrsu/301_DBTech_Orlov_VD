PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS CarCategory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Employee (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE NOT NULL,
    dismissal_date DATE NULL,
    salary_percentage DECIMAL(5,2) NOT NULL DEFAULT 25.00,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (salary_percentage BETWEEN 0 AND 100),
    CHECK (dismissal_date IS NULL OR dismissal_date > hire_date)
);

CREATE TABLE IF NOT EXISTS Service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    base_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (duration_minutes > 0),
    CHECK (base_price >= 0)
);

CREATE TABLE IF NOT EXISTS ServicePrice (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    actual_price DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES Service(id) ON DELETE CASCADE,
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id) ON DELETE CASCADE,
    CHECK (actual_price >= 0),
    UNIQUE(service_id, car_category_id, effective_date)
);

CREATE TABLE IF NOT EXISTS EmployeeSpecialization (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Service(id) ON DELETE CASCADE,
    UNIQUE(employee_id, service_id)
);

CREATE TABLE IF NOT EXISTS Appointment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    client_name VARCHAR(100) NOT NULL,
    client_phone VARCHAR(20),
    car_model VARCHAR(100) NOT NULL,
    car_license_plate VARCHAR(20),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    scheduled_duration INTEGER NOT NULL,
    scheduled_price DECIMAL(10,2) NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id),
    FOREIGN KEY (service_id) REFERENCES Service(id),
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id),
    CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
    CHECK (scheduled_duration > 0),
    CHECK (scheduled_price >= 0)
);

CREATE TABLE IF NOT EXISTS WorkRecord (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    actual_duration INTEGER NOT NULL,
    actual_price DECIMAL(10,2) NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id),
    FOREIGN KEY (employee_id) REFERENCES Employee(id),
    FOREIGN KEY (service_id) REFERENCES Service(id),
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id),
    CHECK (actual_duration > 0),
    CHECK (actual_price >= 0),
    CHECK (end_time > start_time)
);

CREATE TABLE IF NOT EXISTS WorkSchedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    weekday VARCHAR(30) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    note TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    CHECK (end_time > start_time)
);

INSERT INTO CarCategory (name, description) VALUES
('Легковые', 'Легковые автомобили всех классов'),
('Внедорожники', 'Кроссоверы и внедорожники'),
('Коммерческие', 'Грузовики и коммерческий транспорт'),
('Мотоциклы', 'Мотоциклы и скутеры');

INSERT INTO Employee (first_name, last_name, phone, email, hire_date, salary_percentage) VALUES
('Александр', 'Волков', '+7-925-111-22-33', 'volkov@autoservice.ru', '2023-03-12', 31.00),
('Елена', 'Новикова', '+7-925-222-33-44', 'novikova@autoservice.ru', '2023-05-18', 29.00),
('Михаил', 'Лебедев', '+7-925-333-44-55', 'lebedev@autoservice.ru', '2023-07-25', 33.00),
('Ольга', 'Морозова', '+7-925-444-55-66', 'morozova@autoservice.ru', '2022-12-10', 27.00);

INSERT INTO Employee (first_name, last_name, phone, email, hire_date, dismissal_date, salary_percentage, is_active) VALUES
('Владимир', 'Соколов', '+7-925-555-66-77', 'sokolov@autoservice.ru', '2022-09-15', '2023-08-20', 26.00, 0);

INSERT INTO Service (name, description, duration_minutes, base_price) VALUES
('Замена масла', 'Полная замена моторного масла и фильтра', 45, 1650.00),
('Замена тормозных колодок', 'Замена передних или задних тормозных колодок', 90, 3200.00),
('Развал-схождение', 'Регулировка углов установки колес', 60, 2700.00),
('Диагностика двигателя', 'Компьютерная диагностика двигателя', 30, 1350.00),
('Замена свечей зажигания', 'Замена комплекта свечей зажигания', 40, 1950.00);

INSERT INTO ServicePrice (service_id, car_category_id, actual_price) VALUES
(1, 1, 1650.00), (1, 2, 1950.00), (1, 3, 2350.00), (1, 4, 850.00),
(2, 1, 3200.00), (2, 2, 3700.00), (2, 3, 4700.00), (2, 4, 1300.00),
(3, 1, 2700.00), (3, 2, 3000.00), (3, 3, 3400.00), (3, 4, 1600.00),
(4, 1, 1350.00), (4, 2, 1550.00), (4, 3, 1750.00), (4, 4, 950.00),
(5, 1, 1950.00), (5, 2, 2150.00), (5, 3, 2550.00), (5, 4, 1100.00);

INSERT INTO EmployeeSpecialization (employee_id, service_id) VALUES
(1, 1), (1, 2), (1, 5),
(2, 1), (2, 4), (2, 5),
(3, 2), (3, 3),
(4, 1), (4, 4), (4, 5),
(5, 1), (5, 2);

INSERT INTO Appointment (employee_id, service_id, car_category_id, client_name, client_phone, car_model, car_license_plate, appointment_date, appointment_time, scheduled_duration, scheduled_price) VALUES
(1, 1, 1, 'Дмитрий Романов', '+7-999-234-56-78', 'Volkswagen Passat', 'М234НП198', '2024-02-20', '10:00', 45, 1650.00),
(2, 4, 2, 'Татьяна Белова', '+7-999-345-67-89', 'Nissan X-Trail', 'К567ЛР199', '2024-02-20', '11:30', 30, 1550.00),
(3, 2, 1, 'Игорь Гришин', '+7-999-456-78-90', 'Hyundai Solaris', 'С890МТ200', '2024-02-21', '14:00', 90, 3200.00),
(4, 5, 1, 'Наталья Федорова', '+7-999-567-89-01', 'Skoda Octavia', 'Т123УХ201', '2024-02-22', '09:00', 40, 1950.00);

INSERT INTO WorkRecord (appointment_id, employee_id, service_id, car_category_id, actual_duration, actual_price, work_date, start_time, end_time, notes) VALUES
(1, 1, 1, 1, 42, 1650.00, '2024-02-20', '10:00', '10:42', 'Замена полусинтетического масла 10W-40'),
(2, 2, 4, 2, 38, 1550.00, '2024-02-20', '11:30', '12:08', 'Обнаружены незначительные отклонения, рекомендована повторная проверка'),
(3, 3, 2, 1, 88, 3200.00, '2024-02-21', '14:00', '15:28', 'Замена задних тормозных колодок и дисков');

CREATE INDEX IF NOT EXISTS idx_appointment_date ON Appointment(appointment_date, appointment_time);
CREATE INDEX IF NOT EXISTS idx_appointment_employee ON Appointment(employee_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_workrecord_date ON WorkRecord(work_date);
CREATE INDEX IF NOT EXISTS idx_workrecord_employee ON WorkRecord(employee_id, work_date);
CREATE INDEX IF NOT EXISTS idx_employee_active ON Employee(is_active);
CREATE INDEX IF NOT EXISTS idx_service_price ON ServicePrice(service_id, car_category_id);

