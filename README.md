# 👩‍🦰 Pesquisa SOP

Este repositório contém os códigos e recursos desenvolvidos para o projeto de pesquisa que visa prever a Síndrome dos Ovários Policísticos utilizando técnicas de aprendizado de máquina.

![Static Badge](https://img.shields.io/badge/Status-Em_Desenvolvimento-blue)

## 🎯 Objetivo do Projeto

A Síndrome dos Ovários Policísticos (SOP) é um distúrbio endócrino que afeta mulheres em idade reprodutiva, sendo de difícil diagnóstico devido à sua heterogeneidade clínica e sobreposição de sintomas com outras condições. O seguinte estudo busca investigar o uso de técnicas de Machine Learning (ML) para aprimorar a precisão diagnóstica da SOP, utilizando um conjunto de dados público e comparando os classificadores Support Vector Machine (SVM), K-Nearest Neighbors (KNN), Decision Tree (DT) e Random Forest (RF). Além disso, foi construída uma API em Flask visando a disponibilização eficiente do melhor modelo treinado.

## 🗂️ Estrutura do Repositório

O repositório está dividido da seguinte forma:

```
projeto-sop
├─ api/
│  ├─ model/
│  │  ├─ rf_bests.joblib
│  ├─ requirements.txt
│  └─ app.py
├─ dataset/
│  └─ PCOS_data.csv
├─ decision_tree.ipynb
├─ knn.ipynb
├─ svm.ipynb
├─ random_forest.ipynb
└─ readme.md
```

## 🚀 Tecnologias Utilizadas

As tecnologias utilizadas no projeto são as seguintes:

[![python](https://img.shields.io/badge/Python-3.9-3776AB.svg?style=flat&logo=python&logoColor=white)](https://www.python.org)
[![jupyter](https://img.shields.io/badge/Jupyter-Lab-F37626.svg?style=flat&logo=Jupyter)](https://jupyterlab.readthedocs.io/en/stable)

## 🛠️ Como utilizar

Para utilizar a aplicação siga esses passos:

- i. Clone o repositório:

  > git clone https://github.com/luizfernando05/projeto-alzheimer

- ii. Instale os pacotes necessários do Python:

  > pip install -r requirements.txt

- iii. Execute os Jupyters Notebooks.

- iv. Rode a API

  - abra a pasta `api/` em seu terminal e rode a aplicação com o seguinte comando:

    > python app.py

  - execute uma requisição `POST` para API passando, em um json, os valores esperados pelo modelo:

    ```
      {
          "weight": 44.6,
          "cycle": 2,
          "amh": 2.07,
          "weight_gain": 0,
          "hair_growth": 0,
          "skin_darkening": 0,
          "pimples": 0,
          "fast_food": 1,
          "follicle(L)": 3,
          "follicle(R)": 3
      }
    ```

## 👥 Equipe do Projeto

#### Discentes

- Luiz Fernando da Cunha Silva (UFERSA)
- Wesley Dos Santos Silva (UFERSA)

#### Docentes Orientadoras

- Prof. Dra. Samara Martins Nascimento (UFERSA)
- Prof. Dra. Verônica Maria Lima Silva (UFPB)
