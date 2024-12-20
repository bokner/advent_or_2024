include "globals.mzn";
%include "gecode.mzn";

%
% Data
%
int: N; % number of nodes
set of int: NODE = 1..N;

%% Upper bound
%int: upper_bound = 400000;
% Node coordinates (for compatibility with dzn)
%array[NODE] of int: x;
%array[NODE] of int: y;  
% Precalculated distance bounds
%int: min_distance;
%int: max_distance;



array[NODE, NODE] of int: distances;  % distance matrix
int: min_val = min([distances[i,j] | i,j in NODE where distances[i,j] > 0]);
int: max_val = max([distances[i,j] | i,j in NODE]);
array[NODE] of var min_val..max_val: d;
%var min_distance..max_distance: distance;

var min_val..sum(distances): distance;

constraint distance  = sum(d);

array[NODE] of var NODE: route;             % the circuit
constraint  forall(i in NODE) (
     distances[i, route[i]] = d[i]
   );
constraint circuit(route);
%constraint alldifferent(route);
constraint value_precede(N, N-1, route);

%constraint distance < 8000;


% %% Semi-circuit
% set of int: NODE0 = 0..n;
% array[NODE0] of var NODE0: route; 
% %% Path
% predicate path(array[NODE0] of var NODE0: x) = 
%   x[0] = 1 /\ x[n] = 1 /\
%   forall(i in 1..n-1)(
%     x[i] > 1
%   ) /\
%   all_different([x[i] | i in 1..n-1])
%   /\ lex_lesseq([x[i] | i in 1..n-1], [x[i] | i in reverse(1..n-1)])
%   ; 


% constraint path(route);

% constraint forall(i in NODE) (
%   distances[route[i-1], route[i]] = d[i]
% );
   

%% Search
annotation relax_and_reconstruct(array[int] of var int,int);
annotation restart_luby(int);

% solve minimize distance;
%solve :: int_search(d, max_regret, indomain_split, complete)
%solve :: int_search(d ++ route, first_fail, indomain_split, complete) %minimize travel_time;

solve
 :: seq_search([
                        %int_search(route, dom_w_deg, indomain_split, complete),
%                         int_search(d ++ route ++ [distance],  occurrence, indomain_split, complete),
                         %int_search([distance],  dom_w_deg, indomain_split, complete),
                         ])
            %:: relax_and_reconstruct(
            %            d, 85)   % 55 is good for smaller problem
                        :: relax_and_reconstruct(route, 95)
            :: restart_luby(1000)
            %::restart_geometric(1.5, 100)
  minimize distance;


% function float: dist_fun(NODE: p1,  NODE: p2) = 
%   sqrt( (x[p1] - x[p2] ) * (x[p1] - x[p2]) +  
%           (y[p1] - y[p2]) * (y[p1] - y[p2]) 
%           );

%output [
       %"route: ", show(route),"\n",
       %show(sum([sqrt(t) | t in d])),
       %"real_distance:", show(sum(i in NODE)(
       %  dist_fun(i, fix(route[i])))),"\n",
%       show(distance)
%];



%%%%%% CIRCUIT
% predicate mycircuit(array[NODE] of var NODE: x) =
%   let { 
%         int: lbx = 1; %min(index_set(x)),
%         int: ubx = n; %max(index_set(x)),
%         array[NODE] of var NODE: z,
%         array[NODE] of var NODE: uncircuit
%   }
%   in
%    all_different(x) /\
%    %all_different(z) /\

%    % put the orbit of x[1] in in z[1..n]
%    % 
%    uncircuit[lbx] = x[x[lbx]] /\ 
%    z[lbx] = x[lbx] /\ 
%    forall(i in lbx+1..ubx) (
%       uncircuit[i] = x[uncircuit[i-1]] /\ 
%       z[i] = x[z[i-1]] 
        
%    )
%    /\ % may not be 1 for i < n
%    forall(i in lbx..ubx-1) (
%       z[i] != lbx
%    )
%    /\  % when i = n it must be 1
%    z[n] = lbx
%         /\ 
%      symmetry_breaking_constraint(   
%      lex_lesseq([uncircuit[i] | i in lbx+1..ubx], [uncircuit[i] | i in reverse(lbx+1..ubx)])
%      )
% ;

%%%%%% END OF CIRCUIT

% array[NODE] of var NODE: uncircuit;
% constraint uncircuit[1] = route[route[1]];
% constraint forall(i in 2..n) (
%   uncircuit[i] = route[uncircuit[i-1]]  
% );

% % breaking symmetry (i.e., (4,2,1,3) and (4,3,1,2) represent the same circuit

% constraint symmetry_breaking_constraint(lex_lesseq([uncircuit[i] | i in 2..n], [uncircuit[i] | i in reverse(2..n)]));

%% Restrict circuit (this might lose some routes, such as for the pair {5, 3, 1, 4, 2} and {5, 3, 4, 1, 2}

%constraint route[1] > route[2];