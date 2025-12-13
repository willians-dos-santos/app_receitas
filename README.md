# Minhas Receitas 🍳

Um aplicativo móvel para gestão pessoal de receitas culinárias, desenvolvido em **Flutter** com foco em arquitetura limpa, performance e inteligência artificial.

Este projeto foi desenvolvido originalmente como atividade prática da disciplina **M4.25 | Desenvolvimento de Aplicativos Móveis nas Engenharias** da faculdade **Unimar**, e evoluído com recursos de IA Generativa.

---

## 📱 Funcionalidades

### CRUD Completo
- **Criar**: Cadastro de novas receitas com título, tempo de preparo, ingredientes, modo de preparo e foto.  
- **Ler**: Listagem visual das receitas e tela de detalhes ("Modo Cozinha") focada na leitura.  
- **Atualizar**: Edição completa de todos os campos e substituição da foto.  
- **Deletar**: Remoção de receitas com diálogo de confirmação de segurança.

### 🤖 Inteligência Artificial (Novo!)
- **Chef IA**: Crie receitas completas apenas descrevendo o que você quer comer (ex: "Sobremesa rápida com chocolate").
- **Visão Computacional**: Tire uma foto dos ingredientes que você tem na geladeira e a IA sugere uma receita baseada neles.
- **Preenchimento Automático**: A IA estrutura a resposta e preenche os campos de Título, Ingredientes, Tempo e Modo de Preparo automaticamente.

### Persistência Local (Offline-First)
- Utiliza **Hive (NoSQL)** para salvar dados instantaneamente.  
- O app funciona 100% sem internet.  

### Recursos Nativos
- **Câmera e Galeria**: Integração robusta usando `wechat_camera_picker` para seleção de fotos.  
- **Splash Screen**: Tela de abertura nativa personalizada.  
- **Ícones**: Ícones adaptativos configurados para Android e iOS.  

### UX/UI Aprimorada
- Feedback visual (**SnackBars**) para sucesso e erro.  
- Campos de texto otimizados (multilinhas, capitalização de frases, ação de "Próximo" no teclado).  
- Tradução completa da interface de seleção de imagens para **Português (BR)**.  

---

## 🛠️ Arquitetura e Tecnologias

O projeto segue rigorosamente os princípios da **Clean Architecture** combinada com o padrão de gestão de estado **MVI (Model-View-Intent)**.

- **Linguagem**: Dart  
- **Framework**: Flutter  
- **IA & ML**: Google Generative AI SDK (Gemini 2.5 Flash)
- **Gerenciamento de Estado**: Stream / RxDart (*BehaviorSubject & PublishSubject*)  
- **Injeção de Dependência**: get_it  
- **Banco de Dados Local**: hive e hive_flutter  
- **Mídia**: wechat_camera_picker (substituindo o image_picker padrão para melhor suporte a permissões e UI)  
- **Comparação de Objetos**: equatable  

### Estrutura de Pastas
```
lib/
├── app/                  # Configurações globais (DI, Temas, Traduções)
├── core/                 # Interfaces e utilitários compartilhados
├── features/
│   └── receitas/
│       ├── data/         # Implementação de Repositórios e DataSources (Hive)
│       ├── domain/       # Entidades, Interfaces de Repositório e UseCases
│       └── presentation/ # Camada de UI (MVI)
│           ├── detalhe_receita/ # Tela de Visualização
│           ├── form_receita/    # Tela de Criação/Edição
│           └── lista_receitas/  # Tela Principal
└── main.dart
```

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK instalado e configurado.  
- Dispositivo Android ou iOS (físico ou emulador).  
- Uma **API Key** do Google Gemini (Obtenha no [Google AI Studio](https://aistudio.google.com/)).

### Configuração de Ambiente (.env)
Este projeto utiliza variáveis de ambiente para segurança.
1.  Na raiz do projeto, crie um arquivo chamado `.env`.
2.  Adicione sua chave no arquivo (conforme `.env_example`):
    ```env
    LLM_API_KEY=SuaChaveDoGeminiAqui
    LLM_MODEL=gemini-2.5-flash
    ```

### Instalação
```bash
# Clone o repositório
git clone https://github.com/willians-dos-santos/app_receitas.git
cd app_receitas

# Instale as dependências
flutter pub get

# Gere os adaptadores do Hive (necessário para o banco de dados)
dart run build_runner build --delete-conflicting-outputs

# Execute o aplicativo (passando o arquivo de ambiente)
flutter run --dart-define-from-file=.env
```

---

## 📸 Capturas de Tela
| ![Lista de Receitas](screenshots/lista.jpg) | ![Detalhes](screenshots/detalhes.jpg) | ![Formulário](screenshots/formulario.jpg) | ![Seleção](screenshots/selecao.jpg) |

---

## 🔮 Melhorias Futuras
- [ ] Filtro de busca por nome ou ingrediente.  
- [ ] Categorização por tags (Doce, Salgado, Vegano).  
- [ ] Implementação híbrida com Gemini Nano (On-device) para dispositivos compatíveis.  
- [ ] Backup na nuvem (Firebase).  

---

### Desenvolvido por **Willians Santos**