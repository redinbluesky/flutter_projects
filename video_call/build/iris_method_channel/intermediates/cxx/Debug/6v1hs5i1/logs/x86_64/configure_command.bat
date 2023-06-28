@echo off
"D:\\003_SDK\\Android\\Sdk\\cmake\\3.18.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\Ju Yeong\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\iris_method_channel-1.1.0\\src" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=16" ^
  "-DANDROID_PLATFORM=android-16" ^
  "-DANDROID_ABI=x86_64" ^
  "-DCMAKE_ANDROID_ARCH_ABI=x86_64" ^
  "-DANDROID_NDK=D:\\003_SDK\\Android\\Sdk\\ndk\\23.1.7779620" ^
  "-DCMAKE_ANDROID_NDK=D:\\003_SDK\\Android\\Sdk\\ndk\\23.1.7779620" ^
  "-DCMAKE_TOOLCHAIN_FILE=D:\\003_SDK\\Android\\Sdk\\ndk\\23.1.7779620\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=D:\\003_SDK\\Android\\Sdk\\cmake\\3.18.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=D:\\001_Work\\004_Flutter\\AndroidStudio\\video_call\\build\\iris_method_channel\\intermediates\\cxx\\Debug\\6v1hs5i1\\obj\\x86_64" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=D:\\001_Work\\004_Flutter\\AndroidStudio\\video_call\\build\\iris_method_channel\\intermediates\\cxx\\Debug\\6v1hs5i1\\obj\\x86_64" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\Ju Yeong\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\iris_method_channel-1.1.0\\android\\.cxx\\Debug\\6v1hs5i1\\x86_64" ^
  -GNinja
