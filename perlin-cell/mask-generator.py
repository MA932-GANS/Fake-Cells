import math

import numpy as np
import cv2
from PIL import Image
# Requires https://github.com/pvigier/perlin-numpy/blob/master/perlin2d.py
from perlin2d import generate_perlin_noise_2d

def cone(n):
    # Generate a 'cone' image to force a mask to be like an 'island', in the centre
    c = np.zeros((n, n))
    for x in range(0, n):
        for y in range(0, n):
            c[x, y] = -2 * math.sqrt(math.pow(n/2 - x, 2) + math.pow(n/2 - y, 2))/(n/2)
    return c

def normalize(arr):
    # Normalize the image to be between 0 and 1
    arr = (arr - np.min(arr))/(np.max(arr) - np.min(arr)) 
    return arr

def np_to_pil(arr):
    # convert numpy array to a Pillow image
    arr = arr.astype(np.uint8) * (2**8 - 1)
    return Image.fromarray(arr)

def generate_mask():
    # Generate a mask through overlaying different frequency perlin noise
    mask = generate_perlin_noise_2d((256, 256), (2,2))
    mask += 0.5 * generate_perlin_noise_2d((256, 256), (2,2))
    mask += 0.25 * generate_perlin_noise_2d((256, 256), (4,4))
    mask += 0.125 * generate_perlin_noise_2d((256, 256), (8,8))
    mask += 1/16 * generate_perlin_noise_2d((256, 256), (16,16))

    # Make it central
    mask += cone(256)
    mask = np.power(normalize(mask), 2)

    # Convert to a binary mask, we don't need the rest of the features
    mask = (mask > 0.4).astype(np.uint8)
    
    # Erode to remove small outlying islands
    kernel = np.ones((4,4),np.uint8)
    return cv2.erode(mask,kernel,iterations = 4)

if __name__ == '__main__':
    import matplotlib.pyplot as plt
    r = generate_mask()
    im = np_to_pil(r)
    im.save('test.png')
    plt.imshow(im, cmap='gray')