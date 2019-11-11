/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * index_bin_search_initialize.c
 *
 * Code generation for function 'index_bin_search_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "index_bin_search.h"
#include "index_bin_search_initialize.h"
#include "_coder_index_bin_search_mex.h"
#include "index_bin_search_data.h"

/* Function Definitions */
void index_bin_search_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (index_bin_search_initialize.c) */
