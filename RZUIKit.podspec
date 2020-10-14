
Pod::Spec.new do |spec|

  spec.name         = "RZUIKit"
  spec.version      = "1.0.0"
  spec.summary      = "Small example to test code sharing."
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RZUIKit.git"

  spec.license      = "MIT"
  

 

  spec.author       = { "Angel-senpai" => "daniil.murygin68@gmail.com", "nersonSwift" => "aleksandrsenin@icloud.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/nersonSwift/RZUIKit.git", :tag => "1.0.0" }

  spec.source_files  = "RZUIKit/**/*"
  spec.exclude_files = "RZUIKit/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '13.0'

  spec.requires_arc = true

end
