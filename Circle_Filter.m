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