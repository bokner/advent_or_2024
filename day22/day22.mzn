include "globals.mzn";

int: N;
int: M;

set of int: JOBS = 1..N;
set of int: MACHINES = 1..M;

array[JOBS, MACHINES] of int: durations;
array[JOBS, MACHINES] of int: steps;

int: min_duration = 
    max(j in JOBS)(sum(row(durations, j)));

int: max_duration = sum(durations);

%% Start times (job i starts at start[i] on machine j)
array[JOBS, MACHINES] of var 0..max_duration: start;


constraint forall(j in JOBS, m in 1..M-1)(
  start[j, m] + durations[j, m] <= start[j, m +1]
);

% constraint forall(m in MACHINES)(
%   cumulative(
%     col(start, m),
%     col(durations, m),

%   [1 | i in JOBS],
%   1
%   )
% );

constraint forall(m1, m2 in MACHINES)(
  forall(j1 in 1..N-1, j2 in  (j1+1)..N)(
    (steps[j1, m1]  =  steps[j2, m2])  ->

  (
    start[j1, m1] + durations[j1, m1] <= start[j2, m2]
    \/
    start[j2, m2] + durations[j2, m2] <= start[j1, m1]

  ) 
  )
);


var min_duration..max_duration : makespan;

constraint makespan = max(j in 1..N)(start[j, M] + durations[j, M]);

annotation relax_and_reconstruct(array[int] of var int,int);
annotation restart_luby(int);

solve 
  :: int_search(start, dom_w_deg, indomain_min, complete)
  %:: relax_and_reconstruct(array1d(start), 5)
  %:: restart_luby(100)
  
 minimize makespan;
 
 output ["job \(j): \(row(start, j))\n" | j in JOBS] ++ ["\nmakespan: \(makespan)"];  