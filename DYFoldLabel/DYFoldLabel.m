//
//  DYFoldLabel.m
//  DYFoldLabelDemo
//
//  Created by admin on 2019/8/1.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import "DYFoldLabel.h"
#import <CoreText/CoreText.h>
#import <objc/message.h>
#import <objc/runtime.h>

static NSString *kDisplay = @"KisDisplay";

@interface DYFoldLabel ()
@property (nonatomic, copy) DYFoldBtnClickBlock clickBlock;
@end

@implementation DYFoldLabel

- (void)setFoldText:(NSString *)text
         LabelWidth:(CGFloat)width
                clickBlock:(DYFoldBtnClickBlock)block{
    [self layoutIfNeeded];
    self.userInteractionEnabled = YES;
    if (!text || text.length == 0) {
        self.text = text;
        return;
    }
    
    if (self.model.foldAttributeText && self.model.foldAttributeText.length > 0) {
        [self foldLabel:self.model.isFolded];
        return;
    }
    
    self.text = text;
    [self layoutIfNeeded];
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    if (self.model.packUpText) {
        NSAttributedString *packUpText = [[NSAttributedString alloc] initWithString:self.model.packUpText attributes:@{NSFontAttributeName:self.model.packUpTextFont,NSForegroundColorAttributeName:self.model.packUpTextColor}];
        [attributeText appendAttributedString:packUpText];
    }
    
    //数据记录
    self.model.dy_attributedText = attributeText;
    self.model.dy_text = attributeText.string;
    self.model.textFont = self.font;
    self.model.numberOfLines = self.numberOfLines;
    self.model.labelSize = CGSizeMake(width, self.bounds.size.height);
    self.clickBlock = [block copy];

    NSAttributedString *foldAttText = [[NSAttributedString alloc] initWithString:self.model.foldText attributes:@{NSFontAttributeName:self.model.foldFont,NSForegroundColorAttributeName:self.model.foldTextColor}];
    
    CTFrameRef frameRef = [self framesetterRefWithAttString:attributeText size:CGSizeMake(width, self.bounds.size.height)];
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (!lines || CFArrayGetCount(lines) == 0) return;
    CFIndex cfindex = CFArrayGetCount(lines);
    //计算第几行结束,折叠文字字体大于文本字体会占用多行
    CFIndex endLineIndex = [self lineReplaceWithLine:cfindex lines:lines fontDiff:self.model.foldFont.pointSize - self.font.pointSize];
    self.model.endLineIndex = endLineIndex;
    CTLineRef line = CFArrayGetValueAtIndex(lines, endLineIndex);
    CFRange lineRange = CTLineGetStringRange(line);
    NSRange trimRange = NSMakeRange(0, lineRange.location + lineRange.length);
    if (trimRange.length < self.text.length) {
        //获取当前能显示文字
        attributeText = [[attributeText attributedSubstringFromRange:trimRange] mutableCopy];
        if ([attributeText.string hasSuffix:@"\n\n"]) {
            attributeText = [[attributeText attributedSubstringFromRange:NSMakeRange(0, lineRange.location + lineRange.length - 1)] mutableCopy];
            [attributeText appendAttributedString:[[NSAttributedString alloc] initWithString:@"… "]];
            [attributeText appendAttributedString:foldAttText];
        } else {
            //获取需要替换的文字长度
            NSInteger length = [self subLenthWithString:attributeText lineRange:trimRange text:[NSString stringWithFormat:@"… %@",self.model.foldText] textFont:self.model.foldFont];
            //省略号前需要添加的文字
            attributeText = [[attributeText attributedSubstringFromRange:NSMakeRange(0, lineRange.location + lineRange.length - length)] mutableCopy];
            [attributeText appendAttributedString:[[NSAttributedString alloc] initWithString:@"… "]];
            [attributeText appendAttributedString:foldAttText];
        }
        
        self.attributedText = attributeText;
        self.model.foldAttributeText = attributeText;
    }
    CTFrameRef foldFrameRef = [self framesetterRefWithAttString:attributeText size:CGSizeMake(width, self.bounds.size.height)];
    self.model.foldframe = foldFrameRef;
    
    CTFrameRef packUpframe = [self framesetterRefWithAttString:self.model.dy_attributedText size:CGSizeMake(width, self.model.textHeight)];
    self.model.packUpframe = packUpframe;
    
    CFArrayRef packUpLines = CTFrameGetLines(packUpframe);
    if (!packUpLines || CFArrayGetCount(packUpLines) == 0) return;
    self.model.lineCount = CFArrayGetCount(packUpLines);
    
    if(frameRef) {
        CFRelease(frameRef);
    }
    [self layoutIfNeeded];
}

