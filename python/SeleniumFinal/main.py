from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd
from urllib.parse import urlparse
import json

class WebScraper:
    def __init__(self, config_file):
        self.config_file = self.load_config(config_file)
        self.driver = webdriver.Chrome()
        self.result_list = []

        for page in self.config_file:
            self.driver = webdriver.Chrome()
            self.scrape_page(page['url'], page)
            self.close()

    def load_config(self, config_file):
        with open(config_file, 'r') as json_file:
            return json.load(json_file)

    def scrape_page(self, url, page):
        self.result_list.clear()
        self.driver.get(url)
        self.driver.implicitly_wait(5.0)

        paginators = self.driver.find_elements(
            By.CSS_SELECTOR, page['pagination_class'])

        for index, paginator in enumerate(paginators):
            try:
                if index != 0: 
                    paginator.click()
                    
                items_to_search = self.driver.find_elements(By.CSS_SELECTOR, page['header_list_items_class'])

                for item in items_to_search:
                    item_dict = {}
                    for key, value in page['body_list_item_class'].items():
                        try:
                            inner_element = item.find_element(
                                By.CSS_SELECTOR, value)
                            item_dict[key] = inner_element.text
                        except:
                            continue
                    self.result_list.append(item_dict)
            except:
                continue

        host = urlparse(url).hostname

        self.export_to_json(self.result_list, f"{host}_{page['search']['to_search']}.json")
        self.export_to_excel(self.result_list, f"{host}_{page['search']['to_search']}.xlsx")

    def export_to_json(self, data, filename):
        df = pd.DataFrame(data)
        with open(filename, 'w', encoding='utf-8') as file:
            df.to_json(file, orient='index', force_ascii=False)

    def export_to_excel(self, data, filename):
        df = pd.DataFrame(data)
        df.to_excel(filename, index=False)

    def close(self):
        self.driver.quit()


if __name__ == '__main__':
    web_scraper = WebScraper('config.json')
    web_scraper.close()
