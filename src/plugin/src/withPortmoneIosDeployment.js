const fs = require('fs')

const path = require('path')

const { withDangerousMod } = require('@expo/config-plugins')
const {
  mergeContents,
} = require('@expo/config-plugins/build/utils/generateCode')

const xcode = require('xcode')

const IOS_DEPLOYMENT_TARGET = '16.6'

const withPortmoneIosDeployment = (config) => {
  return withDangerousMod(config, [
    'ios',
    async (config) => {
      // Find the Podfile
      const podfile = path.join(
        config.modRequest.platformProjectRoot,
        'Podfile'
      )
      const podfileContents = fs.readFileSync(podfile, 'utf8')

      // Merge the contents of the Podfile to set deployment target
      const setDeploymentTarget = mergeContents({
        tag: 'ios-deployment-target',
        src: podfileContents,
        newSrc: `
          installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '${IOS_DEPLOYMENT_TARGET}'
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
              config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            end
          end`,
        anchor: /post_install do \|installer\|/i,
        offset: 1,
        comment: '#',
      })

      if (!setDeploymentTarget.didMerge) {
        console.log('Failed to set iOS deployment target in Podfile')
        return config
      }

      fs.writeFileSync(podfile, setDeploymentTarget.contents)

      // Update the Xcode project file
      const pbxprojPath = path.join(
        config.modRequest.platformProjectRoot,
        'example.xcodeproj',
        'project.pbxproj'
      )

      const project = xcode.project(pbxprojPath)
      project.parseSync()

      // Update the minimum deployment target in all build configurations
      Object.values(project.pbxXCBuildConfigurationSection())
        .filter((config) => config.buildSettings)
        .forEach((config) => {
          config.buildSettings.IPHONEOS_DEPLOYMENT_TARGET =
            IOS_DEPLOYMENT_TARGET
        })

      fs.writeFileSync(pbxprojPath, project.writeSync())

      console.log(
        `iOS Deployment target successfully set to ${IOS_DEPLOYMENT_TARGET}`
      )

      return config
    },
  ])
}

module.exports = withPortmoneIosDeployment