- (void)foldLabel:(BOOL)folded {
    if (folded) {
        self.numberOfLines = 0;
        self.attributedText = self.model.dy_attributedText;
    } else {
        self.numberOfLines = self.model.numberOfLines;
        self.attributedText = self.model.foldAttributeText;
    }
    [self layoutIfNeeded];
}

#pragma mark - Private
- (CTFrameRef)framesetterRefWithAttString:(NSAttributedString *)attString size:(CGSize)size{
    //创建frameSetter
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGMutablePathRef path = CGPathCreateMutable();
    
    //指定每行的宽度,计算共多少行
    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
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
    CGFloat lineHeight = ascent + fabs(descent) + leading;
    
    NSInteger lineIndex = 0,index = 0;
    NSInteger number = self.numberOfLines - 1;
    CGFloat totalLineHeight = 0;
    while (totalLineHeight < (lineHeight + fontDiff) && lineCount > index ) {
        index++;
        totalLineHeight = lineHeight * index;
    }
    lineIndex = lineCount - index;//这里需要+1，因为最后一行没计算在内，又因为数组最后一个元素索引=count-1,所以+1抵消
    lineIndex = (self.numberOfLines > 0) ? MIN(lineIndex, number) : lineCount - 1;
    return lineIndex;
}

//计算被替换文字长度
- (NSInteger)subLenthWithString:(NSMutableAttributedString *)string lineRange:(NSRange)range text:(NSString *)text textFont:(UIFont *)font{
    //折叠按钮文字宽度
    CGFloat foldWidth = [DYFoldLabel dy_sizeForText:text Font:font size:CGSizeMake(self.model.labelSize.width, CGFLOAT_MAX) mode:0].width;
    CGFloat spaceTextWidth = 0.0;
    NSInteger index = 0;
    while (spaceTextWidth < foldWidth) {
        NSString *spaceText = [string attributedSubstringFromRange:NSMakeRange(range.location + range.length - index, index)].string;
        spaceTextWidth = [DYFoldLabel dy_sizeForText:spaceText Font:self.font size:CGSizeMake(self.model.labelSize.width, CGFLOAT_MAX) mode:0].width;
        index++;
    }
    return index;
}

#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 
    if (!self.clickBlock) return;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint clickPoint = CGPointMake(location.x, self.bounds.size.height - location.y);
    CTFrameRef _frame;
    CFIndex endLineIndex;
    UIFont *font;
    if (self.model.isFolded) {
        _frame = self.model.packUpframe;
        endLineIndex = self.model.lineCount - 1;
        font = self.model.packUpTextFont;
    } else {
        _frame = self.model.foldframe;
        endLineIndex = self.model.endLineIndex;
        font = self.model.foldFont;
    }
    //获取最后行
    
    CFArrayRef lines = CTFrameGetLines(_frame);
    if (!lines || CFArrayGetCount(lines) == 0) return;
    //获取行上行、下行、间距
    CGFloat ascent = 0,descent = 0,leading = 0;
    CTLineRef endLine = CFArrayGetValueAtIndex(lines, endLineIndex);
    CTLineGetTypographicBounds(endLine, &ascent, &descent, &leading);
    
    
    CGFloat endLineHeight = leading + MAX(font.pointSize, self.font.pointSize);
    //计算点击位置是否在折叠行内
    CGPoint origins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
    CGPoint endLineOrigin = origins[endLineIndex];
    
    CGFloat textHeight = self.bounds.size.height - endLineOrigin.y + endLineHeight;
    if (clickPoint.y <= (self.bounds.size.height * 0.5 - textHeight * 0.5 + endLineHeight + 5) && clickPoint.y >= (self.bounds.size.height * 0.5 - textHeight * 0.5 )) {
        CFIndex index = CTLineGetStringIndexForPosition(endLine, clickPoint);
        NSString *foldText = self.model.foldText;
        NSInteger offset = self.text.length > 2 ? 2 : 0;
        NSRange range = NSMakeRange(self.text.length - foldText.length - offset, foldText.length + offset);
        
        //判断点击的字符是否在需要处理点击事件的字符串范围内
        if (range.location <= index) {
            self.model.isFolded = !self.model.isFolded;
            [self foldLabel:self.model.isFolded];
            if (self.clickBlock) {
                if (self.model.isFolded) {
                    self.clickBlock(self.model.isFolded,self.model.indexPath,self.model.textHeight);
                } else {
                    self.clickBlock(self.model.isFolded,self.model.indexPath,self.model.foldHeight);
                }
            }
        }
    }
}

+ (CGSize)dy_sizeForText:(NSString *)text Font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
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

- (DYLabelModel *)model {
    if (!_model) {
        _model = [[DYLabelModel alloc] init];
    }
    return _model;
}

@end
