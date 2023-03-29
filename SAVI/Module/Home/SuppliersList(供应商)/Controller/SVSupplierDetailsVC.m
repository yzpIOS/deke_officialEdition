//
//  SVSupplierDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSupplierDetailsVC.h"
//供应记录
#import "SVSupplyRecordVC.h"
//修改供应商
#import "SVAddSupplierVC.h"
//还款
#import "SVRepayMoneyVC.h"

@interface SVSupplierDetailsVC ()

//供应商
@property (weak, nonatomic) IBOutlet UILabel *supplier;

//联系人
@property (weak, nonatomic) IBOutlet UILabel *name;

//电话
@property (weak, nonatomic) IBOutlet UIButton *phone;
//QQ
@property (weak, nonatomic) IBOutlet UILabel *QQ;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address;

//时间
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

//备注
@property (weak, nonatomic) IBOutlet UILabel *note;

//欠款
@property (weak, nonatomic) IBOutlet UILabel *arrears;


@end

@implementation SVSupplierDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"供应商详情";
    
    //navigation右边按钮
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;
    
    //赋值
    self.supplier.text = self.sv_suname;
    self.name.text = self.sv_sulinkmnm;
    [self.phone setTitle:self.sv_sumoble forState:UIControlStateNormal];
    
    self.date.text = [self.sv_suaddtime substringWithRange:NSMakeRange(0, 10)];
    self.time.text = [self.sv_suaddtime substringWithRange:NSMakeRange(11, 5)];
    
    if (![SVTool isBlankString:self.sv_subeizhu]) {
        self.note.text = self.sv_subeizhu;
    } else {
        self.note.textColor = [UIColor grayColor];
        self.note.text = @"无";
    }
    if (![SVTool isBlankString:self.sv_suqq]) {
        self.QQ.text = self.sv_suqq;
    } else {
        self.QQ.textColor = [UIColor grayColor];
        self.QQ.text = @"无";
    }
    if (![SVTool isBlankString:self.sv_suadress]) {
        self.address.text = self.sv_suadress;
    } else {
        self.address.textColor = [UIColor grayColor];
        self.note.text = @"无";
    }
    
    self.arrears.text = [NSString stringWithFormat:@"￥%@",self.arrear];
}

- (void)rightbuttonResponseEvent {
    
    SVAddSupplierVC *VC = [[SVAddSupplierVC alloc]init];
    VC.sv_suname = self.sv_suname;
    VC.sv_sulinkmnm = self.sv_sulinkmnm;
    VC.sv_sumoble = self.sv_sumoble;
    VC.sv_subeizhu = self.sv_subeizhu;
    VC.sv_suid = self.sv_suid;
    VC.sv_suqq = self.sv_suqq;
    VC.sv_suadress = self.sv_suadress;
    
    __weak typeof(self) weakSelf = self;
    VC.modifySupplierBlock = ^(){
        if (weakSelf.supplierDetailsBlock) {
            weakSelf.supplierDetailsBlock();
        }
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

//供应商品记录
- (IBAction)supplierDetailsResponseEvect {
    
    SVSupplyRecordVC *VC = [[SVSupplyRecordVC alloc]init];
    VC.sv_suname = self.sv_suname;
    VC.sv_suid = self.sv_suid;
    VC.sv_sumoble = self.sv_sumoble;
    [self.navigationController pushViewController:VC animated:YES];
    
}


//还款
- (IBAction)repayMoneyResponseEvect {
    
    SVRepayMoneyVC *VC = [[SVRepayMoneyVC alloc]init];
    VC.sv_suname = self.sv_suname;
    VC.arrears = self.arrear;
    VC.sv_suid = self.sv_suid;
    
    __weak typeof(self) weakSelf = self;
    VC.repayMoneyBlock = ^(){
        if (weakSelf.supplierDetailsBlock) {
            weakSelf.supplierDetailsBlock();
        }
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

//打电话
-(IBAction)cellResponseEvent{
    
    //判断电话号码
    if (![SVTool valiMobile:self.sv_sumoble]) {
        [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
        return;
    }
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.sv_sumoble];
    //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {
        
    }];//此方法有一个报错
}


@end
