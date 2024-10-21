# # Descrição Técnica da Tarefa 1
O arquivo fornecido define uma infraestrutura na AWS, incluindo a criação de uma VPC, subnet, gateway de internet, grupo de segurança, uma instância EC2 baseada em uma imagem Debian 12 e a configuração de uma chave SSH para acesso à instância.

## Bloco `provider`
Define o provedor AWS e a região em que os recursos serão provisionados.
## Bloco `variable "projeto"`
Define uma variável de entrada usada para armazenar o nome do projeto.
## Bloco `resource "tls_private_key" "ec2_key"`
Gera uma chave privada RSA, que será usada para acessar a instância EC2.
## Bloco `resource "aws_key_pair" "ec2_key_pair"`
Cria um par de chaves no AWS EC2 usando a chave pública gerada pelo recurso
## Bloco `resource "aws_vpc" "main_vpc"`
Cria uma VPC (Virtual Private Cloud) na AWS. Definindo a faixa de ip`s, habilita o suporte a DNS e resolução de nomes.
## Bloco `resource "aws_subnet" "main_subnet"`
Cria uma subnet dentro da VPC para seguimentar, definindo a faixa de ip`s como sendo 10.0.1.0/24, alem de definir a zona de disponibilidade.
## Bloco `resource "aws_internet_gateway" "main_igw"`
Cria um Internet Gateway, permitindo que as instâncias dentro da VPC se conectem à Internet.
## Bloco `resource "aws_route_table" "main_route_table"`
Cria uma tabela de rotas para a VPC e direciona todo o trafego para o internet gateway
## Bloco `resource `"aws_route_table_association" "main_association"`
Associa a tabela de rotas à subnet.
## Bloco `resource "aws_security_group" "main_sg"`
Cria um grupo de segurança, permitindo o tráfego de entrada e saída. Entrada na porta 22, ou seja, somente SSH e saída para qualquer lugar.
## Bloco `data "aws_ami" "debian12"`
Busca a AMI (Amazon Machine Image) mais recente do Debian 12. É uma boa abordagem, dessa forma evita usar o ID completo, ao usar o `filter` torna a busca mais precisa.
## Bloco `resource "aws_instance" "debian_ec2"`
Cria uma instância EC2 baseada no Debian 12 associando o AMI, definindo o tipo da instancia, definição de rede, um IP publico e um disco de 20 GiB do tipo gp2
## Bloco `output "private_key"` e `output "ec2_public_ip"`
Utilizados para mostrar o IP publique sera usado para acessar a instancia e uma mensagem sobre a geração da chave privada, que nesse caso nao sera mostrada por questão de segurança (`sensitive=true`)

---

# # Descrição Técnica da Tarefa 2

Com base no arquivo fornecido, optei por reorganizar o código em módulos, conforme sugere a documentação do Terra form, dessa forma torna o código mais legível e que partes da infraestrutura seja reutilizável e configurável, alem de melhorar a manutenção, reutilização e escalabilidade.

## Bloco `terraform e Backend S3`
Adicionei o bloco terraform para garantir que o provedor utilizado é o AWS e mantendo sua versão para compatibilidade.
Ainda no bloco terraform, configurei o armazenamento do arquivo *terraform.tfstate* num bucket no S3 para segurança e colaboração, tendo em vista que o mesmo pode ser compartilhado com o time de infraestrutura. Adicionei criptografia no arquivo e o uso do lock de estado, que garante que 2 ou mais pessoas não estarão modificando o arquivo ao mesmo tempo, garantindo integridade ao arquivo.

## Bloco `module "dynamodb"`
Este módulo gerencia a criação de uma tabela DynamoDB usada para bloquear o estado do Terraform, evitando que múltiplas execuções do Terraform escrevam no estado ao mesmo tempo.

## Blocos `module "vpc", "ec2", "security"`
Esses módulos gerenciam a criação do recursos que dão nome a eles, seguindo a ideia inicial e mantendo a separação de tarefas, para evitar que mudanças em uma parte da infraestrutura impactem negativamente outras partes.

---

# # Executando o projeto.

Para executar, primeiro inicie um container docker, a fim de evitar expor direto em sua maquina, o token da AWS.
```bash
docker container run -it --name terraform -v $PWD:/app -w /app --entrypoint="" hashicorp/terraform:light sh
```

Você sera redirecionado para o container, informe entao seu id e key da AWS, dessa forma, ao fim da execução, nada sera salvo em sua maquina.

```bash
export AWS_ACCESS_KEY_ID=<seu ID>
export AWS_SECRET_ACCESS_KEY=<sua key>
```

Por fim, para executar o projeto, primeiro inicie o backend, depois execute o plano para garantir que, o que o binário do terraform leu, é o mesmo que sera criado na AWS, e aplique.

```bash
terraform init
terraform plan -out vexpenses
terraform apply "vexpenses"
```

Para conectar na VM, basta exportar a chave que foi gerado e logar no servidor

```bash
terraform output -raw private_key > ec2_key.pem
chmod 400 ec2_key.pem
ssh -i ec2_key.pem admin@$(terraform output ec2_public_ip | sed 's/"//g')
```