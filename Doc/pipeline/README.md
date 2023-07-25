<h2>Pipeline com Cloud Build</h2>

![image](https://github.com/paivalais/desafio-final/assets/57145285/00fb7fda-0aa5-4a28-a5a4-49e2d97d15c8)


A criação da pipeline com o Cloud Build é uma tarefa relativamente simples, pois engloba apenas a interação com o console do Google para criar uma trigger e algumas informações referentes à autenticação de usuário como service account, por exemplo, para que possa subir a infraestrutura. 

Primeiro de tudo, é necessário utilizar o Cloud Repositories para criar uma conexão entre o GitHub (ou outro datasource) e o console do Google. 


### 💡 Ponto positivo:
Ao criar a pipeline, existe a possibilidade de adicionar a service account utilizada. Logo, não há necessidade de hospedá-la no código, garantindo a segurança e a confidencialidade do token.
