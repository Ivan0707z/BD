-- Active: 1714365578665@@127.0.0.1@5432@users
-- 1. Вибрати всіх користувачів:
SELECT * FROM users;
-- 2. Вибрати всі листи від користувача з ідентифікатором 1:
SELECT * FROM emails WHERE sender_id = 1;
-- 3. Перевірити, чи існує користувач з певною електронною поштою:
SELECT EXISTS(SELECT 1 FROM users WHERE email = 'user1@example.com');
-- 4. Підрахувати загальну кількість листів у поштовій скриньці користувача з ідентифікатором 3:
SELECT COUNT(*) FROM mailbox WHERE email_id IN (SELECT email_id FROM emails WHERE receiver_id = 3);
-- 5. Знайти всі листи, які містять слово "важлива" у темі:
SELECT * FROM emails WHERE subject LIKE '%важлива%';
-- 6. Оновити пароль користувача з ідентифікатором 2:
UPDATE users SET password = 'newpassword' WHERE user_id = 2;
-- 7. Видалити лист з ідентифікатором 4:
DELETE FROM emails WHERE email_id = 4;
-- 8. Знайти всі листи, які були відправлені або отримані користувачем з ідентифікатором 1:
SELECT * FROM emails WHERE sender_id = 1 OR receiver_id = 1;
-- 9. Підрахувати загальну кількість архівованих листів:
SELECT COUNT(*) FROM mailbox WHERE is_archived = true;
-- 10. Вибрати всі листи, відсортовані за датою відправлення у зворотньому порядку:
SELECT * FROM emails ORDER BY sent_at DESC;
-- 11. Вибрати всі унікальні адреси електронної пошти з таблиці користувачів:
SELECT DISTINCT email FROM users;
-- 12. Перевірити, чи існують листи в поштовій скриньці користувача з ідентифікатором 2:
SELECT EXISTS(SELECT 1 FROM mailbox WHERE email_id IN (SELECT email_id FROM emails WHERE receiver_id = 2));
-- 13. Підрахувати загальну кількість листів, відправлених від користувача з ідентифікатором 3:
SELECT COUNT(*) FROM emails WHERE sender_id = 3;
-- 14. Знайти всі листи, відправлені користувачем з іменем "user1":
SELECT * FROM emails WHERE sender_id = (SELECT user_id FROM users WHERE username = 'user1');
-- 15. Оновити ім'я користувача з ідентифікатором 4:
UPDATE users SET username = 'newusername' WHERE user_id = 4;
-- 16. Видалити всі архівовані листи з таблиці поштової скриньки:
DELETE FROM mailbox WHERE is_archived = true;
-- 17. Знайти всі листи, які були відправлені користувачем з ідентифікатором 2 та мають суму більше 200:
SELECT * FROM emails WHERE sender_id = 2 AND amount > 200;
-- 18. Вибрати всі листи, відсортовані за темою у алфавітному порядку:
SELECT * FROM emails ORDER BY subject ASC;
-- 19. Підрахувати загальну кількість листів у папці "inbox":
SELECT COUNT(*) FROM mailbox WHERE folder = 'inbox';
-- 20. Видалити користувача з ідентифікатором 5:
DELETE FROM users WHERE user_id = 5;
-- 21. Вибрати всі листи, які мають суму менше або дорівнюють 150 та є непрочитаними:
SELECT * FROM emails WHERE amount <= 150 AND email_id NOT IN (SELECT email_id FROM mailbox WHERE folder = 'inbox');
-- 22. Перевірити, чи існують користувачі з паролем "password3":
SELECT EXISTS(SELECT 1 FROM users WHERE password = 'password3');
-- 23. Підрахувати загальну кількість листів, отриманих користувачем з ідентифікатором 1 та не знаходяться в папці "inbox":
SELECT COUNT(*) FROM mailbox WHERE email_id IN (SELECT email_id FROM emails WHERE receiver_id = 1) AND folder <> 'inbox';
-- 24. Знайти всі листи, відправлені або отримані користувачем з ідентифікатором 4 за останній тиждень:
SELECT * FROM emails WHERE (sender_id = 4 OR receiver_id = 4) AND sent_at >= NOW() - INTERVAL '7 days';
-- 25. Вибрати усіх користувачів, які мають унікальні електронні адреси:
SELECT * FROM users WHERE email IN (SELECT DISTINCT email FROM users GROUP BY email HAVING COUNT(*) = 1);
-- 26. Оновити папку для всіх листів користувача з ідентифікатором 3 на "archive":
UPDATE mailbox SET folder = 'archive' WHERE email_id IN (SELECT email_id FROM emails WHERE receiver_id = 3);
-- 27. Знайти всі листи, які мають суму більше 200 та відправлені користувачем з ідентифікатором 2:
SELECT * FROM emails WHERE amount > 200 AND sender_id = 2;
-- 28. Підрахувати загальну кількість архівованих листів для кожного користувача:
SELECT u.username, COUNT(m.email_id) AS archived_count 
FROM users u 
LEFT JOIN emails e ON u.user_id = e.receiver_id 
LEFT JOIN mailbox m ON e.email_id = m.email_id AND m.is_archived = true 
GROUP BY u.username;
-- 29. Вибрати всі листи, відсортовані за датою відправлення для користувача з ідентифікатором 5:
SELECT * FROM emails WHERE sender_id = 5 OR receiver_id = 5 ORDER BY sent_at DESC;
-- 30. Вибрати всі листи разом з іменами відправника та отримувача:
SELECT e.*, sender.username AS sender_username, receiver.username AS receiver_username
FROM emails e
JOIN users sender ON e.sender_id = sender.user_id
JOIN users receiver ON e.receiver_id = receiver.user_id;
-- 31. Знайти всі листи, відправлені користувачем з іменем "user1", разом з інформацією про відправника:
SELECT e.*, sender.username AS sender_username
FROM emails e
JOIN users sender ON e.sender_id = sender.user_id
WHERE sender.username = 'user1';
-- 32. Підрахувати загальну кількість листів у папці "inbox" для кожного користувача:
SELECT u.username, COUNT(m.email_id) AS inbox_count
FROM users u
LEFT JOIN emails e ON u.user_id = e.receiver_id
LEFT JOIN mailbox m ON e.email_id = m.email_id AND m.folder = 'inbox'
GROUP BY u.username;
-- 33. Вибрати всі листи, відправлені та отримані користувачем з ідентифікатором 3, разом з даними відправника та отримувача:
SELECT e.*, sender.username AS sender_username, receiver.username AS receiver_username
FROM emails e
JOIN users sender ON e.sender_id = sender.user_id
JOIN users receiver ON e.receiver_id = receiver.user_id
WHERE sender.user_id = 3 OR receiver.user_id = 3;
-- 34. Вибрати всі листи, що знаходяться в папці "archive", разом з іменами користувачів:
SELECT e.*, u.username
FROM emails e
JOIN mailbox m ON e.email_id = m.email_id
JOIN users u ON e.receiver_id = u.user_id
WHERE m.folder = 'archive';
-- 35. Знайти всі листи, що знаходяться в папці "inbox" та "archive", разом з іменами користувачів:
SELECT e.*, u.username
FROM emails e
JOIN mailbox m ON e.email_id = m.email_id
JOIN users u ON e.receiver_id = u.user_id
WHERE m.folder IN ('inbox', 'archive');

