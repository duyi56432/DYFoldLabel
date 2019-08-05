//
//  DYFoldLabel.h
//  DYFoldLabelDemo
//
//  Created by admin on 2019/8/1.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYLabelModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^DYFoldBtnClickBlock)(BOOL isFolded,NSIndexPath *path,CGFloat currentHeight);
@interface DYFoldLabel : UILabel

/**
 设置折叠收起文字

 @param text label内容
 @param width label宽度，这个一定要获取准确，特别是对屏幕做了等比缩放的情况下。最好不要使用label.size.width，而是根据UI布局的计算获取宽度。
 @param block 回调
 */
- (void)setFoldText:(NSString *)text
         LabelWidth:(CGFloat)width
         clickBlock:(DYFoldBtnClickBlock)block;
/**
 计算文字大小区域
 
 @param text 文本
 @param font 字体
 @param size 宽高限制区域大小
 @param lineBreakMode NSLineBreakMode
 @return 文本所占区域大小
 */
+ (CGSize)dy_sizeForText:(NSString *)text
                    Font:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode;

@property (nonatomic, strong) DYLabelModel *model;



/**
 设置是否展开label。
 */
- (void)foldLabel:(BOOL)folded;
@end

NS_ASSUME_NONNULL_END
