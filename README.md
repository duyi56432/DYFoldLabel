# DYFoldLabel

## 简介
设置一段显示不完整文字省略号后的折叠按钮。

功能亮点：


1.可以兼容自动布局。

2.解决大多数第三方文字点击在特殊情况有误问题。

3.解决在tableView中的重用问题。

![dicImg](https://github.com/duyi56432/DYFoldLabel/blob/master/效果图.gif)  

## 博客
[这里有更详细用法](https://www.jianshu.com/p/f188f53695d7)

## 安装

使用 cocoapods
<pre><code> 
pod 'DYFoldLabel'
</code></pre>
当前最新版本1.2.0，如果不能搜索最新版本，执行命令 pod setup更新pod后再试。

持续优化中，如果有好的建议和意见欢迎交流，QQ群:433212576
## 用法
<pre><code> 
/**
设置折叠收起文字

@param text label内容
@param width label宽度，这个一定要获取准确，特别是对屏幕做了等比缩放的情况下。最好不要使用label.size.width，而是根据UI布局的计算获取宽度。
@param block 回调
*/
- (void)setFoldText:(NSString *)text
           LabelWidth:(CGFloat)width
             clickBlock:(DYFoldBtnClickBlock)block;

</code></pre>

## 版本更新

【版本号】1.1.0

【更新内容】

1.解决只有一行文本时崩溃问题。

2.解决在tableView中的重用问题。 

3.添加展开时收起按钮。

【版本号】1.2.0

【更新内容】
解决换行符显示异常问题。
