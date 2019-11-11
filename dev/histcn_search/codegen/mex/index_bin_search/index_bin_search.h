/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * index_bin_search.h
 *
 * Code generation for function 'index_bin_search'
 *
 */

#ifndef INDEX_BIN_SEARCH_H
#define INDEX_BIN_SEARCH_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "index_bin_search_types.h"

/* Function Declarations */
extern void index_bin_search(const emlrtStack *sp, const emxArray_real_T *data,
  const emxArray_real_T *edges, emxArray_real_T *bin_idx);

#endif

/* End of code generation (index_bin_search.h) */
