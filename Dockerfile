# Must use a Cuda version 11+
FROM ilyakam/deps-for-tts:002

# Set up a working directory and copy everything over
WORKDIR /
ADD . .

ENV PYTHONPATH="${PYTHONPATH}:/"

# Commented out the three lines below (`##`) because the models were
# already downloaded and stored on the image itself. Surprisingly, it
# only has the following models. But since the image is huge (10+ GB),
# let's run it as-is until it becomes a real problem. If so, I should
# just write/update a script to download the models directly from HF.
# autoregressive.pth, clvp2.pth, diffusion_decoder.pth, and vocoder.pth
## Add your model weight files 
## (in this case we have a python script)
## RUN python3 download.py

EXPOSE 8000

CMD python -u server.py
