include "globals.mzn";

int: R = 4;
int: T = 4;
int: C = 4;
int: S = 30;

set of int: ROOM = 1..R;
set of int: CLASS = 1..C;
set of int: TEACHER = 1..T;
set of int: SLOT = 1..S;

array[ROOM, CLASS, TEACHER] of int: requirements;

array[SLOT, ROOM, CLASS, TEACHER] of var 0..1: assignments;


constraint forall(s in SLOT, c in CLASS)(
  sum(r in ROOM, t in TEACHER)(assignments[s, r, c, t]) = 1
 );
 
 constraint forall(s in SLOT, r in ROOM)(
  sum(c in CLASS, t in TEACHER)(assignments[s, r, c, t]) = 1
 );
 
 constraint forall(s in SLOT, t in TEACHER)(
  sum(r in ROOM, c in CLASS)(assignments[s, r, c, t]) = 1
 );
 
constraint forall(r in ROOM, c in CLASS, t in TEACHER)(
  sum(s in SLOT)(assignments[s, r, c, t]) = requirements[r, c, t]
 );
 
solve minimize sum(assignments);   

output ["{Slot \(s), Room \(r)} -> {Teacher \(t), Class \(c)}" ++"\n"  | s in SLOT, r in ROOM, c in CLASS, t in TEACHER where fix(assignments[s,r, c, t]) = 1];





