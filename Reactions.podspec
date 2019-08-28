Pod::Spec.new do |s|
  s.name             = 'Reactions'
  s.version          = '3.0.1'
  s.license          = 'MIT'
  s.summary          = 'Fully customizable Facebook reactions control'
  s.homepage         = 'https://github.com/starfall-9000/gp-reactions-swift'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.source           = { :git => 'https://github.com/starfall-9000/gp-reactions-swift' }

  s.ios.deployment_target = '8.0'
  s.ios.framework         = 'UIKit'

  s.source_files         = 'Sources/**/*.swift'
  s.ios.resource_bundles = { 'Reactions' => 'Resources/**/*' }

  s.requires_arc = true
end
