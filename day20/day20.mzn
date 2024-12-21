include "globals.mzn";

int: N;
set of int: LOCATION = 1..N;
array[LOCATION, LOCATION] of int: flow;
array[LOCATION, LOCATION] of int: distances;

array[LOCATION] of var LOCATION: location_assignments;

constraint alldifferent(location_assignments);

solve 
  :: int_search(location_assignments, 
  dom_w_deg, indomain_min)
  
  :: relax_and_reconstruct(location_assignments, 65)
            :: restart_luby(500)
  minimize 
    sum(i in LOCATION, j in LOCATION)(
        flow[i,j] * distances[location_assignments[i], location_assignments[j]]
    );

output ["facility \(i) => \(location_assignments[i])\n" | i in LOCATION] ++ 
  ["total cost = \(_objective)\n" ];
