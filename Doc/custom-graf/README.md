<h2>Configuração do Grafana com o Prometheus</h2>
<br>
Configurar o Grafana é um processo relativamente simples, já que é necessário apenas adicionar uma fonte de dados e o dashboard. 
Funciona da seguinte forma:

- Coletar o IP de serviço do Prometheus;
- Criar uma nova fonte de dados no Grafana, adicionando o IP coletado no passo anterior;
- Importar um dashboard para Kubernetes (ID 12740, 6417 ou 17149) +  Adicionar a fonte de dados criada anteriormente ao dashboard.
