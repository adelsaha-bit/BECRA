%% Problem Definition mod1 (obj1)
model1=CreateD_Set('kroA100.tsp');
CostFunction=@(tour) TourLength(tour,model1);
nVar=model1.n;
D=model1.D;
X(:,1)=(model1.x);
X(:,2)=(model1.y);