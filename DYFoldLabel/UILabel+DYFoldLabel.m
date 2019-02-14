//
//  UILabel+DYFoldLabel.m
//  DYFoldLabel
//
//  Created by 杜燚 on 2019/1/4.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import "UILabel+DYFoldLabel.h"
#import <CoreText/CoreText.h>
#import <objc/message.h>
#import <objc/runtime.h>

static NSString *completeText = @"completeText";
static NSString *completeAttText = @"completeAttText";
static NSString *kDisplay = @"KisDisplay";

@implementation UILabel (DYFoldLabel)

- (void)setFoldText:(NSString *)foldText
           textFont:(UIFont *)font
          textColor:(UIColor *)color
         clickBlock:(DYFoldBtnClickBlock)block{
   [self layoutIfNeeded];
    self.userInteractionEnabled = YES;
    if (!self.text || self.text.length == 0) {
        return;
    }
    
    NSAttributedString *foldAttributeText = objc_getAssociatedObject(self, "foldAttributeText");
    if (foldAttributeText && foldAttributeText.length > 0) {
        self.attributedText = foldAttributeText;
        return;
    }
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    //数据记录
    [self setDy_attributedText:attributeText];
    objc_setAssociatedObject(self, "foldText", foldText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "foldFont", font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "clickBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.isFolded = NO;
    
    NSAttributedString *foldAttText = [[NSAttributedString alloc] initWithString:foldText attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];

    CTFrameRef frameRef = [self framesetterRefWithAttString:attributeText];
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex cfindex = CFArrayGetCount(lines);
    
    //计算第几行结束,折叠文字字体大于文本字体会占用多行
    CFIndex endLineIndex = [self lineReplaceWithLine:cfindex lines:lines fontDiff:font.pointSize - self.font.pointSize];
    objc_setAssociatedObject(self, "endLineIndex", @(endLineIndex), OBJC_ASSOCIATION_ASSIGN);
    CTLineRef line = CFArrayGetValueAtIndex(lines, endLineIndex);
    CFRange lineRange = CTLineGetStringRange(line);
    NSRange trimRange = NSMakeRange(0, lineRange.location + lineRange.length);
    if (trimRange.length < self.text.length) {
        //获取当前能显示文字
        attributeText = [[attributeText attributedSubstringFromRange:trimRange] mutableCopy];
        //获取需要替换的文字长度
        NSInteger length = [self subLenthWithString:attributeText lineRange:trimRange text:foldText textFont:font];
        //省略号前需要添加的文字
        attributeText = [[attributeText attributedSubstringFromRange:NSMakeRange(0, lineRange.location + lineRange.length - length)] mutableCopy];
        
        [attributeText appendAttributedString:[[NSAttributedString alloc] initWithString:@"… "]];
        [attributeText appendAttributedString:foldAttText];
        
        self.attributedText = attributeText;
        objc_setAssociatedObject(self, "foldAttributeText", attributeText, OBJC_ASSOCIATION_RETAIN);
    }
    CTFrameRef kframeRef = [self framesetterRefWithAttString:attributeText];
    objc_setAssociatedObject(self, "frameRef", (__bridge id _Nullable)(kframeRef), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(frameRef) {
        CFRelease(frameRef);
    }
}

- (void)foldLabel:(BOOL)folded {
    self.isFolded = folded;
    if (folded) {
        self.attributedText = self.dy_attributedText;
        self.numberOfLines = 0;
    } else {
        NSAttributedString *att = objc_getAssociatedObject(self, "foldAttributeText");
        self.attributedText = att;
    }
    [self layoutIfNeeded];
}

#pragma mark - Private
- (CTFrameRef)framesetterRefWithAttString:(NSMutableAttributedString *)attString {
    //创建frameSetter
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGMutablePathRef path = CGPathCreateMutable();
    
    //指定每行的宽度,计算共多少行
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    if(frameSetter) {
        CFRelease(frameSetter);
    }
    CGPathRelease(path);
    return frameRef;
}


//因为替换文字大小问题，需要计算第几行结束
- (NSInteger)lineReplaceWithLine:(CFIndex)lineCount lines:(CFArrayRef)lines fontDiff:(CGFloat)fontDiff {
    //计算单行高度
    CGFloat ascent = 0,descent = 0,leading = 0;
    CTLineRef line = CFArrayGetValueAtIndex(lines, 0);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat lineHeight = ascent + descent + leading;
    
    NSInteger lineIndex = 0,index = 0;
    NSInteger number = self.numberOfLines - 1;
    CGFloat totalLineHeight = 0;
    while (totalLineHeight < (lineHeight + fontDiff) && lineCount > index) {
        if (totalLineHeight < (lineHeight + leading)) {
            index++;
        }
        totalLineHeight = lineHeight * index;
    }
    lineIndex = lineCount - index;//这里需要+1，因为最后一行没计算在内，又因为数组最后一个元素索引=count-1,所以+1抵消
    lineIndex = (self.numberOfLines > 0) ? MIN(lineIndex, number) : lineCount;
    return lineIndex;
}

//计算被替换文字长度
- (NSInteger)subLenthWithString:(NSMutableAttributedString *)string lineRange:(NSRange)range text:(NSString *)text textFont:(UIFont *)font{
    //折叠按钮文字宽度
    CGFloat foldWidth = [self dy_sizeForText:text Font:font size:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) mode:0].width;
    CGFloat spaceTextWidth = 0.0;
    NSInteger index = 0;
    while (spaceTextWidth < foldWidth) {
        NSString *spaceText = [string attributedSubstringFromRange:NSMakeRange(range.location + range.length - index, index)].string;
        spaceTextWidth = [self dy_sizeForText:spaceText Font:self.font size:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) mode:0].width;
        index++;
    }
    return index;
}

