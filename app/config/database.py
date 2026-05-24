import os
import pg8000
from dotenv import load_dotenv

# Carrega o .env corretamente dependendo de onde o script é chamado
env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
load_dotenv(dotenv_path=env_path)

class DatabaseConfig:
    def __init__(self):
        self.host = os.getenv("DB_HOST", "localhost")
        self.port = int(os.getenv("DB_PORT", "5432"))
        self.user = os.getenv("DB_USER", "postgres")
        self.password = os.getenv("DB_PASSWORD", "postgres_password")
        self.dbname = os.getenv("DB_NAME", "aurora_comercial")

    def get_connection(self):
        try:
            conn = pg8000.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.dbname
            )
            return conn
        except Exception as e:
            print(f"Erro ao conectar ao banco de dados: {e}")
            return None
