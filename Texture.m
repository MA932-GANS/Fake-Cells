function cell = Texture(img,pix)

    %% Filters
    
    % Red Filter
    red_sz = 30;
    filter2 = (Circle_Filter(red_sz/2,red_sz)/300 - Circle_Filter(5,red_sz));
    
    % Green Filter
    grn_sz = 80;
    filter3 = Circle_Filter(grn_sz/3,grn_sz)/800 + Circle_Filter(grn_sz/2,grn_sz)/1000;
    
    
    %% Red Channel
    
    edges = imdilate(edge(img), strel('disk',2));         %Edge of mask
    
    cell = cat(3,zeros(pix),zeros(pix),zeros(pix)); % Cell Image
    tmp1 = convn(imdilate(imfilter(edges,filter2), strel('disk',5)), ones(10)/100, 'same');

    for i = 1:pix
        for j = 1:pix
            if img(i,j) > 0.05
                cell(i,j,1) = edges(i,j)*(4*tmp1(i,j) + 0.5*rand(1));
            end            
        end
    end
    
     %% Green Channel
    inner = imerode(img, strel('disk',3));  %Edge of 'inner' cell
    tmp2 = imfilter(cell(:,:,1),filter3);
    cell(:,:,1) = convn(cell(:,:,1), ones(8)/40, 'same');
    
    for i = 1:pix
        for j = 1:pix
            if inner(i,j) > 0
                cell(i,j,2) = 3*tmp2(i,j);
            end
        end
    end
    cell(:,:,2) = convn(cell(:,:,2), ones(10)/100, 'same');
%     cell(:,:,1) = convn(cell(:,:,1), ones(7)/49, 'same');
    
    %% Dilate the channels to smooth texture
    cell(:,:,1) = imdilate(cell(:,:,1),strel('disk', 0));
    cell(:,:,2) = imdilate(cell(:,:,2),strel('disk', 0));

end

function circ = Circle_Filter(rad,pix)
r = linspace(rad,rad,100);
theta = linspace(0,2*pi,100);

x = r.*cos(theta);
y = r.*sin(theta);

%Next we create a cell mask running through all the pixels and setting
%them to 1 if the fall in the boundary or 0 if they don't

xx = linspace(1-pix/2,pix/2,pix);
[X,Y] = meshgrid(xx,xx);
[in,on] = inpolygon(X,Y,x,y);

a = cat(1,X(in),X(on)); %array of all indices in and on the boundary
b = cat(1,Y(in),Y(on));

%% Creat binary mask
circ = zeros(pix);
for i = 1:length(X(in))
    circ(a(i)+.5*pix,b(i)+.5*pix) = 1;
end 

end