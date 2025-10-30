# Receitas App (Atividade Prática)

Este projeto é um MVP (Produto Mínimo Viável) de um aplicativo de catálogo de receitas, desenvolvido como atividade prática da disciplina de Desenvolvimento de Aplicativos Móveis.

O objetivo foi criar um app funcional com CRUD básico, persistência local e integração com um recurso nativo do dispositivo.

## 🚀 Tecnologias Utilizadas

* **Flutter (Dart):** Framework principal para o desenvolvimento multiplataforma.
* **Hive:** Banco de dados NoSQL local, leve e rápido, usado para a persistência dos dados das receitas.
* **Image Picker:** Plugin para acessar a câmera e a galeria do dispositivo, permitindo adicionar fotos às receitas.

## ✨ Recursos Implementados

O aplicativo cumpre os seguintes requisitos:

* **2 Telas:**
    * `Tela de Lista`: Exibe todas as receitas cadastradas.
    * `Tela de Formulário`: Permite o cadastro (e edição/exclusão) de novas receitas.
* **CRUD Básico:**
    * **Criar (Create):** Adicionar novas receitas através do formulário.
    * **Ler (Read):** Listar todas as receitas salvas na tela principal.
    * **Excluir (Delete):** Remover receitas (ex: deslizando o item na lista).
* **Persistência Local:**
    * Os dados (incluindo o caminho das imagens) são salvos localmente usando o Hive. As receitas permanecem no app mesmo após ele ser fechado e reaberto.
* **Recurso Nativo:**
    * Integração com a **Câmera/Galeria** (`image_picker`) para anexar uma foto à receita durante o cadastro.

## 🏃 Como Rodar

1.  Clone este repositório.
2.  Garanta que o Flutter SDK esteja instalado e configurado.
3.  Rode `flutter pub get` para instalar as dependências.
4.  Execute o `build_runner` (necessário para o Hive):
    ```bash
    flutter packages pub run build_runner build
    ```
5.  Execute o aplicativo em um emulador ou dispositivo físico:
    ```bash
    flutter run
    ```