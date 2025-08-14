Pod::Spec.new do |s|
  s.name             = 'SakuraPetalsView'
  s.version          = '0.1.0'
  s.summary          = 'Sakura petal falling animation for UIKit & SwiftUI.'
  s.description      = 'A UIView + SwiftUI wrapper that renders falling sakura petals via CAEmitterLayer.'
  s.homepage         = 'https://example.com' # update if/when you publish
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'You' => 'you@example.com' }

  # For local development, the source is this folder. (When publishing, switch to :git + tag)
  s.source           = { :path => '.' }
  s.static_framework = true
  s.ios.deployment_target = '13.0'
  s.swift_versions    = ['5.0', '5.7', '5.8', '5.9', '5.10']

  s.source_files     = 'Sources/SakuraPetalsView/**/*.swift'
  s.resources = 'Sources/SakuraPetalsView/Assets/*'
end
