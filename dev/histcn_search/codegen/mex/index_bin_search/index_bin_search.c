/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * index_bin_search.c
 *
 * Code generation for function 'index_bin_search'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "index_bin_search.h"
#include "index_bin_search_emxutil.h"
#include "index_bin_search_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 12,    /* lineNo */
  "index_bin_search",                  /* fcnName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 9,   /* lineNo */
  9,                                   /* colNo */
  "index_bin_search",                  /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  11,                                  /* lineNo */
  19,                                  /* colNo */
  "data",                              /* aName */
  "index_bin_search",                  /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  24,                                  /* colNo */
  "edges",                             /* aName */
  "index_bin_search",                  /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  53,                                  /* lineNo */
  8,                                   /* colNo */
  "vec",                               /* aName */
  "binary_search_first_elm",           /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  20,                                  /* lineNo */
  18,                                  /* colNo */
  "edges",                             /* aName */
  "index_bin_search",                  /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  2,                                   /* colNo */
  "bin_idx",                           /* aName */
  "index_bin_search",                  /* fName */
  "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void index_bin_search(const emlrtStack *sp, const emxArray_real_T *data, const
                      emxArray_real_T *edges, emxArray_real_T *bin_idx)
{
  int32_T num_edges;
  int32_T i0;
  int32_T i1;
  int32_T ii;
  int32_T top;
  int32_T btm;
  int32_T exitg1;
  uint32_T closest_idx;
  int32_T mid;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;

  /*  number of bins is edges-1 +  2 extra for below lowest and above highest */
  num_edges = edges->size[0];
  i0 = data->size[0];
  i1 = bin_idx->size[0];
  bin_idx->size[0] = data->size[0];
  emxEnsureCapacity_real_T(sp, bin_idx, i1, &emlrtRTEI);
  for (ii = 0; ii < i0; ii++) {
    i1 = data->size[0];
    top = 1 + ii;
    if ((top < 1) || (top > i1)) {
      emlrtDynamicBoundsCheckR2012b(top, 1, i1, &emlrtBCI, sp);
    }

    st.site = &emlrtRSI;
    top = num_edges;

    /* modified from mathworks submission by Benjamin Bernard  */
    /* from https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array */
    /*  Returns index of vec that is closest to val, searching between min_idx start_idx .  */
    /* If several entries */
    /*  are equally close, return the first. Works fine up to machine error (e.g. */
    /*  [v, i] = closest_value([4.8, 5], 4.9) will return [5, 2], since in float */
    /*  representation 4.9 is strictly closer to 5 than 4.8). */
    /*  =============== */
    /*  Parameter list: */
    /*  =============== */
    /*  arr : increasingly ordered array */
    /*  val : scalar in R */
    /*  use for debug in loop %fprintf('%i, %i, %i\n',btm,top,mid) */
    btm = 1;

    /*  Binary search for index */
    do {
      exitg1 = 0;
      closest_idx = btm + 1U;
      if ((uint32_T)top > closest_idx) {
        mid = (int32_T)muDoubleScalarFloor((real_T)((uint32_T)top + btm) / 2.0);

        /*  Replace >= here with > to obtain the last index instead of the first. */
        i1 = edges->size[0];
        if ((mid < 1) || (mid > i1)) {
          emlrtDynamicBoundsCheckR2012b(mid, 1, i1, &c_emlrtBCI, &st);
        }

        if (edges->data[mid - 1] <= data->data[ii]) {
          /* modified to work to suit histogram */
          btm = mid;
        } else {
          top = mid;
        }

        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&st);
        }
      } else {
        exitg1 = 1;
      }
    } while (exitg1 == 0);

    /*  Replace < here with <= to obtain the last index instead of the first. */
    /* if top - btm == 1 && abs(arr(top) - val) < abs(arr(btm) - val) */
    /*     btm = top; */
    /* end   */
    /* if closest is on the edge check if it should go up or down */
    if (closest_idx == 2U) {
      i1 = edges->size[0];
      if (1 > i1) {
        emlrtDynamicBoundsCheckR2012b(1, 1, i1, &b_emlrtBCI, sp);
      }

      if (data->data[ii] < edges->data[0]) {
        closest_idx = 1U;
      }
    } else {
      if (closest_idx == (uint32_T)num_edges) {
        i1 = edges->size[0];
        if ((num_edges < 1) || (num_edges > i1)) {
          emlrtDynamicBoundsCheckR2012b(num_edges, 1, i1, &d_emlrtBCI, sp);
        }

        if (data->data[ii] > edges->data[num_edges - 1]) {
          closest_idx = btm + 2U;
        }
      }
    }

    i1 = bin_idx->size[0];
    top = 1 + ii;
    if ((top < 1) || (top > i1)) {
      emlrtDynamicBoundsCheckR2012b(top, 1, i1, &e_emlrtBCI, sp);
    }

    bin_idx->data[top - 1] = closest_idx;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }
}

/* End of code generation (index_bin_search.c) */
