import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


electrics = pd.read_csv('./modificated-data/consumption-eletrics.csv', sep=',')
fossil_fuel = pd.read_csv('./modificated-data/consumption-fossilfuels.csv', sep=',')
hybrids = pd.read_csv('./modificated-data/consumption-hybrids.csv', sep=',')
fuels_price = pd.read_csv('./modificated-data/fuels-price.csv', sep=',')


diesel = fossil_fuel[fossil_fuel['Fuel Type']=='D']
gasoline = fossil_fuel[(fossil_fuel['Fuel Type']!='D')&(fossil_fuel['Fuel Type']!='ET')]


premium_gas_price = fuels_price[(fuels_price['Year']==2023)]['Gasoline 98 (euro/liter)'].iloc[0]
gas_price = fuels_price[(fuels_price['Year']==2023)]['Gasoline 95 (euro/liter)'].iloc[0]
diesel_price = fuels_price[(fuels_price['Year']==2023)]['Diesel (euro/liter)'].iloc[0]
electricity_price = fuels_price[(fuels_price['Year']==2023)]['Electricity (euro/kWh)'].iloc[0]


def errorCodes(typeError):
    return f"\33[91mWARNING: {typeError.title()}\33[0;0m\n"

def exitMessange(index_value,typeMessange):
    return f"\033[93m{index_value} {typeMessange}\033[0m\n"

def nextMessange(index_value, typeMessange):
    return f"\033[94m{index_value} {typeMessange}\033[0m\n"

def viewDataFrame(df):
    return print(f"{df.to_markdown(index=False)}\n")

def filtersMenu(toFilter): #return index in filterMenu
    for index, value in enumerate(toFilter):
        print(f"\33[1m{index+1} \033[0;0m{value}")
    print(f"\33[1m{index+2}\033[0;0m selecionar todos\n{exitMessange(0, "sair")}")
    return index

#dataFrame, elements in dataFrame to filter, information messange
def getUserFiltersLoop(df, toFilter, messange): #return array with all filters to use
    theSelectedFilters = []
    while True:
        index = filtersMenu(toFilter)
        try:
            print(f"\33[0;0mFiltros selecionados: {theSelectedFilters} \33[0;0m\nSe quiser alterar a seleção apenas selecionar novamente o item") #show what filters was select
            input_value = input(f"\33[0;0mEscolha um número para selecionar \33[95m{messange}\33[0;0m: ")

            if int(input_value) != 0 and int(input_value) != index+2 and int(input_value) != index+3: #when 0 abort all, i+2 select all, i+3 finish

                while int(input_value) < 0 or int(input_value)-1 > len(toFilter):
                    print(errorCodes("Entrada incorreta"))
                    input_value = input(f"\33[0;0mEscolha um número para selecionar \33[95m{messange}\33[0;0m: ") #request new input

                selection = toFilter[int(input_value)-1] #the selecion is the input_value on index toFilter

                if selection not in theSelectedFilters: #if selection wasnt select after
                    theSelectedFilters.append(selection)
                else: #remove the term if was select after
                    theSelectedFilters.remove(selection)
                viewDataFrame(df[theSelectedFilters].drop_duplicates())

            elif int(input_value) == index+2: #selected all filters
                while True:
                    allfilters_value = int(input(f"\nDeseja selecionar todos os filtros?\n\033[1m1 \033[0;0mSim\n\033[1m2 \033[0;0mNão\nSelecione uma opção: "))
                    match allfilters_value:
                        case 1: #confirm selection all terms
                            theSelectedFilters = toFilter
                            print(f"\033[0;0mFiltros selecionados: {theSelectedFilters} \033[0;0m\n")
                            break
                        case 2: #return to choice the filters
                            break  # Break out of the loop without changing theSelectedFilters
                        case _: #error code
                            print(errorCodes("Entrada incorreta"))

                if allfilters_value == 1: #before confirmation about selection all filters
                    break
                else: #new selection filters
                    print("\n")
                    continue
            
            else: # if choice 0, abort all
                return theSelectedFilters
            
        except: #errorCodes
            print('\n\n')
    return theSelectedFilters #return de array with all selected filters

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

