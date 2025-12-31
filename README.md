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
huggingface-cli login
```

Contenedor:
```bash
docker compose exec jupyter huggingface-cli login
```

3) Descarga los modelos en `./models`:

Host (WSL):
```bash
mkdir -p models
huggingface-cli download TheBloke/Nous-Hermes-2-Llama-2-13B-GGUF \
  nous-hermes-2-llama-2-13b.Q4_K_M.gguf \
  --local-dir models --local-dir-use-symlinks False
huggingface-cli download TheBloke/Nous-Hermes-2-Llama-2-13B-GGUF \
  nous-hermes-2-llama-2-13b.Q5_K_M.gguf \
  --local-dir models --local-dir-use-symlinks False
```

Contenedor:
```bash
docker compose exec jupyter bash -lc 'mkdir -p /app/models && \
huggingface-cli download TheBloke/Nous-Hermes-2-Llama-2-13B-GGUF \
  nous-hermes-2-llama-2-13b.Q4_K_M.gguf \
  --local-dir /app/models --local-dir-use-symlinks False && \
huggingface-cli download TheBloke/Nous-Hermes-2-Llama-2-13B-GGUF \
  nous-hermes-2-llama-2-13b.Q5_K_M.gguf \
  --local-dir /app/models --local-dir-use-symlinks False'
```
