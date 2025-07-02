#include <jni.h>
#include "HybridHfPortmoneOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
  return margelo::nitro::hfportmone::initialize(vm);
}
