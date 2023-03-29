//
//  SVRepayMoneyVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/24.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVRepayMoneyVC.h"
#import "SVSuppliersListVC.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface SVRepayMoneyVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UILabel *arrearsLabel;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

//还款按钮
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SVRepayMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"还款";
    
    //赋值
    self.nameLabel.text = self.sv_suname;
    self.money.text = self.arrears;
    
    //将按钮设置为圆
    self.button.layer.cornerRadius = 6;
    
    //指定代理
    self.oneTextField.delegate = self;
    
}

//还钱按钮响应方法
- (IBAction)repayMoneyButton {
    
    if ([SVTool isBlankString:self.oneTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入还款金额"];
        return;
    }

    [self.button setEnabled:NO];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];

    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/SaveSupplierRepay?key=%@",token];
    
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //ID
    [parameters setObject:@"sv_suid" forKey:@"name"];
    //0代表充值
    [parameters setObject:self.sv_suid forKey:@"value"];
    
    //创建可变字典
    NSMutableDictionary *parameters2 = [NSMutableDictionary dictionary];
    //ID
    [parameters2 setObject:@"sv_repaymoney" forKey:@"name"];
    //0代表充值
    [parameters2 setObject:self.oneTextField.text forKey:@"value"];
    
    //创建可变字典
    NSMutableDictionary *parameters3 = [NSMutableDictionary dictionary];
    //ID
    [parameters3 setObject:@"sv_repaybehind" forKey:@"name"];
    //0代表充值
    [parameters3 setObject:self.money.text forKey:@"value"];
    
    //创建可变字典
    NSMutableDictionary *parameters4 = [NSMutableDictionary dictionary];
    //ID
    [parameters4 setObject:@"sv_repaydate" forKey:@"name"];
    //0代表充值
    [parameters4 setObject:@"2018-02-08 16:17:12" forKey:@"value"];
    
    //创建可变字典
    NSMutableDictionary *parameters5 = [NSMutableDictionary dictionary];
    //ID
    [parameters5 setObject:@"sv_remark" forKey:@"name"];
    //0代表充值
    [parameters5 setObject:self.threeTextField.text forKey:@"value"];
    [parameters5 setObject:@"301" forKey:@"sv_operation_source"];
    
    NSMutableArray *Arr = [NSMutableArray array];
    [Arr addObject:parameters];
    [Arr addObject:parameters2];
    [Arr addObject:parameters3];
    [Arr addObject:parameters4];
    [Arr addObject:parameters5];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:Arr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];


        if ([dic[@"succeed"] floatValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonActionWithSing:@"还款成功"];

            if (self.repayMoneyBlock) {
                self.repayMoneyBlock();
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
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonActionWithSing:@"网络开了个小差"];
    }];
    
    [self.button setEnabled:YES];
    
}

#pragma mark - UITextFieldDelegate
//编辑完成时调用
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//    switch (textField.tag) {
//        case 0:
////            self.filling = textField.text;
//            break;
//        case 1:
////            self.note = textField.text;
//            break;
//
//        default:
//            break;
//    }
//}

- (IBAction)CalculationMethod:(UITextField *)sender {
    
    
    float numbe = [self.arrears floatValue] - [sender.text floatValue];
    self.arrearsLabel.text = [NSString stringWithFormat:@"%.2f",numbe];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        
        // 判断字符串中是否有小数点，并且小数点不在第一位
        
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            
            /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= 9) {
                
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                return NO;
            }
        }else {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
        // 按cs分离出数组,数组按@""分离出字符串
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            
            return NO;
            
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            
            return NO;
        }
        if (textField.text.length > 11) {
            
            return NO;
            
        }
    }
    return YES;
}



@end
