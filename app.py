import torch
import torchaudio

# Init is ran on server startup
# Load your model to GPU as a global variable here using the variable name "model"
def init():
    global model
    
    model = TextToSpeech()

# Inference is ran for every server call
# Reference your preloaded global model variable here.
def inference(model_inputs:dict) -> dict:
    global model

    # TODO: replace with `voice = model_inputs.get('voice', None)`, etc.
    preset = 'fast'
    text = 'this should be working now'
    voice = 'tom'

    # Prepare the model
    voice_samples, conditioning_latents = model.load_voice(voice)

    # Run the model
    gen = model.tts_with_preset(text,
                                voice_samples=voice_samples,
                                conditioning_latents=conditioning_latents, 
                                preset=preset)
    
    # Save the audio file:
    torchaudio.save('generated.wav', gen.squeeze(0).cpu(), 24000)

    # Output
    return {"message": "Successfully created generated.wav. Now go get it!"}
