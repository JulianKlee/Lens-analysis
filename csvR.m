function [ x,y ] = csvR( filename,col1,col2,header )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[A,delimiterOut]=importdata(filename);
for k=header+1:length(A)
    a=A{k};
    del=0;
    i=1;
    tempx='';
    tempy='';
    while del<3 && i<length(a)
        if a(i)==' '
        elseif a(i)==delimiterOut
            del=del+1;
        elseif del==col1-1
            tempx=strcat(tempx,a(i));
        elseif del==col2-1
            tempy=strcat(tempy,a(i));
        end
        x(k)=str2double(tempx);
        y(k)=str2double(tempy);
        i=i+1;
    end
    
    
end

end

