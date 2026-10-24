
[minValue, minIndex] = min(L);
p=pk(minIndex,:);
L=minValue;

%function [p,L] = exchange2(p,D,X)
%EXCHANGE2 Improve tour p by 2-opt heuristics (pairwise exchange of edges).
%   The basic operation is to exchange the edge pair (ab,cd) with the pair
%   (ac,bd). The algorithm examines all possible edge pairs in the tour and
%   applies the best exchange. This procedure continues as long as the
%   tour length decreases. The resulting tour is called 2-optimal.

n = numel(p);

% Tour length
L = D(p(n),p(1));
for j = 2:n
    L = L + D(p(j-1),p(j));
end

zmin = -L;

% Iterate until the tour is 2-optimal
while zmin/L < -1e-6

    zmin = 0;
    i = 0;
    b = p(n);

    % Loop over all edge pairs (ab,cd)
    while i < n-2
        a = b;
        i = i+1;
        b = p(i);
        Dab = D(a,b);
        j = i+1;
        d = p(j);
        while j < n
            c = d;
            j = j+1;
            d = p(j);
            % Tour length diff z
            % Note: a == d will occur and give z = 0
            z = (D(a,c) - D(c,d)) + D(b,d) - Dab;
            % Keep best exchange
            if z < zmin
                zmin = z;
                imin = i;
                jmin = j;
            end
        end
    end

    % Apply exchange
    if zmin < 0
        p(imin:jmin-1) = p(jmin-1:-1:imin);
        L = L + zmin;
        iminm1=imin-1 ; jminm1=jmin-1;
        % Closed polygon: point number "0" becomes point "n"
        if imin==1, iminm1=n; end
        if jmin==1, jminm1=n; end
        x = X(p,1);
        y = X(p,2);
        % Highlight the edges 
        plot([x(iminm1) x(jminm1)],[y(iminm1) y(jminm1)],'b','LineWidth',2)
        plot([x(imin) x(jmin)],[y(imin) y(jmin)],'b','LineWidth',2)
        pause(0.2)
        % Erasure of them
        plot([x(iminm1) x(jminm1)],[y(iminm1) y(jminm1)],'w','LineWidth',2)
        plot([x(imin) x(jmin)],[y(imin) y(jmin)],'w','LineWidth',2)
        % Plot of new edges
        plot([x(iminm1) x(imin)],[y(iminm1) y(imin)],'r','LineWidth',2)
        plot([x(jminm1) x(jmin)],[y(jminm1) y(jmin)],'r','LineWidth',2)
        pause(0.2)
        str = sprintf('Tour Length of BECRA_2opt: %g',L);
        title(str)
    end
best_BECRA_2opt=L;
end
%end