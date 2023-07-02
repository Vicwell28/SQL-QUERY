import pandas as pd
import sqlalchemy

class DatabaseConnection:
    def __init__(self):
        self.host = "127.0.0.1"
        self.user = "root"
        self.password = ""
        self.database = "northwind"
        self.engine = None

    def connect(self):
        try:
            connection_string = f"mysql+pymysql://{self.user}:{self.password}@{self.host}/{self.database}"
            self.engine = sqlalchemy.create_engine(connection_string)
            print("Conexión exitosa a la base de datos")
        except sqlalchemy.exc.SQLAlchemyError as e:
            print(f"Error al conectar a la base de datos: {str(e)}")

    def execute_query(self, query):
        try:
            result = pd.read_sql(query, self.engine)
            return result
        except sqlalchemy.exc.SQLAlchemyError as e:
            print(f"Error al ejecutar la consulta: {str(e)}")

    def disconnect(self):
        if self.engine:
            self.engine.dispose()
            print("Conexión cerrada")
