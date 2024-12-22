include "globals.mzn";

int: N;
int: M;

set of int: CARS = 1..N;
set of int: MACHINES = 1..M;

array[CARS, MACHINES] of int: durations;

array[CARS] of var CARS: sequence;

%% Start times (car i starts at start[i] at machine j)
array[CARS, MACHINES] of var 0..sum(durations): start;

% The car sequence[i] is at position i in the sequence.
constraint alldifferent(sequence);

%constraint forall(c in CARS, m in 1..M-1)(
%  start[c, m] + durations[c, m] <= start[c, m +1]
%);

constraint forall(c in 1..N-1, m in MACHINES)(
  start[sequence[c], m] + durations[sequence[c], m] <= start[sequence[c+1], m]
);

var 0..sum(durations) : makespan;

constraint makespan = start[sequence[N], M] + durations[sequence[N], M] - 1;

solve minimize makespan;