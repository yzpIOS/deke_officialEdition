//
//  SVAddMoreColorVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/20.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVAddMoreColorVC.h"
#import "SVDetailAttrilistModel.h"
@interface SVAddMoreColorVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation SVAddMoreColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    self.titleL.text = self.titleStr;
//    self.textFiled.delegate = self;
//    [self.textFiled becomeFirstResponder];
}

- (IBAction)cleanClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sureClick:(id)sender {
    if (kStringIsEmpty(self.textFiled.text)) {
        [SVTool TextButtonAction:self.view withSing:@"请输入颜色名称"];
    }else{
        if ([self.titleStr isEqualToString:@"新增颜色"]) {
            if (self.colorBlock) {
                self.colorBlock(self.textFiled.text);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            if (self.detailAttrilistModelBlock) {
                SVDetailAttrilistModel *model = [[SVDetailAttrilistModel alloc] init];
                model.attri_name = self.textFiled.text;
                self.detailAttrilistModelBlock(model);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
       
    }
   
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.textFiled becomeFirstResponder];
//}
//
////按下Done按钮的调用方法，我们让键盘消失
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    [textField resignFirstResponder];
//
//    return YES;
//
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [textField endEditing:YES];
//}
@end
