#!/usr/bin/env bash

# Warte, bis Netzwerk verfügbar ist (Ping-Test oder Timeout)
echo "[Netbird] Warte auf Netzwerk..."
for i in {1..10}; do
    if ping -c1 1.1.1.1 &>/dev/null; then
        echo "[Netbird] Netzwerk verfügbar!"
        break
    fi
    sleep 2
done

# Netbird starten
echo "[Netbird] Starte Netbird..."
netbird up --management-url https://netbird.detailm.cloud:443 & disown
