Pod::Spec.new do |s|
  s.name         = "FXAlertView"
  s.version      = "1.0.1"
  s.summary      = "自定义alertView,可以添加图片button,文字button,文字和图片结合button,中间视图可以根据需求自定义"
  s.homepage     = "https://github.com/zfx5130/FXAlertView"
  s.license      = "MIT"
  s.authors      = { 'thomas' => 'dui1cuo@126.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zfx5130/FXAlertView.git", :tag => s.version }
  s.source_files = 'FXAlertView', 'FXAlertView/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'Masonry'

end
