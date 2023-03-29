//
//  SVsubCardObjectDetailVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVsubCardObjectDetailVC.h"
#import "SVsubCardDetailCell.h"
#import "SVModifySunCardVC.h"

static NSString *const SVsubCardDetailCellID = @"SVsubCardDetailCell";
@interface SVsubCardObjectDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cikaName;
@property (weak, nonatomic) IBOutlet UILabel *cimoney;

@end

@implementation SVsubCardObjectDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVsubCardDetailCell" bundle:nil] forCellReuseIdentifier:SVsubCardDetailCellID];
    self.cikaName.text = self.name;
    self.cimoney.text = self.price;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.title = @"次卡项目详情";
    // 设置tableView的估算高度
    self.tableView.estimatedRowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVsubCardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SVsubCardDetailCellID];
    if (!cell) {
        cell = [[SVsubCardDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVsubCardDetailCellID];
    }
    cell.dict = self.dataArray[indexPath.row];
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}


@end