#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    DYFoldBtnClickBlock clickBlock = objc_getAssociatedObject(self, "clickBlock");
    if (!clickBlock || self.isFolded) return;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint clickPoint = CGPointMake(location.x, self.bounds.size.height - location.y);
    CTFrameRef _frame = (__bridge CTFrameRef)(objc_getAssociatedObject(self, "frameRef"));
    
    //获取最后行
    CFIndex endLineIndex = [objc_getAssociatedObject(self, "endLineIndex") integerValue];
    CFArrayRef lines = CTFrameGetLines(_frame);
    CTLineRef line = CFArrayGetValueAtIndex(lines, endLineIndex);
    CFRange lineRange = CTLineGetStringRange(line);
    NSRange trimRange = NSMakeRange(0, lineRange.location + lineRange.length);
    if (trimRange.length == self.dy_text.length) {
        return;
    }
    
    //获取行上行、下行、间距
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    CTLineRef endLine = CFArrayGetValueAtIndex(lines, endLineIndex);
    CTLineGetTypographicBounds(endLine, &ascent, &descent, &leading);
    
    UIFont *font = objc_getAssociatedObject(self, "foldFont");
    CGFloat endLineHeight = leading + MAX(font.pointSize, self.font.pointSize);
    //计算点击位置是否在折叠行内
    CGPoint origins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
    CGPoint endLineOrigin = origins[endLineIndex];
    
    CGFloat textHeight = self.bounds.size.height - endLineOrigin.y + endLineHeight;
    if (clickPoint.y <= (self.bounds.size.height * 0.5 - textHeight * 0.5 + endLineHeight) && clickPoint.y >= (self.bounds.size.height * 0.5 - textHeight * 0.5 )) {
        CFIndex index = CTLineGetStringIndexForPosition(endLine, clickPoint);
        NSString *foldText = objc_getAssociatedObject(self, "foldText");
        NSRange range = NSMakeRange(self.text.length - foldText.length, foldText.length);
        //判断点击的字符是否在需要处理点击事件的字符串范围内
        if (range.location <= index) {
            if (clickBlock) {
                clickBlock();
            }
        }
    }
}

- (CGSize)dy_sizeForText:(NSString *)text Font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [text sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

#pragma mark - property

- (void)setDy_text:(NSString *)dy_text {
    objc_setAssociatedObject(self, &completeText, dy_text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)dy_text {
    return [self dy_attributedText].string;
}

- (void)setDy_attributedText:(NSAttributedString *)dy_attributedText {
    objc_setAssociatedObject(self, &completeAttText, dy_attributedText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setDy_text:dy_attributedText.string];
}

- (NSAttributedString *)dy_attributedText {
    NSAttributedString *att = objc_getAssociatedObject(self, &completeAttText);
    return att;
}

- (BOOL)isFolded {
    NSNumber *isFolded = objc_getAssociatedObject(self, &kDisplay);
    return isFolded.boolValue;
}

- (void)setIsFolded:(BOOL)isFolded {
    objc_setAssociatedObject(self, &kDisplay, @(isFolded), OBJC_ASSOCIATION_ASSIGN);
}

@end
