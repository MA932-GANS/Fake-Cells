function shapes(num,purpose)

% num - number of files to save from code
% purpose - what is the file to be used for? 'train' or 'test'

for n = 1:num
    pix = 256; %Number of pixels
    sd = pix/10; %Standard Deviation

    %To produce an arbitrary cell shape, we draw a number of normally 
    %distributed integers and form a boundary round them with the function
    %boundary(x,y,sf) where sf is shrink factor

    x = round(sd*randn(100,1));
    y = round(sd*randn(100,1));
    k = boundary(x,y,1);

    %Next we create a cell mask running through all the pixels and setting
    %them to 1 if the fall in the boundary or 0 if they don't

    xx = linspace(1-pix/2,pix/2,pix);
    [X,Y] = meshgrid(xx,xx);
    [in,on] = inpolygon(X,Y,x(k),y(k));

    a = cat(1,X(in),X(on)); %array of all indices in and on the boundary
    b = cat(1,Y(in),Y(on));

    %% Creat binary mask

    img = zeros(pix);
    for i = 1:length(X(in))
        img(a(i)+.5*pix,b(i)+.5*pix) = 1;
    end 

    %% Texture
    img = imdilate(img, strel('disk',10)); %Dilate the image, more cell-like
    cell = Texture(img,pix); %Add the protein textures

    %% Save to File for pix2pix
    
    r = cat(3,cell(:,:,1),zeros(pix),zeros(pix));
    g = cat(3,zeros(pix),cell(:,:,2),zeros(pix)); 
    
    file = cat(2,r,g);

    imwrite(file,['2D-figs/' purpose '/Fake-Cell' (num2str(n)) '.png'])
    
end
    
end