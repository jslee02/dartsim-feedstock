:: Keep some parallelism to reduce wall time while avoiding OOM
set CMAKE_BUILD_PARALLEL_LEVEL=2

:: Remove C++ build artifacts from previous output to free disk space
if exist build rmdir /s /q build

:: Use a build temp directory on the system drive to avoid D: disk exhaustion
set "DARTPY_BUILD_TEMP=%USERPROFILE%\\AppData\\Local\\Temp\\dartpy_build"

:: Avoid DART's MSVC release flags that add /Zi and /GL (big memory spikes).
:: Use conda-forge's nanobind and ImGui packages instead of downloads.
:: Unity builds share MSVC's header parsing across sources (DART's CI measured
:: dartpy objects building 4.5x faster).
set "CMAKE_ARGS=%CMAKE_ARGS% -DDART_MSVC_DEFAULT_OPTIONS=ON"
set "CMAKE_ARGS=%CMAKE_ARGS% -DDART_USE_SYSTEM_NANOBIND=ON -Dnanobind_DIR=%SP_DIR:\=/%/nanobind/cmake"
set "CMAKE_ARGS=%CMAKE_ARGS% -DDART_USE_SYSTEM_IMGUI=ON"
set "CMAKE_ARGS=%CMAKE_ARGS% -DCMAKE_UNITY_BUILD=ON"

:: Compiler flags to reduce memory usage while keeping Release optimization:
:: - /Zm2000     => increase compiler heap (change if needed)
:: - /bigobj     => allow larger .obj files
:: - (NO /Z7)    => no debug symbols
:: - (NO /GL)    => ensure LTCG is off
set "CL=%CL% /Zm2000 /bigobj"
set CXXFLAGS=%CXXFLAGS% /Zm2000 /bigobj

:: Install the Python package (triggers CMake build via pip)
python -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit 1
