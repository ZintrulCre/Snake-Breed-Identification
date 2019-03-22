## Pretrained Model

| Model        | Output Layer                      | Shape              |
| ------------ | --------------------------------- | ------------------ |
| MobileNetV2  | out_relu (ReLU)                   | (None, 7, 7, 1280) |
| VGG16        | block5_pool (MaxPooling2D)        | (None, 7, 7, 512)  |
| VGG19        | block5_pool (MaxPooling2D)        | (None, 7, 7, 512)  |
| DenseNet121  | relu (Activation)                 | (None, 7, 7, 1024) |
| NASNetMobile | activation_375 (Activation)       | (None, 7, 7, 1056) |
| Xception     | block14_sepconv2_act (Activation) | (None, 7, 7, 2048) |
|              |                                   |                    |

