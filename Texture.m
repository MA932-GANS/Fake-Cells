function cell = Texture(img,pix)

    %% Filters
    % Edges
    gr = linspace(-.1,0,5);
    filter1 = [gr,-sum(gr)];
    
    % Red Filter
    filter2 = ones(29)/250;
    filter2(14:16,14:16) = -1/5;
    
    % Green Filter
    x = 0.4*linspace(-1,1,15);
    filter3 = kron(x.^2,(x.^2)');
    
    %% Red Channel
    
    edges1 = Edge(img,filter1);          %Edge of mask
    
    cell = cat(3,zeros(pix),zeros(pix),zeros(pix)); % Cell Image
    tmp1 = imfilter(edges1,filter2);

    for i = 1:pix
        for j = 1:pix
            if  edges1(i,j) > 0 && tmp1(i,j) > 0.4
                cell(i,j,1) = 1.2*tmp1(i,j)-0.1*rand(1);
            elseif edges1(i,j) > 0 && tmp1(i,j) < 0.4
                cell(i,j,1) = .5*tmp1(i,j)-0.1*rand(1);
            end
        end
    end
    
    %% Green Channel
    inner = imerode(img-edges1, strel('disk',8));  %Edge of 'inner' cell
    tmp2 = imfilter(cell(:,:,1),filter3);
    for i = 1:pix
        for j = 1:pix
            if inner(i,j) > 0
                cell(i,j,2) = 2*tmp2(i,j) + 0.1*rand(1);
            end
        end
    end
    
    %% Dilate the channels to smooth texture
    cell(:,:,1) = imdilate(cell(:,:,1),strel('disk', 1));
    cell(:,:,2) = imdilate(cell(:,:,2),strel('disk', 1));

end


function [out] = Edge(img, filter)

out = abs(imfilter(img,filter))+abs(imfilter(img,flip(filter))) + abs(imfilter(img,flip(filter)')) + abs(imfilter(img,filter'));

end