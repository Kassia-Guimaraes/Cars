import pandas as pd
import numpy as np

# fuel prices
fuels_price = pd.read_csv('C:\Users\vanes\OneDrive\Desktop\LE\aulas.py\CO2_ProjectShared\initial-data\fuel-prices.csv', sep=',')

fuels_price = fuels_price.rename(columns={'Anos': 'Year',
                                          'Gasolina Super com Chumbo ou Aditivada (Euro/litro)': 'Premium Gasoline (euro/liter)',
                                          'Gasolina sem chumbo I.O.95 (Euro/litro)': 'Gasoline 95 (euro/liter)',
                                          'Gasolina sem chumbo I.O.98 (Euro/litro)': 'Gasoline 98 (euro/liter)',
                                          'Gasolina Normal (Euro/litro)': 'Regular Gasoline (euro/liter)',
                                          'Gasóleo Rodoviário (Euro/litro)': 'Diesel (euro/liter)',
                                          'Fuelóleo (Euro/kg)': 'Heating Oil (euro/kg)',
                                          'Butano Garrafas (Euro/kg)': 'Butane Bottles (euro/kg)',
                                          'Propano Garrafas (Euro/kg)': 'Propane Bottles (euro/kg)',
                                          'Propano Canalizado (Euro/kg)': 'Piped Propane with lead (euro/kg)'})

fuels_price = fuels_price.drop(
    ['Regular Gasoline (euro/liter)'], axis=1)  # coluna toda vazia

for column_name in fuels_price.columns.tolist():
    fuels_price[column_name] = fuels_price[column_name].fillna(
        round(fuels_price[column_name].mean(), 3))

electricity_price = pd.read_csv(
    './initial-data/electricity-price.csv', sep=',')

fuels_price['Electricity (euro/kWh)'] = electricity_price['Eletricidade (euro/kWh)']

fuels_price.to_csv('./modificated-data/fuels-price.csv', index=False)


# consumptions eletrics
eletrics = pd.read_csv('./initial-data/consumption-eletrics.csv', sep=',')

eletrics = eletrics.rename(columns={'Model year': 'Year',
                                    'City (kWh/100 km)': 'City (E) (kWh/100 km)',
                                    'Highway (kWh/100 km)': 'Highway (E) (kWh/100 km)',
                                    'Combined (kWh/100 km)': 'Combined (E) (kWh/100 km)',
                                    'City (Le/100 km)': 'City (E) (Le/100 km)',
                                    'Highway (Le/100 km)': 'Highway (E) (Le/100 km)',
                                    'Combined (Le/100 km)': 'Combined (E) (Le/100 km)',
                                    'Motor (kW)': 'Engine Power (kW)'
                                    })

# sobreposição de dados, uma vez que já temos estas informações
eletrics = eletrics.drop(['_id', 'CO2 emissions (g/km)',
                         'CO2 rating', 'Smog rating', 'Transmission'], axis=1)

eletrics = eletrics.rename(columns={'Fuel type':'Fuel Type'})

eletrics = eletrics[(eletrics['Year'] >= 2018) &
                    # deixar apenas nos anos 2018 - 2022
                    (eletrics['Year'] <= 2022)]

eletrics['Fuel Type'] = eletrics['Fuel Type'].replace(
    ['B'], ['E'])  # trocar b por e = eletric

eletrics.to_csv('./modificated-data/consumption-eletrics.csv', index=False)


# consumptions hybrids
hybrids = pd.read_csv('./initial-data/consumption-hydrids.csv', sep=',')

hybrids = hybrids.rename(columns={'Fuel type 1':'Fuel Type 1', 'Fuel type 2':'Fuel Type 2'})


hybrids['Fuel Type 1'] = hybrids['Fuel Type 1'].replace(
    # renomeado linhas com siglas
    ['B/Z', 'B/Z*', 'B/X*', 'B/X', 'B'], ['E/PG', 'E/PG*', 'E/G*', 'E/G', 'E'])

hybrids[['Combined Le/100 km', 'Combined calculus/100 km']
        # split da coluna com Le/100km
        ] = hybrids['Combined Le/100 km'].str.split('(', expand=True)

hybrids[['Combined kWh/100 km', 'Combined L/100 km']] = hybrids['Combined calculus/100 km'].str.split(
    # split da coluna calculus que tinha as informações da soma dos litros e kWh
    'kWh', expand=True)

