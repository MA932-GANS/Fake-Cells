function out = MyoB(in,img1,img2)

red = in(:,:,1);
% red = red + 2*(img1-img2).*rand(256);

outer = imdilate(edge(img1),strel('disk',10)).*img1; %edge of the outer mask

% Find high intensity areas at membrane

part1 = heaviside(outer.*red-0.7);
part1 = imdilate(part1,strel('disk',5)).*red;%.*(1-img1);

x = linspace(-25,25,30);
y = normpdf(x,-10,2.5) + normpdf(x,10,2.5);
filt = kron(y,y');

part1 = imfilter(part1,filt).*(imdilate(img1,strel('disk',5))-imerode(img1,strel('disk',8)));
part1 = part1.*(.7-kron(randn(64),ones(4)))/2;
part1 = convn(part1,ones(5)/25,'same').*imdilate(img1,strel('disk',10));

% Highlight the inward moving inner waves

% part2 = heaviside((inner-outer).*red-0.6);
tmp = red - 2*(img1-img2);
part2 = imerode(img2,strel('disk',0)).*(1 - imfilter(tmp,Circle_Filter(40,80)/(pi*40^2)));
part2 = part2.*kron(rand(128),ones(2)).*imerode(img2,strel('disk',4));
part2 = convn(part2, ones(8)/64,'same') + imfilter(part1,Circle_Filter(15,30)/(pi*15^2)).*img1;

% Highlight the outward moving inner waves

tmp2 = (1-part2).*imerode(img2,strel('disk',2));

part3 = imfilter(tmp2,2*Circle_Filter(20,60)/(pi*20^2)).*imdilate((img1-img2),strel('disk',1));
part3 = imfilter(part3,Circle_Filter(5,10)/(pi*5^2));
part3 = part3.*(.3+kron(rand(128),ones(2)));
part3 = 2*convn(part3, ones(5)/25,'same');

%Fill in the blebs

part4 = 1.2*kron(rand(256),ones(1)).*(img1-imdilate(img2,strel('disk',8))).*red;
part4 = convn(part4, ones(7)/7^2,'same');

green = part1 + part2 + part3 + part4;
green = convn(green,ones(5)/25,'same');

out = cat(3,zeros(256),green,zeros(256));

end