function bin_to_texture(dim)

if dim == 2
    folder = '2D-figs';
    k = length(dir([folder '/binary-masks/*.png']));

    for i = 1:k
        D = [folder '/binary-masks/'];
        a = imread([D sprintf('mask%d.png',i)])/255;
        subplot(1,5,i)
        imshow(Texture(a,256))
    end
elseif dim == 3
    folder = '3D-figs';
        k = length(dir([folder '/binary-masks/*.png']));
        m = k/66;
        
    for i = 1:m
        for j = 0:23
            D = [folder '/binary-masks/'];
            a = imread([D sprintf('mask%d_layer_%d.png',i,j)])/255;
            figure(i)
            subplot(6,4,j+1)
            imshow(Texture(a,256))
        end
    end
end

end