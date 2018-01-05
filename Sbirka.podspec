#
#  Be sure to run `pod spec lint Sbirka.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Sbirka"
  s.version      = "0.0.2"
  s.summary      = "UICollectionView wrapper library"
  s.description  = <<-DESC
Helps you to create fast scrolling ui
                   DESC

  s.homepage     = "https://github.com/escfrya/Sbirka"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Igor Skovorodkin" => "escfrya@mail.ru" }
  s.platform     = :ios
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/escfrya/Sbirka.git", :tag => "#{s.version}" }
  s.source_files  = "Sbirka/Sbirka/Source/**/*.{swift}"
  s.framework  = "UIKit"
  s.swift_version = "4.0"
end
