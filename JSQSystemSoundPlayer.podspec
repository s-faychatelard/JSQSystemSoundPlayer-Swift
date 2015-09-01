Pod::Spec.new do |s|
   s.name = 'JSQSystemSoundPlayer-Swift'
   s.version = '1.0'
   s.license = 'MIT'

   s.summary = 'A fancy Obj-C wrapper for Cocoa System Sound Services'
   s.homepage = 'https://github.com/s-faychatelard/JSQSystemSoundPlayer-Swift'
   s.documentation_url = 'http://jessesquires.com/JSQSystemSoundPlayer'

   s.social_media_url = 'https://twitter.com/proto0moi'
   s.author = { 'Sylvain Fay-Châtelard' => 'sylvain.faychatelard@gmail.com' }

   s.source = { :git => 'https://github.com/s-faychatelard/JSQSystemSoundPlayer-Swift.git', :tag => s.version }
   s.source_files = 'JSQSystemSoundPlayer/JSQSystemSoundPlayer/*.{h,m,swift}'

   s.ios.deployment_target = '8.0'
   s.ios.frameworks = 'AudioToolbox', 'Foundation', 'UIKit'

   s.osx.deployment_target = '10.7'
   s.osx.frameworks = 'AudioToolbox', 'Foundation'

   s.requires_arc = true
end
