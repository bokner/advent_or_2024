include "globals.mzn";

int: N;
int: T;

set of int: WORKERS = 1..N;
set of int: TASKS = 1..T;

array[TASKS, WORKERS] of int: costs;

array[TASKS] of var WORKERS: task_assignments;

constraint alldifferent(task_assignments);


solve minimize sum(w in WORKERS)(costs[task_assignments[w], w]);

output ["worker: ", show([w | w in WORKERS]), "\n\n", "task: ", show([task_assignments[w] | w in WORKERS]), "\n", "cost:", show(_objective) ];