-- 36. Знайти всі листи, відправлені або отримані користувачем з ідентифікатором 3, і відмітити їх як архівовані:
UPDATE mailbox
SET is_archived = true
WHERE user_id = 3 AND email_id IN (SELECT email_id FROM emails WHERE sender_id = 3 OR receiver_id = 3);

-- 37. Знайти всі листи, відправлені або отримані за певний період часу (наприклад, з 2024-01-01 по 2024-03-01):
SELECT * FROM emails WHERE sent_at BETWEEN '2024-01-01' AND '2024-03-01';

-- 38. Знайти всі листи, які мають певне слово у повідомленні (наприклад, слово "третій"):
SELECT * FROM emails WHERE message LIKE '%третій%';

-- 39. Знайти всі листи, в яких сума перевищує певне значення (наприклад, 200) та відправлені користувачем з ідентифікатором 1:
SELECT * FROM emails WHERE amount > 200 AND sender_id = 1;

-- 40. Знайти всі листи, відправлені користувачем з ідентифікатором 1 та отримані користувачем з ідентифікатором 3:
SELECT * FROM emails WHERE sender_id = 1 AND receiver_id = 3;

-- 41. Знайти всі архівовані листи, відправлені або отримані користувачем з ідентифікатором 1:
SELECT * FROM emails e
JOIN mailbox m ON e.email_id = m.email_id
WHERE m.user_id = 1 AND m.is_archived = true;

