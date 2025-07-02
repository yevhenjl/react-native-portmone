// ReactActivityHelper.kt
package com.margelo.nitro.hfportmone

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.margelo.nitro.NitroModules
import com.facebook.react.bridge.ReactApplicationContext

/**
 * Helper class to find the current activity from React Native context
 */
object ReactActivityHelper {
    private const val TAG = "ReactActivityHelper"
    private var openedActivity: ReactApplicationContext? = null

    /**
     * Try multiple approaches to get the current activity
     */
    fun getCurrentActivity(): Activity? {

        Log.i(TAG, "call fun getCurrentActivity")
        // First try our activity provider
        val context = NitroModules.applicationContext
        val activity = context?.currentActivity
        if (activity != null) {
            openedActivity = context
            return activity
        }

        // Then try to get it from application context
        return findActivityFromContext(NitroModules.applicationContext)
    }

    /**
     * Try to find activity from any context
     */
    private fun findActivityFromContext(context: Context?): Activity? {
        Log.i(TAG, "call fun findActivityFromContext")
        if (context == null) return null

        // If context is already an activity, return it
        if (context is Activity) {
            Log.i(TAG, "call fun findActivityFromContext: context is Activity")
            return context
        }

        // Unwrap context wrapper to find activity
        if (context is ContextWrapper) {
            Log.i(TAG, "call fun findActivityFromContext: context is ContextWrapper")
            val baseContext = context.baseContext
            if (baseContext is Activity) {
                return baseContext
            }

            return findActivityFromContext(baseContext)
        }

        Log.i(TAG, "call fun findActivityFromContext: context is null")
        return null
    }

    /**
     * Get AppCompatActivity for Activity Result API
     */
    fun getAppCompatActivity(): AppCompatActivity? {
        Log.i(TAG, "call fun getAppCompatActivity")
        val activity = getCurrentActivity()

        if (activity is AppCompatActivity) {
            return activity
        }

        Log.e(TAG, "Current activity is not an AppCompatActivity, cannot use Activity Result API")
        return null
    }

    fun getApplicationContext(): ReactApplicationContext? {
        return openedActivity
    }
}
