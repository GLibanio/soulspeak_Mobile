import re
import torch
import json
import random
import numpy as np
from collections import deque
from transformers import BertTokenizer, BertForSequenceClassification
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# === Carregamento de modelos ===
bert_model = BertForSequenceClassification.from_pretrained("nlptown/bert-base-multilingual-uncased-sentiment")
tokenizer = BertTokenizer.from_pretrained("nlptown/bert-base-multilingual-uncased-sentiment")
embedder = SentenceTransformer('all-MiniLM-L6-v2')

# === Contexto ===
contexto_conversa = deque(maxlen=3)

# === Palavras-chave de urgência emocional ===
palavras_chave_urgentes = [
    "me cortar", "me corto", "me machuco", "me ferindo", "acabar com tudo",
    "não aguento mais", "desisto da vida", "sumir", "quero morrer", "me matar",
    "pensamentos ruins", "suicídio", "suicida", "morrer", "tirar a vida", "auto-mutilação"
]

# === Abreviações e correções comuns ===
abreviacoes = {
    "vc": "você", "vcs": "vocês", "blz": "beleza", "tmj": "tamo junto",
    "td": "tudo", "pq": "porque", "q": "que", "eh": "é", "n": "não",
    "to": "estou", "ta": "está", "tá": "está", "cê": "você", "mto": "muito",
    "obg": "obrigado", "dps": "depois", "hj": "hoje", "tbm": "também",
    "msg": "mensagem", "pfv": "por favor", "flw": "falou", "agr": "agora", "bl": "beleza"
}

# === Pré-processamento ===

def corrigir_erro_portugues(texto):
    """Corrige abreviações e erros comuns de português informal."""
    palavras = texto.lower().split()
    corrigido = [abreviacoes.get(p, p) for p in palavras]
    return ' '.join(corrigido)

# === Detecção ===

def verifica_urgencia(texto):
    """Verifica se o texto contém sinais de urgência emocional."""
    texto = texto.lower()
    return any(termo in texto for termo in palavras_chave_urgentes)

def nivel_bert_classificacao(texto):
    """Classifica o sentimento da mensagem usando BERT (1 a 5)."""
    inputs = tokenizer(texto, return_tensors="pt", truncation=True, padding=True)
    outputs = bert_model(**inputs)
    probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
    pred = torch.argmax(probs).item() + 1
    return pred

# === Intents ===

def load_intents(path='intents.json'):
    """Carrega as intents de um arquivo JSON."""
    try:
        with open(path, 'r', encoding='utf-8') as file:
            data = json.load(file)
            return data.get("intents", [])
    except Exception as e:
        print("Erro ao carregar intents:", e)
        return []

intents_data = load_intents()

def resposta_por_intent(texto_usuario):
    """Retorna uma resposta com base na similaridade semântica com as intents."""
    if not intents_data:
        return None

    emb_usuario = embedder.encode([texto_usuario])[0]
    melhor_sim = 0
    melhor_resposta = None

    for intent in intents_data:
        for resposta in intent.get("responses", []):
            emb_resposta = embedder.encode([resposta])[0]
            sim = cosine_similarity([emb_usuario], [emb_resposta])[0][0]
            if sim > melhor_sim:
                melhor_sim = sim
                melhor_resposta = resposta

    return melhor_resposta if melhor_sim > 0.4 else None

# === Contexto ===

def resposta_contextual(mensagem):
    """Responde com base no contexto recente da conversa."""
    texto_lower = mensagem.lower()

    for contexto in reversed(contexto_conversa):
        if "família" in contexto and any(p in texto_lower for p in ["melhorar", "me ajuda", "sair dessa", "formas"]):
            return (
                "Sei que lidar com problemas familiares pode ser muito difícil.\n\n"
                "Aqui vão algumas ideias que podem ajudar:\n"
                "- Fale com alguém neutro sobre o que sente (psicólogo, amigo de confiança).\n"
                "- Escreva o que está sentindo, isso ajuda a desabafar e organizar pensamentos.\n"
                "- Respeite seu tempo e tente cuidar de si com carinho.\n\n"
                "Se quiser, posso continuar por aqui com você."
            )

        if any(x in contexto for x in ["sozinho", "luto", "me odeia", "ninguém liga"]) and "melhorar" in texto_lower:
            return (
                "Você não precisa enfrentar isso sozinho.\n\n"
                "Algumas sugestões que podem te fazer bem:\n"
                "- Converse com alguém, mesmo por mensagem.\n"
                "- Tire um tempo para cuidar de você: um banho, uma música, uma caminhada.\n"
                "- Encontre pequenos momentos bons no dia e anote-os.\n\n"
                "Estou aqui se quiser continuar conversando."
            )

    return None

