# A continuación, te mostraré un ejemplo de cómo estructurar un programa orientado a objetos con Selenium para extraer información de etiquetas de `<table>` en una serie de páginas web y luego procesarla con pandas para su posterior exportación en formato Excel o JSON. Para este ejemplo, asumiremos que estamos extrayendo información de una tabla de datos simple en cada página web.

# Primero, asegúrate de tener Selenium y pandas instalados en tu entorno de Python. Puedes instalarlos utilizando pip:

# ```
# pip install selenium pandas
# ```

# Ahora, aquí está el código orientado a objetos:

# ```python
from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd
from urllib.parse import urlparse


# 1. Creamos una clase `WebScraper` que se encargará de todo el proceso de raspado y procesamiento de datos.
class WebScraper:
    # 2. En el constructor `__init__`, inicializamos el controlador de Selenium y una lista `data` que almacenará los datos extraídos.
    def __init__(self):
        self.driver = webdriver.Chrome()
        self.data = []

# 3. La función `scrape_page` toma una URL como entrada y extrae la información de la tabla de esa página. Luego, llama a `extract_table_data` para procesar los datos de la tabla.
    def scrape_page(self, url):
        #VALIDAR SI ES UNA RUTA DE GOBIERNO PARA AHCER TODO EL PROCESO DE LLENAR LA INFORACION
        self.driver.get(url)
        table_elements = self.driver.find_elements(By.TAG_NAME, "table")
        for table_element in table_elements:
            table_data = self.extract_table_data(table_element)
            if table_data:
                self.data.append(table_data)

# 4. La función `extract_table_data` toma un elemento de tabla y extrae los datos de las filas y columnas. Luego, retorna una lista con los datos procesados.
    def extract_table_data(self, table_element):
        headers = table_element.find_elements(By.TAG_NAME, "th")
        rows = table_element.find_elements(By.TAG_NAME, "tr")
        if not headers or not rows:
            return None

        data = []
        for row in rows:
            row_data = [cell.text for cell in row.find_elements(By.TAG_NAME, "td")]
            data.append(row_data)

        return data

# 5. `export_to_excel` y `export_to_json` toman la lista `data`, la convierten en un DataFrame de pandas y la exportan a un archivo Excel o JSON, respectivamente.
    def export_to_excel(self, filename):
        df = pd.DataFrame(self.data)
        df.to_excel(filename, index=False)

    def export_to_json(self, filename):
        df = pd.DataFrame(self.data)
        df.to_json(filename, orient="records")

    def close(self):
        self.driver.quit()

# 6. El ejemplo de uso muestra cómo usar la clase `WebScraper` para extraer datos de una lista de URLs y luego exportarlos a Excel y JSON.
# Ejemplo de uso
if __name__ == "__main__":
    urls = ["https://es.wikipedia.org/wiki/Anexo:Pa%C3%ADses_y_territorios_dependientes_por_poblaci%C3%B3n", "https://www.cre.gob.mx/ConsultaPrecios/GasolinasyDiesel/GasolinasyDiesel.html"]

    for url in urls:
        web_scraper = WebScraper()
        web_scraper.scrape_page(url)
        host = urlparse(url).hostname
        web_scraper.export_to_excel(f"{host}.xlsx")
        web_scraper.export_to_json(f"{host}.json")
        web_scraper.close()

    
# ```

# Explicación del código:

# Recuerda que este es solo un ejemplo básico. En una situación real, puede que necesites adaptar el código según la estructura de las páginas web y las tablas que estás raspando. También, ten en cuenta que es posible que algunos sitios web tengan restricciones para el rascado, así que siempre asegúrate de cumplir con las políticas del sitio antes de utilizar Selenium para extraer información.



# Por ejemplo quiero hacer un programa orientado a objecto con Selenium, muestrame como seria el codigo orientado a objectos, donde yo pase una serie de paginas y esta me extraigan la informacion de etiquetas de <table>, me debe de extrar esta informacion y luego procesarla con pandas para darle forma para su despues exportacion ya sea en excel o json






# Selenium es una herramienta de automatización web que se puede utilizar en una amplia variedad de sitios web para extraer información de tablas y procesarla. Puedes utilizar Selenium en casi cualquier página web que necesite automatización, siempre que no viole los términos de servicio o las políticas del sitio web.

# Algunas páginas web recomendadas donde puedes utilizar Selenium para extraer información de tablas y procesarla incluyen:

# 1. Wikipedia: Puedes utilizar Selenium para extraer datos de tablas con información detallada sobre temas específicos.
# 2. Sitios de noticias: Puedes automatizar la extracción de datos de tablas con información actualizada sobre eventos o noticias importantes.
# 3. Sitios de comercio electrónico: Selenium te permite extraer datos de tablas de productos, precios y reseñas.
# 4. Sitios gubernamentales: Puedes obtener información de tablas relacionadas con datos públicos, estadísticas, etc.
# 5. Redes sociales: Puedes utilizar Selenium para extraer información de tablas en perfiles de usuarios o páginas de negocios.

# Recuerda que al utilizar Selenium para extraer información de sitios web, debes asegurarte de cumplir con las políticas y términos de servicio del sitio web en cuestión. Algunos sitios pueden tener restricciones o medidas anti-rascado (scraping) que debes tener en cuenta. Es importante actuar de manera ética y respetar la privacidad y los derechos de autor de los sitios web que estás automatizando.