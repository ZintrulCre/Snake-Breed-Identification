import sys

if len(sys.argv) != 3:
    sys.exit()

if sys.argv[1] == '-h':
    print('python Conversion.py <model.h5> <description>')
    sys.exit()

import os
from tqdm import tqdm
from keras.models import load_model

model_name = sys.argv[1].split('.')[0]
keras_model = load_model(sys.argv[1])

keras_model.summary()

breeds = []
data_path = "../Data/"
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

coreml_model.author = "Zhengyu Chen"
coreml_model.license = "BSD"
coreml_model.short_description = sys.argv[2]

coreml_model.save(model_name + ".mlmodel")