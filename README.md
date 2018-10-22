# fast_search_based_histogram
**Bryce M. Henson**  
fast 1d histograming algorithms based on binary search

The brute approach to histograming is to compare each bin to each data value (or *count*) and gives a complexity **O(n·m)** where *n* is the number of data values and *m* is the number of bins. This can be improved by two algorithms.
1. **Bin Search, O(n·log(m))**: For each count do a binary search for the histogram bin that it should go into and then increment that bin. Because the bins are already ordered then there is no sorting needed. Best when m>>n (sparse histograming).
2. **Count Search, O(m·log(n))**:  For each bin edge do a binary search to find the nearest data index. Use the difference in this data index between bins to give the number of counts.  Must have ordered data for the search to work, sorting first would cost **O(n·log(n))** and would make this method always slower. Best when n>>m (dense histograming) which is the more common use use case.

I obsereve empyricaly (see fig. 1) that there is a fiairly complex dependence of which algo is best on the value of n and m.
For maximum utility to a user it would be great to create an adaptive wraper that choses the fastest algorithm based on the input size. It needs to be evaluated what the impact of sparsity is on the relative performance.

## Benchmarking
| ![A comparison runtime for different hist algorithms](/figs/scaling_comparison.png "Fig1") | 
|:--:| 
 **Figure 1**- Comparison of the search based methods to matlabs inbuilt histogram i7-3610 @ 3.00GHz. The reader should note the inverted Z axis with. Data is sampled from the uniform unit distributon, bins are uniform across the unit interval. The search based algorithms outperform for most combinations of n and m exept for a band ~(m<n & m>1e5) where the inbuilt isup to 5x faster than the search based methods. The more comon use cases are the left side of the plot where m<n. |

## Features
count_search_hist  
- sparse opt: will not run the count search if the higest edge of the current bin is less than next count (after the last bin)
  - may slow dense case down by one compare evaluation

## Future work
- try and use some kind of learner or clasifier to predict the best method to use baed on some model and n,m
  - want a light to calculate method
  - had good sucess with a gaussian kernel SVM: ~87% accuracy, 7ms prediction runtime
  - predition runtime is still prohibitive for an adaptive wraper
    - perhaps a hybrid approach where a more simple rule is used for the small n,m then when the margins or the optimal/suboptimal algorithm are larger than the perdiction time the SVM model is used. 
- try forward prediction for count search.
  - based on the count in the previous bin estimate a better place to start the binary search.
  - improvements of log(n)/log(2*n/m) , ~2.6 for n=1e6 m=1e4
  - worst case log(n)+1
  - works best for dense histogram
 
- try basic search reduction in Bin Search
  - compare count with last value to search only edges above or below that.
  - NO improvement for counts in the middle log2(n)/(log2(n/2)+1) =~1 
  - for uniform dist aprox 5% speedup for 1e6 see /dev/opt_for_bin_Search.m
  - can be generalized to a pre search look up table
    - see [Interpolation search](https://en.wikipedia.org/wiki/Interpolation_search)
	- tradeoff between look up table depth/overhead and increased performance 
    - randomization may improve performance
	

## Contributions
- **Benjamin Bernard** Binary search modified from fileexchange project [binary-search-for-closest-value-in-an-array](https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array)
- **Daniel Eaton**    [sfigure](https://au.mathworks.com/matlabcentral/fileexchange/8919-smart-silent-figure)




