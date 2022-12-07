# In this file, we define download_model
# It runs during container build time to get model weights built into the container

import torch

from tortoise.api import TextToSpeech

def download_model():
    model = TextToSpeech()

if __name__ == "__main__":
    download_model()