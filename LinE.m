function out = LinE(img1,img2)

%% Red Channel
outer = imdilate(edge(img1),strel('disk',10)).*img1; %edge of the outer mask
inner = imdilate(edge(img2),strel('disk',8)).*img1; %edge of the inner mask

red = zeros(256);

%Here we would like to highlight where the two edges cross and where the
%inner edge is in the cell, much like cell in the paper, as the red marker
%is brighter where they overlap at the cell edge

for i=1:256
    for j=1:256
        if outer(i,j) == 1 && inner(i,j) == 1
            red(i,j) = 1*rand(1);
        elseif outer(i,j) == 1 && inner(i,j) == 0
            red(i,j) = 0;
        elseif inner(i,j) == 1 && outer(i,j) == 0
            red(i,j) = .5*rand(1);
        end
    end
end

% Blur the first component of the texture
part1 = convn(red, ones(4)/16,'same');

% Next we want to capture the gaussian-shaped distribution in the centre of
% the cell, and blur it to have the same sharpness

x = linspace(-128,128,256);
y = 15*normpdf(x,0,30);
dome = kron(y,y');

part2 = 7*dome.*(1 + kron(rand(16),ones(16))/3);
part2 = convn(part2, ones(2)/4, 'same');

%Add a booster

part3 = img1.*(kron(rand(128),ones(2)))/2;
% part3 = convn(part3, ones(4)/16, 'same');

red = part1 + part2 + part3;
red = convn(red, ones(6)/36, 'same');

% red = convn(red, ones(6)/36, 'same')+0.2*img2.*kron(rand(128),ones(2))+0.2*img1.*kron(rand(128),ones(2));
out = cat(3,red,zeros(256),zeros(256));

end