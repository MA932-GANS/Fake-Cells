function Dynamic_Cell(time)
pix = 256; %Number of pixels
% num - number of files to save from code
% purpose - what is the file to be used for? 'train' or 'test'
% stack_a = zeros(pix,pix,3,time-1);
% stack_b = zeros(pix,pix,3,time-1);
stack_c = zeros(pix,pix,3,time-1);

sd = 25; %Standard Deviation
%initial points
x1 = round(sd*randn(10,1));
y1 = round(sd*randn(10,1));

x2 = round(sd/2*randn(50,1));
y2 = round(sd/2*randn(50,1));
t = 1;

while t<time
    
    img1 = Bin_Mask(cat(1,x1,x2),cat(1,y1,y2),1);
    img2 = Bin_Mask(x2,y2,1);
    
    r = LinE(img1,img2);
%     g1 = Arp3(r,img1,img2);
%     g2 = Coronin(r,img1,img2);
    g3 = MyoB(r,img1,img2);

%     stack_a(:,:,:,t) = r+g1;
%     stack_b(:,:,:,t) = r+g2;
    stack_c(:,:,:,t) = r+g3;
    
    x1 = random_step(x1);
    y1 = random_step(y1);
    x2 = random_step(x2);
    y2 = random_step(y2);
    t = t+1;

%     %% Texture
%     img = imdilate(img, strel('disk',15)); %Dilate the image, more cell-like
%     cell = Texture(img,pix,round(sf)); %Add the protein textures
%     
%     %% Save to File for pix2pix
%     
%     r = cat(3,cell(:,:,1),zeros(pix),zeros(pix));
%     g = cat(3,zeros(pix),cell(:,:,2),zeros(pix));
%     b = cat(3,zeros(pix),zeros(pix),cell(:,:,3));
%     rgb = r+g+b;
%     
%     figure(1)
%     subplot(1,3,1)
%     imshow(r)
%     subplot(1,3,2)
%     imshow(g)
%     subplot(1,3,3)
%     imshow(rgb)
%     
%     file = cat(2,r,g,b);
% 
% %     imwrite(file,['2D-figs/' purpose '/Fake-Cell' (num2str(n)) '.png'])
%     
% end
    
end

figure(1)
for i = 1:time-1
%     subplot(1,3,1)
%     imshow(stack_a(:,:,:,i))
%     subplot(1,3,2)
%     imshow(stack_b(:,:,:,i))
%     subplot(1,3,3)
    imshow(stack_c(:,:,:,i))
    pause(0.005)
end

end

function out = random_step(vec)

for i = 1:length(vec)
    r = rand(1);
    if r < 1/3
        vec(i) = vec(i)+3;
    elseif r > 2/3
        vec(i) = vec(i)-3;
    end
end

out = vec;
    
end

function img = Bin_Mask(x,y,sf)
pix = 256;
k = boundary(x,y,sf);

%Next we create a cell mask running through all the pixels and setting
%them to 1 if the fall in the boundary or 0 if they don't

xx = linspace(1-pix/2,pix/2,pix);
[X,Y] = meshgrid(xx,xx);
[in,on] = inpolygon(X,Y,x(k),y(k));

a = cat(1,X(in),X(on)); %array of all indices in and on the boundary
b = cat(1,Y(in),Y(on));

%% Creat binary mask

img = zeros(pix);
for i = 1:length(a)
    img(a(i)+.5*pix,b(i)+.5*pix) = 1;
end 

%% Texture
img = imdilate(img, strel('disk',15));

end