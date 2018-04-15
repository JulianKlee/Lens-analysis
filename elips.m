function [xy,region]=elips(ra,rb,x0,y0,theta)
t=-pi:0.01:pi;
x=ra*cos(t);
y=rb*sin(t);
rot=[cos(theta),-sin(theta);sin(theta),cos(theta)];
xy=rot*[x;y];
xy(1,:)=xy(1,:)+x0; xy(2,:)=xy(2,:)+y0;
region=round(xy);
for xx=-ceil(ra):ceil(ra)
    for yy=-ceil(rb):ceil(rb)
        xi=x0+xx;
        yi=y0+yy;
        rat=abs(xx/cos(atan(yy/xx)));
        rbt=yy/sin(atan(yy/xx));
        if(rat<=ra &&rbt<=rb)
            region=[region,[xi;yi]];
        end
    end
end
end