-- 42. Видалити всі листи, відправлені або отримані за певний період часу (наприклад, з 2024-01-01 по 2024-03-01):
DELETE FROM emails WHERE sent_at BETWEEN '2024-01-01' AND '2024-03-01';

-- 43. Видалити всі листи, в яких сума перевищує певне значення (наприклад, 200):
DELETE FROM emails WHERE amount > 200;

-- 44. Оновити лист з ідентифікатором 1, змінити відправника та отримувача:
UPDATE emails SET sender_id = 3, receiver_id = 2 WHERE email_id = 1;

-- 45. Оновити статус архіву листа з ідентифікатором 2:
UPDATE mailbox SET is_archived = true WHERE email_id = 2;

-- 46. Знайти всі листи, відправлені або отримані користувачем з ідентифікатором 2, та позначити їх як архівовані:
UPDATE mailbox SET is_archived = true WHERE user_id = 2;

-- 47. Видалити всі листи, в яких сума менше або рівна 150:
DELETE FROM emails WHERE amount <= 150;

-- 48. Оновити тему листа з ідентифікатором 3:
UPDATE emails SET subject = 'Нова тема' WHERE email_id = 3;
-- 49. Знайти всі листи, які містять певне слово у темі (наприклад, слово "важлива"):
SELECT * FROM emails WHERE subject LIKE '%важлива%';

-- 50. Знайти всі листи, які були відправлені після певної дати та мають суму більше певного значення (наприклад, після 2024-01-01 та сума більше 200):
SELECT * FROM emails WHERE sent_at > '2024-01-01' AND amount > 200;

-- 51. Знайти всі листи, в яких сума перевищує певне значення та відправлені користувачем з ідентифікатором 2:
SELECT * FROM emails WHERE amount > 150 AND sender_id = 2;

-- 52. Знайти всі листи, в яких сума перевищує певне значення та отримані користувачем з ідентифікатором 3:
SELECT * FROM emails WHERE amount > 100 AND receiver_id = 3;

-- 53. Знайти всі листи, в яких сума перевищує певне значення та тема містить певне слово (наприклад, сума більше 150 та тема містить слово "важлива"):
SELECT * FROM emails WHERE amount > 150 AND subject LIKE '%важлива%';

-- 54. Знайти всі листи, відправлені або отримані за певний період часу та позначити їх як архівовані (наприклад, з 2024-01-01 по 2024-03-01):
UPDATE mailbox
SET is_archived = true
WHERE email_id IN (SELECT email_id FROM emails WHERE sent_at BETWEEN '2024-01-01' AND '2024-03-01');

-- 55. Знайти всі листи, відправлені або отримані користувачем з ідентифікатором 1 та відсортувати їх за датою відправлення у зростаючому порядку:
SELECT * FROM emails WHERE sender_id = 1 OR receiver_id = 1 ORDER BY sent_at ASC;

