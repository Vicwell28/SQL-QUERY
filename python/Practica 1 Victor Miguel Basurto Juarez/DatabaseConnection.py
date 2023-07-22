# 1. Importaciones:
#    - Se importa la biblioteca Pandas con el nombre abreviado "pd". Pandas es una biblioteca popular para el análisis de datos en Python.
#    - Se importa el módulo "sqlalchemy" para establecer la conexión con la base de datos.
import pandas as pd
import sqlalchemy

# 2. Definición de la clase DatabaseConnection:
#    - La clase DatabaseConnection tiene métodos para establecer la conexión con la base de datos, ejecutar consultas y cerrar la conexión.
class DatabaseConnection:
#    - El método `__init__` inicializa los atributos de la clase, como el host de la base de datos, el nombre de usuario, la contraseña y el nombre de la base de datos.
    def __init__(self):
        self.host = "127.0.0.1"
        self.user = "root"
        self.password = ""
        self.engine = None
        self.database = "northwind"

#    - El método `connect` establece la conexión con la base de datos utilizando los datos proporcionados.
    def connect(self):
        try:
            connection_string = f"mysql+pymysql://{self.user}:{self.password}@{self.host}/{self.database}"
            self.engine = sqlalchemy.create_engine(connection_string)
            print("Conexión exitosa a la base de datos")
        except sqlalchemy.exc.SQLAlchemyError as e:
            print(f"Error al conectar a la base de datos: {str(e)}")

#    - El método `execute_query` ejecuta una consulta SQL en la base de datos y devuelve los resultados como un DataFrame de Pandas.
    def execute_query(self, query):
        try:
            result = pd.read_sql(query, self.engine)
            return result
        except sqlalchemy.exc.SQLAlchemyError as e:
            print(f"Error al ejecutar la consulta: {str(e)}")

#    - El método `disconnect` cierra la conexión con la base de datos.
    def disconnect(self):
        if self.engine:
            self.engine.dispose()
            print("Conexión cerrada")
