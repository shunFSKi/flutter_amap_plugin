#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_amap_plugin'
  s.version          = '0.0.1'
  s.summary          = 'AMap common plugin.'
  s.description      = <<-DESC
AMap common plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AMapNavi-NO-IDFA', '6.7.0'
  s.dependency 'AMapLocation-NO-IDFA', '2.6.2'
  s.dependency 'AMapSearch-NO-IDFA', '6.6.0'
  s.dependency 'HandyJSON', '5.0.0-beta.1'
  
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

