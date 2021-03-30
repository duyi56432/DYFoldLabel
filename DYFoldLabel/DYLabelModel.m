//
//  DYLabelModel.m
//  DYFoldLabelDemo
//
//  Created by admin on 2019/8/1.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import "DYLabelModel.h"
#import "DYFoldLabel.h"

@implementation DYLabelModel

- (CGFloat)textHeight {
    if (_textHeight == 0) {
        if (_dy_text.length == 0) return 0;
        _textHeight = [DYFoldLabel dy_sizeForText:_dy_text Font:_textFont size:CGSizeMake(_labelSize.width, CGFLOAT_MAX) mode:0].height + _textFont.pointSize;
    }
    return _textHeight;
}

- (CGFloat)foldHeight {
    if (_foldHeight == 0) {
        if (_numberOfLines == 0) {
            _foldHeight = self.textHeight;
        } else {
            _foldHeight = [DYFoldLabel dy_sizeForText:_dy_text Font:_textFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:0].height * (_numberOfLines + 1);
        }
    }
    return _foldHeight;
}

@end
