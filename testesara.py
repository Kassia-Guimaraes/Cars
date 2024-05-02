import pandas as pd
import numpy as np

concated = price_hybrids = pd.read_csv(
    './modificated-data/PT-all.csv', sep=',')

print(concated.isna().sum())

# print(concated[concated['Test weight (kg)'].isna(
# )]['Model'].value_counts())

model_NaN = (concated.groupby('Model')[
    'Test weight (kg)'].apply(lambda x: x.isna().sum())).index.values
print(len(model_NaN))

for model in model_NaN:
    model_df = concated[concated['Model'] == model]

    teste_weight = model_df['Test weight (kg)'].values
    teste_weight = teste_weight[~np.isnan(teste_weight)]

    if len(teste_weight) == 0:  # verificar se não existe valor do peso sobre aquele modelo
        make = model_df['Make'].unique()[0]
        make_df = concated[concated['Make'] == make]
        teste_weight = make_df['Test weight (kg)'].values
        teste_weight = teste_weight[~np.isnan(teste_weight)]
        if len(teste_weight) == 0:
            teste_weight = concated['Test weight (kg)'].values
            teste_weight = teste_weight[~np.isnan(teste_weight)]
            teste_weight_mean = np.mean(teste_weight)
            concated.loc[concated["Model"] == model, 'Test weight (kg)'] = concated.loc[concated["Model"] ==
                                                                                        model, 'Test weight (kg)'].fillna(teste_weight_mean)
        else:
            teste_weight_mean = np.mean(teste_weight)
            concated.loc[concated["Model"] == model, 'Test weight (kg)'] = concated.loc[concated["Model"] ==
                                                                                        model, 'Test weight (kg)'].fillna(teste_weight_mean)

    else:
        teste_weight_mean = np.mean(teste_weight)
        concated.loc[concated["Model"] == model, 'Test weight (kg)'] = concated.loc[concated["Model"] ==
                                                                                    model, 'Test weight (kg)'].fillna(teste_weight_mean)

print(concated.isna().sum())
