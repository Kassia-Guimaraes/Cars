import pandas as pd

# Importar o documento
df = pd.read_csv('C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_Project/CO2_Project/PT-all.csv')

# Renomear as colunas Whell Base e Test weight
df.rename(columns={'Whell Base (mm)': 'Wheel Base (mm)'}, inplace= True)
df.rename(columns={'Test weight (kg)': 'Test Weight (kg)'}, inplace= True)

# Remover coluna 'Version'
df2 = df.drop(columns= ['Version'])

# Verificar onde existem valores Nan
colunas_com_nan = df2.columns[df2.isna().any()]
print(colunas_com_nan)

# Dado que Wheel Base está vazio para os Carros POLESTAR, completar com o valor encontrado na net correspondente.
df2.loc[(df2['Make'] == 'POLESTAR') & (df2['Wheel Base (mm)'].isna()), 'Wheel Base (mm)'] = 2735

# Conferir para ver se os valores NaN foram corretamente substituídos
polestar_cars = df2[df2['Make'] == 'POLESTAR']
print(polestar_cars[['Make', 'Wheel Base (mm)']])

# Fazer o mesmo procedimento para estes modelos dos carros da Toyota que estão com valores Nan.
df2.loc[(df2['Make'] == 'TOYOTA') & (df2['Wheel Base (mm)'].isna()), 'Wheel Base (mm)'] = 2510
toyota_cars = df2[df2['Make'] == 'TOYOTA']

# Conferir para ver se os valores NaN foram corretamente substituídos
yaris_grmn_cars = toyota_cars[toyota_cars['Model'] == 'TOYOTA YARIS GRMN']
print(yaris_grmn_cars[['Make', 'Wheel Base (mm)', 'Model']])

# Checar se ainda existem valores NaN
any_nan = df2['Wheel Base (mm)'].isna().any()

# Imprimir o resultado encontrado na checagem. 
if any_nan:
    print("Ainda existem valores NaN na coluna 'Wheel Base (mm)'.")
else:
    print("Nao ha mais valores NaN na coluna 'Wheel Base (mm)'.")
    
