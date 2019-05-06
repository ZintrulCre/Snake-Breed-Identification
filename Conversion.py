import os
from tqdm import tqdm
import tensorflow as tf
from tensorflow.keras.models import load_model

model_name = "Snake-VGG16"
keras_model = load_model(model_name + ".h5")

keras_model.summary()

breeds = []
data_path = "./Data/"
breed_names = os.listdir(data_path)
for breed_name in tqdm(breed_names):
    breeds.append(breed_name)
print(breeds)

scale = 1/255.

import coremltools
coreml_model = coremltools.converters.keras.convert(keras_model,
                                                    input_names='image',
                                                    image_input_names='image',
                                                    output_names='output', 
                                                    class_labels=breeds,
                                                    image_scale=scale)


coreml_model.save(model_name + ".mlmodel")