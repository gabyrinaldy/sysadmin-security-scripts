#!/bin/bash

# ==============================================================================
# SCRIPT DE AUDITORIA DE SEGURANÇA (VERSÃO V2 - ROBUSTA)
# Descrição: Verifica hardening com tratamento de erros.
# ==============================================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m' # Cor amarela para alertas
NC='\033[0m'

echo ""
echo "========================================"
echo "    RELATÓRIO DE AUDITORIA DE SEGURANÇA "
echo "========================================"
echo ""

check_status() {
    if [ "$1" == "OK" ]; then
        echo -e "[ ${GREEN}OK${NC} ] $2"
    elif [ "$1" == "WARN" ]; then
        echo -e "[ ${YELLOW}WARN${NC} ] $2"
    else
        echo -e "[ ${RED}FALHA${NC} ] $2"
    fi
}

# 1. Verificar UFW (Com checagem se está instalado)
if ! command -v ufw &> /dev/null; then
    check_status "WARN" "Firewall UFW não está instalado."
else
    # Se instalado, verifica se está ativo
    # Precisa de sudo para ver o status real
    if sudo ufw status | grep -q "Status: active"; then
        check_status "OK" "Firewall está ATIVO"
    else
        check_status "FAIL" "Firewall está INATIVO"
    fi
fi

# 2. Verificar Permissão de Root no SSH
if [ -f "/etc/ssh/sshd_config" ]; then
    root_login=$(grep "^PermitRootLogin no" /etc/ssh/sshd_config)
    if [[ ! -z "$root_login" ]]; then
        check_status "OK" "Login de Root via SSH Bloqueado"
    else
        check_status "FAIL" "Login de Root via SSH PERMITIDO"
    fi
else
     check_status "WARN" "Arquivo sshd_config não encontrado (SSH não instalado?)"
fi

# 3. Verificar SYN Cookies (Kernel)
syn_cookies=$(sysctl net.ipv4.tcp_syncookies 2>/dev/null | awk '{print $3}')
if [[ "$syn_cookies" == "1" ]]; then
    check_status "OK" "Proteção SYN Flood (Syncookies) ATIVA"
else
    check_status "FAIL" "Proteção SYN Flood INATIVA"
fi

# 4. Verificar Redirecionamentos ICMP
redirects=$(sysctl net.ipv4.conf.all.accept_redirects 2>/dev/null | awk '{print $3}')
if [[ "$redirects" == "0" ]]; then
    check_status "OK" "Redirecionamentos ICMP Bloqueados"
else
    check_status "FAIL" "Redirecionamentos ICMP Permitidos"
fi

echo ""
echo "========================================"
echo "          FIM DA AUDITORIA"
echo "========================================"
echo ""