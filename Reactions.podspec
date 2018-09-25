Pod::Spec.new do |s|
  s.name             = 'Reactions'
  s.version          = '3.0.0'
  s.license          = 'MIT'
  s.summary          = 'Fully customizable Facebook reactions control'
  s.homepage         = 'https://github.com/yannickl/Reactions'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.source           = { :git => 'https://github.com/yannickl/Reactions.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.ios.framework         = 'UIKit'

  s.source_files         = 'Sources/**/*.swift'
  s.ios.resource_bundles = { 'Reactions' => 'Resources/**/*' }

  s.requires_arc = true
end
