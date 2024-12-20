include "globals.mzn";

%% Number of items
int: N;
set of int: ITEMS = 1..N;


%% Number of bins
int: B;
set of int: BINS = 1..B;

%% Wights and heights of items 
array[ITEMS] of int: item_width;
array[ITEMS] of int: item_height;

%% Sizes of bins
array[BINS] of int: bin_width;
array[BINS] of int: bin_height;


% What bin each item goes to
array[ITEMS, BINS] of var bool: item_placement;
array[BINS] of var set of ITEMS: item_sets; 

%% Coordinates of items
array[ITEMS, BINS] of var 0..max(bin_width): x;
array[ITEMS, BINS] of var 0..max(bin_height): y;

%% Item rotation
array[ITEMS] of var bool: rotated;

%% The item can't be in more than 1 bin
constraint forall(i in ITEMS)(
  sum(row(item_placement, i)) = 1
);

% constraint forall(b in BINS)(
%   sum(i in item_sets[b])(if rotated[i] then item_height[i] else item_width[i] endif) <= bin_width[b]
% );

constraint forall(b in BINS)(
   sum(i in item_sets[b])(if rotated[i] then item_width[i] else item_height[i] endif) <= bin_height[b]  
);


constraint forall(b in BINS)(
 link_set_to_booleans(item_sets[b], col(item_placement, b))
);

%% Fitting into bins
constraint forall(b in BINS)(
  packed(b)
  %true
);

predicate packed(int: idx) = let {
  int: b_width = bin_width[idx];
  int: b_height = bin_height[idx];
  } in (
   forall(c1, c2 in item_sets[idx] where c1 < c2)(
    let {
      var int: w1 = if rotated[c1] then item_height[c1] else item_width[c1] endif; 
      var int: w2 = if rotated[c2] then item_height[c2] else item_width[c2] endif; 
      var int: h1 = if rotated[c1] then item_width[c1] else item_height[c1] endif; 
      var int: h2 = if rotated[c2] then item_width[c2] else item_height[c2] endif; 
  
    } in
    x[c1, idx] + w1 <= x[c2,idx]  \/ 
    x[c2, idx] + w2 <= x[c1,idx]  \/ 
    y[c1, idx] + h1 <= y[c2,idx]  \/ 
    y[c2, idx] + h2 <= y[c1,idx]    
    ) 
);

solve minimize sum(i in ITEMS, b in BINS)(item_placement[i, b] * item_width[i] * item_height[b]);

output ["obj: \(_objective)\n", "rotated: \(rotated)"];