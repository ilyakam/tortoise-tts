# Must use a Cuda version 11+
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

# Set up a working directory and copy everything over
WORKDIR /
ADD . .

# Install git & ffmpeg
RUN apt-get update && apt-get install -y git ffmpeg

# Install python packages
# More info on Conda here: https://github.com/neonbjb/tortoise-tts#local-installation
RUN conda install -y pytorch torchvision torchaudio pytorch-cuda=11.6 -c pytorch -c nvidia
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN python3 setup.py install

# Add your model weight files 
# (in this case we have a python script)
RUN python3 download.py

# Add your custom app code, init() and inference()
ADD app.py .

EXPOSE 8000

CMD python3 -u server.py
