-- Active: 1714365464599@@127.0.0.1@5432@users
-- 1. Процедура для додавання нового листа:
CREATE OR REPLACE PROCEDURE add_email(IN subject VARCHAR(255), IN message TEXT, IN sender_id INT, IN receiver_id INT, IN amount INT)
AS
$$
BEGIN
    INSERT INTO emails (subject, message, sender_id, receiver_id, amount) VALUES (subject, message, sender_id, receiver_id, amount);
END;
$$
LANGUAGE plpgsql;

SELECT * FROM emails;

CALL add_email('тема п', 'Нове повідомлення з процедури', 1, 2, 200);
-- 2. Процедура для оновлення існуючого листа:
CREATE OR REPLACE PROCEDURE update_email(IN p_email_id INT, IN new_subject VARCHAR(255), IN new_message TEXT, IN new_amount INT)
AS
$$
BEGIN
    UPDATE emails 
    SET subject = new_subject, message = new_message, amount = new_amount 
    WHERE email_id = p_email_id;
END;
$$
LANGUAGE plpgsql;
SELECT * FROM emails;

CALL update_email(1, 'Оновлена тема з процедури', 'Процедура процедура', 300);
-- 3. Архівування листа у поштовій скриньці:
CREATE OR REPLACE PROCEDURE archive_email(
    IN p_mailbox_id INT
)
AS $$
BEGIN
    UPDATE mailbox SET is_archived = TRUE WHERE mailbox_id = p_mailbox_id;
END;
$$ LANGUAGE plpgsql;
CALL archive_email(1);

SELECT * FROM mailbox;

-- функція для підрахунку кількості листів, отриманих конкретним користувачем

CREATE FUNCTION count_received_emails(user_id INT) 
RETURNS INT AS $$
DECLARE
    received_count INT;
BEGIN
    SELECT COUNT(*)
    INTO received_count
    FROM emails
    WHERE receiver_id = user_id;

    RETURN received_count;
END;
$$ LANGUAGE plpgsql;

SELECT count_received_emails(1);

-- функція для підрахунку загальної суми символів, отриманих конкретним користувачем через листи

CREATE FUNCTION sum_received_amount(user_id INT) 
RETURNS INT AS $$
DECLARE
    total_amount INT;
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO total_amount
    FROM emails
    WHERE receiver_id = user_id;

    RETURN total_amount;
END;
$$ LANGUAGE plpgsql;

SELECT sum_received_amount(1);

-- функція для підрахунку кількості листів, надісланих конкретним користувачем за певний період часу

CREATE FUNCTION count_sent_emails(user_id INT, start_date TIMESTAMP, end_date TIMESTAMP) 
RETURNS INT AS $$
DECLARE
    sent_count INT;
BEGIN
    SELECT COUNT(*)
    INTO sent_count
    FROM emails
    WHERE sender_id = user_id AND sent_at BETWEEN start_date AND end_date;

    RETURN sent_count;
END;
$$ LANGUAGE plpgsql;

SELECT count_sent_emails(1, '2024-01-01 00:00:00', '2024-05-19 23:59:59');


-- тригер для автоматичного додавання листів у папку "inbox" після їх створення:

CREATE OR REPLACE FUNCTION add_email_to_inbox()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO mailbox (email_id, id_folder, is_archived)
    VALUES (NEW.email_id, (SELECT id_folder FROM folder_directory WHERE folder_name = 'inbox'), FALSE);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_add_email_to_inbox
AFTER INSERT ON emails
FOR EACH ROW
EXECUTE FUNCTION add_email_to_inbox();

INSERT INTO emails (subject, message, sender_id, receiver_id, amount) 
VALUES ('Тестовий 1', 'Це тестовий лист для перевірки тригера', 1, 2, 100);
SELECT 
    e.email_id,
    e.subject,
    e.message,
    fd.folder_name
FROM 
    emails e
JOIN 
    mailbox mb ON e.email_id = mb.email_id
JOIN 
    folder_directory fd ON mb.id_folder = fd.id_folder;


-- тригер для оновлення поля sent_at при кожному оновленні листа:

CREATE OR REPLACE FUNCTION update_sent_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.sent_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sent_at
BEFORE UPDATE ON emails
FOR EACH ROW
EXECUTE FUNCTION update_sent_at();

UPDATE emails
SET message = 'Оновлене повідомлення 3x'
WHERE email_id = (SELECT MAX(email_id) FROM emails);

SELECT email_id, subject, message, sent_at FROM emails WHERE email_id = (SELECT MAX(email_id) FROM emails);

-- тригер, який автоматично додає лист у поштову скриньку користувача, якщо він адресований йому

CREATE OR REPLACE FUNCTION add_to_mailbox()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO mailbox (email_id, id_folder, is_archived) VALUES (NEW.email_id, 2, false); -- Інакше це лист отриманий
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_to_mailbox_trigger
AFTER INSERT ON emails
FOR EACH ROW EXECUTE FUNCTION add_to_mailbox();


INSERT INTO emails (subject, message, sender_id, receiver_id, amount) 
VALUES ('Лист3', 'Це тестовий лист для перевірки тригера 3', 1, 2, 100);

DROP TRIGGER add_to_mailbox_trigger ON emails;


SELECT 
    e.email_id,
    e.subject,
    e.message,
    fd.folder_name
FROM 
    emails e
JOIN 
    mailbox mb ON e.email_id = mb.email_id
JOIN 
    folder_directory fd ON mb.id_folder = fd.id_folder;


-- транзакції 

-- транзакція 1 оновлення теми листа та переміщення до папки "drafts"
BEGIN;

-- Оновлення теми листа з email_id 5
UPDATE emails
SET subject = 'Updated Subject'
WHERE email_id = 1;

-- Переміщення листа з email_id 5 до папки "drafts"
UPDATE mailbox
SET id_folder = (SELECT id_folder FROM folder_directory WHERE folder_name = 'drafts')
WHERE email_id = 1;

COMMIT;

SELECT * FROM emails;
SELECT * FROM mailbox;

-- Транзакція 2: переміщення листа до папки "trash" і архівування
BEGIN;
-- Переміщення листа з id 3 до папки "trash"
UPDATE mailbox
SET id_folder = (SELECT id_folder FROM folder_directory WHERE folder_name = 'trash')
WHERE email_id = 3;

-- Архівування листа з id 3
UPDATE mailbox
SET is_archived = true
WHERE email_id = 3;

COMMIT;

SELECT * FROM mailbox WHERE email_id = 3;


-- Транзакція 3: Зміна пароля користувача та видалення листа

BEGIN;
-- Зміна пароля для користувача з user_id 2
UPDATE users
SET password = 'newpassword2'
WHERE user_id = 2;
-- Видалення запису з таблиці mailbox, що відноситься до видаленого листа
DELETE FROM mailbox
WHERE email_id = 4;
-- Видалення листа з id 4 з таблиці emails
DELETE FROM emails
WHERE email_id = 4;
COMMIT;

SELECT * FROM users;
SELECT * FROM emails;

ROLLBACK;