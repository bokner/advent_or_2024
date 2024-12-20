include "globals.mzn";

int: NUM_SEGMENTS;
int: NUM_SUBSETS;

set of int: SUBSETS = 1..NUM_SUBSETS;
set of int: SEGMENTS = 1..NUM_SEGMENTS;


array[SUBSETS] of set of int: combinations;
array[SUBSETS] of int: costs;

array[SUBSETS] of var bool: selected;

var min(costs)..sum(costs): total_cost;

constraint total_cost = 
  sum(c in SUBSETS where selected[c]) (costs[c]);

%constraint all_disjoint([if selected[c] then combinations[c] else {} endif | c in SUBSETS]); 
constraint forall(s in SEGMENTS)(
  sum(c in SUBSETS where selected[c])(s in combinations[c]) >=1
);




%constraint forall(c in SUBSETS)(
%  sum(combinations[c]) > 0 <- selected[c]
%);

solve minimize total_cost; 