# excluindo a coluna calculus que só serviu para separar a coluna principal
hybrids = hybrids.drop(columns={'Combined calculus/100 km'}, axis=1)

# ajustando linhas com estado + num L/100km e deixando para os litros
hybrids['Combined L/100 km'] = hybrids['Combined L/100 km'].str.extract(
    r'\+\s*([\d\.]+)')

# ajustando linhas com estado [num e deixando apenas o número
hybrids['Combined kWh/100 km'] = hybrids['Combined kWh/100 km'].str.replace(
    r'\[', '', regex=True)

# excluindo os espaços vazios depois dos nomes
hybrids = hybrids.apply(lambda x: x.str.strip() if x.dtype == 'object' else x)

hybrids = hybrids.drop(['_id', 'CO2 emissions (g/km)', 'CO2 rating', 'Smog rating', 'Cylinders',
                       # sobreposição de dados, uma vez que já temos estas informações
                        'Transmission'], axis=1)

hybrids = hybrids.rename(columns={'Model year': 'Year'})

# deixar apenas nos anos 2018 - 2022
hybrids = hybrids[(hybrids['Year'] >= 2018) & (hybrids['Year'] <= 2022)]

hybrids['Fuel Type 2'] = hybrids['Fuel Type 2'].replace(
    ['X', 'Z'], ['G', 'PG'])  # trocar b por e = eletric

hybrids = hybrids[['Year', 'Make', 'Model', 'Vehicle class', 'Motor (kW)', 'Engine size (L)', 'Fuel Type 1', 'Combined Le/100 km', 'Combined kWh/100 km',
                   'Combined L/100 km', 'Range 1 (km)', 'Recharge time (h)', 'Fuel Type 2', 'City (L/100 km)', 'Highway (L/100 km)', 'Combined (L/100 km)', 'Range 2 (km)']]

hybrids['Engine size (L)'] = hybrids['Engine size (L)']*1000

hybrids = hybrids.rename(columns={'Combined Le/100 km': 'Combined (E) (Le/100 km)',
                                  'Combined L/100 km': 'Combined (E) (L/100 km)',
                                  'Combined kWh/100 km': 'Combined (E) (kWh/100 km)',
                                  'City (L/100 km)': 'City (F) (L/100 km)',
                                  'Highway (L/100 km)': 'Highway (F) (L/100 km)',
                                  'Combined (L/100 km)': 'Combined (F) (L/100 km)',
                                  'Engine size (L)': 'Engine Capacity (cm3)',
                                  'Motor (KW)': 'Engine Power (kW)'})

hybrids = hybrids.sort_values(by='Year')

# os hibridos que utilizam parte 100% eletrica
hybrids['Combined (E) (L/100 km)'] = hybrids['Combined (E) (L/100 km)'].fillna(0)

hybrids.to_csv('./modificated-data/consumption-hybrids.csv', index=False)


# consumptions fossil fuels
fossil_fuels = pd.read_csv(
    './initial-data/consumption-fossilfuels.csv', sep=',')

fossil_fuels = fossil_fuels.drop(["CO2 emissions g/km", "CO2 rating", "Smog rating", 'Transmission',
                                 # sobreposição de dados, uma vez que já temos estas informações
                                  'Combined mpg', 'Cylinders'], axis=1)

fossil_fuels['Engine size L'] = fossil_fuels['Engine size L']*1000

fossil_fuels = fossil_fuels.rename(columns={'Model year': 'Year',
                                            'City L/100 km': 'City (F) (L/100 km)',
                                            'Highway L/100 km': 'Highway (F) (L/100 km)',
                                            'Combined L/100 km': 'Combined (F) (L/100 km)',
                                            'Engine size L': 'Engine Capacity (cm3)',
                                            'Fuel type':'Fuel Type'})

fossil_fuels['Fuel Type'] = fossil_fuels['Fuel Type'].replace(
    ['X', 'Z', 'E'], ['G', 'PG', 'ET'])  # trocar a sigla dos combustíveis

fossil_fuels.to_csv(
    './modificated-data/consumption-fossilfuels.csv', index=False)

# prices

price_eletrics = pd.read_csv(
    './initial-data/cars-price/price-electrics.csv', sep=',')
price_fossil_fuel = pd.read_csv(
    './initial-data/cars-price/price-fuelfossil.csv', sep=',')
price_hybrids = pd.read_csv(
    './initial-data/cars-price/price-hybrids.csv', sep=',')

