# Deep Image Quality Assessment (OU,DU,NRIQA)

Algorithm-based Image Quality Assessment outputs a quality score for a given (possibly distorted) input image to mimic the response of a human observer. Traditional IQA required a distortion-free version of the input image (full-reference), knowledge of types of possible distortions (distortion-aware) or training on subjective opinion scores (opinion-aware) and was based on hand-crafted features. This project proposes and validates the first ever method to overcome all of these limitations using learned features.

Please cite our [paper](https://arxiv.org/pdf/1911.11903) if you use the code in its original or modified form.

# Guidelines

1. This project uses the end-to-end compression paper code available [here](https://github.com/tensorflow/compression). The contents of this repo should be placed inside the [examples](https://github.com/tensorflow/compression/tree/master/examples) folder of the end-to-end compression [repo](https://github.com/tensorflow/compression).
2. The [bls2017.py](https://github.com/subhayanmukherjee/deepiqa/blob/master/bls2017.py) script of this repo has the code changes required to remove the rate-distortion term from the loss function of the [bls2017.py](https://github.com/tensorflow/compression/blob/master/examples/bls2017.py) script of the end-to-end compression [repo](https://github.com/tensorflow/compression), and few other changes, which should be ensured.
3. Please read the text files placed inside the [train](https://github.com/subhayanmukherjee/deepiqa/tree/master/train) and [train_imgs](https://github.com/subhayanmukherjee/deepiqa/tree/master/train_imgs) folders to understand what those folders should contain.
