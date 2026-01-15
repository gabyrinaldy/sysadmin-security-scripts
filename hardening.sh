#!/bin/bash

# ==============================================================================
# SCRIPT DE HARDENING AUTOMATIZADO (LINUX)
# Autor: @gabyrinaldy
# Descrição: Aplica configurações de segurança em servidores Ubuntu/Debian.
# Foco: Blue Team / Server Hardening
# ==============================================================================

# Cores para logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[!] Iniciando processo de Hardening...${NC}"

# 1. Verificação de Superusuário
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERRO] Este script precisa ser executado como root (sudo).${NC}"
   exit 1
fi

# 2. Atualização do Sistema
echo -e "${GREEN}[+] Atualizando repositórios e pacotes...${NC}"
apt update && apt upgrade -y
apt autoremove -y

# 3. Configuração de Firewall (UFW)
echo -e "${GREEN}[+] Configurando Firewall (UFW)...${NC}"
apt install ufw -y > /dev/null
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
# Adicione outras portas se necessário, ex: ufw allow 80/tcp
echo "y" | ufw enable

# 4. Hardening do SSH
echo -e "${GREEN}[+] Reforçando segurança do SSH...${NC}"
SSH_CONFIG="/etc/ssh/sshd_config"

# Backup do arquivo original antes de alterar
cp $SSH_CONFIG "$SSH_CONFIG.bak"

# Desabilitar login de root via SSH
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $SSH_CONFIG
# Remover suporte a senhas vazias (garantia)
sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' $SSH_CONFIG
# Limitar tentativas de autenticação
sed -i 's/^MaxAuthTries.*/MaxAuthTries 3/' $SSH_CONFIG

systemctl restart ssh

# 5. Segurança de Kernel (Sysctl)
echo -e "${GREEN}[+] Aplicando regras de Kernel (Network Security)...${NC}"
cat <<EOF > /etc/sysctl.d/99-security.conf
# Desabilitar redirecionamentos de IP (Evita MITM)
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0

# Ignorar Pings de Broadcast (Evita Smurf Attacks)
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Proteção contra SYN Flood
net.ipv4.tcp_syncookies = 1
EOF

sysctl --system > /dev/null

echo -e "${YELLOW}[!] Hardening concluído! Execute o script de auditoria para verificar.${NC}"