#
# Be sure to run `pod lib lint APGenericSearchTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APGenericSearchTextField'
  s.version          = '0.1.9'
  s.summary          = 'A generic search UITextField with suggestions list'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"A generic search UITextField with suggestions list with the power of KeyPath and NSPredicate"
                       DESC

  s.homepage         = 'https://github.com/Bellaposa/APGenericSearchTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bellaposa' => 'antonioposabella91@gmail.com' }
  s.source           = { :git => 'https://github.com/Bellaposa/APGenericSearchTextField.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nice_pose'

  s.ios.deployment_target = '12.0'

  #s.source_files = 'APGenericSearchTextField/Classes/**/*'
  s.source_files = 'Sources/**/*.swift'
  s.swift_version = '5.0'
  s.platforms = {
	  "ios": "12.0"
  }
end
