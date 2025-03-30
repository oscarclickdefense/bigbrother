#!/usr/bin/env bash

#!/bin/bash

# Configuración
SYSLOG_IP="127.0.0.1"
SYSLOG_PORT="514"
SNMP_IP="127.0.0.1"
SNMP_PORT="161"
SYSLOG_MSGS=20
SNMP_QUERIES=20
TMPDIR=$(mktemp -d)
TCPDUMP_IF="lo"  # o la interfaz conectada a los contenedores si no es loopback

echo "=== Validación de alerta por Syslog y SNMP ==="
echo "Usando interfaz: $TCPDUMP_IF"
echo

# Función para limpiar capturas anteriores
cleanup() {
    echo "Limpiando..."
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

# ==============================
# 🟢 VALIDACIÓN SYSLOG
# ==============================
echo "📨 Enviando $SYSLOG_MSGS mensajes Syslog a $SYSLOG_IP:$SYSLOG_PORT..."

tcpdump -i $TCPDUMP_IF udp port $SYSLOG_PORT -w "$TMPDIR/syslog.pcap" &
TCPDUMP_PID_SYSLOG=$!
sleep 1

for i in $(seq 1 $SYSLOG_MSGS); do
    logger -n "$SYSLOG_IP" -P "$SYSLOG_PORT" "Alerta Syslog prueba $i"
done

sleep 2
kill $TCPDUMP_PID_SYSLOG
sleep 1

SYSLOG_COUNT=$(tcpdump -nn -r "$TMPDIR/syslog.pcap" | wc -l)
echo "🔎 Syslog capturado: $SYSLOG_COUNT de $SYSLOG_MSGS mensajes enviados"

SYSLOG_RATIO=$(echo "scale=2; $SYSLOG_COUNT*100/$SYSLOG_MSGS" | bc)

# ==============================
# 🟢 VALIDACIÓN SNMP
# ==============================
echo
echo "📡 Ejecutando $SNMP_QUERIES consultas SNMP a $SNMP_IP:$SNMP_PORT..."

tcpdump -i $TCPDUMP_IF udp port $SNMP_PORT -w "$TMPDIR/snmp.pcap" &
TCPDUMP_PID_SNMP=$!
sleep 1

for i in $(seq 1 $SNMP_QUERIES); do
    snmpwalk -v2c -c public "$SNMP_IP":"$SNMP_PORT" 1.3.6.1.2.1.1.1.0 >/dev/null 2>&1
done

sleep 2
kill $TCPDUMP_PID_SNMP
sleep 1

SNMP_COUNT=$(tcpdump -nn -r "$TMPDIR/snmp.pcap" | grep "UDP" | wc -l)
echo "🔎 SNMP capturado: $SNMP_COUNT de $SNMP_QUERIES consultas enviadas"

SNMP_RATIO=$(echo "scale=2; $SNMP_COUNT*100/$SNMP_QUERIES" | bc)

# ==============================
# ✅ RESULTADO FINAL
# ==============================
echo
echo "📊 Resultados finales:"
echo "Syslog: $SYSLOG_RATIO% de mensajes capturados"
echo "SNMP:   $SNMP_RATIO% de consultas capturadas"

echo
if (( $(echo "$SYSLOG_RATIO >= 90" | bc -l) )) && (( $(echo "$SNMP_RATIO >= 90" | bc -l) )); then
    echo "✅ Validación exitosa: se ha capturado ≥ 90% en ambos casos."
    exit 0
else
    echo "❌ Validación incompleta: no se ha alcanzado el 90% de captura en al menos uno de los casos."
    exit 1
fi



