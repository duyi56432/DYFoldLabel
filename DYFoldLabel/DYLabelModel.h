//
//  DYLabelModel.h
//  DYFoldLabelDemo
//
//  Created by admin on 2019/8/1.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYLabelModel : NSObject

/**
 在tableview中记录indexpath，方便回调数据处理。
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 折叠文字、颜色、字体设置。
 */
@property (nonatomic, strong) NSString *foldText;
@property (nonatomic, strong) UIColor *foldTextColor;
@property (nonatomic, strong) UIFont *foldFont;

/**
 展开文字、颜色、字体设置。
 */
@property (nonatomic, strong) NSString *packUpText;
@property (nonatomic, strong) UIColor *packUpTextColor;
@property (nonatomic, strong) UIFont *packUpTextFont;

//========================以上为需要设置参数================================

/**
 label.text因为添加折叠文字被裁剪,重新保存完整的text、attributedText。
 */
@property (nonatomic, strong) NSString *dy_text;
@property (nonatomic, strong) NSAttributedString *dy_attributedText;
@property (nonatomic, strong) NSAttributedString *foldAttributeText;

/**
 绘制区域。
 */
@property (nonatomic, assign) CTFrameRef foldframe;
@property (nonatomic, assign) CTFrameRef packUpframe;

/**
 label的numberOfLines。
 */
@property (nonatomic, assign) NSInteger numberOfLines;

/**
 折叠后最后一行的index。
 */
@property (nonatomic, assign) NSInteger endLineIndex;

/**
 展开后总行数。
 */
@property (nonatomic, assign) NSInteger lineCount;

/**
 label内容文字字体。
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 label的size。
 */
@property (nonatomic, assign) CGSize labelSize;

/**
 折叠后的文字高度。
 */
@property (nonatomic, assign) CGFloat foldHeight;

/**
 展开后的文字高度。
 */
@property (nonatomic, assign) CGFloat textHeight;

/**
 label是否展开，foldLabel方法调用之后才能生效，默认值为NO。
 */
@property (nonatomic, assign) BOOL isFolded;

@end

NS_ASSUME_NONNULL_END
