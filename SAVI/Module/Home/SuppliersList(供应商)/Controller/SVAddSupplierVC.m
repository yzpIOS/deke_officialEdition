//
//  SVAddSupplierVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/25.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAddSupplierVC.h"
#import "SVSuppliersListVC.h"

@interface SVAddSupplierVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *supplierTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@end

@implementation SVAddSupplierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.supplierTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.qqTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.noteTextField.delegate = self;
    
    if (self.supplierBool == YES) {
        
        self.navigationItem.title = @"新增供应商";
        
    } else {
        
        self.navigationItem.title = @"修改供应商";
        //赋值
        self.supplierTextField.text = self.sv_suname;
        self.nameTextField.text = self.sv_sulinkmnm;
        self.phoneTextField.text = self.sv_sumoble;
        
        if (![SVTool isBlankString:self.sv_subeizhu]) {
            self.noteTextField.text = self.sv_subeizhu;
        }
        if (![SVTool isBlankString:self.sv_suqq]) {
            self.qqTextField.text = self.sv_suqq;
        }
        if (![SVTool isBlankString:self.sv_suadress]) {
            self.addressTextField.text = self.sv_suadress;
        }
        
    }
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

//
- (void)rightbuttonResponseEvent {
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    if ([SVTool isBlankString:self.supplierTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入供应商名称"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }
    if ([SVTool isBlankString:self.nameTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入联系人"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }
    if ([SVTool isBlankString:self.phoneTextField.text]) {
        [SVTool TextButtonActionWithSing:@"请输入电话"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }
    if (![SVTool valiMobile:self.phoneTextField.text]) {
        [SVTool TextButtonActionWithSing:@"输入的手机号码有误"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.supplierTextField.text forKey:@"sv_suname"];
    [parameters setObject:self.nameTextField.text forKey:@"sv_sulinkmnm"];
    [parameters setObject:self.phoneTextField.text forKey:@"sv_sumoble"];
    
    if (![SVTool isBlankString:self.qqTextField.text]) {
        [parameters setObject:self.qqTextField.text forKey:@"sv_suqq"];
    }
    if (![SVTool isBlankString:self.addressTextField.text]) {
        [parameters setObject:self.addressTextField.text forKey:@"sv_suadress"];
    }
    if (![SVTool isBlankString:self.noteTextField.text]) {
        [parameters setObject:self.noteTextField.text forKey:@"sv_subeizhu"];
    }
    if (self.supplierBool == NO) {
        [parameters setObject:self.sv_suid forKey:@"sv_suid"];
    }
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/AUDSupplier?key=%@",token];
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.supplierBool == YES) {
                [SVTool TextButtonActionWithSing:@"添加成功"];
            } else {
                [SVTool TextButtonActionWithSing:@"修改成功"];
            }
            
            //添加的
            if (self.supplierBlock) {
                self.supplierBlock();
            }
            //修改的
            if (self.modifySupplierBlock) {
                self.modifySupplierBlock();
            }
            
            //用延迟来来返来
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //返回到任意界面
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[SVSuppliersListVC class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                
            });
            
        }else{
            [SVTool TextButtonActionWithSing:@"操作有误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonActionWithSing:@"网络开小差了"];
    }];
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
}

//限制字数输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    
    if (textField == self.noteTextField || textField == self.addressTextField) {
        //超过20位 就不能在输入了
        if (pointLength > 50) {
            return NO;
        }else{
            return YES;
        }
    }
    //超过20位 就不能在输入了
    if (pointLength > 20) {
        return NO;
    }else{
        return YES;
    }
    
}

@end
