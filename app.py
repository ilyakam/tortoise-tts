import base64
import io
import torchaudio

from tortoise.api import TextToSpeech
from tortoise.utils.audio import load_voice

# Init is ran on server startup
# Load your model to GPU as a global variable here using the variable name "model"
def init():
    print('Running `init()` in `app.py`...')

    global model

    model = TextToSpeech()

    print('Finished running `init()` in `app.py`. Waiting for an `interface()` call.')

# Inference is ran for every server call
# Reference your preloaded global model variable here.
def inference(model_inputs:dict) -> dict:
    print(f'Running `inference()` in `app.py` with a dict of {model_inputs}')

    global model

    preset = model_inputs.get(preset, 'fast')
    text = model_inputs.get(text, '[annoyed] no text provided')
    voice = model_inputs.get(voice, 'tom')

    # Prepare the model
    voice_samples, conditioning_latents = load_voice(voice)

    # Run the model
    gen = model.tts_with_preset(text,
                                voice_samples=voice_samples,
                                conditioning_latents=conditioning_latents,
                                preset=preset)

    buffer = io.BytesIO()

    # Save the audio file:
    torchaudio.save(buffer, gen.squeeze(0).cpu(), 24000, format='wav')

    b64bytes = base64.b64encode(buffer.getvalue())

    b64string = f'data:audio/wav;base64,{b64bytes.decode("ascii")}'

    print(f'base64 string of the wav file is:\n\n{b64string}')

    # Output
    return {"base64wav": b64string}
