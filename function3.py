import pandas as pd

fuels_price = pd.read_csv('./modificated-data/fuels-price.csv', sep=',')

premium_gas_price = fuels_price[(fuels_price['Year']==2023)]['Gasoline 98 (euro/liter)'].iloc[0]
gas_price = fuels_price[(fuels_price['Year']==2023)]['Gasoline 95 (euro/liter)'].iloc[0]
diesel_price = fuels_price[(fuels_price['Year']==2023)]['Diesel (euro/liter)'].iloc[0]
electricity_price = fuels_price[(fuels_price['Year']==2023)]['Electricity (euro/kWh)'].iloc[0]

def errorCodes(typeError):
    return f"\33[91mWARNING: {typeError.title()}\33[0;0m\n"

def userFilter(toFilter, messange):
    theSelectedFilters = []
    while True:
        try:
            for index, value in enumerate(toFilter):
                print(f"\33[1m{index+1} \033[0;0m{value}")
            input_value = input(f"\33[0;0mEscolha um número para selecionar \33[95m{messange}\33[0;0m: ")

            while int(input_value) <1 and int(input_value) > len(toFilter)-1:
                print(errorCodes("Entrada incorreta"))
                input_value = int(input(f"\33[0;0mEscolha um número para selecionar \33[95m{messange}\33[0;0m: "))
            theSelectedFilters = toFilter[int(input_value)-1]

            return theSelectedFilters #return de array with all selected filters
        except:
            print(errorCodes('Entrada inválida'))

print('\n\nOlá, seja bem-vindo a \033[1;96mcalculadora de gastos\033[0;0m')
while True:
    #Escolha do tipo de combustível
    print('\n\n')
    choice_fuel = userFilter(['Gasolina', 'Diesel', 'Híbrido', 'Elétrico'], 'o tipo de combustível')

    #Entrada do consumo dos carros
    if (choice_fuel != 'Híbrido' and choice_fuel!='Elétrico'):
        consumption = (float(input('Qual o consumo médio do seu carro em L a cada 100Km? (ex: 9.2)\t=> ')))/100

    elif (choice_fuel == 'Híbrido'):
        consumption1 = (float(input('Qual o consumo médio do seu carro na parte elétrica, em kWh a cada 100Km? (ex: 20.2) => ')))/100
        consumption2 = (float(input('Qual o consumo médio do seu carro na com combustível fóssil, em L a cada 100Km? (ex: 4.1)=>  ')))/100

    else:
        consumption = (float(input('Qual o consumo médio do seu carro em kWh a cada 100Km? (ex: 20.2)=> ')))/100

    distance = float(input('Para qual distância, em km, deseja calcular a média de gasto? (ex: 102)=> '))

    #Cálculo do gasto
    if (choice_fuel == 'Gasolina'):
        calc_gas = consumption * distance * gas_price
        calc_pgas = consumption * distance * premium_gas_price

        print(f'\nPara o seu carro percorrer {distance} Km, tendo o consumo de {consumption*100} L a cada 100km, gasta em média:\n\t\033[93mGasolina 95\033[0;0m: {round(calc_gas,2)} euros, sendo a gasolina 95 {gas_price} euro por liter\n\t\033[93mGasolina 98\033[0;0m {round(calc_pgas,2)} euros, sendo a gasolina 98 {premium_gas_price}\n\n')

    elif (choice_fuel == 'Diesel'):
        calc_diesel = consumption * distance * diesel_price

        print(f'\nPara o seu carro percorrer {distance} Km, tendo o consumo de {consumption*100} L a cada 100Km, gasta em média:\n\t\033[93mDiesel\033[0;0m: {round(calc_diesel,2)} euros, sendo o diesel {diesel_price} euro por liter\n\n')

    elif (choice_fuel == 'Elétrico'):
        calc_ele = consumption * distance * electricity_price

        print(f'\nPara o seu carro percorrer {distance} Km, tendo o consumo de {consumption*100} kWh a cada 100Km, gasta em média:\n\t\033[94mEletricidade\033[0;0m: {round(calc_ele,2)} euros, sendo a eletricidade {electricity_price} euro por kW\n\n')

    else:
        calc_hy_e = consumption1 * distance * electricity_price
        calc_hy_f = consumption2 * distance * gas_price

        print(f'\nPara o seu carro percorrer {distance} Km, tendo o consumo de {consumption1*100} kWh a cada 100km e {consumption1*100} L a cada 100Km, gasta em média:\n\t\033[94mEletricidade\033[0;0m: {round(calc_hy_e,2)} euros, sendo a eletricidade {electricity_price} euro por kW\n\t\033[93mGasolina 95\033[0;0m: {round(calc_hy_f,2)} euros, sendo a gasolina 95 {gas_price}\n\n')

    finish = userFilter(['Sim','Não'], 'calcular mais algum consumo')
    if (finish == 'Não'):
        break

