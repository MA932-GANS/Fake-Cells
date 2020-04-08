function shapes3D(pix)
    
    sd = pix/7;

    x = pix/2 + round(sd*randn(20,1));
    y = pix/2 + round(sd*randn(20,1));
    z = pix/2 + round(sd*randn(20,1));

    figure(1)
    DT = delaunayTriangulation([x y z]);    
    [K,~] = convexHull(DT);
    trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','k','FaceAlpha','0.05')
    xlim([0 pix]);
    ylim([0 pix]);
    zlim([0 pix]);
    
    [p,q,r] = meshgrid(1:1:pix,1:1:pix,1:1:pix);
    points1 = [p(:) q(:) r(:)];
    
    points2 = cat(2,x,y,z);
    
    t = tsearchn(points2,DT,points1);
    
    vlm = zeros(pix,pix,pix);
    for i = 1:length(t)
        if ~isnan(t(i))
            vlm(points1(i,1),points1(i,2),points1(i,3)) = 255;
        end
    end    
    
    figure(2)
    for i = 1:pix/8
        subplot(4,pix/32,i)
        imshow(imdilate(vlm(:,:,8*i), strel('disk', round(pix/25))))
    end
end