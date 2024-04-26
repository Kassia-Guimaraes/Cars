import pandas as pd

eletrics = pd.read_csv(
    './modificated-data/consumption-eletrics.csv', sep=',')
fossil_fuels = pd.read_csv(
    './modificated-data/consumption-fossilfuels.csv', sep=',')
hybrids = pd.read_csv(
    './modificated-data/consumption-hybrids.csv', sep=',')
price_eletrics = pd.read_csv(
    './initial-data/cars-price/price-eletrics.csv', sep=',')
price_fossil_fuel = pd.read_csv(
    './initial-data/cars-price/price-fuelfossil.csv', sep=',')
price_hybrids = pd.read_csv(
    './initial-data/cars-price/price-hybrids.csv', sep=',')

consumptions = [eletrics, fossil_fuels, hybrids]
price_fuels = [price_eletrics, price_fossil_fuel, price_hybrids]

for comsumption, price_fuel in zip(consumptions, price_fuels):

    if comsumption.equals(consumptions[1]):
        comsumption['Price (euros)'] = [0] * len(comsumption)

        years = price_fuel['Model.year'].values
        models = price_fuel['Model'].values
        prices = price_fuel['Price (euros)'].values
        fuels = price_fuel['Fuel type'].values

        for year, model, price, fuel in zip(years, models, prices, fuels):
            condition = (comsumption['Year'] == year) & (
                comsumption['Model'] == model) & (comsumption['Fuel type'] == fuel)
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
