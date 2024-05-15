import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


def compare_fuels(fuel1, fuel2):

    i = 1
    fuel1_new = fuel1[['Year', 'Make', 'Model']].copy()
    fuel1_new.loc[:, "Option"] = 1

    for index, row in fuel1_new.iterrows():
        fuel1_new.loc[index, "Option"] = i
        i += 1

    print("######################## OPCÃO 1 ########################")
    print(fuel1_new)

    car1_index = int(input(
        "Escolha o primeiro carro que pretende comparar (Digite o número correspondente na coluna 'Option'?): ")) - 1
    car1 = fuel1.iloc[car1_index]

    i = 1
    fuel2_new = fuel2[['Year', 'Make', 'Model']].copy()
    fuel2_new.loc[:, "Option"] = 1

    for index, row in fuel2_new.iterrows():
        fuel2_new.loc[index, "Option"] = i
        i += 1
    print("######################## OPCÃO 2 ########################")
    print(fuel2_new)

    car2_index = int(input(
        "Escolha o primeiro carro que pretende comparar (Digite o número correspondente na coluna 'Option'?): ")) - 1
    car2 = fuel2.iloc[car2_index]

    return car1, car2


def fuels(price_car, fuel_type, car):
    price_fuels = pd.read_csv('./modificated-data/fuels-price.csv', sep=',')
    price_fuels_2023 = price_fuels[price_fuels["Year"] == 2023]

    total_price_car = [price_car]
    if fuel_type == 'G':
        price_gasoline = float(
            price_fuels_2023["Gasoline 95 (euro/liter)"].values[0])
        consumption = float(car["Combined (F) (L/100 km)"])
        # Considerando que por mês o carro percorre 800km
        # Soma dos preço dos combustivel de ano em ano
        month_consumption = 10*consumption*price_gasoline
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(50):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    elif fuel_type == 'D':
        price_diesel = float(
            price_fuels_2023["Diesel (euro/liter)"].values[0])
        consumption = float(car["Combined (F) (L/100 km)"])
        month_consumption = 10*consumption*price_diesel
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(50):
            price_car = price_car + (year_price_comsumption*price_diesel)
            total_price_car.append(price_car)

    elif fuel_type == 'H':
        price_eletrics = float(
            price_fuels_2023["Electricity (euro/kWh)"].values[0])

        consumption_eletrics = float(car["Combined (E) (kWh/100 km)"])
        consumption_fossilfuel = float(car["Combined (F) (L/100 km)"])

        if car["Fuel Type 2"] == 'G':
            price_gasoline = float(
                price_fuels_2023["Gasoline 95 (euro/liter)"].values[0])
        else:
            price_gasoline = float(
                price_fuels_2023["Premium Gasoline (euro/liter)"].values[0])

        month_consumption_eletrics = 10*consumption_eletrics*price_eletrics
        month_consumption_fossilfuel = 10*consumption_fossilfuel*price_gasoline
        year_price_comsumption = (
            month_consumption_eletrics + month_consumption_fossilfuel)*12
        print(year_price_comsumption)
        for i in range(50):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    elif fuel_type == 'E':
        price_eletrics = float(
            price_fuels_2023["Electricity (euro/kWh)"].values[0])
        consumption = float(car["Combined (E) (kWh/100 km)"])
        month_consumption = 10*consumption*price_eletrics
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(50):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    else:
        price_gasoline = float(
            price_fuels_2023["Premium Gasoline (euro/liter)"].values[0])
        consumption = float(car["Combined (F) (L/100 km)"])
        month_consumption = 10*consumption*price_gasoline
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(50):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    return total_price_car


def find_intersections(x, y1, y2):
    intersections = []
    for i in range(len(x) - 1):
        if (y1[i] - y2[i]) * (y1[i+1] - y2[i+1]) < 0:
            # Encontrar a interseção por interpolação linear
            inter_x = x[i] + (x[i+1] - x[i]) * (y2[i] - y1[i]) / \
                ((y1[i+1] - y1[i]) - (y2[i+1] - y2[i]))
            inter_y = y1[i] + (inter_x - x[i]) * \
                (y1[i+1] - y1[i]) / (x[i+1] - x[i])
            intersections.append((inter_x, inter_y))
    return intersections


# Leitura dos dados
consumption_fossilfuel = pd.read_csv(
    './modificated-data/consumption-fossilfuels.csv', sep=',')

consumptio_hybrids = pd.read_csv(
    './modificated-data/consumption-hybrids.csv', sep=',')

consumption_eletrics = pd.read_csv(
    './modificated-data/consumption-eletrics.csv', sep=',')

fuel_price = pd.read_csv(
    './modificated-data/fuels-price.csv', sep=',')


# Filtrar apenas os carros que contemos dados sobre o preço
fossilfuel = consumption_fossilfuel[consumption_fossilfuel["Price (euros)"]
                                    != 0]
