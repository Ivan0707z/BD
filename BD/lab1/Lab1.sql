CREATE DATABASE users;
-- Створення таблиці користувачів
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- Створення таблиці листів
CREATE TABLE emails (
    email_id SERIAL PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    amount INT NOT NULL, 
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users (user_id),
    FOREIGN KEY (receiver_id) REFERENCES users (user_id)
);

-- Створення таблиці поштової скриньки для зберігання листів, що отримані кожним користувачем
CREATE TABLE mailbox (
    mailbox_id SERIAL PRIMARY KEY,
    email_id INT NOT NULL,
    id_folder INT NOT NULL,
    is_archived BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (email_id) REFERENCES emails (email_id),
    FOREIGN KEY (id_folder) REFERENCES folder_directory (id_folder)
);
-- Створення таблиці довідника для папок
CREATE TABLE folder_directory (
    id_folder SERIAL PRIMARY KEY,
    folder_name VARCHAR(50) UNIQUE NOT NULL
);

-- Додавання даних до таблиці довідника для папок
INSERT INTO folder_directory (folder_name) VALUES
    ('inbox'),
    ('sent'),
    ('drafts'),
    ('trash');
-- Додавання даних користувачів
INSERT INTO users (username, email, password) VALUES
    ('user1', 'user1@example.com', 'password1'),
    ('user2', 'user2@example.com', 'password2'),
    ('user3', 'user3@example.com', 'password3'),
    ('user4', 'user4@example.com', 'password4'), 
    ('user5', 'user5@example.com', 'password5');

-- Додавання даних листів
INSERT INTO emails (subject, message, sender_id, receiver_id, amount) VALUES
    ('Привіт', 'Це перший лист', 1, 2, 150),
    ('Привіт', 'Це другий лист', 2, 1, 150),
    ('Важлива інформація', 'Третій лист', 1, 3, 250),
    ('Подяка', 'Четвертий лист', 3, 1, 100),
    ('Привіт', 'Це пятий лист', 1, 4, 150), 
    ('Привіт', 'Це шостий лист', 4, 1, 150), 
    ('Важлива інформація', 'Сьомий лист', 2, 3, 250), 
    ('Подяка', 'Восьмий лист', 3, 4, 100);

-- Додавання даних поштової скриньки
INSERT INTO mailbox (email_id, id_folder, is_archived) VALUES 
    (1, 1, false), 
    (2, 1, false), 
    (3, 1, false), 
    (4, 1, false);
        
CREATE ROLE admin_user LOGIN PASSWORD 'password';

GRANT ALL PRIVILEGES ON DATABASE "users" TO admin_user;

CREATE ROLE basic_user LOGIN PASSWORD 'password';

GRANT SELECT ON users TO basic_user;

SELECT * FROM users;

REVOKE SELECT ON TABLE users FROM basic_user;