price_fossil_fuel = price_fossil_fuel.rename(columns={'Fuel type':'Fuel Type'})
price_eletrics = price_eletrics.rename(columns={'Fuel type':'Fuel Type'})
price_hybrids = price_hybrids.rename(columns={'Fuel type':'Fuel Type'})


consumptions = [eletrics, fossil_fuels, hybrids]
price_fuels = [price_eletrics, price_fossil_fuel, price_hybrids]

for comsumption, price_fuel in zip(consumptions, price_fuels):

    if comsumption.equals(consumptions[1]):
        comsumption['Price (euros)'] = [0] * len(comsumption)

        years = price_fuel['Model.year'].values
        models = price_fuel['Model'].values
        prices = price_fuel['Price (euros)'].values
        fuels = price_fuel['Fuel Type'].values

        for year, model, price, fuel in zip(years, models, prices, fuels):
            condition = (comsumption['Year'] == year) & (
                comsumption['Model'] == model) & (comsumption['Fuel Type'] == fuel)
            comsumption.loc[condition, 'Price (euros)'] = price

        comsumption.to_csv(
            './modificated-data/consumption-fossilfuels.csv', index=False)

    else:
        comsumption['Price (euros)'] = [0] * len(comsumption)

        years = price_fuel['Model.year'].values
        models = price_fuel['Model'].values
        prices = price_fuel['Price (euros)'].values

        for year, model, price in zip(years, models, prices):
            condition = (comsumption['Year'] == year) & (
                comsumption['Model'] == model)
            comsumption.loc[condition, 'Price (euros)'] = price

        if comsumption.equals(consumptions[0]):
            comsumption.to_csv(
                './modificated-data/consumption-eletrics.csv', index=False)

        elif comsumption.equals(consumptions[2]):
            comsumption.to_csv(
                './modificated-data/consumption-hybrids.csv', index=False)


# emissions
pt_2018 = pd.read_csv('./initial-data/PT-2018.csv', sep=',', low_memory=False)
pt_2019 = pd.read_csv('./initial-data/PT-2019.csv', sep=',')
pt_2020 = pd.read_csv('./initial-data/PT-2020.csv', sep=',')
pt_2021 = pd.read_csv('./initial-data/PT-2021.csv', sep=',', low_memory=False)
pt_2022 = pd.read_csv('./initial-data/PT-2022.csv', sep=',')

to_drop = ['Country', 'VFN', 'Mp', 'Mh', 'Man', 'MMS', 'Tan', 'Va', 'Ct', 'Cr', 'r', 'm (kg)', 'Enedc (g/km)', 'At1 (mm)',
           'At2 (mm)', 'Fm', 'z (Wh/km)', 'Electric range (km)', 'IT', 'Ernedc (g/km)', 'Erwltp (g/km)', 'De', 'Vf',
           'Date of registration', 'Fuel consumption ', 'Status', 'T', 'Ve']

to_rename = {'Mk': 'Make', 'Cn': 'Model', 'Mt': 'Test Weight (kg)', 'Ewltp (g/km)': 'Test Emission CO2 (g/km)',
             'W (mm)': 'Wheel Base (mm)', 'ec (cm3)': 'Engine Capacity (cm3)', 'ep (KW)': 'Engine Power (kW)', 'year': 'Year', 'Ft': 'Fuel Type'}


fuels_name = ['electric', 'diesel', 'diesel/electric', 'DIESEL', 'DIESEL/ELECTRIC', 'PETROL/ELECTRIC',
              'petrol', 'Electric', 'PETROL', 'ELECTRIC', 'Diesel', 'Petrol', 'petrol/electric']

fuels_rename = ['E', 'D', 'H', 'D', 'H',
                'H', 'G', 'E', 'G', 'E', 'D', 'G', 'H']


