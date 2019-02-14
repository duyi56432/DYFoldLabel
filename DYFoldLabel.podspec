
Pod::Spec.new do |s|


s.name         = "DYFoldLabel"
s.version      = "1.0.1"
s.summary      = "设置一段显示不完整文字省略号后的折叠按钮"

s.description  = <<-DESC
设置一段显示不完整文字省略号后的折叠按钮,可自定义折叠文字样式。
DESC

s.homepage     = "https://github.com/duyi56432/DYFoldLabel"

s.license      = "MIT"

s.author             = { "duyi56432" => "564326678@qq.com" }
s.frameworks   = "Foundation"
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/duyi56432/DYFoldLabel.git", :tag => "#{s.version}" }


s.source_files  = "DYFoldLabel/**/*.{h,m}"


end
