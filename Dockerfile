FROM python:3.12-slim
ARG VERSION=v0.3.7
RUN apt-get update && apt-get install -y git
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN git clone --depth=1 --branch=${VERSION} https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI && \
    git clone --depth=1 https://github.com/Comfy-Org/ComfyUI-Manager.git /opt/ComfyUI/custom_nodes/ComfyUI-Manager && \
    git clone --depth=1 https://github.com/city96/ComfyUI-GGUF.git /opt/ComfyUI/custom_nodes/ComfyUI-GGUF

RUN pip install --no-cache-dir -r /opt/ComfyUI/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt

RUN pip install --no-cache-dir SageAttention

CMD ["python", "/opt/ComfyUI/comfyui.py", "--listen", "0.0.0.0", "--use-sage-attention"]
