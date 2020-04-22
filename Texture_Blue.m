function img = Texture_Blue()

a = imread('2D-figs/binary-masks/mask1.png')/255;
img = Texture(a,256,1);

threshold = heaviside(img(:,:,1)-0.1);
tmp = edge(threshold);
img(:,:,3) = imdilate(tmp.*imdilate(edge(a*255),strel('disk',1)),strel('disk',2));

figure(1)
subplot(1,2,1)
imshow(img);
subplot(1,2,2)
imshow(edge(a*255))
end