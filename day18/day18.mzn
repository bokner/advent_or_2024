include "globals.mzn";

int: N;
set of int: NODES = 1..N;
int: E;
set of int: EDGES = 1..E;
int: M;
set of int: MANDATORY = 1..M;

array[EDGES] of int: from;
array[EDGES] of int: to;
array[EDGES] of int: weight;
array[MANDATORY] of int: mandatory;

array[NODES] of var bool: node_included;
array[EDGES] of var bool: edge_included;

var min(weight)..sum(weight): total_weight;

constraint forall(m in MANDATORY)(
  node_included[mandatory[m]] = true
);

constraint steiner(N, E, from, to, weight, node_included, edge_included,
                                 total_weight);

solve minimize total_weight;

output [if fix(edge_included[e]) then "\(from[e]) -> \(to[e])\n"  else "" endif | e in EDGES] ++ ["\ntotal_cost: \(_objective)"];