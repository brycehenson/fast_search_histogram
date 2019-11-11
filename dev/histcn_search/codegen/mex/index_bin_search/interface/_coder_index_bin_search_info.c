/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_index_bin_search_info.c
 *
 * Code generation for function '_coder_index_bin_search_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "index_bin_search.h"
#include "_coder_index_bin_search_info.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[6] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs", "FullPath", "TimeStamp" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 6, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 2);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("index_bin_search"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(2.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (1.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, "FullPath", emlrtMxCreateString(
    "C:\\Users\\Bryce\\Dropbox\\UNI\\projects\\programs\\Core_BEC_Analysis\\dev\\index_bin_search.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp", emlrtMxCreateDoubleScalar
                (737740.549212963));
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.6.0.1150989 (R2019a) Update 4"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[10] = {
    "789ced5ac16edb3618568ab6c80e6d75d9806187b5405160eb602e0932b7050a3452ec4485ed38b53d672d5a9792e88a354529a494d839e511fa007b829d76dc"
    "71bd0d3bedb21df6083bec01761826d952626b26ecd6ae0abb22e050c407f3fbf9e7d3f78b94a515adbc2249d2d5e07321f8acae49fd7665d04972d45f90465b",
    "125f89fad5c4386e97a48b23df8bf1efa3de70a887bade6040304515dfd6110b0614dae86c1ad3b13185d4abf75c2431c41d7284cc3ed2c604d5b18d4aced060"
    "170703bb38049d0d4228bc562d64746abe2d318b9f874b8607d2507e7e12acffe294f93910e4474ee04f0a4fd57ba0c111e340613d03816de6b8bad3058d8a06",
    "5ce6bc4486c7c38b170cda1ca80e432da5a0b6b628243d8e3930d111c0d444dd968e698b23c80c2b67c7eb782e88f3f294eb48f671fbe84c01fdf66012dfb479"
    "13e94a8e10cc0d87f8369d17dfe5c4f89c6f80988eaf1374ae8b1f67e42b09f946f1275ae9a02f8deae03f7f3dd43007e5ad7a694b018fd6bf5ebb0b81e73824",
    "940ab20920580736f408d40122c105883395b3c3f9d2d3c3cffffcfde7ef5b29eb2fc5f5bd5fbeae60be69f5f7b1804f4ee035d2eb742ab8583eaeafd18eb2b3"
    "db8087fe501cd5093c93e29004e3b4e6cfeee3f1f18feaee668abe1eac95e16ee6eb93f530c854da7a78f0facb9d3f325f7f477cb3fafa27023e3981578c4e53",
    "6345a35df40e368cb5fd4de5bbb2b2b33cbefe9be0fbd3e6d115cc2f27f077f5dc7e231840d68bc6ad3666dc6b05377eaaba3cd5e6e6fb97047c7284b489e384"
    "bbbf45f57d4dc8378acfe6fb6d9f827ea606a62fa5ea53af1bb7b2e7f945f7fd3b87f9bdfa21d9deec28567d7fa7e61d6e6f1bc5e5f1fdec3e1e1fffa8eeae9f",
    "f9faa960be69f3f5b9804f4ee086632296c3d4432c287c39cc151f134fa315df460c1befcdf77f9991cf10f28de26fa4176e41864cd0cf59f4f776d4c51904c9"
    "0c464a4a5147bf4aff66fb8045af07c78f95c6c949d7caefb97ea1b0ae1a9b8fe01d25ab071f563db839b77af099804f4ee0897ac00d4820cbc5bb80d9f701c9",
    "268a276ef37adfd398c017e36fac97f0f3bf22707b90b721eda4a79bd31f9a9f66fb8145f77fddfaa67a408967d61cbbe0d3dd0dbda03c5ca273a0ccffc7c72f"
    "f2ff5782f9a6cdd717023e398127fc1fba2ee9d5fa6656f4a9e161876ab44aa011ff14208e2f3e777bdbf8ae4d882fc6db51142d0b5233d830cc6bbfa04fe08f",
    "f1f9d407715a63a1a5a8b3fde65fd97e61d1eb855f55d56e5e6dba95fa26ca57ac8d7229df5197a75e64f7f7f8754da7c7af527c4fcc5dc8385ad4f7051521df"
    "283ecb734598a1f0c922ce55a88914df13afde7f96f9fda2fbfd7153e345d2f9b6b8de663572f472ef213dd9cffc3ef3fb7ecb2dddb9d1dbd683ecdc687c1fb7",
    "ecdc281dbeecdc68b6f9ff0305cc09a3", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 12576U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_index_bin_search_info.c) */
