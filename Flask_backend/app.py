from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token, JWTManager, jwt_required, get_jwt_identity
from flask_cors import CORS
from datetime import datetime
import os
import json
import random
import nltk
from chatbot_server import chatbot_response


app = Flask(__name__)
CORS(app, supports_credentials=True)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'supersecretkey'

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)

    
# Modelo do Usuário
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

# Modelo do Psicólogo
class Psychologist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

# Modelo de Mensagem
class Message(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, nullable=False)
    receiver_id = db.Column(db.Integer, nullable=False)
    content = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Modelo do Diário
class DiaryEntry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)
    content = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Criar banco de dados
with app.app_context():
    db.create_all()

# Rota de cadastro do usuário
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username, email, password = data.get('username'), data.get('email'), data.get('password')

    if not username or not email or not password:
        return jsonify({"message": "Todos os campos são obrigatórios"}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({"message": "Email já cadastrado"}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(username=username, email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "Usuário cadastrado com sucesso!"}), 201

# Rota de login do usuário
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email, password = data.get('email'), data.get('password')

    user = User.query.filter_by(email=email).first()
    if user and bcrypt.check_password_hash(user.password, password):
        access_token = create_access_token(identity={'id': user.id, 'username': user.username})
        return jsonify({"message": "Login realizado com sucesso!", "token": access_token}), 200
    return jsonify({"message": "Credenciais inválidas"}), 401

# Rota de cadastro do psicólogo
@app.route('/register_psicologo', methods=['POST'])
def register_psicologo():
    data = request.get_json()
    username, email, password = data.get('username'), data.get('email'), data.get('password')

    if not username or not email or not password:
        return jsonify({"message": "Todos os campos são obrigatórios"}), 400

    if Psychologist.query.filter_by(email=email).first():
        return jsonify({"message": "Email já cadastrado"}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_psychologist = Psychologist(username=username, email=email, password=hashed_password)
    db.session.add(new_psychologist)
    db.session.commit()

    return jsonify({"message": "Psicólogo cadastrado com sucesso!"}), 201

# Rota de login do psicólogo
@app.route('/login_psicologo', methods=['POST'])
def login_psicologo():
    data = request.get_json()
    email, password = data.get('email'), data.get('password')

    psychologist = Psychologist.query.filter_by(email=email).first()
    if psychologist and bcrypt.check_password_hash(psychologist.password, password):
        access_token = create_access_token(identity={'id': psychologist.id, 'username': psychologist.username})
        return jsonify({"message": "Login realizado com sucesso!", "token": access_token}), 200
    return jsonify({"message": "Credenciais inválidas"}), 401

# Rota para enviar mensagem
@app.route('/send_message', methods=['POST'])
@jwt_required()
def send_message():
    data = request.get_json()
    receiver_id = data.get('receiver_id')
    content = data.get('content')

    if not receiver_id or not content:
        return jsonify({"message": "Receiver ID e conteúdo são obrigatórios"}), 400

    sender_id = get_jwt_identity()['id']

    new_message = Message(sender_id=sender_id, receiver_id=receiver_id, content=content)
    db.session.add(new_message)
    db.session.commit()

    return jsonify({"message": "Mensagem enviada com sucesso!"}), 201

# Rota para receber mensagens
@app.route('/get_messages', methods=['GET'])
@jwt_required()
def get_messages():
    user_id = get_jwt_identity()['id']

    messages = Message.query.filter((Message.sender_id == user_id) | (Message.receiver_id == user_id)).order_by(Message.timestamp).all()

    messages_list = []
    for message in messages:
        messages_list.append({
            "id": message.id,
            "sender_id": message.sender_id,
            "receiver_id": message.receiver_id,
            "content": message.content,
            "timestamp": message.timestamp
        })

    return jsonify(messages_list), 200

# Rota para salvar entrada no diário
@app.route('/diary', methods=['POST'])
@jwt_required()
def save_diary_entry():
    data = request.get_json()
    content = data.get('content')
    user_id = get_jwt_identity()['id']

    if not content:
        return jsonify({"message": "O conteúdo do diário não pode estar vazio."}), 400

    new_entry = DiaryEntry(user_id=user_id, content=content)
    db.session.add(new_entry)
    db.session.commit()

    return jsonify({"message": "Entrada do diário salva com sucesso!"}), 201

# Rota para obter entradas do diário do usuário
@app.route('/diary', methods=['GET'])
@jwt_required()
def get_diary_entries():
    user_id = get_jwt_identity()['id']
    entries = DiaryEntry.query.filter_by(user_id=user_id).order_by(DiaryEntry.timestamp.desc()).all()

    diary_list = [{
        "id": entry.id,
        "content": entry.content,
        "timestamp": entry.timestamp.strftime('%Y-%m-%d %H:%M:%S')
    } for entry in entries]

    return jsonify(diary_list), 200

@app.route('/chatbot', methods=['POST', 'OPTIONS'])
@jwt_required(optional=True)  # permite acessar sem JWT para OPTIONS
def chat_with_bot():
    if request.method == 'OPTIONS':
        return '', 200

    data = request.get_json()
    msg = data.get('message')
    if not msg:
        return jsonify({"message": "Mensagem vazia."}), 400

    resposta = chatbot_response(msg)
    return jsonify({"resposta": resposta}), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
