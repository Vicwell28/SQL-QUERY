import json
import matplotlib.pyplot as plt

# Leer los datos del archivo JSON
with open('datos.json', 'r') as file:
    data = json.load(file)

# Crear una figura y ejes para la gráfica
fig, ax = plt.subplots()

# Iterar sobre los datos y crear un plot para cada serie
for item in data:
    name = item['name']
    series = item['series']
    values = [entry['value'] for entry in series]
    dates = [entry['name'] for entry in series]

    ax.plot(dates, values, label=name)

# Personalizar la gráfica
ax.set_xlabel('Fecha')
ax.set_ylabel('Valor')
ax.set_title('Datos por país')
ax.legend()

# Rotar las etiquetas del eje x para mayor legibilidad
plt.xticks(rotation=45)

# Mostrar la gráfica
plt.show()
