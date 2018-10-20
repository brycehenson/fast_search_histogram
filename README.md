# fast_search_based_histogram
**Bryce M. Henson**  
fast 1d histograming algorithms based on binary search

The brute approach to histograming is to compare each bin to each data value (or *count*) and gives a complexity **O(n·m)** where *n* is the number of data values and *m* is the number of bins. This can be improved by two algorithms.
1. **Bin Search, O(n·log(m))**: For each count do a binary search for the histogram bin that it should go into and then increment that bin. Because the bins are already ordered then there is no sorting needed. Best when m>>n (aka sparse histograming).
2. **Count Search, O(m·log(n))**:  For each bin edge do a binary search to find the nearest data index. Use the difference in this data index between bins to give the number of counts.  Must have ordered data for the search to work, sorting first would cost **O(n·log(n))** and would make this method always slower. Best when n>>m which is the most common use use case of regular histograming.

For maximum utility to a user it we desire to create an adaptive wraper that choses the fastest algorithm based on the input size. It needs to be evaluated what the impact of sparsity is on the relative performance.


## Features
count_search_hist  
- sparse opt that will not run the search if the higest edge of the current bin is less than the count after the last bin
  - may slow dense case down by one compare evaluation

| ![A comparison runtime for different hist algorithms](/figs/scaling_comparison.png "Fig1") | 
|:--:| 
 **Figure 1**- Comparison of the search based methods to matlabs inbuilt histogram i7-3610 @ 3.00GHz. The reader should note the inverted Z axis with .Data is random pulled from the uniform unit distributon, bins are uniform across the unit interval. The search algorithms outperform for most combinations of n and m exept for a band ~(m<n & m>1e5) where the worst case is the inbuilt is 5x faster than the search based methods. The more comon use cases are the left side of the plot where m<n. |

## Future work
- try forward prediction for count search.
  - based on the count in the previous bin estimate a better place to start the binary search.
  - improvements of log(n)/log(2*n/m) , ~2.6 for n=1e6 m=1e4
  - worst case log(n)+1
  - works best for dense histogram
- try basic search reduction in Bin Search
   - compare count with last value to search only edges above or below that.
   - NO improvement for counts in the middle log2(n)/(log2(n/2)+1) =~1 
   - for uniform dist aprox 9% speedup for 1e6 see /dev/opt_for_bin_Search.m


## Contributions
-Benjamin Bernard: Binary search modified from fileexchange project [binary-search-for-closest-value-in-an-array](https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array)




