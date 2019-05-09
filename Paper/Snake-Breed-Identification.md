# Snake Breed Identification

## Abstract

Deep learning is


## Introduction

### Breed Identification

### Target Detection

### Framework

### iOS Application

## Data Set

For the majority of computer vision problems, the quality and quantity of the dataset determine the performance of the neural network to a large extent. All the images will be transferred into the same-resolution pixels for the purpose to be recognized and distinguished by computers, then fed into the neural network, used to train the model in many epochs, and finally, after being convolved and pooled, become a confidence matrix, which is the output of the neural network.

For quality, it means that good datasets should include an object (sometimes may be multiple objects) to be classified, high resolution, exact label and bounding box information (only for object detection). For quantity, however, the image classification problem requires a huge amount of data which is extremely difficult to obtain. Thus collecting data becomes the most difficult part of all the jobs.

The number of breeds of snakes in Australia is roughly estimated at more than 30. Most of the breeds are covered in this project but not all, since some of which are rare and the images of these species are extremely hard to obtain. Every image is carefully censored and labelled before putting into the dataset.

### Data Retrieving

In order to collect data, lots of data sources are tried but only a few are utilized given their quality of images. The most source used to collect data is Google Image. For each breed of snakes, batches of images can be retrieved by searching the breed name. Then the search results can be downloaded in bulk through Python scripts. However, not every single image satisfy the requirement for being fed into neural networks. The first thing is to remove low-quality images, for example, images with too many redundant information. Secondly, manually give images the right label by examing each.

<image/redundant information>

As we all know, ImageNet is a large visual database designed for computer vision research. It contains more than 14 million images and more than 20,000 categories with a typical category. What is most impressing is that each image has bounding box information, which is wonderful for training model for object detection. Depressingly, The top search results under "snake" on ImageNet are Cobra, Night Snake, King Snake, etc., but for this project, we are focusing on snakes in Australia, none of which exists on ImageNet.

There are also some other datasets used in this project, including the Australian Reptile Online Database, Science Photo Library, The Reptile Database. However, the quality of these databases is quite low compared to Google Image, and the quantity is relatively small. Also, there are other problems existing on these databases, like wrongly-labelled.

### Data Cleanse

### Data Augmentation

When training computer vision models, often data augmentation will help whether we are using pre-trained models or building a neural network from scratch. And so data augmentation is one of the techniques that is often used to improve the performance of computer vision systems.

## Training

### Convolutional Neural Network

## iOS Application

## Conclusion

## Future Work