-- 56. Підрахувати кількість листів, відправлених користувачем з ідентифікатором 1 та позначених як архівовані:
SELECT COUNT(*) FROM emails e
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1 AND m.is_archived = true;

-- 57. Підрахувати загальну кількість архівованих листів:
SELECT COUNT(*) FROM mailbox WHERE is_archived = true;

-- 58. Знайти всі архівовані листи, які мають суму більше певного значення (наприклад, більше 200):
SELECT * FROM emails e
JOIN mailbox m ON e.email_id = m.email_id
WHERE m.is_archived = true AND e.amount > 200;

-- 59. Знайти всі листи, в яких сума менша або рівна 100 та відмітити їх як архівовані:
UPDATE mailbox
SET is_archived = true
WHERE email_id IN (SELECT email_id FROM emails WHERE amount <= 100);

-- 60. Видалити всі архівовані листи, які мають суму меншу за певне значення (наприклад, менше або рівні 100):
DELETE FROM emails WHERE email_id IN (SELECT email_id FROM mailbox WHERE is_archived = true) AND amount <= 100;

-- 61. Приєднати таблицю користувачів до таблиці листів для отримання інформації про відправника листа:
SELECT e.*, u.username AS sender_username
FROM emails e
JOIN users u ON e.sender_id = u.user_id;

-- 62. Приєднати таблицю користувачів до таблиці листів для отримання інформації про отримувача листа:
SELECT e.*, u.username AS receiver_username
FROM emails e
JOIN users u ON e.receiver_id = u.user_id;

-- 63. Приєднати таблицю користувачів до таблиці поштової скриньки для отримання інформації про користувача, який має доступ до поштової скриньки:
SELECT m.*, u.username
FROM mailbox m
JOIN users u ON m.user_id = u.user_id;

-- 64. Приєднати таблицю листів до таблиці поштової скриньки для отримання інформації про листи, що знаходяться у поштовій скриньці:
SELECT e.*, m.*
FROM emails e
JOIN mailbox m ON e.email_id = m.email_id;

-- 65. Приєднати таблицю листів до таблиці користувачів для отримання інформації про листи та відправників:
SELECT e.*, u.username AS sender_username
FROM emails e
JOIN users u ON e.sender_id = u.user_id;

-- 66. Приєднати таблицю листів до таблиці користувачів для отримання інформації про листи та отримувачів:
SELECT e.*, u.username AS receiver_username
FROM emails e
JOIN users u ON e.receiver_id = u.user_id;

-- 67. Приєднати таблицю поштової скриньки до таблиці користувачів для отримання інформації про користувачів, які мають доступ до поштової скриньки:
SELECT m.*, u.username
FROM mailbox m
JOIN users u ON m.user_id = u.user_id;

-- 68. Приєднати таблицю поштової скриньки до таблиці листів для отримання інформації про листи, що знаходяться у поштовій скриньці:
SELECT m.*, e.*
FROM mailbox m
JOIN emails e ON m.email_id = e.email_id;

-- 69. Приєднати таблиці листів та користувачів для отримання інформації про листи та їх відправників:
SELECT e.*, u.username AS sender_username
FROM emails e
JOIN users u ON e.sender_id = u.user_id;

-- 70. Приєднати таблиці листів та користувачів для отримання інформації про листи та їх отримувачів:
SELECT e.*, u.username AS receiver_username
FROM emails e
JOIN users u ON e.receiver_id = u.user_id;

-- 71. Приєднати таблиці поштової скриньки та користувачів для отримання інформації про користувачів, які мають доступ до поштової скриньки:
SELECT m.*, u.username
FROM mailbox m
JOIN users u ON m.user_id = u.user_id;

-- 72. Приєднати таблиці поштової скриньки та листів для отримання інформації про листи, що знаходяться у поштовій скриньці:
SELECT m.*, e.*
FROM mailbox m
JOIN emails e ON m.email_id = e.email_id;

