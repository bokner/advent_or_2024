include "globals.mzn";

% Number of components
int: N;
set of int: COMPONENTS = 1..N;

% Number of connections
int: C;
set of int: CONNECTIONS = 1..C;

% Connections
array[CONNECTIONS] of int: from;

array[CONNECTIONS] of int: to;

% Decision variables
array[COMPONENTS] of var COMPONENTS: position; % = [5, 6, 7, 8, 2, 1, 4, 3];
%= inverse([5, 7, 6, 11, 10, 8, 13, 3, 9, 4, 1, 16, 15, 14, 12, 2]);
%= []



%array[COMPONENTS] of var COMPONENTS: inv; 

%constraint inverse(inv, position);
  
array[CONNECTIONS, CONNECTIONS] of var bool: crossings;
constraint alldifferent(position);

%% Crossings
constraint forall(c1, c2 in CONNECTIONS where c1 < c2)(
  let {
    var int: c1_v1 = position[from[c1]];
    var int: c1_v2 = position[to[c1]];
    var int: c2_v1 = position[from[c2]];
    var int: c2_v2 = position[to[c2]];
 
    var int: start1 = min([c1_v1, c1_v2]);
    var int: end1 = max([c1_v1, c1_v2]);
    var int: start2 = min([c2_v1, c2_v2]);
    var int: end2 = max([c2_v1, c2_v2]);
  } in
  
 
  ((start1 < start2 /\ start2 < end1 /\ end2 > end1)
  \/
  (start2 < start1 /\ start1 < end2 /\ end1 > end2)) = crossings[c1, c2]
 
);

%% Crossings per component
% array[COMPONENTS] of var 0..N*C: crossings_per_component;

% constraint forall(c in COMPONENTS)(
%  crossings_per_component[c] = sum(c1, c2 in CONNECTIONS where c1 < c2)
%  (crossings[c1, c2] /\ (from[c] in [c1, c2] \/ to[c] in [c1, c2]))
%);

%var int: max_per_component = max(crossings_per_component);

%%%%%%%%%%%%%%%%%%%

% Symmetry breaking
constraint position[1] < position[N];

%% 
var int: total_crossings = sum(c1, c2 in CONNECTIONS where c1 < c2)(crossings[c1, c2]);



solve minimize total_crossings;
%solve minimize max_per_component;

output ["total number of crossings: \(total_crossings)\n", 
%"max crossings per component: \(max_per_component)\n", 
"layout: \(inverse(position))\n"]; %crossings:"]; %, "\([if crossings[i, j] then {i, j} else {} endif | i, j in CONNECTIONS where i < j]) \n"];

%%%%%%%%%%%% DATA (day 10 instance) %%%%%%%%%%%%%%
N = 16;
C = 24;
from = array1d(1..24, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,4,13,8,9,14,3,1,6,4]);
to = array1d(1..24, [16,14,13,10,10,9,10,15,16,11,13,15,15,15,16,1,10,10,4,10,1,14,11,12]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%