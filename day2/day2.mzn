include "globals.mzn";

int: N;
int: E;

set of int: NODES = 1..N;
set of int: EDGES = 1..E;

array[EDGES] of int: from;
array[EDGES] of int: to;

array[NODES, NODES] of int: distances;
array[NODES, NODES] of int: fuel;

array[NODES] of var bool: path_nodes;
array[EDGES] of var bool: path_edges;

var int: total_fuel;
var int: total_distance;

constraint dpath(N, E, from, to, 1, N, path_nodes, path_edges);

constraint total_distance = sum(e in EDGES)(path_edges[e]*(distances[from[e], to[e]]));
constraint total_fuel = sum(e in EDGES)(path_edges[e]*(fuel[from[e], to[e]]));

constraint total_fuel <= 73;

solve minimize(total_distance);

%% For output (optional)
var set of EDGES: route_edges;
constraint link_set_to_booleans(route_edges, path_edges);
output ["objective: \(_objective)\n",  "from:\t", show([fix(from[e]) | e in route_edges]), "\n", "to:\t", show([fix(to[e]) | e in route_edges])];