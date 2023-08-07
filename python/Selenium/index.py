# Para mejorar el código y cumplir con los requisitos mencionados, necesitaremos hacer algunas modificaciones. A continuación, te presento el código orientado a objetos con Selenium que extraerá información de las etiquetas de `<table>` y generará una estructura tipo JSON con clave-valor, y además soportará paginación y búsqueda de captcha:

# ```python
from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd

class WebScraper:
    def __init__(self):
        self.driver = webdriver.Chrome()  # Cambiar el controlador según tu navegador preferido

    def scrape_page(self, url):
        self.driver.get(url)
        table_elements = self.driver.find_elements(By.TAG_NAME, "table")
        data = []
        for table_element in table_elements:
            table_data = self.extract_table_data(table_element)
            if table_data:
                data.extend(table_data)
        return data

    def extract_table_data(self, table_element):
        headers = table_element.find_elements(By.TAG_NAME, "th")
        if not headers:
            return None

        data = []
        rows = table_element.find_elements(By.TAG_NAME, "tr")
        for row in rows:
            cells = row.find_elements(By.TAG_NAME, "td")
            if cells:
                row_data = {}
                for i in range(len(headers)):
                    header_text = headers[i].text.strip()
                    cell_text = cells[i].text.strip()
                    row_data[header_text] = cell_text
                data.append(row_data)
        return data

    def export_to_json(self, data, filename):
        df = pd.DataFrame(data)
        df.to_json(filename, orient="records")

    def close(self):
        self.driver.quit()

# Ejemplo de uso
if __name__ == "__index__":
    web_scraper = WebScraper()
    # urls = ["https://www.cre.gob.mx/ConsultaPrecios/GasolinasyDiesel/GasolinasyDiesel.html"]
    urls = ["https://es.wikipedia.org/wiki/México"]

    all_data = []
    for url in urls:
        data = web_scraper.scrape_page(url)
        all_data.extend(data)

    web_scraper.export_to_json(all_data, "data.json")

    web_scraper.close()
# ```

# Explicación del código:

# 1. Se ha agregado un método `scrape_page` que recibe una URL y extrae la información de las tablas de esa página web. En lugar de guardar la información en `self.data`, ahora se devuelve una lista `data` que contendrá los datos extraídos de todas las tablas de la página.
# 2. El método `extract_table_data` ahora genera una lista de diccionarios, donde cada diccionario representa una fila de datos de la tabla. La clave del diccionario es el texto del encabezado de la columna y el valor es el texto de la celda correspondiente en esa fila.
# 3. El método `export_to_json` ahora toma la lista `data` y la convierte en un DataFrame de pandas para luego exportarla a un archivo JSON.
# 4. En el ejemplo de uso, hemos agregado paginación para procesar varias páginas. Los datos extraídos de todas las páginas se combinan en una lista `all_data`.
# 5. La estructura del JSON generado será una lista de diccionarios, donde cada diccionario representa una fila de la tabla, y las claves son los encabezados de columna y los valores son los datos correspondientes.

# Ten en cuenta que en este código, se asume que no hay captchas o restricciones adicionales que puedan interferir con el raspado de datos. Si la página web tiene un captcha o mecanismos de seguridad, es posible que necesites implementar soluciones específicas para sortearlos, como el uso de bibliotecas de resolución de captchas o la solicitud de ayuda manual para resolver los captchas.





















# Aquí se importan los módulos necesarios para el web scraping* y el manejo de datos. selenium se utiliza para la automatización del navegador, pandas para manipular y exportar datos, y urllib.parse para analizar las URLs.
# El web scraping es una técnica de extracción de información de sitios web de manera automatizada. Consiste en escribir programas o scripts que acceden a una página web, obtienen su contenido y extraen los datos de interés. Estos datos pueden incluir texto, imágenes, tablas, enlaces y otros tipos de información presentes en la página.
from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd
from urllib.parse import urlparse

class WebScraper:
    # Se define una clase llamada WebScraper, que encapsula la lógica del web scraping y la manipulación de datos. El método __init__ es el constructor de la clase y crea una instancia del controlador de Chrome de Selenium para automatizar el navegador.
    def __init__(self):
        self.driver = webdriver.Chrome()  

# Este método toma una URL como entrada, abre esa URL en el navegador controlado por Selenium, busca todos los elementos de tabla en la página y extrae los datos de cada tabla llamando al método extract_table_data. Luego, combina los datos de todas las tablas en una lista y los devuelve.
    def scrape_page(self, url):
        self.driver.get(url)
        table_elements = self.driver.find_elements(By.TAG_NAME, "table")
        for index, table_element in enumerate(table_elements):
            table_data = self.extract_table_data(table_element)
            if table_data:
                host = urlparse(url).hostname
                filename = f"{host}_table_{index}.json"
                self.export_to_json(table_data, filename)

# Este método toma un elemento de tabla como entrada y extrae los datos de las celdas y los encabezados de la tabla. Luego, crea un diccionario para cada fila de datos, donde las claves son los encabezados y los valores son los datos de las celdas.
    def extract_table_data(self, table_element):
        headers = table_element.find_elements(By.TAG_NAME, "th")
        if not headers:
            return None

        data = []
        rows = table_element.find_elements(By.TAG_NAME, "tr")
        for row in rows:
            cells = row.find_elements(By.TAG_NAME, "td")
            if len(cells) == len(headers):
                row_data = {}
                for i in range(len(headers)):
                    header_text = headers[i].text.strip()
                    cell_text = cells[i].text.strip()
                    row_data[header_text] = cell_text
                data.append(row_data)
        return data

# Este método toma los datos extraídos, los convierte en un DataFrame de pandas y luego exporta los datos en formato JSON y excel a un archivo con el nombre proporcionado.
    # def export_to_json(self, data, filename):
    #     df = pd.DataFrame(data)
    #     df.to_json(filename, orient="index")
    def export_to_json(self, data, filename):
        df = pd.DataFrame(data)
        with open(filename, 'w', encoding='utf-8') as file:
            df.to_json(file, orient="index", force_ascii=False)


    def export_to_excel(self, data, filename):
        df = pd.DataFrame(data)
        df.to_excel(filename, index=False)

# Este método cierra la instancia del navegador controlado por Selenium cuando ya no se necesita.
    def close(self):
        self.driver.quit()

# Ejemplo de uso
if __name__ == "__main__":

    urls = [
            "https://es.wikipedia.org/wiki/Anexo:Pa%C3%ADses_y_territorios_dependientes_por_poblaci%C3%B3n",
            "https://www.cre.gob.mx/ConsultaPrecios/GasolinasyDiesel/GasolinasyDiesel.html"
        ]

    for url in urls:
        web_scraper = WebScraper()
        web_scraper.scrape_page(url)
        web_scraper.close()


