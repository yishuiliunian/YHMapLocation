#
# Be sure to run `pod lib lint DZChatUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

def MapFramework(name)
    return " $(PODS_ROOT)/BaiduMapKit/BaiduMapKit/"+name
end
Pod::Spec.new do |s|
  s.name             = "YHMapLocation"
  s.version          = "0.1.0"
  s.summary          = "A short description of DZChatUI."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/YHMapLocation"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "stonedong" => "yishuiliunian@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/YHMapLocation.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YHMapLocation/Classes/**/*'

  s.resource_bundles = {
     'YHMapLocation' => ['YHMapLocation/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'DZProgrameDefines'
  s.dependency 'DZLogger'
  s.dependency 'ElementKit'
  s.dependency 'DZGeometryTools'
  s.dependency 'DZCache'

  s.pod_target_xcconfig = {
        'FRAMEWORK_SEARCH_PATHS' => '$(inherited)   $(PODS_ROOT)/BaiduMapKit/BaiduMapKit/',
        'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup'
  }
end
