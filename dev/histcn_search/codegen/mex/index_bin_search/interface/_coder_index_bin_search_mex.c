/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_index_bin_search_mex.c
 *
 * Code generation for function '_coder_index_bin_search_mex'
 *
 */

/* Include files */
#include "index_bin_search.h"
#include "_coder_index_bin_search_mex.h"
#include "index_bin_search_terminate.h"
#include "_coder_index_bin_search_api.h"
#include "index_bin_search_initialize.h"
#include "index_bin_search_data.h"

/* Function Declarations */
static void index_bin_search_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[2]);

/* Function Definitions */
static void index_bin_search_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[2])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        16, "index_bin_search");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 16,
                        "index_bin_search");
  }

  /* Call the function. */
  index_bin_search_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(index_bin_search_atexit);

  /* Module initialization. */
  index_bin_search_initialize();

  /* Dispatch the entry-point. */
  index_bin_search_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  index_bin_search_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_index_bin_search_mex.c) */
