function out = Coronin(in,img1,img2)

red = in(:,:,1);

% Highlight the inward moving inner waves

% part2 = heaviside((inner-outer).*red-0.6);
tmp = red - 2*(img1-img2);

part2 = imerode(img2,strel('disk',4)).*(1 - imfilter(tmp,Circle_Filter(20,40)/(pi*20^2)));
part2 = part2.*kron(rand(128),ones(2)).*(1-0.5*imerode(img2,strel('disk',20)));
part2 = convn(part2, ones(8)/64,'same');

% Highlight the outward moving inner waves

tmp2 = (1-2.5*part2).*imerode(img2,strel('disk',1));

part3 = imfilter(tmp2,10*Circle_Filter(20,40)/(pi*20^2)).*(img1-img2);
part3 = part3.*kron(rand(128),ones(2));
part3 = convn(part3, ones(8)/64,'same');

%Fill in the blebs

part4 = kron(rand(256),ones(1)).*heaviside(img1-imdilate(img2,strel('disk',5))).*red;
part4 = convn(part4, ones(15)/15^2,'same');

green = part2/1.2 + part3/2 + 0.8*kron(rand(128),ones(2)).*red + part4/1.5;
green = convn(green,ones(5)/25,'same');

out = cat(3,zeros(256),green,zeros(256));

end