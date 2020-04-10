function shapes(pix)
    x = round(15*randn(100,1));
    y = round(25*randn(100,1));


    k = boundary(x,y,1);

    xx = linspace(1-pix/2,pix/2,pix);
    [X,Y] = meshgrid(xx,xx);

    [in,on] = inpolygon(X,Y,x(k),y(k));

    a = cat(1,X(in),X(on));
    b = cat(1,Y(in),Y(on));
    
    %% Creat binary mask

    img = zeros(pix);
    for i = 1:length(X(in))
        img(a(i)+.5*pix,b(i)+.5*pix) = 1;
    end 
    
    img = imdilate(img, strel('disk',15));
    %% Take edges
    
    gr = linspace(-.1,0,8);
    filter = [gr,-sum(gr)];
    
    edges1 = Edge(img,filter);          %Edge of mask
    edges2 = Edge(img-edges1,-filter);  %Edge of 'inner' cell
    cell = cat(3,zeros(pix),zeros(pix),zeros(pix)); % Cell Image
    for i = 1:pix
        for j = 1:pix
            cell(i,j,1) = 3*edges1(i,j)*rand(1);  %Red Channel
            cell(i,j,2) = edges2(i,j)*img(i,j)*rand(1)+0.5*img(i,j)*rand(1); %Green Channel
        end
    end
    
    cell(:,:,1) = imerode(cell(:,:,1),strel('disk', 1));
    cell(:,:,2) = imerode(cell(:,:,2),strel('disk', 1));
    
    imshow(cell)
    
    
end


function [out] = Edge(img, filter)

out = abs(imfilter(img,filter))+abs(imfilter(img,flip(filter))) + abs(imfilter(img,flip(filter)')) + abs(imfilter(img,filter'));

end