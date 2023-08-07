from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd
from urllib.parse import urlparse

class WebScraper:
    def __init__(self):
        self.driver = webdriver.Chrome()  

    def scrape_page(self, url):
        self.driver.get(url)
        table_elements = self.driver.find_elements(By.TAG_NAME, "table")
        for index, table_element in enumerate(table_elements):
            table_data = self.extract_table_data(table_element)
            if table_data:
                host = urlparse(url).hostname
                filename = f"{host}_table_{index}.json"
                self.export_to_json(table_data, filename)


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


    def export_to_json(self, data, filename):
        df = pd.DataFrame(data)
        with open(filename, 'w', encoding='utf-8') as file:
            df.to_json(file, orient="index", force_ascii=False)


    def export_to_excel(self, data, filename):
        df = pd.DataFrame(data)
        df.to_excel(filename, index=False)


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


