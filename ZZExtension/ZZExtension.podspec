Pod::Spec.new do |s|

@version                    = "1.1.3"
s.name                      = "ZZExtension"
s.version                   = "1.1.3"
s.summary                   = "first version"
s.description               = "first version for UITabbar"
s.author                    = { "ZZ" => "1156858877@qq.com" }
s.platform                  = :ios, "7.0"
s.license                   = { :type => 'MIT', :file => 'LICENSE' }
s.homepage                  = "https://github.com/iOS-ZZ/ZZExtension.git"
s.source                    = { :git => "https://github.com/iOS-ZZ/ZZExtension.git", :tag => "1.1.3" }
s.source_files              = "ZZExtension/ZZExtension/ZZExtension/**/*"
s.requires_arc              = true
# s.dependency                'SDAutoLayout'
end
