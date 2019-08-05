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
@property (nonatomic, assign) NSInteger numberOfLines;
/**
 label.text因为添加折叠文字被裁剪,重新保存完整的text、attributedText,
 */
@property (nonatomic, strong) NSString *dy_text;
@property (nonatomic, strong) NSAttributedString *dy_attributedText;

/**
 在tableview中记录indexpath，方便回调数据处理
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *foldText;
@property (nonatomic, strong) UIColor *foldTextColor;
@property (nonatomic, strong) UIFont *foldFont;
@property (nonatomic, strong) NSAttributedString *foldAttributeText;
@property (nonatomic, assign) CTFrameRef foldframe;
@property (nonatomic, assign) NSInteger endLineIndex;

@property (nonatomic, strong) NSString *packUpText;
@property (nonatomic, strong) UIColor *packUpTextColor;
@property (nonatomic, strong) UIFont *packUpTextFont;
//@property (nonatomic, strong) NSAttributedString *packUpAttributeText;
@property (nonatomic, assign) CTFrameRef packUpframe;
@property (nonatomic, assign) NSInteger lineCount;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGSize labelSize;

@property (nonatomic, assign) CGFloat foldHeight;
@property (nonatomic, assign) CGFloat textHeight;

/**
 label是否展开，foldLabel方法调用之后才能生效，默认值为NO。
 */
@property (nonatomic, assign) BOOL isFolded;

@property (nonatomic, strong) NSString *identifier;
@end

NS_ASSUME_NONNULL_END
