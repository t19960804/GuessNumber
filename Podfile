# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GuessNumber' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
	
	
	pod 'Firebase'
	pod'Firebase/Auth'
	pod'Firebase/Database'
	pod 'SVProgressHUD'
	pod 'RealmSwift'
	pod 'FBSDKCoreKit'
	pod 'FBSDKShareKit'
	pod 'FBSDKLoginKit'
	pod 'GoogleSignIn'
	pod 'Google-Mobile-Ads-SDK'


  # Pods for GuessNumber

  target 'GuessNumberTests' do
    inherit! :search_paths
    # Pods for testing

  end

  target 'GuessNumberUITests' do
    inherit! :search_paths
    # Pods for testing

  end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
