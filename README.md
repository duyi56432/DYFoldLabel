# DYFoldLabel

## 简介
设置一段显示不完整文字省略号后的折叠按钮。

功能亮点：

1.用category实现，无需继承UILabel。

2.可以兼容自动布局。

3.解决大多数第三方文字点击在特殊情况有误问题。

![dicImg](https://github.com/duyi56432/DYFoldLabel/blob/master/效果图.gif)  

## 博客
[这里有更详细用法](https://www.jianshu.com/p/f188f53695d7)

## 安装

使用 cocoapods
<pre><code> 
pod 'DYFoldLabel'
</code></pre>

## 用法
<pre><code> 
/**
设置一段显示不完整文字省略号后的折叠按钮。

@param foldText 折叠按钮文字
@param font 折叠按钮文字字体
@param color 折叠按钮文字颜色
@param block 折叠按钮回调block,传入nil禁止点击
*/
- (void)setFoldText:(NSString *)foldText
                textFont:(UIFont *)font
               textColor:(UIColor *)color
             clickBlock:(DYFoldBtnClickBlock)block;

</code></pre>
