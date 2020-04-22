function shapes_2(num, g_label, purpose)


for n = 1:num
    sd = 25;
    x1 = round(sd*randn(100,1));
    y1 = round(sd*randn(100,1));

    r = round(95*rand(1)+2);
    idx = randsample(100,r);

    x2 = rm_element(x1,idx);
    y2 = rm_element(y1,idx);

    img1 = Bin_Mask(x1,y1,1);
    img2 = Bin_Mask(x2,y2,1);
    r = LinE(img1,img2);
    
    if g_label == "Arp3"
        g = Arp3(r,img1,img2);
    elseif g_label == "Coronin"
        g = Coronin(r,img1,img2);
    elseif g_label == "MyoB"
        g = MyoB(r,img1,img2);
    end
    
%     figure(5)
%     plot(1:1:256,r(128,:,1),'r',1:1:256,g(128,:,2),'g')
%     ylabel('Fluorescence')
%     xlim([0 256])
%     ylim([0 1])

    file = cat(2,r,g);

    imwrite(file,['Data/' g_label '/' purpose '/' (num2str(n)) '.png'])
%     line = zeros(256,256,3);
%     line(128,:,:) = 1;
%     
%     imwrite(r+g+line,'test.png')
end

end

function out = rm_element(vec,idx)

for i = 1:length(idx)
    vec(idx(i)) = 0;
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