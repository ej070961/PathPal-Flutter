from flask import Flask, request, jsonify
import os
from dotenv import load_dotenv
from pydantic import BaseModel
from langchain_openai import ChatOpenAI
from langchain_community.document_loaders import CSVLoader
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

app = Flask(__name__)

load_dotenv()  # 환경변수 로드

api_key = os.getenv("OPENAI_API_KEY")
if api_key is None:
    raise ValueError("OpenAI API 키가 환경변수에 설정되지 않았습니다.")

# 임베딩 함수 설정
embedding_function = OpenAIEmbeddings()

# 문서 로드 및 ChromaDB 설정
file_paths = ["/Users/changha/Documents/24-1-quarter/PathPal-Flutter/chatbot_server/승강기 위치정보.csv", "/Users/changha/Documents/24-1-quarter/PathPal-Flutter/chatbot_server/장애인화장실위치.csv"]
documents = []
for file_path in file_paths:
    loader = CSVLoader(file_path, encoding="CP949")  # 인코딩은 파일에 맞게 조정
    documents.extend(loader.load())

db = Chroma.from_documents(documents, embedding_function)
retriever = db.as_retriever()

# 채팅 프롬프트 및 모델 설정
template = """You must answer question based only on the following context. This question is usually about the location of facilities. Also, reply in Korean and in sentence:
{context}

Question: {question}
"""
prompt = ChatPromptTemplate.from_template(template)

model = ChatOpenAI(temperature=0, max_tokens=512, model_name='gpt-3.5-turbo')

# 채팅 랭체인 구성
chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | model
    | StrOutputParser()
)

# 요청 본문을 위한 모델 정의
class Query(BaseModel):
    question: str

@app.route("/get-response/", methods=["POST"])
def get_response():
    data = request.json
    query = Query(**data)
    response = chain.invoke(query.question)
    return jsonify({"response": response})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
