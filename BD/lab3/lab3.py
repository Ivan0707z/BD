from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        dbname='users',
        user='postgres',
        password='admin',
        host='localhost',
        port='5432'
    )
    return conn

# CRUD операції для таблиці листів
@app.route('/emails', methods=['POST'])
def create_email():
    data = request.get_json()
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO emails (subject, message, sender_id, receiver_id, amount) VALUES (%s, %s, %s, %s, %s) RETURNING email_id;",
        (data['subject'], data['message'], data['sender_id'], data['receiver_id'], data['amount'])
    )
    email_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'email_id': email_id}), 201

@app.route('/emails/<int:email_id>', methods=['GET'])
def get_email(email_id):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM emails WHERE email_id = %s;", (email_id,))
    email = cur.fetchone()
    cur.close()
    conn.close()
    return jsonify(email)

@app.route('/emails', methods=['GET'])
def get_emails():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM emails;")
    emails = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(emails)

@app.route('/emails/<int:email_id>', methods=['PUT'])
def update_email(email_id):
    data = request.get_json()
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        "UPDATE emails SET subject = %s, message = %s, sender_id = %s, receiver_id = %s, amount = %s WHERE email_id = %s;",
        (data['subject'], data['message'], data['sender_id'], data['receiver_id'], data['amount'], email_id)
    )
    conn.commit()
    cur.close()
    conn.close()
    return '', 204

@app.route('/emails/<int:email_id>', methods=['DELETE'])
def delete_email(email_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE FROM emails WHERE email_id = %s;", (email_id,))
    conn.commit()
    cur.close()
    conn.close()
    return '', 204

# Запуск сервера
if __name__ == '__main__':
    app.run(debug=True)
