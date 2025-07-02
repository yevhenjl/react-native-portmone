const {
  withProjectBuildGradle,
  withAppBuildGradle,
} = require('@expo/config-plugins')

const withPortmoneAndroidDeployment = (config) => {
  // Add Maven repository to android/build.gradle
  config = withProjectBuildGradle(config, (config) => {
    if (config.modResults.language === 'groovy') {
      // Check if Portmone repository is already added to avoid duplicates
      if (
        !config.modResults.contents.includes(
          'github.com/Portmone/Android-e-Commerce-SDK'
        )
      ) {
        // Find JitPack repository and add Portmone right after it
        const jitpackPattern =
          /(maven\s*{\s*url\s*['"]https:\/\/www\.jitpack\.io['"].*?})/

        if (jitpackPattern.test(config.modResults.contents)) {
          config.modResults.contents = config.modResults.contents.replace(
            jitpackPattern,
            `$1\n        maven { url "https://github.com/Portmone/Android-e-Commerce-SDK/raw/master/" }`
          )
        } else {
          // Fallback: Add to all repositories if JitPack is not found
          config.modResults.contents = config.modResults.contents.replace(
            /allprojects\s*{\s*repositories\s*{/,
            `allprojects { repositories {
          maven { url "https://github.com/Portmone/Android-e-Commerce-SDK/raw/master/" }`
          )
        }
      }
    }
    return config
  })

  // Add dependency to android/app/build.gradle
  config = withAppBuildGradle(config, (config) => {
    if (config.modResults.language === 'groovy') {
      // Check if dependency is already added to avoid duplicates
      if (
        !config.modResults.contents.includes('com.portmone.ecomsdk:ecomsdk')
      ) {
        config.modResults.contents = config.modResults.contents.replace(
          /dependencies\s*{/,
          `dependencies {
      implementation 'com.portmone.ecomsdk:ecomsdk:3.0.8'`
        )
      }
    }
    return config
  })

  return config
}

module.exports = withPortmoneAndroidDeployment
