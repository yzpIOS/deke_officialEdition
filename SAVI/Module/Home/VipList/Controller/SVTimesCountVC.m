//
//  SVTimesCountVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVTimesCountVC.h"

#import "SVTimesCountCell.h"
#import "SVTimesCountModel.h"


static NSString *TimesCountCellID = @"TimesCountCell";
@interface SVTimesCountVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;

@end

@implementation SVTimesCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"计次卡";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight)];
    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //完全没有线   这样就不会显示自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVTimesCountCell" bundle:nil] forCellReuseIdentifier:TimesCountCellID];
    
    for (NSDictionary *dic in self.dateArr) {
        SVTimesCountModel *model = [SVTimesCountModel mj_objectWithKeyValues:dic];
        [self.modelArr addObject:model];
    }
    [self.tableView reloadData];
    
}

#pragma mark - tableVeiw
//让section头部不停留在顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 5;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *oneHeaderView = [[UIView alloc]init];
    return oneHeaderView;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVTimesCountCell *cell = [tableView dequeueReusableCellWithIdentifier:TimesCountCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVTimesCountCell" owner:nil options:nil].lastObject;
        
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    
    cell.model = self.modelArr[indexPath.row];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}


#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}






@end
