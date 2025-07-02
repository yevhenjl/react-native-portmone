// NitroHfPortmonePackage.java
package com.margelo.nitro.hfportmone;

import android.util.Log;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.module.model.ReactModuleInfoProvider;
import com.facebook.react.TurboReactPackage;

import java.util.HashMap;
import java.util.function.Supplier;

public class NitroHfPortmonePackage extends TurboReactPackage {
    static {
        HybridHfPortmoneOnLoad.initializeNative();
    }

    @Nullable
  @Override
  public NativeModule getModule(String name, ReactApplicationContext reactContext) {
    return null;
  }

  @Override
  public ReactModuleInfoProvider getReactModuleInfoProvider() {
    return () -> {
        return new HashMap<>();
    };
  }
}
