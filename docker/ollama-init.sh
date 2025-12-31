#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="mistral-7b-v0.3"
MODEL_FILE="/models/Mistral-7B-Instruct-v0.3.Q5_K_M.gguf"

ollama serve &
SERVER_PID=$!

for _ in $(seq 1 30); do
  if ollama list >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if ! ollama list >/dev/null 2>&1; then
  echo "Ollama server did not start in time."
  exit 1
fi

if ollama list | awk '{print $1}' | grep -qx "${MODEL_NAME}"; then
  echo "Ollama model ${MODEL_NAME} already exists."
else
  if [ ! -f "${MODEL_FILE}" ]; then
    echo "Model file not found: ${MODEL_FILE}"
    exit 1
  fi

  cat > /tmp/Modelfile <<EOF
FROM ${MODEL_FILE}
PARAMETER temperature 0.7
EOF

  ollama create "${MODEL_NAME}" -f /tmp/Modelfile
fi

wait "${SERVER_PID}"
