//
//  ViewController.m
//  DYFoldLabel
//
//  Created by 杜燚 on 2019/1/4.
//  Copyright © 2019年 dayunwenchuang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry/Masonry.h"
#import <sys/utsname.h>
#import "DemoModel.h"
#import "DemoCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *foldLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *textArray = @[
                           @"新浪科技讯 北京时间7月31日凌晨消息，苹果公司股价在纳斯达克常规交易中下跌0.90美元，报收于208.78美元，跌幅为0.43%，财报发布后，在随后截至美国东部时间周二下午5点01分（北京时间周三凌晨5点01分）为止的盘后交易中，苹果股价上涨4.13%。过去52周，苹果公司的最高价为233.47美元，最低价为142.00美元。",
                           @"NSDecimalNumber可以定制四种精度的取正类型分别是：向上取正、向下取正、四舍五入和特殊的四舍五入（碰到保留位数后一位的数字为5时，根据前一位的奇偶性决定。为偶时向下取正，为奇数时向上取正如：1.25保留1为小数。5之前是2偶数向下取正1.2；1.35保留1位小数时。5之前为3奇数，向上取正1.4）。",
                           @"5月28日消息，昨日比特币创下价格新高，突破8845美元，市值达到1568亿美元，创下了比特币价格和市值12个月来的最高纪录。",
                           @"苹果公司今天发布了2019财年第三财季业绩。报告显示，苹果公司第三财季净营收为538.09亿美元，比去年同期的532.65亿美元增长1%；净利润为100.44亿美元，比去年同期的115.19亿美元下降13%。",
                           @"“股神”沃伦·巴菲特旗下的伯克希尔-哈撒韦（Berkshire Hathaway）2019年度股东大会近日在巴菲特的家乡奥马哈（Omaha）举行。自巴菲特开始执掌伯克希尔-哈撒韦以来，公司已经在投资界叱咤55年。在2018年最新公布的《财富》世界500强名单中，伯克希尔-哈撒韦排名第十，利润更是高居榜单首位。本次股东大会中，89岁的巴菲特和95岁的查理芒格两位投资大师同台主持今年度的股东大会，二人共花费近6小时回答投资者关于投资苹果公司、亚马逊等科技股的疑问，并就5G前景，投资逻辑等分享自己的看法。",
                           @"“股神”沃伦·巴菲特旗下的伯克希尔-哈撒韦（Berkshire Hathaway）2019年度股东大会近日在巴菲特的家乡奥马哈（Omaha）举行。自巴菲特开始执掌伯克希尔-哈撒韦以来，公司已经在投资界叱咤55年。在2018年最新公布的《财富》世界500强名单中，伯克希尔-哈撒韦排名第十，利润更是高居榜单首位。本次股东大会中，89岁的巴菲特和95岁的查理芒格两位投资大师同台主持今年度的股东大会，二人共花费近6小时回答投资者关于投资苹果公司、亚马逊等科技股的疑问，并就5G前景，投资逻辑等分享自己的看法。",
                           @"“股神”沃伦·巴菲特旗下的伯克希尔-哈撒韦（Berkshire Hathaway）2019年度股东大会近日在巴菲特的家乡奥马哈（Omaha）举行。自巴菲特开始执掌伯克希尔-哈撒韦以来，公司已经在投资界叱咤55年。在2018年最新公布的《财富》世界500强名单中，伯克希尔-哈撒韦排名第十，利润更是高居榜单首位。本次股东大会中，89岁的巴菲特和95岁的查理芒格两位投资大师同台主持今年度的股东大会，二人共花费近6小时回答投资者关于投资苹果公司、亚马逊等科技股的疑问，并就5G前景，投资逻辑等分享自己的看法。",
                           @"“股神”沃伦·巴菲特旗下的伯克希尔-哈撒韦（Berkshire Hathaway）2019年度股东大会近日在巴菲特的家乡奥马哈（Omaha）举行。自巴菲特开始执掌伯克希尔-哈撒韦以来，公司已经在投资界叱咤55年。在2018年最新公布的《财富》世界500强名单中，伯克希尔-哈撒韦排名第十，利润更是高居榜单首位。本次股东大会中，89岁的巴菲特和95岁的查理芒格两位投资大师同台主持今年度的股东大会，二人共花费近6小时回答投资者关于投资苹果公司、亚马逊等科技股的疑问，并就5G前景，投资逻辑等分享自己的看法。",
                           @"“股神”沃伦·巴菲特旗下的伯克希尔-哈撒韦（Berkshire Hathaway）2019年度股东大会近日在巴菲特的家乡奥马哈（Omaha）举行。自巴菲特开始执掌伯克希尔-哈撒韦以来，公司已经在投资界叱咤55年。在2018年最新公布的《财富》世界500强名单中，伯克希尔-哈撒韦排名第十，利润更是高居榜单首位。本次股东大会中，89岁的巴菲特和95岁的查理芒格两位投资大师同台主持今年度的股东大会，二人共花费近6小时回答投资者关于投资苹果公司、亚马逊等科技股的疑问，并就5G前景，投资逻辑等分享自己的看法。"
                           ];
    
    for (NSString *string in textArray) {
        DemoModel *model = [[DemoModel alloc] init];
        model.text = string;
        model.textHeight = 50;
        
        DYLabelModel *labelModel = [[DYLabelModel alloc] init];
        labelModel.foldText = @"更多";
        labelModel.foldTextColor = [UIColor redColor];
        labelModel.foldFont = [UIFont systemFontOfSize:15];
        labelModel.packUpText = @"收起";
        labelModel.packUpTextColor = [UIColor redColor];
        labelModel.packUpTextFont = [UIFont systemFontOfSize:15];
        
        model.labelModel = labelModel;
        [self.dataArray addObject:model];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row < self.dataArray.count) {
        DemoModel *model = self.dataArray[indexPath.row];
        model.labelModel.indexPath = indexPath;
        cell.contentLabel.model = model.labelModel;
        //label宽度，这个一定要获取准确，特别是对屏幕做了等比缩放的情况下。最好不要使用label.size.width，而是根据UI布局的计算获取宽度。
        [cell.contentLabel setFoldText:model.text
                            LabelWidth:[UIScreen mainScreen].bounds.size.width - 30
                            clickBlock:^(BOOL isFolded, NSIndexPath * _Nonnull path, CGFloat currentHeight) {
            DemoModel *cellModel = self.dataArray[path.row];
            cellModel.textHeight = currentHeight;
            NSLog(@"点击");
            [self.tableView reloadData];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > indexPath.row) {
        DemoModel *model = self.dataArray[indexPath.row];
        return model.textHeight;
    }
    return 0;
}

@end