def chooseCars():
    result = pd.DataFrame(dtype='object', columns=['Marca', 'Modelo','Consumo','Circuito','Distância','Combustível','Preço Combustível', 'Gasto'])
    while True:

        #distância em Km Universidade Braga - Guimarães
        AE = 29.5 #autoestrada
        N = 24.7 #nacional

        until_days = 22 #dias úteis no mês

        print('\n')
        choice_fuel = userFilter(['Gasolina', 'Diesel', 'Híbrido', 'Elétrico'], 'o tipo de combustível')

        if (choice_fuel == 'Gasolina'):
            df = gasoline        
        elif (choice_fuel == 'Diesel'):
            df = diesel
        elif (choice_fuel == 'Híbrido'):
            df = hybrids
        else:
            df = electrics

        print('\n\n')
        make_filter = df['Make'].drop_duplicates().to_list()
        choice_make = userFilter(make_filter, 'a marca do carro')

        print('\n\n')
        model_filter = df[(df['Make']==choice_make)]['Model'].drop_duplicates().to_list()
        choice_models = getUserFiltersLoop(df, model_filter, 'os modelos de carro')

        for element in choice_models:
            data = df[(df['Make']==choice_make)&(df['Model']==element)]

            if (choice_fuel == 'Gasolina'):

                #Gasolina 95
                national = (data['City (F) (L/100 km)'].iloc[0]/100) * (2 * N) * gas_price * until_days
                row_gasoline_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['City (F) (L/100 km)'].iloc[0]} L/100km',
                                    'Circuito':'Nacional',
                                    'Distância':N,
                                    'Combustível':'Gasolina 95', 
                                    'Preço Combustível': gas_price, 
                                    'Gasto':round(national,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_gasoline_n

                elif (not result.empty) and ( not row_gasoline_n.empty):
                    result = pd.concat([result, row_gasoline_n], ignore_index=True)

                
                hightway = (data['Combined (F) (L/100 km)'].iloc[0]/100) * (2 * AE) * gas_price * until_days
                row_gasoline_ae = pd.DataFrame({'Marca':choice_make, 
                                     'Modelo':f'{choice_make}:{element}',
                                     'Consumo':f'{data['Combined (F) (L/100 km)'].iloc[0]} L/100km',
                                     'Circuito':'Auto-Estrada',
                                     'Distância':AE,
                                     'Combustível':'Gasolina 95',
                                     'Preço Combustível': gas_price, 
                                     'Gasto': round(hightway,2)}, 
                                     index=[0])
                
                if result.empty:
                    result = row_gasoline_ae
                
                elif (not result.empty) and (not row_gasoline_ae.empty):
                    result = pd.concat([result, row_gasoline_ae], ignore_index=True)


                #Gasolina 98 
                national = (data['City (F) (L/100 km)'].iloc[0]/100) * (2 * N) * premium_gas_price * until_days
                row_pgasoline_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['City (F) (L/100 km)'].iloc[0]} L/100km',
                                    'Circuito':'Nacional',
                                    'Distância':N,
                                    'Combustível':'Gasolina 98', 
                                    'Preço Combustível': premium_gas_price, 
                                    'Gasto':round(national,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_pgasoline_n

                elif (not result.empty) and (not row_pgasoline_n.empty):
                    result = pd.concat([result, row_pgasoline_n], ignore_index=True)


                hightway = (data['Combined (F) (L/100 km)'].iloc[0]/100) * (2 * AE) * premium_gas_price * until_days
                row_pgasoline_ae = pd.DataFrame({'Marca':choice_make, 
                                     'Modelo':f'{choice_make}:{element}',
                                     'Consumo':f'{data['Combined (F) (L/100 km)'].iloc[0]} L/100km',
                                     'Circuito':'Auto-Estrada',
                                     'Distância':AE,
                                     'Combustível':'Gasolina 98',
                                     'Preço Combustível': premium_gas_price, 
                                     'Gasto': round(hightway,2)}, 
                                     index=[0])
                
                if result.empty:
                    result = row_pgasoline_ae
                
                elif (not result.empty) and (not row_pgasoline_ae.empty):
                    result = pd.concat([result, row_pgasoline_ae], ignore_index=True)

            elif (choice_fuel == 'Diesel'):
                
                pay = diesel_price
                fuel = 'Diesel'

                #Diesel
                national = (data['City (F) (L/100 km)'].iloc[0]/100) * (2 * N) * pay * until_days
                row_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['City (F) (L/100 km)'].iloc[0]} L/100km',
                                    'Circuito':'Nacional',
                                    'Distância':N,
                                    'Combustível':choice_fuel, 
                                    'Preço Combustível': pay, 
                                    'Gasto':round(national,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

                
                hightway = (data['Combined (F) (L/100 km)'].iloc[0]/100) * (2 * AE) * pay * until_days
                row_ae = pd.DataFrame({'Marca':choice_make, 
                                     'Modelo':f'{choice_make}:{element}',
                                     'Consumo':f'{data['Combined (F) (L/100 km)'].iloc[0]} L/100km',
                                     'Circuito':'Auto-Estrada',
                                     'Distância':AE,
                                     'Combustível': fuel,
                                     'Preço Combustível': pay, 
                                     'Gasto': round(hightway,2)}, 
                                     index=[0])
                
                if result.empty:
                    result = row_ae
                
                elif (not result.empty) and (not row_ae.empty):
                    result = pd.concat([result, row_ae], ignore_index=True)

            elif (choice_fuel == 'Híbrido'):
                
                pay_e = electricity_price
                pay_gas = gas_price 


                #Híbrido Nacional, parte elétrica
                national = (((data['Combined (E) (kWh/100 km)'].iloc[0]/100) * pay_e) + 
                            ((data['Combined (E) (L/100 km)'].iloc[0]/100) * pay_gas)) * (2 * N) * until_days
                
                row_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['Combined (E) (kWh/100 km)'].iloc[0]} kWh/100km + {data['Combined (E) (L/100 km)'].iloc[0]} L/100km',
                                    'Circuito':'Nacional',
                                    'Distância':N,
                                    'Combustível':f'{choice_fuel} parte elétrica', 
                                    'Preço Combustível': f'{pay_e} kWh + {pay_gas} L', 
                                    'Gasto':round(national,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

                
                #Híbrido Auto-Estrada, parte elétrica
                hightway = (((data['Combined (E) (kWh/100 km)'].iloc[0]/100) * pay_e) + 
                            ((data['Combined (E) (L/100 km)'].iloc[0]/100) * pay_gas)) * (2 * AE) * until_days
                
                row_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['Combined (E) (kWh/100 km)'].iloc[0]} kWh/100km + {data['Combined (E) (L/100 km)'].iloc[0]/100 * pay_gas} L/100km',
                                    'Circuito':'Auto-Estrada',
                                    'Distância':AE,
                                    'Combustível':f'{choice_fuel} parte elétrica', 
                                    'Preço Combustível': f'{pay_e} kWh + {pay_gas} L', 
                                    'Gasto':round(hightway,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

                
                #Híbrido Nacional, combustível fóssil
                national = (data['City (F) (L/100 km)'].iloc[0]/100) * pay_gas * (2 * N) * until_days
                
                row_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['City (F) (L/100 km)'].iloc[0]} L/100Km',
                                    'Circuito':'Nacional',
                                    'Distância':N,
                                    'Combustível':f'{choice_fuel} combustível fóssil', 
                                    'Preço Combustível': f'{pay_gas}', 
                                    'Gasto':round(national,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

                
                #Híbrido Auto-Estrada, combustível fóssil
                hightway = (data['Combined (F) (L/100 km)'].iloc[0]/100) * pay_gas * (2 * AE) * until_days
                
                row_n = pd.DataFrame({'Marca':choice_make, 
                                    'Modelo':f'{choice_make}:{element}',
                                    'Consumo':f'{data['Combined (F) (L/100 km)'].iloc[0]} L/100km',
                                    'Circuito':'Auto-Estrada',
                                    'Distância':AE,
                                    'Combustível':f'{choice_fuel} combustível fóssil', 
                                    'Preço Combustível': f'{pay_gas}', 
                                    'Gasto':round(hightway,2)}, 
                                    index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

            else: #electrics

                pay = electricity_price

                #Nacional
                national = (data['City (E) (kWh/100 km)'].iloc[0]/100) * (2 * N) * pay * until_days

                row_n = pd.DataFrame({'Marca':choice_make, 
                                        'Modelo':f'{choice_make}:{element}',
                                        'Consumo':f'{data['City (E) (kWh/100 km)'].iloc[0]} kWh/100km',
                                        'Circuito':'Nacional',
                                        'Distância':N,
                                        'Combustível':f'{choice_fuel}', 
                                        'Preço Combustível': pay, 
                                        'Gasto':round(national,2)}, 
                                        index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

                #Auto-Estrada
                hightway = (data['Combined (E) (kWh/100 km)'].iloc[0]/100) * (2 * AE) * pay * until_days

                row_n = pd.DataFrame({'Marca':choice_make, 
                                        'Modelo':f'{choice_make}:{element}',
                                        'Consumo':f'{data['Combined (E) (kWh/100 km)'].iloc[0]} kWh/100km',
                                        'Circuito':'Auto-Estrada',
                                        'Distância':AE,
                                        'Combustível':f'{choice_fuel}', 
                                        'Preço Combustível': pay, 
                                        'Gasto':round(hightway,2)}, 
                                        index=[0])

                if result.empty:
                    result = row_n

                elif (not result.empty) and ( not row_n.empty):
                    result = pd.concat([result, row_n], ignore_index=True)

        print('\n')
        new_fuel = userFilter(['Sim', 'Não'], 'se desejar ver carros')
        
        if (new_fuel == 'Não'):
            print(result)
            return(result)
        



df = chooseCars()

# Agrupar os dados pelo modelo e pelo tipo de combustível, somando o gasto
grouped_data = df[(df['Circuito']=='Nacional')].groupby(['Modelo', 'Combustível'])['Gasto'].sum().reset_index()

# Definir as cores para cada tipo de combustível
fuel_colors = {
    'Gasolina 95': "#F5BF4C",
    'Diesel': "#F58C4C",
    'Gasolina 98': "#F5D44C",
    'Híbrido combustível fóssil': "#F5AA4C",
    'Híbrido parte elétrica': "#0C7CFA",
    'Elétrico': "#78C8FA"
}

# Criar o gráfico de barras usando seaborn
plt.figure(figsize=(14, 8))
barplot = sns.barplot(data=grouped_data, x='Modelo', y='Gasto', hue='Combustível', palette=fuel_colors)

# Adicionar rótulos e título
plt.xlabel('Modelo do Carro')
plt.ylabel('Gasto')
plt.title('Gasto dos Carros por Modelo e Tipo de Combustível')
plt.legend(title='Tipo de Combustível', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.xticks(rotation=30)

# Adicionar os valores em cima das barras
for p in barplot.patches:
    height = p.get_height()
    if height > 0:  # Adicione somente se a altura da barra for maior que 0
        barplot.annotate(format(height, '.1f'),
                         (p.get_x() + p.get_width() / 2., height),
                         ha='center', va='center',
                         xytext=(0, 9),
                         textcoords='offset points')

# Ajustar os limites do eixo Y para remover o rótulo 0.0
ymin, ymax = barplot.get_ylim()
barplot.set_ylim(ymin + 1e-7, ymax)  # Adiciona uma pequena margem ao ymin

# Exibir o gráfico
plt.tight_layout()
plt.show()