# Jupyter + Models

## Descargar modelos desde Hugging Face

1) Si lo ejecutarás en el host (WSL), instala `huggingface-cli` si no lo tienes
   (en el contenedor ya viene por `requirements.txt`):

```bash
pip install -U huggingface_hub
```

2) Inicia sesión (host o contenedor):

Host (WSL):
```bash
hf auth login
```

Contenedor:
```bash
docker compose exec jupyter hf auth login
```

3) Descarga los modelos en `./models`:

Host (WSL):
```bash
mkdir -p models
#mistral
hf download TheBloke/Mistral-7B-Instruct-v0.2-GGUF \
 mistral-7b-instruct-v0.2.Q4_K_M.gguf \
  --local-dir models
hf download MaziyarPanahi/Mistral-7B-Instruct-v0.3-GGUF \
 Mistral-7B-Instruct-v0.3.Q4_K_M.gguf \
  --local-dir models
#Llama
hf download   bartowski/Meta-Llama-3.1-8B-Instruct-GGUF \
  Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf \
  --local-dir /app/jupyter/models
hf download \
  bartowski/Meta-Llama-3.1-8B-Instruct-GGUF \
  Meta-Llama-3.1-8B-Instruct-Q5_K_M.gguf \
  --local-dir /app/jupyter/models

#QWEN
#Opción recomendada: Q4_K_M (3 partes)
mkdir -p jupyter/models/qwen2.5-14b-instruct-q4_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q4_k_m-00001-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q4_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q4_k_m-00002-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q4_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q4_k_m-00003-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q4_k_m

#Opción “más calidad”: Q5_K_M (3 partes)

mkdir -p jupyter/models/qwen2.5-14b-instruct-q5_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q5_k_m-00001-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q5_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q5_k_m-00002-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q5_k_m

hf download Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q5_k_m-00003-of-00003.gguf \
  --local-dir jupyter/models/qwen2.5-14b-instruct-q5_k_m

# Opcion de mas ligereza (Q3_K_M)
mkdir -p jupyter/models/qwen2.5-14b-q3km

hf download \
  Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q3_k_m-00001-of-00002.gguf \
  --local-dir jupyter/models/qwen2.5-14b-q3km
hf download \
  Qwen/Qwen2.5-14B-Instruct-GGUF \
  qwen2.5-14b-instruct-q3_k_m-00002-of-00002.gguf \
  --local-dir jupyter/models/qwen2.5-14b-q3km

```

Contenedor:
```bash
docker compose exec jupyter mkdir -p /app/models
docker compose exec jupyter hf download TheBloke/Mistral-7B-Instruct-v0.2-GGUF \
 mistral-7b-instruct-v0.2.Q4_K_M.gguf \
  --local-dir /app/models
docker compose exec jupyter hf download MaziyarPanahi/Mistral-7B-Instruct-v0.3-GGUF \
 Mistral-7B-Instruct-v0.3.Q4_K_M.gguf \
  --local-dir /app/models
```

## Descargar modelo GPT4All (Mistral 7B Instruct v0.1 Q4_0)

Host (WSL):
```bash
mkdir -p ~/.cache/gpt4all
curl -LO --output-dir .cache/gpt4all/ \
  https://gpt4all.io/models/gguf/mistral-7b-instruct-v0.1.Q4_0.gguf
```

Contenedor:
```bash
docker compose exec jupyter mkdir -p /home/jovyan/.cache/gpt4all
docker compose exec jupyter curl -L -o /home/jovyan/.cache/gpt4all \
  https://gpt4all.io/models/gguf/mistral-7b-instruct-v0.1.Q4_0.gguf
```


# generar makefile de ollama

```bash
docker compose exec ollama bash -lc 'cat > /tmp/Modelfile <<EOF
FROM /models/Mistral-7B-Instruct-v0.3.Q5_K_M.gguf
PARAMETER temperature 0.7
EOF
ollama create mistral-7b-v0.3 -f /tmp/Modelfile'
```
