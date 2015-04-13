#
# Be sure to run `pod lib lint MBXGraphs.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MBXGraphs"
  s.version          = "0.2.0"
  s.summary          = "A simple library to show one or more graphs in a chart"
  s.homepage         = "https://github.com/tamarinda/MBXGraphs"
  s.license          = 'MIT'
  s.author           = { "tamarabernad" => "tamara.bernad@gmail.com" }
  s.source           = { :git => "https://github.com/tamarinda/MBXGraphs.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MBXGraphs' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit','CoreGraphics'
  # s.dependency 'AFNetworking', '~> 2.3'
end
