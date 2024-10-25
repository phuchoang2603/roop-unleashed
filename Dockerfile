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
ENV OS=ubuntu2004

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/cuda-${OS}.pin

RUN mv cuda-${OS}.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/7fa2af80.pub
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/ /"
RUN apt-get update

ENV cudnn_version=8.2.4
ENV cuda_version=cuda11.8

RUN apt-get install libcudnn8=${cudnn_version}-1+${cuda_version}
RUN apt-get install libcudnn8-dev=${cudnn_version}-1+${cuda_version}

RUN pip uninstall onnxruntime onnxruntime-gpu -y
RUN pip install onnxruntime-gpu==1.15.1

# launching gradio app 
ENV GRADIO_SERVER_NAME="0.0.0.0"
EXPOSE 7860
ENTRYPOINT python ./run.py
