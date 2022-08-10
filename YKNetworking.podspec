#
# Be sure to run `pod lib lint YKNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKNetworking'
  s.version          = '0.0.1'
  s.summary          = 'A short description of YKNetworking.'
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
    DESC

  s.homepage         = 'https://github.com/wanyakun/YKNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanyakun' => 'yakun.wan@gmail.com' }
  s.source           = { :git => 'git@github.com:wanyakun/YKNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}

  s.source_files = 'YKNetworking/Classes/**/*'

  # s.resource_bundles = {
  #   'YKNetworking' => ['YKNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
#   s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire', '~> 5.4.3'
end
