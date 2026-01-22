# 🛡️ Linux Server Hardening & Audit Script

> **Blue Team Automation:** Scripts em Bash para aplicar configurações de segurança (Hardening) e auditar servidores Linux (Ubuntu/Debian).

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Security](https://img.shields.io/badge/Focus-CyberSecurity-red?style=for-the-badge)

## 📖 Sobre o Projeto

Este projeto foi desenvolvido com o objetivo de automatizar a segurança inicial de servidores Linux. Em ambientes de infraestrutura, a configuração manual é propensa a erros humanos. Este toolkit resolve isso dividindo o processo em duas etapas: **Auditoria** (Diagnóstico) e **Hardening** (Correção).

Linkedin da criadora: https://www.linkedin.com/in/gabrielarinaldi02/ 

### Funcionalidades Principais
* **Firewall (UFW):** Configuração automática de política "Deny All Incoming" (Bloqueio total de entrada), permitindo apenas SSH.
* **SSH Hardening:** Bloqueio de login root, senhas vazias e limitação de tentativas de autenticação.
* **Kernel Security:** Proteção contra *IP Spoofing*, *SYN Flood* e *ICMP Redirects* (MITM).
* **Auditoria Visual:** Script com feedback colorido para verificar o status de segurança instantaneamente.

---

## 📂 Estrutura dos Arquivos

| Arquivo | Descrição |
| :--- | :--- |
| `audit.sh` | **Diagnóstico.** Verifica vulnerabilidades e configurações atuais. Não altera o sistema. |
| `hardening.sh` | **Correção.** Aplica as configurações de segurança, instala UFW e altera parâmetros do Kernel. |
| `LICENSE` | Termos de uso (MIT License). |

---

## 🚀 Como Usar

### Pré-requisitos
* Um sistema operacional baseado em Debian (Ubuntu, Debian, Kali Linux, Mint).
* Acesso root ou privilégios `sudo`.

### Passo a Passo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/gabyrinaldy/sysadmin-security-scripts.git
   cd sysadmin-security-scripts

2. **Execute o Script:**
   ### Audit.sh
   ```bash
   sudo ./audit.sh

### Hardening.sh
   ```bash
   sudo ./hardening.sh
