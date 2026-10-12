require 'xcodeproj'

project_name = 'AuraFish'
project_path = "#{project_name}.xcodeproj"

# 1. Create the project
project = Xcodeproj::Project.new(project_path)

# 2. Add the Parent iOS Application Target
ios_target = project.new_target(:application, project_name, :ios, '17.0')

# 3. Add the WatchOS Standalone Application Target (Modern Single Target watchOS 10+ App)
watch_target = project.new_target(:application, "#{project_name} Watch App", :watchos, '10.0')

# 4. Create a group for Sources
sources_group = project.main_group.new_group('Sources', 'Sources')

# 5. Find all .swift files recursively in Sources/ and add to their proper target
Dir.glob('Sources/**/*.swift').each do |file_path|
  file_name = file_path.sub('Sources/', '')
  file_ref = sources_group.new_reference(file_name)
  
  if file_name == 'AuraFishiOSApp.swift'
    # Compile the iOS companion wrapper strictly on the parent iOS target
    ios_target.source_build_phase.add_file_reference(file_ref)
  else
    # Compile the fish game logic strictly on the watchOS target
    watch_target.source_build_phase.add_file_reference(file_ref)
  end
end

# 5.5. Add Asset Catalog (Assets.xcassets) to both iOS and Watch Targets
ios_assets_ref = sources_group.new_reference('Assets.xcassets')
ios_assets_ref.last_known_file_type = 'folder.assetcatalog'
ios_target.resources_build_phase.add_file_reference(ios_assets_ref)

watch_assets_ref = sources_group.new_reference('Assets.xcassets')
watch_assets_ref.last_known_file_type = 'folder.assetcatalog'
watch_target.resources_build_phase.add_file_reference(watch_assets_ref)

# 6. Set up Build Settings for the Parent iOS Target
ios_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "com.air.#{project_name}"
  config.build_settings['PRODUCT_NAME'] = 'AuraFish'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1' # iPhone
  config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
  config.build_settings['SKIP_INSTALL'] = 'NO'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['SDKROOT'] = 'iphoneos' # Force iOS SDK
  config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos iphonesimulator' # Set iOS platforms
  config.build_settings['MARKETING_VERSION'] = '1.0.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '4'
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  config.build_settings['INFOPLIST_KEY_CFBundleIconName'] = 'AppIcon'
end

# 7. Set up Build Settings for the Watch Target (Properly prefixed by Parent's Bundle ID!)
watch_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "com.air.#{project_name}.watchapp"
  config.build_settings['PRODUCT_NAME'] = 'AuraFish Watch App'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  
  # Standard Apple standalone keys (Satisfies both the standalone requirement and simulator companion validation)
  config.build_settings['INFOPLIST_KEY_WKRunsIndependentlyOfCompanionApp'] = 'YES' # True standalone watch app!
  config.build_settings['INFOPLIST_KEY_WKCompanionAppBundleIdentifier'] = "com.air.#{project_name}" # Point to parent iOS app
  config.build_settings['INFOPLIST_KEY_UIRequiredDeviceCapabilities'] = 'arm64_32 armv7k'
  
  config.build_settings['INFOPLIST_KEY_ITSAppUsesNonExemptEncryption'] = 'NO'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '4' # Apple Watch
  config.build_settings['DEVELOPMENT_TEAM'] = ''
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'WatchAppIcon'
  config.build_settings['MARKETING_VERSION'] = '1.0.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '4'
  config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
  config.build_settings['SKIP_INSTALL'] = 'YES' # The watch target is nested, so skip independent install!
  config.build_settings['WATCHOS_DEPLOYMENT_TARGET'] = '10.0'
  config.build_settings['SDKROOT'] = 'watchos' # Force watchOS SDK
  config.build_settings['SUPPORTED_PLATFORMS'] = 'watchos watchsimulator' # Set watchOS platforms
end

# 8. Embed the Watch App inside the iOS App's bundle (Required by Apple and Simulator installer)
ios_target.add_dependency(watch_target)

# Create a Copy Files phase to embed the Watch App
embed_watch_phase = ios_target.new_copy_files_build_phase('Embed Watch Content')
embed_watch_phase.dst_subfolder_spec = '16' # 16 corresponds to the iOS app's 'Watch' wrapper directory
build_file = embed_watch_phase.add_file_reference(watch_target.product_reference)
build_file.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy'] }

# 9. Save the project
project.save
puts "Xcode project generated at #{project_path}"
