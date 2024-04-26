import pandas as pd
fuels_price = pd.read_csv('./modificated-data/fuels-price.csv', sep=',')
electricity_price = pd.read_csv(
    './initial-data/electricity-price.csv', sep=',')

fuels_price['Electricity (euro/kWh)'] = electricity_price['Eletricidade (euro/kWh)']
