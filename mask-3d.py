from mayavi import mlab
import numpy as np
import math
import matplotlib.pyplot as plt
# Requires https://github.com/pvigier/perlin-numpy/blob/master/perlin3d.py
from perlin3d import generate_perlin_noise_3d
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--num_of_outputs", type=int, default=1)
a = parser.parse_args()


def sphere(n):
    # Generate a 'cone' image to force a mask to be like an 'island', in the centre
    c = np.zeros((64, n, n))
    for x in range(0, 64):
        for y in range(0, n):
            for z in range(0, n):
                c[x, y, z] = -3 * math.sqrt(math.pow(32 - 4*x, 2) + math.pow(n/2 - y, 2) + math.pow(n/2 - z, 2))/(n/2)
    return c

def normalize(arr):
    # Normalize the image to be between 0 and 1
    arr = (arr - np.min(arr))/(np.max(arr) - np.min(arr)) 
    return arr

def generate_cell():
    noise = np.zeros((66, 256, 256))
    noise[1:65] = generate_perlin_noise_3d((64, 256, 256), (1,2,2))
    noise[1:65] += 0.5 * generate_perlin_noise_3d((64, 256, 256), (2, 4,4))
    noise[1:65] += 0.25 * generate_perlin_noise_3d((64, 256, 256), (4, 8,8))
    noise[1:65] += sphere(256)
    noise[1:65] = normalize(noise[1:65])
    return noise > 0.8 # mask

if __name__ == '__main__':
    from PIL import Image
    outputs = a.num_of_outputs
    for i in range(1,outputs+1):
        mask = generate_cell()
        images = [Image.fromarray(layer) for layer in mask]
        for j in range(0, len(images)):
            images[j].save('3D-figs/binary-masks/mask' + str(i) + '_layer_' + str(j) + '.png')


