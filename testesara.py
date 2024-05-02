import pandas as pd
import numpy as np

concated = pd.read_csv('./modificated-data/PT-all.csv', sep=',')

for colum_name in ["Test weight (kg)"]:
    model_NaN = (concated.groupby('Model')[
        colum_name].apply(lambda x: x.isna().sum())).index.values
    print(len(model_NaN))

    for model in model_NaN:
        model_df = concated[concated['Model'] == model]

        teste_weight = model_df[colum_name].values
        teste_weight = teste_weight[~np.isnan(teste_weight)]

        if len(teste_weight) == 0:  # verificar se não existe valor do peso sobre aquele modelo
            make = model_df['Make'].unique()[0]
            make_df = concated[concated['Make'] == make]
            teste_weight = make_df[colum_name].values
            teste_weight = teste_weight[~np.isnan(teste_weight)]
            if len(teste_weight) == 0:
                teste_weight = concated[colum_name].values
                teste_weight = teste_weight[~np.isnan(teste_weight)]
                teste_weight_mean = np.mean(teste_weight)
                concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                    model, colum_name].fillna(teste_weight_mean)
            else:
                teste_weight_mean = np.mean(teste_weight)
                concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                    model, colum_name].fillna(teste_weight_mean)

        else:
            teste_weight_mean = np.mean(teste_weight)
            concated.loc[concated["Model"] == model, colum_name] = concated.loc[concated["Model"] ==
                                                                                model, colum_name].fillna(teste_weight_mean)

print(concated.isna().sum())
