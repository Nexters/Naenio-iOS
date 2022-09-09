# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Naenio' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Naenio
  pod 'Moya', '~> 15.0'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'KakaoSDKAuth', '~> 2.11.1'
  pod 'KakaoSDKUser', '~> 2.11.1'
  pod 'Alamofire'
  pod 'Introspect'
  pod 'lottie-ios' 

  pod 'RxSwift'
  pod 'SwiftLint'

  # Pods for Naenio-deploy
  target 'Naenio-deploy' do
    inherit! :search_paths
  end

  target 'NaenioTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NaenioUITests' do
    # Pods for testing
  end

end
