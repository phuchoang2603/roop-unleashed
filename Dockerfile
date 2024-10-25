FROM python:3.11

# making app folder
WORKDIR /app

# copying files
COPY . .

# installing requirements
RUN apt-get update 
RUN apt-get install ffmpeg -y
RUN pip install --upgrade pip 
RUN pip install -r ./requirements.txt 

# nvidia
RUN pip install --upgrade setuptools pip wheel
RUN pip install nvidia-pyindex
RUN pip install nvidia-cuda-runtime-cu11
RUN pip install nvidia-cudnn-cu11
RUN pip uninstall onnxruntime onnxruntime-gpu
RUN pip install onnxruntime-gpu==1.15.1

# launching gradio app 
ENV GRADIO_SERVER_NAME="0.0.0.0"
EXPOSE 7860
ENTRYPOINT python ./run.py
