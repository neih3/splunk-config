#!/bin/bash

echo "🔧 Stopping Splunk..."
/opt/splunk/bin/splunk stop --answer-yes --no-prompt

echo "🔍 Checking for running Splunk processes..."
ps -ef | grep splunk | grep -v grep

echo "⚠️ Killing remaining Splunk processes..."
pkill -f splunk

echo "📦 Removing Splunk package (dpkg)..."
dpkg -r splunk 2>/dev/null

echo "🧹 Removing Splunk directory..."
rm -rf /opt/splunk

echo "🗑️ Removing leftover init/service scripts (if any)..."
rm -f /etc/init.d/splunk
rm -f /etc/systemd/system/Splunkd.service

echo "🔍 Final check for residual files..."
find / -name "*splunk*" 2>/dev/null

echo "✅ Done. Splunk has been removed completely."
