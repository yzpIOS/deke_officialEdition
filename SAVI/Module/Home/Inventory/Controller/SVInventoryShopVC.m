//
//  SVInventoryShopVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/3.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryShopVC.h"
#import "SVInventoryCell.h"
#import "SVInventoryView.h"


static NSString *const inventoryCellID = @"SVInventoryCell";
@interface SVInventoryShopVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SVInventoryView *inventoryView;
@end

@implementation SVInventoryShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"盘点商品";
    [self setUpTableView];
    [self setUpbottomView_two];
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 60- TopHeight)];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVInventoryCell" bundle:nil] forCellReuseIdentifier:inventoryCellID];
   // self.tableView. = UITableViewStyleGrouped;
//    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"SVInventoryView" owner:nil options:nil].lastObject;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;

}

- (void)setUpbottomView_two{
    
    UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-TopHeight - 60, ScreenW, 60)];
    bottomView_two.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView_two];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = [UIColor whiteColor];
    [bottomView_two addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView_two.mas_left);
        make.width.mas_equalTo(ScreenW * 0.5);
        make.top.mas_equalTo(bottomView_two.mas_top);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    UILabel *addShopLabel = [[UILabel alloc] init];
    addShopLabel.text = @"已添加商品：2种";
    [addShopLabel setTextColor:[UIColor grayColor]];
    [addShopLabel setFont:[UIFont systemFontOfSize:14]];
    [oneView addSubview:addShopLabel];
    [addShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView.mas_left).offset(10);
        make.top.mas_equalTo(oneView.mas_top).offset(10);
    }];
    
    UILabel *profitShopLabel = [[UILabel alloc] init];
    profitShopLabel.text = @"盈3.6万";
    [profitShopLabel setFont:[UIFont systemFontOfSize:14]];
    [profitShopLabel setTextColor:[UIColor redColor]];
    [oneView addSubview:profitShopLabel];
    [profitShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView.mas_left).offset(10);
        make.top.mas_equalTo(addShopLabel.mas_bottom).offset(5);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [oneView addSubview:icon];
    icon.image = [UIImage imageNamed:@"brithdaySmall"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(oneView.mas_right).offset(-10);
        make.centerY.mas_equalTo(oneView.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    //
    // UIView *TemporaryDraftView = [[UIView alloc] init];
    UIButton *temporaryDraftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [temporaryDraftBtn addTarget:self action:@selector(temporaryDraftClick) forControlEvents:UIControlEventTouchUpInside];
    [temporaryDraftBtn setTitle:@"暂存草稿" forState:UIControlStateNormal];
    [temporaryDraftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [temporaryDraftBtn setBackgroundColor:BackgroundColor];
    [temporaryDraftBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [bottomView_two addSubview:temporaryDraftBtn];
    [temporaryDraftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView.mas_right);
        make.width.mas_equalTo(ScreenW /4 *1);
        make.top.mas_equalTo(bottomView_two.mas_top);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
    [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
    [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
    [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView_two addSubview:physicalCountBtn];
    [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(temporaryDraftBtn.mas_right);
        make.width.mas_equalTo(ScreenW /4*1);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

   self.inventoryView = [[NSBundle mainBundle] loadNibNamed:@"SVInventoryView" owner:nil options:nil].lastObject;
   // view.frame = CGRectMake(0, 0, ScreenW, 136);

    return self.inventoryView;
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 136;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryCellID];
    if (!cell) {
        cell = [[SVInventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inventoryCellID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
@end
