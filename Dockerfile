FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04 as builder
RUN apt-get update && apt-get install -y python3.12 python3-pip git build-essential cmake
RUN git clone https://github.com/thu-ml/SageAttention.git /SageAttention
RUN cd /SageAttention && \
    sed -i 's/HAS_SM80 = False/HAS_SM80 = True/' setup.py && \
    python3 setup.py bdist_wheel && \
    ls -lh


FROM python:3.12-slim
ARG VERSION=v0.3.47
RUN apt-get update && apt-get install -y git
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN git clone --depth=1 --branch=${VERSION} https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI && \
    git clone --depth=1 https://github.com/Comfy-Org/ComfyUI-Manager.git /opt/ComfyUI/custom_nodes/ComfyUI-Manager && \
    git clone --depth=1 https://github.com/city96/ComfyUI-GGUF.git /opt/ComfyUI/custom_nodes/ComfyUI-GGUF

RUN pip install --no-cache-dir -r /opt/ComfyUI/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt && \
    pip install --no-cache-dir -r /opt/ComfyUI/custom_nodes/ComfyUI-GGUF/requirements.txt

COPY --from=builder /SageAttention/SageAttention.whl /tmp/SageAttention.whl

CMD ["python", "/opt/ComfyUI/main.py", "--listen", "0.0.0.0"]