for df in [pt_2018, pt_2019, pt_2020, pt_2021, pt_2022]:

    df.drop(to_drop, axis=1, inplace=True)  # excluindo colunas
    df.rename(columns=to_rename, inplace=True)  # renomeando as colunas
    df['Fuel Type'] = df['Fuel Type'].replace(
        fuels_name, fuels_rename)  # trocando os nomes dos combustíveis
    # excluindo os nan da coluna dos combustíveis
    df.dropna(subset=['Fuel Type'], inplace=True)

    # retirando alguns tipos de combustíveis que não vamos utlizar
    for i in ['lpg', 'ng', 'LPG', 'NG', 'HYDROGEN']:
        df.drop(df[df['Fuel Type'] == i].index, inplace=True)

    df.loc[df['Fuel Type'] == 'E', 'Test Emission CO2 (g/km)'] = df.loc[df['Fuel Type'] == 'E',
                                                                        # colocando em 0 emissão eletrico
                                                                        'Test Emission CO2 (g/km)'].fillna(0)

    df.loc[df['Fuel Type'] == 'E', 'Engine Capacity (cm3)'] = df.loc[df['Fuel Type'] == 'E',
                                                                     # colocando em 0 as cilindradas do eletrico
                                                                     'Engine Capacity (cm3)'].fillna(0)
    
    #df['Make'] = df['Make'].str.title()


concated = pd.concat([pt_2018, pt_2019, pt_2020, pt_2021,
                     pt_2022], ignore_index=True)  # PT_all
concated.reset_index(drop=True, inplace=True)




### Filtrando NAN
for column in ['Test Emission CO2 (g/km)', 'Engine Capacity (cm3)']:

    for brand in concated['Make'].drop_duplicates().to_list():

        rule = ((concated['Make'] == brand) & (concated['Fuel Type'] != 'E'))
        array_ozone = concated[rule][column].dropna().to_list()

        if array_ozone:
            mean_ozone = round(np.mean(array_ozone), 0)
            concated.loc[rule, column] = concated.loc[rule,column].fillna(mean_ozone)

        else:
            array_ozone_all = concated[concated['Fuel Type']!='E'][column].dropna().to_list()
            mean_ozone_all = round(np.mean(array_ozone_all))
            concated.loc[rule, column] = concated.loc[rule, column].fillna(mean_ozone_all)  # quando não são encontradas emissões



for colum_name in ["Test Weight (kg)", 'Engine Power (kW)']:
    model_NaN = (concated.groupby('Model')[
        # modelos que possuem valor nan
        colum_name].apply(lambda x: x.isna().sum())).index.values

    for model in model_NaN:
        model_df = concated[concated['Model'] == model]

        teste_weight = model_df[colum_name].values
        teste_weight = teste_weight[~np.isnan(teste_weight)]

        if len(teste_weight) == 0:  # verificar se não existe valor sobre aquele modelo
            make = model_df['Make'].unique()[0]
            make_df = concated[concated['Make'] == make]
            teste_weight = make_df[colum_name].values
            teste_weight = teste_weight[~np.isnan(teste_weight)]

            if len(teste_weight) == 0:  # verificar se não existe valor sobre aquela marca
                teste_weight = concated[colum_name].values
                teste_weight = teste_weight[~np.isnan(teste_weight)]
                teste_weight_mean = round(np.mean(teste_weight), 0)
                concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                    model, colum_name].fillna(teste_weight_mean)
            else:
                teste_weight_mean = round(np.mean(teste_weight), 0)
                concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                    model, colum_name].fillna(teste_weight_mean)

        else:
            teste_weight_mean = round(np.mean(teste_weight), 0)
            concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                model, colum_name].fillna(teste_weight_mean)


# Dado que Wheel Base esta vazio para os Carros POLESTAR, completar com o valor encontrado na net correspondente.
concated.loc[(concated['Make'] == 'POLESTAR') & (
    concated['Wheel Base (mm)'].isna()), 'Wheel Base (mm)'] = 2735

# Conferir para ver se os valores NaN foram corretamente substituidos
polestar_cars = concated[concated['Make'] == 'POLESTAR']
# print(polestar_cars[['Make', 'Wheel Base (mm)']])

# Fazer o mesmo procedimento para estes modelos dos carros da Toyota que estão com valores Nan.
concated.loc[(concated['Make'] == 'TOYOTA') & (
    concated['Wheel Base (mm)'].isna()), 'Wheel Base (mm)'] = 2510
toyota_cars = concated[concated['Make'] == 'TOYOTA']

# Conferir para ver se os valores NaN foram corretamente substitu�dos
yaris_grmn_cars = toyota_cars[toyota_cars['Model'] == 'TOYOTA YARIS GRMN']
# print(yaris_grmn_cars[['Make', 'Wheel Base (mm)', 'Model']])


for column in ['Make', 'Model']:
    concated[column] = concated[column].str.title()

print(concated.isna().sum())


concated.to_csv('./modificated-data/PT-all.csv', index=False)
