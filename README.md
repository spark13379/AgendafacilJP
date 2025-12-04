# Agenda Fácil JP

Um hub completo de agendamento que conecta pacientes a especialistas, médicos às suas agendas e administradores ao controle total, tudo com um design elegante e uma experiência de usuário impecável.

## 🚀 Sobre o Projeto

Este aplicativo foi desenvolvido com Flutter e Firebase, oferecendo uma solução robusta para o gerenciamento de consultas médicas. A plataforma atende a três perfis de usuários distintos:

-   **Pacientes:** Podem buscar especialistas, ver perfis de médicos e agendar consultas.
-   **Médicos:** Gerenciam suas agendas, horários e compromissos.
-   **Administradores:** Têm controle total sobre o cadastro de médicos e especialidades.

## ✨ Tecnologias Utilizadas

-   **Frontend:** Flutter
-   **Backend & Banco de Dados:**
    -   Firebase Authentication
    -   Cloud Firestore
    -   Firebase App Check

## ⚙️ Como Executar o Projeto

Para executar este projeto localmente, siga os passos abaixo.

### Pré-requisitos

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
-   Uma conta Firebase.
-   O emulador Android configurado ou um dispositivo físico.

### Passos

1.  **Clone o repositório:**
    ```sh
    git clone https://github.com/spark13379/AgendafacilJP.git
    cd AgendafacilJP
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Configure o Firebase:**
    Este projeto requer uma configuração com um projeto Firebase para funcionar.
    
    -   Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
    -   Siga as instruções do `flutterfire configure` para registrar seu app Android.
    -   **Importante:** Adicione as **chaves de assinatura SHA-1 e SHA-256** do seu ambiente de desenvolvimento nas configurações do app Android no Firebase Console. Sem isso, o Firebase bloqueará o login.
    -   Baixe o arquivo `google-services.json` atualizado e coloque-o na pasta `android/app`.
    -   No console do Firebase, ative a **Authentication** (com o provedor de Email/Senha), o **Cloud Firestore** (crie o banco de dados) e o **App Check** (registrando o Play Integrity para Android).

4.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

---
