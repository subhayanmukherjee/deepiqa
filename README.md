# Deep Image Quality Assessment (OU,DU,NRIQA)

Algorithm-based Image Quality Assessment outputs a quality score for a given (possibly distorted) input image to mimic the response of a human observer. Traditional IQA required a distortion-free version of the input image (full-reference), knowledge of types of possible distortions (distortion-aware) or training on subjective opinion scores (opinion-aware) and was based on hand-crafted features. This project proposes and validates the first ever method to overcome all of these limitations using learned features.

Please cite our below [paper](https://arxiv.org/pdf/1911.11903) if you use the code in its original or modified form:

*@misc{1911.11903,  
Author = {Subhayan Mukherjee and Giuseppe Valenzise and Irene Cheng},  
Title = {Potential of deep features for opinion-unaware, distortion-unaware, no-reference image quality assessment},  
Year = {2019},  
Eprint = {arXiv:1911.11903},  
}*

# Guidelines

1. This project uses the end-to-end compression paper code available [here](https://github.com/tensorflow/compression). The contents of this repo should be placed inside the [examples](https://github.com/tensorflow/compression/tree/master/examples) folder of the end-to-end compression [repo](https://github.com/tensorflow/compression).
2. The [bls2017.py](https://github.com/subhayanmukherjee/deepiqa/blob/master/bls2017.py) script of this repo has the code changes required to remove the rate-distortion term from the loss function of the [bls2017.py](https://github.com/tensorflow/compression/blob/master/examples/bls2017.py) script of the end-to-end compression [repo](https://github.com/tensorflow/compression), and few other changes, which should be ensured.
3. Please read the text files placed inside the [train](https://github.com/subhayanmukherjee/deepiqa/tree/master/train) and [train_imgs](https://github.com/subhayanmukherjee/deepiqa/tree/master/train_imgs) folders to understand what those folders should contain.
4. First, train the end-to-end architecture as directed in its [repo](https://github.com/tensorflow/compression)'s readme, and then use the trained architecture to encode the training images, by running the [build_natural.m](https://github.com/subhayanmukherjee/deepiqa/blob/master/build_natural.m) script with its *do_fit* flag set to *false*.
6. Next, create the natural model via distribution fitting, by running the [build_natural.m](https://github.com/subhayanmukherjee/deepiqa/blob/master/build_natural.m) script with its *do_fit* flag set to *true*.
7. Now that the natural model is ready and saved, you can call the [discomfiq.m](https://github.com/subhayanmukherjee/deepiqa/blob/master/discomfiq.m) script by passing any color PNG format test image path as parameter, to obtain the score for that image. Higher score means more distortion in the test image.
8. Our model works on compressed content like JPEG2000 also, just convert the file format to PNG for use as test image.
