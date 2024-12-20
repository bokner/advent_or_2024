include "globals.mzn";

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
array[NODE] of var min_val..max_val : d; %sum(distances): d;
%var min_distance..max_distance: distance;

var 0..sum(distances): total_distance = sum(d);

%constraint total_distance < 5000;  

array[NODE] of var NODE: route;             % the circuit
constraint  forall(i in NODE) (
     distances[i, route[i]] = d[i]
);
constraint circuit(route);
constraint alldifferent(route);

solve 
  %:: int_search(d, first_fail, indomain_max, complete)
  minimize(
  total_distance);
  
%constraint value_precede(N, 1, route);


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
%annotation relax_and_reconstruct(array[int] of var int,int);
%annotation restart_luby(int);

% solve minimize distance;
%solve :: int_search(d, max_regret, indomain_split, complete)
%solve :: int_search(d ++ route, first_fail, indomain_split, complete) %minimize travel_time;

%solve
% :: seq_search([
%                         int_search(d, max_regret, indomain_split, complete),
%                         int_search(d ++ route ++ [distance],  occurrence, indomain_split, complete),
%                         int_search([distance],  dom_w_deg, indomain_split, complete),
%                         ])
            %:: relax_and_reconstruct(d ++
             %           route, 55)   % 55 is good for smaller problem
            %:: restart_luby(100)
            %::restart_geometric(1.5, 100)
  %minimize sum(d);




