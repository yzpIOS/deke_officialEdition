//
//  SVWriteOffCodeQueryVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/6/2.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVWriteOffCodeQueryVC.h"
#import "SVDetailsHistoryCell.h"
static NSString *const ID = @"SVDetailsHistoryCell";
@interface SVWriteOffCodeQueryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *AmountReceivableLabel;
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *ReceivingPhone;

@property (weak, nonatomic) IBOutlet UILabel *WriteOffCode;
@property (weak, nonatomic) IBOutlet UILabel *SalesOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *OrderTime;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *immediatelyBtn;
 //-1:订单不存在，1：核销成功/已核销，0：核销失败
@property (nonatomic,assign) int verifystatus;
@end

@implementation SVWriteOffCodeQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"核销码查询";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVDetailsHistoryCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadDataCode:self.code];
}

- (void)loadDataCode:(NSString *)code{
     [SVUserManager loadUserInfo];
     NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/OnlineOrder/GetVerifyOrderByCode?key=%@&code=%@",token,code];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic核销码 == %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            NSDictionary *dict = dic[@"values"];
            if (kDictIsEmpty(dict)) {
                [SVTool TextButtonActionWithSing:@"数据有误"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.AmountReceivableLabel.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_order_receivable"] doubleValue]];
                          self.consignee.text = dict[@"sv_receipt_name"];
                          self.ReceivingPhone.text = dict[@"sv_receipt_phone"];
                          self.WriteOffCode.text = dict[@"verifycode"];
                          self.SalesOrderNo.text = dict[@"wt_nober"];
                          NSString *orderTime = [NSString stringWithFormat:@"%@",dict[@"sv_delivery_time"]];
                              NSString *str2 = [orderTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
                                 NSString *str3 = [orderTime substringWithRange:NSMakeRange(11,8)];//str2
                          self.OrderTime.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
                self.verifystatus = [dict[@"verifystatus"]intValue];
                          NSData *data = [dict[@"order_product_json_str"] dataUsingEncoding:NSUTF8StringEncoding];
                          self.dataArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                          [self.tableView reloadData];
                          NSLog(@"self.dataArray == %@",self.dataArray);
                
                if (self.verifystatus == 1) {
                    self.immediatelyBtn.userInteractionEnabled = NO;
                    self.immediatelyBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
                    self.immediatelyBtn.titleLabel.text = @"已核销";
                }else if (self.verifystatus == -1){
                   // [SVTool TextButtonActionWithSing:@"订单不存在"];
                    self.immediatelyBtn.userInteractionEnabled = NO;
                     self.immediatelyBtn.titleLabel.text = @"订单不存在";
                     self.immediatelyBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
                }
            }
          
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

- (IBAction)immediatelyClick:(id)sender {
    self.immediatelyBtn.userInteractionEnabled = NO;
    [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
       NSString *dURL=[URLhead stringByAppendingFormat:@"/api/OnlineOrder/VerifyOrderByCode?key=%@&code=%@",token,self.code];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                   NSLog(@"dic核销码 == %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVTool TextButtonActionWithSing:@"核销成功"];
        }else{
            [SVTool TextButtonActionWithSing:@"核销失败"];
        }
        self.immediatelyBtn.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           //隐藏提示框
        self.immediatelyBtn.userInteractionEnabled = YES;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVDetailsHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVDetailsHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dict = self.dataArray[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}


//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

@end
