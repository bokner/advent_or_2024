include "globals.mzn";

int: N;

int: C;

set of int: ITEMS = 1..N;

% Upper Bound on the number of bins used
int: max_bins = N;
set of int: BINS = 1..max_bins;

array[ITEMS] of int: item_sizes;

% What bin each item goes to
array[ITEMS] of var BINS: item_placement;

var BINS: total_bins;

constraint bin_packing(C, item_placement, item_sizes);

constraint total_bins = max(item_placement);
%constraint total_bins <= 49;

solve minimize total_bins; 

