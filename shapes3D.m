function shapes3D()
%work in progress
    
    pix = 256;
    sd = pix/5;

    x = pix/2 + round(sd*randn(20,1));
    y = pix/2 + round(sd*randn(20,1));
    z = pix/2 + round(sd*randn(20,1));

%     figure(1)
    DT = delaunayTriangulation([x y z]);
%     [K,~] = convexHull(DT);
%     trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','k','FaceAlpha','0.05')
%     xlim([0 pix]);
%     ylim([0 pix]);
%     zlim([0 pix]);
    
    [p,q,r] = meshgrid(1:1:pix,1:1:pix,1:4:pix);
    points1 = [p(:) q(:) r(:)];
    
    points2 = cat(2,x,y,z);
    
    t = tsearchn(points2,DT,points1);
    
    vlm = zeros(pix,pix,pix/4);
    for i = 1:length(t)
        if ~isnan(t(i))
            points1(i,3)
            vlm(points1(i,1),points1(i,2),(points1(i,3)-1)/4) = 1;
        end
    end
    
    cell = zeros(pix,pix,3,pix/4);
    for i = 1:pix/4
        tmp = imdilate(imerode(vlm(:,:,i), strel('disk',15)), strel('disk',15));
        cell(:,:,:,i) = Texture(cat(3,tmp,tmp,tmp),pix);
    end
    
    
    figure(2)
    for i = 16:27
        subplot(3,4,i-15)
        imshow(cell(:,:,:,i))
    end
    
end