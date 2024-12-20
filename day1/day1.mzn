include "/Users/bokner/Downloads/instance_day1.mzn";

include "globals.mzn";

set of int: ROOMS = 1..20;
set of int: EVENTS = 1..100;

var int: one = 1;

array[EVENTS, ROOMS] of var bool: assignment;

array[EVENTS] of var ROOMS: event_room;
var ROOMS: num_rooms;

%% One event per room
constraint forall(e in EVENTS)(
  global_cardinality(row(assignment, e), [1], [1])
);


constraint forall(e in EVENTS, r in ROOMS)
  (
     assignment[e, r] = 1 -> event_room[e] = r
  );
  
constraint event_room[1] = 1;

constraint num_rooms = sum(r in ROOMS)(sum(col(assignment, r)) > 0);
constraint num_rooms = max(event_room);

solve minimize num_rooms;