# === Resposta Principal ===

def chatbot_response(mensagem_usuario):
    """Função principal que gera a resposta do chatbot."""
    texto_corrigido = corrigir_erro_portugues(mensagem_usuario)
    contexto_conversa.append(texto_corrigido)

    # Urgência emocional
    if verifica_urgencia(texto_corrigido):
        respostas_urgencia = [
            "Sinto muito por você estar passando por isso 💛\nLigue para o CVV no 188 – você será ouvido com carinho, 24h por dia. Você não está sozinho.",
            "Ei, percebo que você está passando por algo sério. Por favor, entre em contato com o CVV (188), eles estão prontos pra te ouvir com atenção e respeito 💛",
            "Você é importante e merece cuidado. Ligue 188 (CVV) – é gratuito, sigiloso e 24h. Estou aqui com você também."
        ]
        return random.choice(respostas_urgencia)

    # Classificação de sentimento
    classificacao = nivel_bert_classificacao(texto_corrigido)
    resposta_contextualizada = resposta_contextual(texto_corrigido)
    resposta_intent = resposta_por_intent(texto_corrigido)

    respostas_negativas = [
        "Parece que você está passando por um momento difícil... e eu sinto muito por isso 🧡",
        "Entendo que as coisas não estejam fáceis agora. Fica tranquilo(a), estou aqui pra te ouvir.",
        "Sei que nem sempre conseguimos colocar em palavras tudo o que sentimos... mas saiba que estou aqui com você 💛",
        "Momentos difíceis fazem parte, mas você não precisa passar por eles sozinho(a)."
    ]

    respostas_neutras = [
        "Entendo. Quer conversar mais sobre isso? Estou por aqui.",
        "Se quiser desabafar, estou te ouvindo, tá bem?",
        "Me conta mais, se quiser. Estou aqui com atenção.",
        "Se quiser continuar, pode me dizer o que está sentindo. Vamos conversar."
    ]

    respostas_positivas = [
        "Fico feliz em saber disso! 😄 Continue se cuidando!",
        "Adorei ouvir isso. Você merece muitos momentos bons!",
        "Que ótimo! Coisas boas merecem ser celebradas 🎉",
        "Muito bom ouvir isso. Conta mais, se quiser compartilhar 😊"
    ]

    if classificacao <= 2:
        if resposta_contextualizada:
            return resposta_contextualizada + "\n\n💡 E lembra: o 188 está sempre disponível se quiser conversar com alguém agora."
        if resposta_intent:
            return resposta_intent + "\n\n🧡 E se quiser falar com alguém, o CVV (188) está disponível sempre."
        return random.choice(respostas_negativas) + "\n\nSe quiser, posso continuar aqui com você. E tem o 188 também, sempre pronto pra ouvir."

    elif classificacao == 3:
        return resposta_contextualizada or resposta_intent or random.choice(respostas_neutras)

    else:
        return resposta_intent or random.choice(respostas_positivas)
    """Função principal que gera a resposta do chatbot."""
    texto_corrigido = corrigir_erro_portugues(mensagem_usuario)
    contexto_conversa.append(texto_corrigido)

    # Urgência emocional
    if verifica_urgencia(texto_corrigido):
        return (
            "Sinto muito por você estar passando por isso 💛\n"
            "Você é importante, e sua dor merece ser ouvida. Se estiver com pensamentos difíceis, ligue para o CVV no 188.\n"
            "Você será ouvido com carinho, sem julgamentos, 24h por dia. Não está sozinho!"
        )

    # Classificação de sentimento
    classificacao = nivel_bert_classificacao(texto_corrigido)
    resposta_contextualizada = resposta_contextual(texto_corrigido)
    resposta_intent = resposta_por_intent(texto_corrigido)

    if classificacao <= 2:
        if resposta_contextualizada:
            return resposta_contextualizada + "\n\n💡 Se quiser conversar com alguém agora, o 188 está sempre disponível."
        if resposta_intent:
            return resposta_intent + "\n\n💛 Lembre-se: você pode ligar 188 a qualquer hora."
        return (
            "Parece que você está passando por um momento difícil... e eu sinto muito por isso 🧡\n"
            "Se quiser, posso te ouvir por aqui. E lembre-se: o 188 está sempre aberto pra você conversar."
        )

    elif classificacao == 3:
        return resposta_contextualizada or resposta_intent or "Entendo. Quer conversar mais sobre isso? Estou aqui por você."

    else:
        return resposta_intent or "Fico feliz em saber disso! 😄 Continue se cuidando e, se quiser conversar, estou por aqui."

# === Modo interativo (para testes locais) ===
if __name__ == '__main__':
    while True:
        msg = input("Você: ")
        print("SoulBot:", chatbot_response(msg))
