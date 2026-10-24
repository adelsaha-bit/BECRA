function TL = tour_length(X, tour)
    tour = [tour tour(1)];
    TL = sum( sqrt(diff(X(tour,1)).^2 + diff(X(tour,2)).^2) );
end