diesel = fossilfuel[fossilfuel["Fuel Type"] == "D"]
diesel = diesel.drop_duplicates(subset=['Year', 'Make', 'Model'])
gasoline = fossilfuel[fossilfuel["Fuel Type"] != "D"]
gasoline = gasoline.drop_duplicates(subset=['Year', 'Make', 'Model'])
hybrids = consumptio_hybrids[consumptio_hybrids["Price (euros)"] != 0]
hybrids = hybrids.drop_duplicates(subset=['Year', 'Make', 'Model'])
eletrics = consumption_eletrics[consumption_eletrics["Price (euros)"] != 0]
eletrics = eletrics.drop_duplicates(subset=['Year', 'Make', 'Model'])


# Escolha dos combustíveis a comparar
option1 = 0
option2 = 0
while (option1 < 1 or option1 > 4) or (option2 < 1 or option2 > 4) or (option1 == option2):
    print("Que carros pretende comparar (os carros tem que ter combustivel diferente) ?")
    print("1 - Gasolina")
    print("2 - Gasóleo")
    print("3 - Híbrido")
    print("4 - Elétrico")
    option1 = int(input("Opção1: "))
    option2 = int(input("Opção2: "))

    if (option1 < 1 or option1 > 4) or (option2 < 1 or option2 > 4) or (option1 == option2):
        print("Opção Indisponível")

options_mapping = {
    "2": (gasoline, diesel),
    "3": (gasoline, hybrids),
    "4": (gasoline, eletrics),
    "6": (diesel, hybrids),
    "8": (diesel, eletrics),
    "12": (hybrids, eletrics)
}

option_sum = str(option1 * option2)
fuel1, fuel2 = options_mapping[option_sum]
car1, car2 = compare_fuels(fuel1, fuel2)
print(car1, car2)

price_car1 = car1.loc["Price (euros)"]
price_car2 = car2.loc["Price (euros)"]

if option1 == 3:
    fuel_type_car1 = 'H'
else:
    fuel_type_car1 = car1.loc["Fuel Type"]

if option2 == 3:
    fuel_type_car2 = 'H'
else:
    fuel_type_car2 = car2.loc["Fuel Type"]


total_price_car1 = fuels(price_car1, fuel_type_car1, car1)
total_price_car2 = fuels(price_car2, fuel_type_car2, car2)

make_car1 = car1.loc["Make"]
model_car1 = car1.loc["Model"]

make_car2 = car2.loc["Make"]
model_car2 = car2.loc["Model"]

months = []
for i in range(51):
    number = i
    months.append(number)

if (fuel_type_car1 == "G") or (fuel_type_car1 == "PG"):
    color_car1 = (245/255, 191/255, 76/255)
elif fuel_type_car1 == "D":
    color_car1 = (245/255, 140/255, 76/255)
elif fuel_type_car1 == "H":
    color_car1 = (12/255, 124/255, 250/255)
elif fuel_type_car1 == "E":
    color_car1 = (120/255, 200/255, 250/255)

if (fuel_type_car2 == "G") or (fuel_type_car2 == "PG"):
    color_car2 = (245/255, 191/255, 76/255)
elif fuel_type_car2 == "D":
    color_car2 = (245/255, 140/255, 76/255)
elif fuel_type_car2 == "H":
    color_car2 = (12/255, 124/255, 250/255)
elif fuel_type_car2 == "E":
    color_car2 = (120/255, 200/255, 250/255)

print(total_price_car1, total_price_car2, months)

# Criar gráfico de linhas com evolução dos custos para o utilizador
plt.plot(months, total_price_car1, color=color_car1,
         label=f"{fuel_type_car1}:{make_car1}({model_car1})")
plt.plot(months, total_price_car2, color=color_car2,
         label=f"{fuel_type_car2}:{make_car2}({model_car2})")

plt.title('Evolução dos Custos para o Utilizador',
          fontdict={'fontsize': 20, 'fontweight': 'bold'})
plt.ylabel('Custos em euros (Preço Inicial + Preço Combustíveis)')
plt.xlabel('Anos')
plt.ticklabel_format(axis='y', style='plain')
plt.xticks(fontsize=8, color='black')
plt.legend(title='Carros')


# Converter os meses para índices numéricos para cálculo
intersections = find_intersections(months, total_price_car1, total_price_car2)

# Anotar interseções no gráfico
for inter_x, inter_y in intersections:
    month_index = int(round(inter_x))
    if month_index < len(months):
        month_label = months[month_index]
        plt.annotate(f'Abate após {month_label} anos',
                     (inter_x, inter_y),
                     textcoords="offset points",
                     xytext=(0, 10),
                     ha='center',
                     fontsize=10,
                     fontweight='bold',
                     color='#43CD80')
        plt.scatter(inter_x, inter_y, color='#43CD80')

plt.show()
