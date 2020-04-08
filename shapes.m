function shapes(pix)
    x = round(15*randn(50,1));
    y = round(20*randn(50,1)) + round(8*randn(50,1));


    k = boundary(x,y,1);

    xx = linspace(1-pix/2,pix/2,pix);
    [X,Y] = meshgrid(xx,xx);
    size(xx)

    [in,on] = inpolygon(X,Y,x(k),y(k));

    a = cat(1,X(in),X(on));
    b = cat(1,Y(in),Y(on));

    img = zeros(pix);
    for i = 1:length(X(in))
        img(a(i)+.5*pix,b(i)+.5*pix) = 255;
    end
    figure(1)
    
    
    radius = 10;
    img   = imdilate(img, strel('disk', radius));
    imshow(img)
    
    
end