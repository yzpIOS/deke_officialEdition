//
//  SVaddWarehouseVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVaddWarehouseVC.h"
#import "SVWarehouseListVC.h"

@interface SVaddWarehouseVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourTextField;
@property (weak, nonatomic) IBOutlet UITextField *fiveTextField;
@property (weak, nonatomic) IBOutlet UITextField *sixTextField;

@end

@implementation SVaddWarehouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    if ([self.sv_warehouse_id isEqualToString:@"0"]) {
        self.navigationItem.title = @"新增仓库";
    } else {
        self.navigationItem.title = @"修改仓库";
        
        self.oneTextField.text = _model.sv_warehouse_name;
        self.twoTextField.text = _model.sv_warehouse_code;
        self.threeTextField.text = _model.sv_warehouse_managers;
        self.fourTextField.text = _model.sv_warehouse_phone;
        self.fiveTextField.text = _model.sv_warehouse_address;
        self.sixTextField.text = _model.sv_remark;
    }
    
    self.oneTextField.delegate = self;
    self.twoTextField.delegate = self;
    self.threeTextField.delegate = self;
    self.fourTextField.delegate = self;
    self.fiveTextField.delegate = self;
    self.sixTextField.delegate = self;
    
    
}

//保存按钮
- (void)rightButtonResponseEvent {
    
    if ([SVTool isBlankString:self.oneTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入仓库名称"];
        return;
    }
    if ([SVTool isBlankString:self.twoTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入仓库编码"];
        return;
    }
    if ([SVTool isBlankString:self.threeTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入管理人员"];
        return;
    }
    if ([SVTool isBlankString:self.fourTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入联系电话"];
        return;
    }
    
    if (![SVTool valiMobile:self.fourTextField.text]) {
        [SVTool TextButtonActionWithSing:@"电话格式错误"];
        return;
    }
    
    //控制添加会员只能点一次
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Supplier/OperationWarehouse?key=%@",[SVUserManager shareInstance].access_token];
    
    //创建字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.sv_warehouse_id forKey:@"sv_warehouse_id"];
    [parameters setObject:self.oneTextField.text forKey:@"sv_warehouse_name"];
    [parameters setObject:self.twoTextField.text forKey:@"sv_warehouse_code"];
    [parameters setObject:self.threeTextField.text forKey:@"sv_warehouse_managers"];
    [parameters setObject:self.fourTextField.text forKey:@"sv_warehouse_phone"];
    [parameters setObject:self.fiveTextField.text forKey:@"sv_warehouse_address"];
    [parameters setObject:self.sixTextField.text forKey:@"sv_remark"];
    [parameters setObject:@"true" forKey:@"sv_is_enable"];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //添加成功时，回调给商品列表刷新
            if (self.addWarehouseBlock) {
                self.addWarehouseBlock();
            }
            
            if ([self.sv_warehouse_id isEqualToString:@"0"]) {
                [SVTool TextButtonActionWithSing:@"添加仓库成功"];
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SVTool TextButtonActionWithSing:@"修改成功"];
                // 返回到任意界面
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[SVWarehouseListVC class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }

        } else {
            //提示添加失败的原因
            [SVTool TextButtonActionWithSing:@"数据出错，添加失败"];
        }
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonActionWithSing:@"网络开小差了"];
    }];
    
}

//限制字数输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if (textField == self.oneTextField || textField == self.twoTextField || textField == self.threeTextField || textField == self.fourTextField) {
        //超过20位 就不能在输入了
        if (pointLength > 20) {
            return NO;
        }else{
            return YES;
        }
    }
    
    //超过20位 就不能在输入了
    if (pointLength > 50) {
        return NO;
    }else{
        return YES;
    }
    
    
}



@end
