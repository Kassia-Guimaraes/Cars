import pandas as pd
import os

### fuel prices
fuels_price = pd.read_csv('./initial-data/fuel-prices.csv', sep=',')

fuels_price = fuels_price.rename(columns={'Anos':'Year',
                              'Gasolina Super com Chumbo ou Aditivada (Euro/litro)':'Premium Gasoline (euro/liter)',
                              'Gasolina sem chumbo I.O.95 (Euro/litro)':'Gasoline 95 (euro/liter)',
                              'Gasolina sem chumbo I.O.98 (Euro/litro)':'Gasoline 98 (euro/liter)',
                              'Gasolina Normal (Euro/litro)':'Regular Gasoline (euro/liter)',
                              'Gasóleo Rodoviário (Euro/litro)':'Diesel (euro/liter)',
                              'Fuelóleo (Euro/kg)':'Heating Oil (euro/kg)',
                              'Butano Garrafas (Euro/kg)':'Butane Bottles (euro/kg)',
                              'Propano Garrafas (Euro/kg)':'Propane Bottles (euro/kg)',
                              'Propano Canalizado (Euro/kg)':'Piped Propane with lead (euro/kg)'})

fuels_price = fuels_price.drop(['Regular Gasoline (euro/liter)'], axis=1) #coluna toda vazia

for column_name in fuels_price.columns.tolist():
    fuels_price[column_name] = fuels_price[column_name].fillna(round(fuels_price[column_name].mean(),3))

fuels_price.to_csv('./modificated-data/fuels-price.csv', index=False)


### consumptions eletrics
eletrics = pd.read_csv('./initial-data/consumption-eletrics.csv', sep=',')
fossil_fuels = pd.read_csv('./initial-data/consumption-fossilfuels.csv', sep=',')

eletrics = eletrics.rename(columns={'_id':'Id',
                                    'Model year': 'Year'})



### consumptions hybrids
hybrids = pd.read_csv('./initial-data/consumption-hydrids.csv', sep=',')

hybrids['Smog rating'] = hybrids['Smog rating'].fillna(10) #colunas que não possuem os dados do smog assumimos como 10, os melhores

hybrids['Fuel type 1'] = hybrids['Fuel type 1'].replace(['B/Z','B/Z*','B/X*','B/X','B'],['E/PG','E/PG*','E/G*','E/G','E']) #renomeado linhas com siglas

hybrids[['Combined Le/100 km', 'Combined calculus/100 km']] = hybrids['Combined Le/100 km'].str.split('(', expand=True) #split da coluna com Le/100km

hybrids[['Combined kWh/100 km', 'Combined L/100 km']] = hybrids['Combined calculus/100 km'].str.split('kWh', expand=True) #split da coluna calculus que tinha as informações da soma dos litros e kWh

hybrids = hybrids.drop(columns={'Combined calculus/100 km'}, axis=1)#excluindo a coluna calculus que só serviu para separar a coluna principal

hybrids['Combined L/100 km'] = hybrids['Combined L/100 km'].str.extract(r'\+\s*([\d\.]+)') #ajustando linhas com estado + num L/100km e deixando para os litros

hybrids['Combined kWh/100 km'] = hybrids['Combined kWh/100 km'].str.replace(r'\[','',regex=True) #ajustando linhas com estado [num e deixando apenas o número

hybrids = hybrids.apply(lambda x: x.str.strip() if x.dtype == 'object' else x)

hybrids.to_csv('./modificated-data/consumption-hydrids.csv', index=False)



### consumptions fossil fuels