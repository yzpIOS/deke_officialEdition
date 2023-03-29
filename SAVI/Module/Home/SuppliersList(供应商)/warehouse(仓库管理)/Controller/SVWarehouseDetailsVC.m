//
//  SVWarehouseDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWarehouseDetailsVC.h"
//修改
#import "SVaddWarehouseVC.h"
//查看仓库
#import "SVWarehouseWaresVC.h"

@interface SVWarehouseDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *sv_warehouse_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_warehouse_code;
@property (weak, nonatomic) IBOutlet UILabel *sv_warehouse_managers;
@property (weak, nonatomic) IBOutlet UIButton *sv_warehouse_phone;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sv_warehouse_address;
@property (weak, nonatomic) IBOutlet UILabel *sv_remark;

@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation SVWarehouseDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"仓库详情";
    
    self.lookButton.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(modifyButtonResponseEvent)];
    
    //赋值
    self.sv_warehouse_name.text = _model.sv_warehouse_name;
    self.sv_warehouse_code.text = _model.sv_warehouse_code;
    self.sv_warehouse_managers.text = _model.sv_warehouse_managers;
    [self.sv_warehouse_phone setTitle:_model.sv_warehouse_phone forState:UIControlStateNormal];
    self.sv_warehouse_address.text = _model.sv_warehouse_address;
    self.sv_remark.text = _model.sv_remark;
    
    self.date.text = [_model.sv_creation_date substringWithRange:NSMakeRange(0, 10)];
    self.time.text = [_model.sv_creation_date substringWithRange:NSMakeRange(11, 5)];
    
    if ([_model.sv_is_enable integerValue] == 1) {
        [self.switchButton setOn:YES];
    } else {
        [self.switchButton setOn:NO];
    }
    
    
}
- (IBAction)lookWarehouseButtonResponseEvent {
    
    SVWarehouseWaresVC *VC = [[SVWarehouseWaresVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

//修改响应方法
- (void)modifyButtonResponseEvent {
    
    SVaddWarehouseVC *VC = [[SVaddWarehouseVC alloc]init];
    VC.sv_warehouse_id = self.model.sv_warehouse_id;
    VC.model = _model;
    __weak typeof(self) weakSelf = self;
    VC.addWarehouseBlock = ^{
        if (weakSelf.warehouseDetailsBlock) {
            weakSelf.warehouseDetailsBlock();
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

//打电话
-(IBAction)cellResponseEvent{
    
    //判断电话号码
    if (![SVTool valiMobile:self.sv_warehouse_phone.titleLabel.text]) {
        [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
        return;
    }
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.sv_warehouse_phone.titleLabel.text];
    //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {
        
    }];//此方法有一个报错
}

- (IBAction)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //启用调用
        [self requestStart:@"false"];
    }else {
        //停用调用
        [self requestStart:@"true"];
    }
    
}

-(void)requestStart:(NSString *)isenable {
    
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Supplier/EnableWarehouse?key=%@&isenable=%@&id=%@",[SVUserManager shareInstance].access_token,isenable,_model.sv_warehouse_id];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (self.warehouseDetailsBlock) {
            self.warehouseDetailsBlock();
        }
        //隐藏提示框POST
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"succeed"] integerValue] == 1 && [isenable isEqualToString:@"false"]) {
            [SVTool TextButtonAction:self.view withSing:@"启用成功"];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"停用成功"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}



@end
