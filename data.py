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

eletrics = eletrics.rename(columns={'Model year':'Year',
                                    'City (kWh/100 km)':'City (E) (kWh/100 km)',
                                    'Highway (kWh/100 km)':'Highway (E) (kWh/100 km)',
                                    'Combined (kWh/100 km)':'Combined (E) (kWh/100 km)',
                                    'City (Le/100 km)':'City (E) (Le/100 km)',
                                    'Highway (Le/100 km)':'Highway (E) (Le/100 km)',
                                    'Combined (Le/100 km)':'Combined (E) (Le/100 km)'
                                    })

eletrics = eletrics.drop(['_id','CO2 emissions (g/km)','CO2 rating','Smog rating','Transmission'], axis=1) #sobreposição de dados, uma vez que já temos estas informações

eletrics = eletrics[(eletrics['Year']>=2018) &
                    (eletrics['Year']<=2022)] #deixar apenas nos anos 2018 - 2022

eletrics['Fuel type'] = eletrics['Fuel type'].replace(['B'],['E']) #trocar b por e = eletric

eletrics.to_csv('./modificated-data/consumption-eletrics.csv', index=False)




### consumptions hybrids
hybrids = pd.read_csv('./initial-data/consumption-hydrids.csv', sep=',')

hybrids['Fuel type 1'] = hybrids['Fuel type 1'].replace(['B/Z','B/Z*','B/X*','B/X','B'],['E/PG','E/PG*','E/G*','E/G','E']) #renomeado linhas com siglas

hybrids[['Combined Le/100 km', 'Combined calculus/100 km']] = hybrids['Combined Le/100 km'].str.split('(', expand=True) #split da coluna com Le/100km

hybrids[['Combined kWh/100 km', 'Combined L/100 km']] = hybrids['Combined calculus/100 km'].str.split('kWh', expand=True) #split da coluna calculus que tinha as informações da soma dos litros e kWh

hybrids = hybrids.drop(columns={'Combined calculus/100 km'}, axis=1)#excluindo a coluna calculus que só serviu para separar a coluna principal

hybrids['Combined L/100 km'] = hybrids['Combined L/100 km'].str.extract(r'\+\s*([\d\.]+)') #ajustando linhas com estado + num L/100km e deixando para os litros

hybrids['Combined kWh/100 km'] = hybrids['Combined kWh/100 km'].str.replace(r'\[','',regex=True) #ajustando linhas com estado [num e deixando apenas o número

hybrids = hybrids.apply(lambda x: x.str.strip() if x.dtype == 'object' else x) #excluindo os espaços vazios depois dos nomes

hybrids = hybrids.drop(['_id','CO2 emissions (g/km)','CO2 rating','Smog rating','Cylinders','Engine size (L)','Transmission'], axis=1) #sobreposição de dados, uma vez que já temos estas informações

hybrids = hybrids.rename(columns={'Model year': 'Year'})

hybrids = hybrids[(hybrids['Year']>=2018) & (hybrids['Year']<=2022)] #deixar apenas nos anos 2018 - 2022

hybrids['Fuel type 2'] = hybrids['Fuel type 2'].replace(['X','Z'],['G','PG']) #trocar b por e = eletric

hybrids = hybrids[['Year','Make','Model','Vehicle class','Motor (kW)','Fuel type 1','Combined Le/100 km','Combined kWh/100 km','Combined L/100 km','Range 1 (km)','Recharge time (h)','Fuel type 2','City (L/100 km)','Highway (L/100 km)','Combined (L/100 km)','Range 2 (km)']]

hybrids = hybrids.rename(columns={'Combined Le/100 km':'Combined (E) (Le/100 km)',
                                  'Combined L/100 km':'Combined (E) (L/100 km)',
                                  'Combined kWh/100 km':'Combined (E) (kWh/100 km)',
                                  'City (L/100 km)':'City (F) (L/100 km)',
                                  'Highway (L/100 km)':'Highway (F) (L/100 km)',
                                  'Combined (L/100 km)':'Combined (F) (L/100 km)'})


hybrids.to_csv('./modificated-data/consumption-hydrids.csv', index=False)




### consumptions fossil fuels
fossil_fuels = pd.read_csv('./initial-data/consumption-fossilfuels.csv', sep=',')

fossil_fuels = fossil_fuels.drop(["CO2 emissions g/km","CO2 rating","Smog rating",'Transmission','Combined mpg','Cylinders'], axis=1) #sobreposição de dados, uma vez que já temos estas informações

fossil_fuels = fossil_fuels.rename(columns={'Model Year':'Year',
                                            'City L/100 km':'City (F) (L/100 km)',
                                            'Highway L/100 km':'Highway (F) (L/100 km)','Combined L/100 km':'Combined (F) (L/100 km)'})

fossil_fuels['Fuel type'] = fossil_fuels['Fuel type'].replace(['X','Z','E'],['G','PG','ET']) #trocar a sigla dos combustíveis

fossil_fuels.to_csv('./modificated-data/consumption-fossilfuels.csv', index=False)