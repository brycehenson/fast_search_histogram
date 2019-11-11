/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_index_bin_search_api.c
 *
 * Code generation for function '_coder_index_bin_search_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "index_bin_search.h"
#include "_coder_index_bin_search_api.h"
#include "index_bin_search_emxutil.h"
#include "index_bin_search_data.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "_coder_index_bin_search_api",       /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *data, const
  char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  c_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[1] = { -1 };

  const boolean_T bv0[1] = { true };

  int32_T iv1[1];
  int32_T i2;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv0[0],
    iv1);
  ret->allocatedSize = iv1[0];
  i2 = ret->size[0];
  ret->size[0] = iv1[0];
  emxEnsureCapacity_real_T(sp, ret, i2, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *data, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(data), &thisId, y);
  emlrtDestroyArray(&data);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[1] = { 0 };

  y = NULL;
  m0 = emlrtCreateNumericArray(1, iv0, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m0, &u->data[0]);
  emlrtSetDimensions((mxArray *)m0, u->size, 1);
  emlrtAssign(&y, m0);
  return y;
}

void index_bin_search_api(const mxArray * const prhs[2], int32_T nlhs, const
  mxArray *plhs[1])
{
  emxArray_real_T *data;
  emxArray_real_T *edges;
  emxArray_real_T *bin_idx;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &data, 1, &b_emlrtRTEI, true);
  emxInit_real_T(&st, &edges, 1, &b_emlrtRTEI, true);
  emxInit_real_T(&st, &bin_idx, 1, &b_emlrtRTEI, true);

  /* Marshall function inputs */
  data->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "data", data);
  edges->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "edges", edges);

  /* Invoke the target function */
  index_bin_search(&st, data, edges, bin_idx);

  /* Marshall function outputs */
  bin_idx->canFreeData = false;
  plhs[0] = emlrt_marshallOut(bin_idx);
  emxFree_real_T(&bin_idx);
  emxFree_real_T(&edges);
  emxFree_real_T(&data);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_index_bin_search_api.c) */
