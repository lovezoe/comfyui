FROM ghcr.io/lovezoe/sage-attention:latest as sage

FROM ubuntu/python:3.12-24.04
ARG VERSION=v0.3.47
RUN apt-get update && apt-get install -y git
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

RUN git clone --depth=1 --branch=${VERSION} https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI && \
    git clone --depth=1 https://github.com/Comfy-Org/ComfyUI-Manager.git /opt/ComfyUI/custom_nodes/ComfyUI-Manager && \
    git clone --depth=1 https://github.com/city96/ComfyUI-GGUF.git /opt/ComfyUI/custom_nodes/ComfyUI-GGUF

RUN pip install --no-cache-dir -r /opt/ComfyUI/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt

COPY --from=sage /sageattention-2.2.0-cp312-cp312-linux_x86_64.whl /tmp/sageattention-2.2.0-cp312-cp312-linux_x86_64.whl

RUN pip install --no-cache-dir /tmp/sageattention-2.2.0-cp312-cp312-linux_x86_64.whl && rm /tmp/sageattention-2.2.0-cp312-cp312-linux_x86_64.whl

CMD ["python", "/opt/ComfyUI/main.py", "--listen", "0.0.0.0", "--use-sage-attention"]
