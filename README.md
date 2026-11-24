# Sinalize Área Técnica (iOS)

> Projeto final da pós-graduação em desenvolvimento mobile do Instituto Infnet.

## Sobre o projeto

O **Sinalize** é um sistema para informar problemas na **sinalização de trânsito da cidade do Rio de Janeiro**. É formado por dois aplicativos iOS que se complementam:

- [sinalize](https://github.com/fabcurvello/sinalize): app do **cidadão**, que registra a solicitação.
- **sinalizetec** (este repositório): app da **área técnica**, exclusivo para profissionais credenciados da CET-Rio, que atendem as solicitações.

Os dois apps compartilham o mesmo back-end no Firebase.

## Contexto acadêmico

Projeto final do curso de **pós-graduação em desenvolvimento mobile do Instituto Infnet**, feito por Fabricio Curvello.

## Funcionalidades

- Cadastro do técnico com nome e número de matrícula.
- Login com e-mail e senha; o acesso só é liberado depois que o administrador autoriza a conta.
- Lista das solicitações em aberto enviadas pelos cidadãos.
- Detalhes de cada solicitação e registro do atendimento.

## Arquitetura

- `Models/`: `Solicitacao`, `Tecnico` e `Alerta`.
- `View Controllers/`: telas de entrada, cadastro, aguardando autorização, solicitações em aberto e detalhes.

## Tecnologias

- **Swift 4**
- **UIKit** (Storyboards)
- **Firebase**: Authentication, Realtime Database e Storage
- **SDWebImage**
- **CocoaPods**
- iOS 11+

## Como executar

1. Clone o repositório e instale as dependências:
   ```bash
   git clone https://github.com/fabcurvello/sinalizetec.git
   cd sinalizetec
   pod install
   ```
2. Abra `sinalizetec.xcworkspace` no **Xcode** e execute no simulador.

> Projeto de 2018 (Swift 4). Versões atuais do Xcode podem pedir a conversão da sintaxe do Swift e a atualização dos pods.

## Veja também

- [sinalize](https://github.com/fabcurvello/sinalize): app do cidadão, que completa este projeto.

## Autor

**Fabricio Curvello**: professor de desenvolvimento de software no SENAI-RJ (desde 1997) e em faculdades do grupo Ânima Educação (IBMR e UNA).

- GitHub: [github.com/fabcurvello](https://github.com/fabcurvello)
- LinkedIn: [linkedin.com/in/fabriciocurvello](https://www.linkedin.com/in/fabriciocurvello)
- YouTube: [@fabriciocurvello](https://www.youtube.com/@fabriciocurvello)
