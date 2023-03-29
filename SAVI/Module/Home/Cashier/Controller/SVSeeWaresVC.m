//
//  SVSeeWaresVC.m
//  SAVI
//
//  Created by Sorgle on 2017/7/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSeeWaresVC.h"
//模型
#import "SVOrderDetailsModel.h"
#import "SVDetailsCell.h"

@interface SVSeeWaresVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//模型
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation SVSeeWaresVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"订单详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"订单详情";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //右上角按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(emptybuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    self.numberLabel.text = [NSString stringWithFormat:@"%.f",self.number1];
    self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",self.money];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVDetailsCell" bundle:nil] forCellReuseIdentifier:@"SVDetailsCell"];
    
    for (NSDictionary *dict in self.orderArr) {
        SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dict];
        
        [self.modelArr addObject:model];
    }
    
}

-(void)emptybuttonResponseEvent{
    //回调的block
    if (self.emptyBlock) {
        self.emptyBlock();
    }
    
    [SVTool TextButtonAction:self.view withSing:@"清空成功"];
    //用延迟来移除提示框
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

/**
 当界面消失的时间调用这个方法
 */
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
    //清楚数据
    //    self.orderArr = nil;
//    [self.orderArr removeAllObjects];
    
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVDetailsCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVDetailsCell" owner:nil options:nil].lastObject;
    }
    
    cell.orderDetailsModel = self.modelArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH - 50 - TopHeight)];
        //去分割线
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView setSeparatorColor:cellSeparatorColor];
        //取消选中
        _tableView.allowsSelection = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
