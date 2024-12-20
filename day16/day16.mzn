include "globals.mzn";

int: T;
int: C;

%% Tasks
set of int: TASKS = 1..T;
set of int: TASKS0 = 0..T;
%% Crews
set of int: CREWS = 1..C;

%% Start and end times
array[TASKS] of int: start_times;
array[TASKS] of int: end_times;
array[TASKS, TASKS] of int: cost;

%array[CREWS] of var set of TASKS: crew_tasks;

array[CREWS, TASKS] of var bool: assignments;

array[CREWS, TASKS] of var TASKS0: schedule;

%% All tasks are assigned
%constraint sum(assignments) = T;
%% One crew per task
%constraint forall(t in TASKS)(
%  sum(col(assignments, t)) = 1
%);

array[CREWS] of var set of TASKS: crew_sets;


constraint forall(c in CREWS)(
  link_set_to_booleans(crew_sets[c], row(assignments, c))
);

constraint partition_set([crew_sets[c] | c in CREWS], TASKS);

% constraint forall(c in CREWS)(
%    alldifferent_except_0(row(schedule, c))
% );

%% Schedules per crew

constraint forall(c in CREWS)(
   forall(t in 1..T-1 where schedule[c, t] != 0 ) (
    let {
      var TASKS: task = schedule[c, t]; 
      var TASKS: next_task = schedule[c, t+1];} in (
     (task != next_task) ->
      end_times[task] < start_times[next_task]
      )
   )
);

% constraint forall(c in CREWS)(
%   forall(t1, t2 in TASKS where t1 < t2 /\ assignments[c, t1] /\ assignments[c, t2] )(
%     (end_times[t1] < start_times[t2])
%   )
% );

%% Assigned tasks
constraint forall(c in CREWS, t in TASKS)(
  if assignments[c, t] then
    t in row(schedule, c)
  else
      if t > 1 then
        schedule[c, t] = schedule[c, t -1]
        else
         schedule[c, 1] = 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  endif
  endif
);

%% Symmerty breaking
% constraint forall(c in 1..C-1)(
%  lex_lesseq(row(schedule, c), row(schedule, c+1))
% );


%% Testing

% constraint assignments[1, 3] 
%    /\ assignments[2, 1] /\ assignments[2, 6]
%    /\ assignments[3, 4] /\ assignments[3, 7]
%      /\ assignments[4, 2] /\ assignments[5, 5]

%       ;


%output [show(row(schedule, i)) ++ "\n" | i in CREWS];

%% Cost
%% array[CREWS] of var crew_cost = sum(c in CREWS,

% % 

array[CREWS] of var 0..sum(cost): crew_cost;

constraint forall(c in CREWS where card(crew_sets[c]) > 1)(
  crew_cost[c] = sum(t1, t2 in TASKS where t1+1 = t2 
    /\ schedule[c, t1] != 0 /\ schedule[c, t1] != schedule[c, t2]
    %/\ schedule[c, t1] != schedule[c, t2]
    )(
    cost[schedule[c, t1], schedule[c, t2]]
  )
   
);
%var 0..sum(cost): total_cost;

solve minimize sum(crew_cost);

% constraint total_cost = sum(c in CREWS where card(crew_sets[c]) > 1)(sum(t in 1..T-1 where schedule[c, t] != 0) 
%   (
%     let {
%       var TASKS: task = schedule[c, t]; 
%       var TASKS: next_task = schedule[c, t+1];} in

%     (
%     if (task != next_task) then
%       cost[task, next_task]
%      else
%       0
%       endif
%       )
%   ));

