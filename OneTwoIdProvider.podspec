Pod::Spec.new do |s|
  s.name             = 'OneTwoIdProvider'
  s.version          = '1.0.4'
  s.summary          = 'A simple network request pod.'
  s.description      = 'A pod for making a simple network request and formatting the response as JSON.'
  s.homepage         = 'https://github.com/goff-studio/OneTwoIdProvider.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your.email@example.com' }
  s.source           = { :git => 'https://github.com/goff-studio/OneTwoIdProvider.git', :tag => '1.0.4' }
  s.swift_version    = '5.5'
  s.ios.deployment_target = '12.4'
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'Alamofire', '~> 5.0'
end
