//
//  UILabel+DYFoldLabel.h
//  DYFoldLabel
//
//  Created by 杜燚 on 2019/1/4.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DYFoldBtnClickBlock)(void);
@interface UILabel (DYFoldLabel)

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

/**
 label.text因为添加折叠文字被裁剪,重新保存完整的text、attributedText,
 */
@property (nonatomic, strong) NSString *dy_text;
@property (nonatomic, strong) NSAttributedString *dy_attributedText;

/**
 label是否展开，foldLabel方法调用之后才能生效，默认值为NO。
 */
@property (nonatomic, assign, readonly) BOOL isFolded;

/**
 设置是否展开label。
 */
- (void)foldLabel:(BOOL)folded;
@end

NS_ASSUME_NONNULL_END