-- 73. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки:
SELECT e.*, u.username AS sender_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users u ON e.sender_id = u.user_id
JOIN mailbox m ON e.email_id = m.email_id;

-- 74. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх отримувачів та користувачів, які мають доступ до поштової скриньки:
SELECT e.*, u.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users u ON e.receiver_id = u.user_id
JOIN mailbox m ON e.email_id = m.email_id;

-- 75. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS
mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id;

-- 76. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE m.is_archived = true;

-- 77. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише листи, відправлені користувачем з ідентифікатором 1:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1;

-- 78. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише листи, отримані користувачем з ідентифікатором 2:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 2;

-- 79. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, відправлені користувачем з ідентифікатором 1:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1 AND m.is_archived = true;

-- 80. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, отримані користувачем з ідентифікатором 2:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 2 AND m.is_archived = true;

-- 81. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише непрочитані листи, отримані користувачем з ідентифікатором 3:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 3 AND m.is_archived = false;

-- 82. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх в ідправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише листи, в яких сума перевищує 200:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount > 200;

-- 83. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, в яких сума менше 100:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount < 100 AND m.is_archived = true;

-- 84. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, в яких сума рівна 150:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount = 150 AND m.is_archived = true;

-- 85. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише непрочитані листи, в яких сума менше 200:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount < 200 AND m.is_archived = false;

-- 86. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише непрочитані листи, в яких тема містить слово "важлива":
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.subject LIKE '%важлива%' AND m.is_archived = false;

-- 87. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, в яких тема містить слово "важлива":
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.subject LIKE '%важлива%' AND m.is_archived = true;

-- 88. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про користувачів, які отримали листи від користувача з ідентифікатором 1:
SELECT DISTINCT u.*
FROM users u
JOIN emails e ON u.user_id = e.receiver_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1;

-- 89. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про користувачів, які отримали листи від користувача з ідентифікатором 1 та позначити їх, якщо вони архівовані:
SELECT DISTINCT u.*, m.is_archived
FROM users u
JOIN emails e ON u.user_id = e.receiver_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1;

-- 90. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про користувачів, які не отримали листи від користувача з ідентифікатором 1:
SELECT DISTINCT u.*
FROM users u
LEFT JOIN emails e ON u.user_id = e.receiver_id AND e.sender_id = 1
WHERE e.email_id IS NULL;

-- 91. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id;

-- 92. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE m.is_archived = true;

-- 93. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише листи, відправлені користувачем з ідентифікатором 1:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1;

-- 94. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише листи, отримані користувачем з ідентифікатором 2:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 2;

-- 95. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, відправлені користувачем з ідентифікатором 1:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.sender_id = 1 AND m.is_archived = true;

-- 96. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, отримані користувачем з ідентифікатором 2:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 2 AND m.is_archived = true;

-- 97. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише непрочитані листи, отримані користувачем з ідентифікатором 3:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.receiver_id = 3 AND m.is_archived = false;

-- 98. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише непрочитані листи, в яких сума перевищує 200:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount > 200 AND m.is_archived = false;

-- 99. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, в яких сума менше 100:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount < 100 AND m.is_archived = true;
-- 100. Приєднати таблиці листів, користувачів та поштової скриньки для отримання інформації про листи, їх відправників, отримувачів та користувачів, які мають доступ до поштової скриньки, і відфільтрувати лише архівовані листи, в яких сума рівна 150:
SELECT e.*, us.username AS sender_username, ur.username AS receiver_username, m.user_id AS mailbox_user_id
FROM emails e
JOIN users us ON e.sender_id = us.user_id
JOIN users ur ON e.receiver_id = ur.user_id
JOIN mailbox m ON e.email_id = m.email_id
WHERE e.amount = 150 AND m.is_archived = true;








SELECT * 
FROM emails 
JOIN mailbox ON emails.email_id = mailbox.email_id
WHERE sender_id = 1 AND id_folder = 1;