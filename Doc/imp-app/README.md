<h2>Implementação das Aplicações</h2>
<br>
As aplicações foram implementadas com o Helm (gerenciador de pacotes para Kubernetes), rodando numa playbook do Ansible, dentro no Cluster. 

A playbook está estruturada da seguinte forma: 

- Configuração padrão do yaml
- Entrar no Cluster
- Criar a namespace para a instalação do ingress-controller
- Instalar o ingress-controller com o pacote Helm
- Rodar playbooks de configuração de discos PVC
- Instalar o Wordpress com o pacote Helm
- Rodar um comando patch para mudar o serviço do Wordpress de "LoadBalancer" para "ClusterIP"
- Rodar uma playbook para aplicar o arquivo de configuração do HPA
- Instalar o Grafana com o pacote Helm
- Instalar o Prometheus com o pacote Helm
- Criar a namespace para a instalação do gerenciador de certificado do Let's Encrypt
- Instalar o certificado com o pacote Helm
- Rodar o apply no arquivo de configuração do certificado
- Rodar o apply no arquivo de configuração do ingress-controller para o Grafana e Wordpress

### HPA
HPA (Horizontal Pod Autoscaler) - altera a forma da carga de trabalho do Kubernetes aumentando ou diminuindo automaticamente o número de pods em resposta à CPU da carga de trabalho ou consumo de memória ou em resposta a métricas personalizadas relatadas no Kubernetes ou métricas externas de fontes fora do cluster.

Junto com a instalação do pacote do Helm, uma pasta chamada “kubernetes-ingress” é adicionada ao projeto. Nesta pasta, contém diversos arquivos/pastas de configuração relevantes, incluindo as necessárias para configuração do escalonamento horizontal. 
Para configurar o HPA, é necessário o seguinte:
No caminho kubernetes-ingress/deployments/helm-chart/templates, crie um arquivo .yaml para ser o arquivo de configuração (hpa.yaml, no caso). 
Nesse arquivo contém a seguinte configuração:
