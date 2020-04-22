function out = Arp3(in,img1,img2)

red = in(:,:,1);

x = linspace(-128,128,256);
y = 15*normpdf(x,0,30);
dome = kron(y,y');

r = 6;
filt = Circle_Filter(r,2*r)/(1.5*pi*r^2);

%Green distribution takes similar shape of lower intensity
part1 = imfilter(red-dome,filt); 

%Noise
part2 = 0.1*kron(rand(128),ones(2)).*(img1+0.1);

%Outside the expanding wave, the green intensity is higher than that
%of the red
part3 = 0.2*kron(rand(64),ones(4)).*(img1-img2);
part3 = convn(part3,ones(7)/49,'same');

green = part1 + part2 + part3;

out = cat(3,zeros(256),green,zeros(256));

end