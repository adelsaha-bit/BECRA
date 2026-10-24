function model=CreateD_Set(filename)
%% read from TSP file 
fileID2 = fopen(filename,'r');
formatSpec = '%f';
sizeA = [3 Inf];
A3 = fscanf(fileID2,formatSpec,sizeA);
fclose(fileID2);

% no. of cities 
n = numel(A3)/3;

% cities in Qurater 
q1=0;q2=0;q3=0;q4=0;

    for i=1:n
        x(i,1)=A3(2,i);
        y(i,1)=A3(3,i);
        %if ((x(i)>=10) && (x(i)<3881)) && ((y(i)>=10) && (y(i)<2592))
         %   x(i,2)=1; y(i,2)=1;
        %end
    end

    D=zeros(n,n);
    
    for i=1:n-1
        for j=i+1:n
            
            D(i,j)=sqrt((A3(2,i)-A3(2,j))^2+(A3(3,i)-A3(3,j))^2);
            
            D(j,i)=D(i,j);
            
        end
    end
    model.n=n;
    model.D=D;    
    model.x=x;
    model.y=y;
    model.A=A3;


end