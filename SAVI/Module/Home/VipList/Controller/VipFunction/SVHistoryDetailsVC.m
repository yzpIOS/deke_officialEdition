//
//  SVHistoryDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/2/10.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVHistoryDetailsVC.h"
#import "SVHistoryDateilsCell.h"
#import "SVHistoryDateilsModel.h"

static NSString *HistoryDateilsCellID = @"HistoryDateilsCell";
@interface SVHistoryDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *twoTime;

@property (weak, nonatomic) IBOutlet UILabel *money;

//tableView
//@property (nonatomic,strong) UITableView *tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SVHistoryDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"销售详情";
    NSLog(@"dic888 = %@",_dic);
    
    //分析数据
    //显示时间
    NSString *timeString = self.dic[@"time"];
    self.time.text = [timeString substringToIndex:10];
    self.twoTime.text = [timeString substringWithRange:NSMakeRange(11, 8)];
    
    //毛利润
    self.money.text = [NSString stringWithFormat:@"%.2f",[self.dic[@"order_money"] floatValue]];
    

  //  self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, ScreenW, ScreenH - 40 -BottomHeight-TopHeight)];

    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
//    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
  //  [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVHistoryDateilsCell" bundle:nil] forCellReuseIdentifier:HistoryDateilsCellID];
    
    
    //取数
    NSMutableArray *prlistArr = [_dic objectForKey:@"prlistArr"];
    
    for (NSDictionary *dict in prlistArr) {
        //给模型赋值
        SVHistoryDateilsModel *model = [SVHistoryDateilsModel mj_objectWithKeyValues:dict];
        
        [self.modelArr addObject:model];
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - tableVeiw


//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.waresNameArr.count;
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVHistoryDateilsCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryDateilsCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVHistoryDateilsCell" owner:nil options:nil].lastObject;
        
    }
    
    //用模型数组给cell赋值
    cell.historyModel = self.modelArr[indexPath.row];
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
