include "globals.mzn";

int: T;
int: C;
int: N;
int: E;

%% Tasks
set of int: TASKS = 1..T;
set of int: TASKS0 = 0..T;
%% Crews
set of int: CREWS = 1..C;

%% Tasks as edges
set of int: EDGES = 1..E;

array[EDGES] of int: from;
array[EDGES] of int: to;
array[EDGES] of int: weight;

array[CREWS, EDGES] of var bool: schedule_assignment;
array[CREWS, TASKS] of var bool: task_assignment;
array[CREWS] of var TASKS: first_assignment;
array[CREWS] of var TASKS: last_assignment;

array[CREWS] of var 0..sum(weight): crew_cost;

constraint forall(c in CREWS)(
    bounded_dpath(N,
      E,
      from,
      to,
      weight,
      first_assignment[c],
      last_assignment[c],
      row(task_assignment, c),
      row(schedule_assignment, c),
      crew_cost[c])
);

%% One crew per task
constraint forall(t in TASKS)(
  sum(col(task_assignment, t)) = 1
);

%solve minimize(sum(crew_cost));

solve minimize sum(c in CREWS)(sum(row(task_assignment, c)) > 0);
%% Optional: output

array[CREWS] of var set of TASKS: crew_tasks;
constraint forall(c in CREWS)(
  link_set_to_booleans(crew_tasks[c], row(task_assignment, c))
);
output ["crew: \(c), task(s): \(crew_tasks[c])\n" | c in CREWS] ++ ["\ntotal cost: \(_objective)"];  

