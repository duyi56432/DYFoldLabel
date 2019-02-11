//
//  ViewController.m
//  DYFoldLabel
//
//  Created by 杜燚 on 2019/1/4.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+DYFoldLabel.h"
#import "Masonry/Masonry.h"
#import <sys/utsname.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel *foldLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.foldLabel = [[UILabel alloc] init];
    self.foldLabel.backgroundColor = [UIColor colorWithRed:153/255.0 green:204/255.0 blue:0/255.0 alpha:1];
    self.foldLabel.font = [UIFont systemFontOfSize:15];
    self.foldLabel.textColor = [UIColor whiteColor];
    self.foldLabel.numberOfLines = 4;
    
    NSString *string = @"虽然苹果公司最新一季度的财报提供的数字非常稳健，但它并没有成为投资者的焦点，因为这是意料之中的。iPhone的销量(同比增长0.5 % )与分析师的预期一致，但正如我们所料，iPhone的平均售价最终显著增长(增长28 % )，导致收入和每股收益大幅增长。服务收入增长与预期相符( 增长27 %)。投资者的注意力完全集中在对下一季度的预期上，苹果的收入预期不仅低于华尔街预期，而且似乎暗示着iPhone的销量将同比降低5%至10 %。与此相一致的是，苹果公司在财报电话会议上对其新手机的评论明显不如前几年那么热情。结果是，我们已经大幅降低了2019财年的收入和每股收益预期。";
    self.foldLabel.text = string;
    [self.view addSubview:self.foldLabel];
    
    [self.foldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(88);
        make.right.equalTo(self.view).offset(-12);
        make.height.equalTo(@280);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.foldLabel setFoldText:@"更多" textFont:[UIFont systemFontOfSize:25] textColor:[UIColor redColor] clickBlock:^{
        NSLog(@"点击");
        [weakSelf.foldLabel foldLabel:!weakSelf.foldLabel.isFolded];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.foldLabel foldLabel:!self.foldLabel.isFolded];
}
@end
