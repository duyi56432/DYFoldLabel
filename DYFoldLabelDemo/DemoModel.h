//
//  DemoModel.h
//  DYFoldLabelDemo
//
//  Created by admin on 2019/7/31.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DYLabelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemoModel : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) DYLabelModel *labelModel;
@end

NS_ASSUME_NONNULL_END
