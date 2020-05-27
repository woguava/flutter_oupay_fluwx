#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_oupay'
  s.version          = '0.0.1'
  s.summary          = 'A oupay Flutter plugin.'
  s.description      = <<-DESC
A oupay Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*','UPPay/**/*'
  s.public_header_files = 'Classes/**/*.h','UPPay/**/*.h'
  s.dependency 'Flutter'

  # 支付宝
  s.dependency 'AlipaySDK-iOS'

  # 银联
  s.ios.vendored_libraries = 'UPPay/**/*.a'
  s.ios.frameworks = 'CFNetwork','SystemConfiguration','Foundation'
  s.ios.libraries = 'stdc++','z'
  s.preserve_paths = 'UPPay/*.a'

  # 招行
  s.ios.vendored_frameworks = 'CMBSDK.framework'

  s.ios.deployment_target = '10.0'

  s.static_framework = true

  s.prefix_header_contents = '#import <flutter_oupay/FlutterOupayPlugin.h>'
end

