
### MaRCoS (MAgnetic Resonance COntrol System)


A proposta do O MaRCoS é ser uma alternativa de baixo custo a alto desempenho fazendo frente as soluções proprietárias no universo dos sistemas de ressonância magnética.
Foi desenvolvido por uma comunidade internacional de pesquisadores e pode lidar com sequências de onda de alta precisão sem limitações de comprimento e forma de onda. 

O sistema inclui: 
- hardware
- firmware
- software com uma interface gráfica baseada em Python para implementação de sequências de pulso, processamento de dados e reconstrução de imagens.

**Introdução:**
O sistema de controle eletrônico é crucial para qualquer scanner de MRI, gerenciando pulsos eletromagnéticos e a aquisição de sinais para reconstrução de imagens. 
Os módulos FPGA mais recentes são ideais para esse tipo de tarefa devido à sua velocidade de transmissão e capacidade de sincronização. 
Consoles genéricos, como o MaRCoS, podem ser usados em diversos tipos de scanners.

**Objetivos e Visão Geral:**
O MaRCoS foi criado para ser programável, sem limitações de tipo de sequência, escalável e capaz de suportar frequências de modulação independentes. Ele utiliza a plataforma SDRLab 122-16, que possui entradas e saídas analógicas para dados RF, controlando uma placa de gradiente e outros periféricos via Ethernet.

**Hardware MaRCoS:**
O núcleo do MaRCoS é baseado no Red Pitaya SDRLab 122-16, com FPGA e processadores ARM, controlando ADCs e DACs para canais independentes de MRI. Suporta placas de gradiente GPA-FHDO e OCRA1 para controle de voltagens e correntes.

**Firmware e Software:**
O firmware FPGA e o servidor MaRCoS recebem e executam instruções de sequência, controlando operações de hardware em tempo real. O MarCoS logra para si, ser o primeiro sistema econômico capaz de lidar com sequências ilimitadas, eventos rápidos e formas de onda arbitrárias com precisão.

**Plataforma de Software:**
O MaRCoS possui uma biblioteca cliente em Python para criação e envio de sequências, além de interfaces gráficas e textuais para programação de pulsos. A GUI permite calibrações e execução de rotinas de aquisição, sendo usada principalmente em ambientes laboratoriais.

***A arquitetura do sistema MaRCoS mostra os principais componentes na pilha de software para desktop e o hardware e software embarcados no SDRLab. Existem várias maneiras de programar uma sequência, incluindo uma interface gráfica de usuário (GUI), arrays Numpy diretos e PulSeq, que todos controlam a biblioteca marcos_client. Esta se comunica com o SDRLab, executando a sequência e retornando os dados adiquiridos***

![Arquitetura do sistema MaRCoS](https://ar5iv.labs.arxiv.org/html/2208.01616/assets/x1.png)

***A arquitetura do servidor MaRCoS e do firmware FPGA no SDRLab. O servidor recebe uma sequência do PC cliente via Ethernet e a transmite para o firmware FPGA, onde é traduzida em operações de hardware sincronizadas no tempo, incluindo saídas de RF e gradiente. O firmware recebe dados dos ADCs, demodula e filtra, e os salva em buffers RX, de onde são lidos pelo servidor e enviados para o PC.***

![Arquitetura do servidor e do firmware](https://ar5iv.labs.arxiv.org/html/2208.01616/assets/x3.png)

# Tutoriais
- [GitHub Wiki](https://github.com/vnegnev/marcos_extras/wiki)
  - Boa parte dos tutoriais estão incompletos ou desatualizados

# Repositórios do Marcos RMI
[Marcos RMI GitHub](https://github.com/marcos-mri)

- **marcos-server** - Servidor embarcado, escrito em C do sistema MaRCoS
- **marcos-client** - Cliente Python para interagir com o marcos-server
- **marcos-extras** - Compilado de utilitários compatíveis com o sistema MaRCoS
- **marge** - Interface gráfica Python para interagir com o marcos-server

# Estrutura do Repositório Principal
- **Dockerfile** - Imagem Docker principal, constrói e executa o marcos-server
- **local_config.py.example** - Configuração básica do marcos-server (IP, porta, etc.)
- **start_server.sh** - Entrypoint para inicialização do marcos-server
- **GUI** - Diretório do projeto da interface gráfica
  - **GUI/Dockerfile** - Imagem Docker para construção da interface gráfica
  - **GUI/hw_config.py.copy** - Arquivo de configuração de interação com o hardware
  - **GUI/local_config.py.example** - Configuração básica referente ao marcos-server (IP, porta, etc.)
  - **GUI/sys_config.py.copy** - (opcional) Configurações gerais do cliente
  - **GUI/units.py.copy** - Configuração global de unidades de grandeza

# Características dos projetos
O marcos-server é estritamente dependente do hardware (Red Pitaya SDRLab 122-16), não tendo grande utilidade sem ele.
Apesar disso, existe uma pequena camada de teste implementada dentro dele, que emula algumas de suas interações como o hardware e pode ser testado utilizando o cliente python.
Para facilitar o testeo o, o marcos-client foi embutido dentro do server, para teste local dentro do container.

O projeto Marga (ou marcos GUI) apresenta error de compilação devido a um _mismtach_ na versão daa lib pymongo.
Provavelmente será necessário fazer um fork (ou PR) do projeto original e corrigir a versão.

# Como executar
- Tendo o Docker instalado em sua máquina execute o seguinte comando para criar a imagem do marcos-server:
```bash
docker build -f Dockerfile -t marcos-server
```
- Tendo o Docker instalado em sua máquina execute:
```bash
docker run marcos-server
```

Os mesmos passos se aplicam para a interface gráfica, sendo executados em seu diretório raiz "GUI", lembrando de usar um nome específico para a imgem docker, por exemplo, *marcos-gui*.

# Como testar
- Uma vez que o container marcos-server estiver em execução é possível entrar dentro dele para realizar testes de API.
- Entre no container utilizando o comando a seguir:
```bash
docker exec -it {id_do_container} sh
```
Ou
```bash
docker exec -it {id_do_container} bash
```
- Navegue até o dirtório marcos-client e execute o seguinte comando:
```python
python test_server.py
```
- Esse comando deverá executa uma série de testes unitários e deve realizar interações com o server, enviado sequencias de sinais para avaliar diferentes cenários.

- Existe um diretório de dados dentro do marcos-client que aceita inputs de ondas em formato CSV.
- Existem várious outros scripts de teste dentro do marcos-client que podem ser configurados para realizar testes utilizando esses dados.


# Referências
Para mais detalhes, acesse o artigo completo [aqui](https://ar5iv.labs.arxiv.org/html/2208.01616).
