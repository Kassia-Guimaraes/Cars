import pandas as pd
import matplotlib.pyplot as plt


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
        month_consumption = 8*consumption*price_gasoline
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(100):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    elif fuel_type == 'D':
        price_diesel = float(
            price_fuels_2023["Diesel (euro/liter)"].values[0])
        consumption = float(car["Combined (F) (L/100 km)"])
        month_consumption = 8*consumption*price_diesel
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(100):
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

        month_consumption_eletrics = 8*consumption_eletrics*price_eletrics
        month_consumption_fossilfuel = 8*consumption_fossilfuel*price_gasoline
        year_price_comsumption = (
            month_consumption_eletrics + month_consumption_fossilfuel)*12
        print(year_price_comsumption)
        for i in range(100):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    elif fuel_type == 'E':
        price_eletrics = float(
            price_fuels_2023["Electricity (euro/kWh)"].values[0])
        consumption = float(car["Combined (E) (kWh/100 km)"])
        month_consumption = 8*consumption*price_eletrics
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(100):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    else:
        price_gasoline = float(
            price_fuels_2023["Premium Gasoline (euro/liter)"].values[0])
        consumption = float(car["Combined (F) (L/100 km)"])
        month_consumption = 8*consumption*price_gasoline
        year_price_comsumption = month_consumption*12
        print(year_price_comsumption)
        for i in range(100):
            price_car = price_car + year_price_comsumption
            total_price_car.append(price_car)

    return total_price_car


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
for i in range(101):
    number = i
    months.append(number)

print(total_price_car1, total_price_car2, months)

# Criar gráfico de linhas com evolução dos custos para o utilizador
plt.plot(months, total_price_car1, color="blue",
         label=f"{fuel_type_car1}:{make_car1}({model_car1})")
plt.plot(months, total_price_car2, color="orange",
         label=f"{fuel_type_car2}:{make_car2}({model_car2})")

plt.title('Evolução dos Custos para o Utilizador')
plt.ylabel('Custos (euros)')
plt.ticklabel_format(axis='y', style='plain')
plt.xticks(rotation=45, fontsize=8, color='black')
plt.legend(title='Meses')

plt.show()
