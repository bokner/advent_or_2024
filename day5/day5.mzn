int: W;
int: C;

set of int: WAREHOUSE = 1..W;
set of int: CLIENT = 1..C;

array[WAREHOUSE] of int: max_demand;
array[WAREHOUSE] of float: fixed_cost;


array[CLIENT] of int: client_demand;
array[CLIENT, WAREHOUSE] of float: client_costs;

%% Decision variables
array[CLIENT, WAREHOUSE] of var 0..max(client_demand): client_allocations;

array[WAREHOUSE] of var bool: warehouse_used;

%% Satisfy client demand 
constraint forall(c in CLIENT)(
  sum(row(client_allocations, c)) = client_demand[c]
);

%% Respect max demand for warehouses
constraint forall(w in WAREHOUSE)(
  sum(col(client_allocations, w)) <= max_demand[w]
);

constraint forall(w in WAREHOUSE)(
  warehouse_used[w] = (sum(col(client_allocations, w)) > 0) 
);

%% Minimize total cost
solve minimize sum(c in CLIENT, w in WAREHOUSE)((client_allocations[c, w] > 0) * client_costs[c, w]) + sum(w in WAREHOUSE)(warehouse_used[w]*fixed_cost[w]);
