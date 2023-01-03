# Must use a Cuda version 11+
FROM ilyakam/tts_w_deps:001

# Set up a working directory and copy everything over
WORKDIR /
ADD . .

RUN pip install -r requirements.txt

# Commented out `setup.py` (`##`) with the hopes that it's not needed.
# It's pointing to the tortoise/tortoise_tts.py script and there are
# a couple of `recursive-include`-s in the `MANIFEST.in`. The majority
# of these requirements are already met in the image itself. The sole,
# remaining requirement is `sanic` and it's installed in the prior step.
## RUN python3 setup.py install

# Commented out the three lines below (`##`) because the models were
# already downloaded and stored on the image itself. Surprisingly, it
# only has the following models. But since the image is huge (10+ GB),
# let's run it as-is until it becomes a real problem. If so, I should
# just write/update a script to download the models directly from HF.
# autoregressive.pth, clvp2.pth, diffusion_decoder.pth, and vocoder.pth
## Add your model weight files 
## (in this case we have a python script)
## RUN python3 download.py

# Commented out the two lines below (`##`) because `ADD . .` should
# have taken care of it by this point
## Add your custom app code, init() and inference()
## ADD app.py .

EXPOSE 8000

CMD python -u server.py
