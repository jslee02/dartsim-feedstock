:: Limit parallel jobs to 1 to reduce memory usage
set CMAKE_BUILD_PARALLEL_LEVEL=2

:: Add compiler flags to increase precompiled header memory and optimize inline functions
set CXXFLAGS=%CXXFLAGS% /Zm800 /Zc:inline

:: Install the Python package
python -m pip install . -vv
