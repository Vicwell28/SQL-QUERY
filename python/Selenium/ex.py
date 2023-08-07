# Introducción

# Selenium es un proyecto que permite automatizar navegadores. Está principalmente enfocado al testeo de aplicaciones web pero también permite desarrollar potentes flujos de trabajo como es el caso de las técnicas de scraping. 1

# Existen múltiples «bindings»2 pero el que nos ocupa en este caso es el de Python:

# Selenium es un conjunto de herramientas y bibliotecas diseñadas para automatizar navegadores web. Ofrece diferentes componentes para adaptarse a diversas necesidades de automatización:

# En resumen, Selenium es un conjunto de herramientas poderosas para automatizar navegadores web y, con su componente WebDriver, puedes controlar eficientemente los navegadores y escribir pruebas automatizadas para mejorar tu proceso de desarrollo de software.


# Escriba su primer script de Selenium

# Todo lo que hace Selenium es enviar comandos al navegador para hacer algo o enviar solicitudes de información. La mayor parte de lo que hará con Selenium es una combinación de estos comandos básicos:
from selenium import webdriver
from selenium.webdriver.common.by import By


def test_eight_components():
    driver = webdriver.Chrome()

    driver.get("https://www.selenium.dev/selenium/web/web-form.html")

    title = driver.title
    assert title == "Web form"

    driver.implicitly_wait(0.5)

    text_box = driver.find_element(by=By.NAME, value="my-text")
    submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")

    text_box.send_keys("Selenium")
    submit_button.click()

    message = driver.find_element(by=By.ID, value="message")
    value = message.text
    assert value == "Received!"

    driver.quit()

test_eight_components()



# El código proporcionado utiliza la biblioteca Selenium para realizar pruebas automatizadas en un formulario web. Explicaremos paso a paso lo que hace este código:

# 1. Importar las bibliotecas necesarias:

# ```
# from selenium import webdriver
# from selenium.webdriver.common.by import By
# ```

# Aquí, importamos las clases `webdriver` y `By` de la biblioteca Selenium. Estas clases nos permiten controlar el navegador y ubicar elementos en la página web mediante diferentes estrategias de localización, como nombre, selector CSS, ID, etc.

# 2. Definir la función de prueba:

# ```
# def test_eight_components():
# ```

# En este paso, definimos una función llamada `test_eight_components()` que contendrá nuestro código de prueba.

# 3. Inicializar el controlador del navegador:

# ```
# driver = webdriver.Chrome()
# ```

# Aquí, creamos una instancia del controlador del navegador Chrome utilizando `webdriver.Chrome()`. Esto abrirá una nueva ventana del navegador Chrome que utilizaremos para interactuar con la página web.

# 4. Abrir una página web:

# ```
# driver.get("https://www.selenium.dev/selenium/web/web-form.html")
# ```

# Usando el controlador del navegador, cargamos la página web "https://www.selenium.dev/selenium/web/web-form.html" en la ventana del navegador.

# 5. Obtener el título de la página:

# ```
# title = driver.title
# assert title == "Web form"
# ```

# Capturamos el título de la página utilizando `driver.title` y luego comprobamos que el título sea igual a "Web form" utilizando una afirmación (`assert`). Si el título no coincide, la prueba fallará.

# 6. Espera implícita:

# ```
# driver.implicitly_wait(0.5)
# ```

# Aquí, establecemos una espera implícita de 0.5 segundos. Esto significa que el controlador del navegador esperará hasta 0.5 segundos antes de lanzar una excepción si no puede encontrar un elemento en la página. Esto ayuda a lidiar con problemas de tiempo de carga de la página o elementos que pueden tardar un poco en aparecer en la página.

# 7. Encontrar elementos en la página:

# ```
# text_box = driver.find_element(by=By.NAME, value="my-text")
# submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")
# ```

# Utilizamos `driver.find_element()` para localizar elementos en la página. En este caso, buscamos un cuadro de texto por su atributo de nombre (`NAME`) "my-text" y un botón de envío (submit) utilizando un selector CSS "button".

# 8. Interactuar con los elementos:

# ```
# text_box.send_keys("Selenium")
# submit_button.click()
# ```

# Usamos `text_box.send_keys()` para ingresar el texto "Selenium" en el cuadro de texto encontrado. Luego, llamamos a `submit_button.click()` para hacer clic en el botón de envío.

# 9. Verificar el resultado:

# ```
# message = driver.find_element(by=By.ID, value="message")
# value = message.text
# assert value == "Received!"
# ```

# Encontramos el elemento con el ID "message" y obtenemos su texto utilizando `message.text`. Luego, verificamos que el texto sea igual a "Received!" utilizando otra afirmación (`assert`). Si el texto no coincide, la prueba fallará.

# 10. Cerrar el navegador:

# ```
# driver.quit()
# ```

# Finalmente, cerramos el navegador y finalizamos la prueba.

# 11. Ejecutar la prueba:

# ```
# test_eight_components()
# ```

# Llamamos a la función `test_eight_components()` para ejecutar la prueba completa.

# En resumen, este código automatiza una prueba donde se ingresa el texto "Selenium" en un cuadro de texto y se hace clic en un botón de envío. Luego, verifica si se muestra el mensaje "Received!" en la página web. Si todo funciona correctamente, la prueba se ejecutará sin errores. De lo contrario, se generarán afirmaciones (`assertions`) para identificar dónde falló la prueba.


# La guía proporcionada explica cómo actualizar de Selenium 3 a Selenium 4, destacando los cambios y pasos necesarios para lograr una actualización exitosa. Aquí se detallan los puntos más importantes de la guía:

# 1. Preparando el código de prueba:
#    Selenium 4 elimina la compatibilidad con el protocolo heredado y utiliza el estándar W3C WebDriver de forma predeterminada. Se mencionan dos cambios importantes:
#    - Capacidades: Se deben actualizar las capacidades de prueba para que cumplan con las capacidades estándar de W3C WebDriver. Las capacidades específicas del navegador o del proveedor de la nube deben incluir un prefijo de proveedor.
#    - Métodos de utilidad de elementos en Java: Los métodos de utilidad para encontrar elementos en Java (interfaces `FindsBy`) han sido eliminados y se deben usar métodos alternativos.

# 2. Actualizar dependencias:
#    Se proporcionan instrucciones para actualizar las dependencias de Selenium en diferentes lenguajes de programación:
#    - Java: Cambiar la versión de Selenium en el archivo de configuración `pom.xml` o `build.gradle`.
#    - C#: Actualizar el paquete de Selenium a través del Administrador de paquetes NuGet.
#    - Python: Asegurarse de tener Python 3.7 o superior y actualizar Selenium mediante el comando `pip`.
#    - Ruby: Actualizar la gema `selenium-webdriver` a través de RubyGems.
#    - JavaScript: Actualizar el paquete `selenium-webdriver` a través de npm.

# 3. Posibles errores y mensajes de desaprobación:
#    Se enumeran algunos ejemplos de posibles errores que pueden surgir después de la actualización y cómo solucionarlos:
#    - Java: Cambios en las esperas y métodos de combinación de capacidades.
#    - C#: Uso de `AddAdditionalCapability` obsoleto en favor de `AddAdditionalOption`.
#    - Python: Cambiar la configuración del controlador `executable_path` utilizando un objeto de servicio.
   
# En resumen, la guía proporciona una visión general de los cambios y pasos necesarios para actualizar a Selenium 4, lo que garantiza que las pruebas automatizadas sigan funcionando correctamente con la versión más reciente de Selenium. Se hace hincapié en la importancia de seguir las recomendaciones y abordar los posibles problemas para asegurar una transición exitosa.