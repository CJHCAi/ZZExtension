@version = “0.01”
Pod::Spec.new do |s| 
s.name = “ZZExtension” 
s.version = @version 
s.summary = “后续提供更多更能” 
s.description = “实现了便捷的tabbar类别,帮助你添加一个超出tabbar的按钮(如美团)” 
s.homepage = “https://github.com/Pangshishan/PSSSegmentControl” 
s.license = { :type => ‘MIT’, :file => ‘LICENSE’ } 
s.author = { “ZZ” => “1156858877@qq.com” } 
s.ios.deployment_target = ‘8.0’ 
s.source = { :git => “https://github.com/iOS-ZZ/ZZExtension.git“, :tag => “v#{s.version}” } 
s.source_files = ‘ZZExtension/ZZExtension/*/.{h,m}’ 
s.requires_arc = true 
s.framework = “UIKit” 
end