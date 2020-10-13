#
#  Be sure to run `pod spec lint RZTransition.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "RZTransition"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of RZTransition."
  spec.description  = "Small example to test code sharing via cocoapods."	
  
  spec.homepage     = "https://github.com/nersonSwift/RZTransition.git"

  spec.license      = "MIT"
  

 

  spec.author       = { "nersonSwift" => aleksandrsenin@icloud.com", "Angel-senpai" => "daniil.murygin68@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/nersonSwift/RZTransition.git", :tag => "0.0.1" }

  spec.source_files  = "RZTransition/RZTransition/**/*"
  spec.exclude_files = "RZTransition/RZTransition/**/*.plist"
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '12.0'

  spec.requires_arc = true

end
