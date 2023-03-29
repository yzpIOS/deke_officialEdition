//
//  SVaddCouponVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/10.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVaddCouponVC.h"
#import "SVaddCouponView.h"
//选择时间
#import "SVSelectTwoDatesView.h"

@interface SVaddCouponVC ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *_placeHolderLabel;
    UILabel *_numberLabel;
}

@property (nonatomic,strong) SVaddCouponView *xibView;

//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;


@end

@implementation SVaddCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增优惠券";
    self.view.backgroundColor = BlueBackgroundColor;
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIScrollView *todyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight)];
    todyScrollView.contentSize = CGSizeMake(0, 570);
//    todyScrollView.backgroundColor = RGBA(241, 241, 241, 1);
    // 隐藏滑动条
    todyScrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
    //    todyScrollView.bounces = NO;
    //指定代理
    todyScrollView.delegate = self;
    [self.view addSubview:todyScrollView];
    
    self.xibView = [[NSBundle mainBundle] loadNibNamed:@"SVaddCouponView" owner:nil options:nil].lastObject;
    self.xibView.frame = CGRectMake(0, 0, ScreenW, 550);
    [todyScrollView addSubview:self.xibView];
    
    self.xibView.oneTextField.delegate = self;
    self.xibView.twoTextField.delegate = self;
    self.xibView.threeTextField.delegate = self;
    self.xibView.fourTextField.delegate = self;
    self.xibView.fiveTextField.delegate = self;
    //指定UITextView
    self.xibView.note.delegate = self;
    //创建Label
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenW - 10, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:15];
    _placeHolderLabel.text = @"限于50字";
    _placeHolderLabel.textColor = placeholderFontColor;
    [self.xibView.note addSubview:_placeHolderLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-25-20, 100, 20, 15)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel.text = @"0";
    _numberLabel.hidden = YES;
    _numberLabel.textColor = placeholderFontColor;
    [self.xibView.note addSubview:_numberLabel];
    
    [self.xibView.oneButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.xibView.oneButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.xibView.twoButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.xibView.twoButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    
    [self.xibView.threeButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.xibView.threeButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.xibView.fourButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    [self.xibView.fourButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    
    self.xibView.oneButton.selected = YES;
    self.xibView.twoButton.selected = NO;
    self.xibView.threeButton.selected = YES;
    self.xibView.fourButton.selected = NO;
    
    [self.xibView.oneButton addTarget:self action:@selector(oneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.xibView.twoButton addTarget:self action:@selector(twoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.xibView.threeButton addTarget:self action:@selector(threeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.xibView.fourButton addTarget:self action:@selector(fourButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//保存
-(void)rightbuttonResponseEvent {
    
    if ([SVTool isBlankString:self.xibView.oneTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"名称不能为空"];
        return;
    }
    if ([SVTool isBlankString:self.xibView.twoTextField.text]) {
        if (self.xibView.oneButton.selected == YES) {
            [SVTool TextButtonAction:self.view withSing:@"面值不能为空"];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"折扣不能为空"];
        }
        return;
    }
    if ([self.xibView.twoTextField.text isEqualToString:@"0"]) {
        if (self.xibView.oneButton.selected == YES) {
            [SVTool TextButtonAction:self.view withSing:@"面值不能为0"];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"折扣不能为0"];
        }
        return;
    }
    if ([SVTool isBlankString:self.xibView.threeTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"消费金额不能为空"];
        return;
    }
    if (self.xibView.threeButton.selected == YES && [SVTool isBlankString:self.xibView.fourTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"有效天数不能为空"];
        return;
    }
    if ([SVTool isBlankString:self.xibView.fiveTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"发放数量不能为空"];
        return;
    }
    
    [self.view endEditing:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [SVTool TextButtonAction:self.view withSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/CreateOrUpdateCoupon?key=%@",[SVUserManager shareInstance].access_token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:self.xibView.oneTextField.text forKey:@"sv_coupon_name"];
    if (self.xibView.oneButton.selected == YES) {
        [parameters setObject:self.xibView.twoTextField.text forKey:@"sv_coupon_money"];
    } else {
        NSString *dis=self.xibView.twoTextField.text;
       double disNum = dis.doubleValue * 10;
       NSNumber * disNumber= [NSNumber numberWithDouble:disNum];
        [parameters setObject:disNumber forKey:@"sv_coupon_money"];
    }
    
    [parameters setObject:self.xibView.threeTextField.text forKey:@"sv_coupon_use_conditions"];
    [parameters setObject:self.xibView.fiveTextField.text forKey:@"sv_coupon_toal_num"];
    [parameters setObject:self.xibView.note.text forKey:@"sv_remark"];
    
    if (self.xibView.oneButton.selected == YES) {
        [parameters setObject:@"0" forKey:@"sv_coupon_type"];
    } else {
        [parameters setObject:@"1" forKey:@"sv_coupon_type"];
    }
    if (self.xibView.threeButton.selected == YES) {
        [parameters setObject:@"1" forKey:@"sv_coupon_termofvalidity_type"];
        [parameters setObject:self.xibView.fourTextField.text forKey:@"sv_coupon_numday"];
    } else {
        [parameters setObject:@"0" forKey:@"sv_coupon_termofvalidity_type"];
        [parameters setObject:self.oneDate forKey:@"sv_coupon_bendate"];
        [parameters setObject:self.twoDate forKey:@"sv_coupon_enddate"];
    }
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            if (self.addCouponBlock) {
                self.addCouponBlock();
            }
            NSString *errmsg = dic[@"errmsg"];
            if (kStringIsEmpty(errmsg)) {
                 [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            }else{
                 [SVTool TextButtonAction:self.view withSing:errmsg];
            }
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据出错,添加失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

-(void)oneButtonResponseEvent {
    self.xibView.oneButton.selected = YES;
    self.xibView.twoButton.selected = NO;
    self.xibView.oneLabel.text = @"面值";
    self.xibView.twoTextField.text = nil;
    self.xibView.twoTextField.placeholder = @"请输入优惠券面值";
}

-(void)twoButtonResponseEvent {
    self.xibView.oneButton.selected = NO;
    self.xibView.twoButton.selected = YES;
    self.xibView.oneLabel.text = @"折扣";
    self.xibView.twoTextField.text = nil;
    self.xibView.twoTextField.placeholder = @"限于1-10之间";
}

-(void)threeButtonResponseEvent {
    self.xibView.threeButton.selected = YES;
    self.xibView.fourButton.selected = NO;
    [self.xibView.fourButton setTitle:[NSString stringWithFormat:@"   开始日期 一 结束日期"] forState:UIControlStateNormal];
    [self.xibView.fourButton setTitleColor:placeholderFontColor forState:UIControlStateNormal];
}

-(void)fourButtonResponseEvent {
    //退出编辑
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
}

#pragma mark - textView
//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
        _numberLabel.hidden = NO;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        _placeHolderLabel.hidden = NO;
        _numberLabel.hidden = YES;
    }
    
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    //超过20位 就不能在输入了
    if (pointLength > 50) {
        return NO;
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%ld",50 - pointLength];
        return YES;
    }
    
    return YES;
    
}

#pragma mark - textField
//限制只能输入一定长度的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        if ([textField isEqual:self.xibView.oneTextField]) {
            NSInteger existedLength = textField.text.length;
            NSInteger selectedLength = range.length;
            NSInteger replaceLength = string.length;
            NSInteger pointLength = existedLength - selectedLength + replaceLength;
            
            //超过20位 就不能在输入了
            if (pointLength > 15) {
                return NO;
            } else {
                return YES;
            }
            
        }
        NSCharacterSet *cs;
        if ([textField isEqual:self.xibView.twoTextField]) {
            if (self.xibView.twoButton.selected == YES) {
                NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
                if (dotLocation == NSNotFound && range.location != 0) {
                    cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                    if (range.location >= 1) {
                        if (([string isEqualToString:@"."] && range.location == 1) || string.doubleValue < 0) {
                            return YES;
                        }
                        return NO;
                    }
                }else {
                    cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                }
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
            } else {
                // 小数点在字符串中的位置 第一个数字从0位置开始
                NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
                // 判断字符串中是否有小数点，并且小数点不在第一位
                // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
                // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
                if (dotLocation == NSNotFound && range.location != 0) {
                    // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                    /*
                     [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                     在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                     */
                    cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                    if (range.location >= 9) {
                        
                        if ([string isEqualToString:@"."] && range.location == 9) {
                            return YES;
                        }
                        
                        return NO;
                    }
                }else {
                    cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
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
        }
        if ([textField isEqual:self.xibView.threeTextField]) {
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 9) {
                    
                    if ([string isEqualToString:@"."] && range.location == 9) {
                        return YES;
                    }
                    
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            }
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
        if ([textField isEqual:self.xibView.fourTextField] || [textField isEqual:self.xibView.fiveTextField]) {
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 5) {
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            }
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                return NO;
            }
            if (dotLocation != NSNotFound && range.location > dotLocation + 0) {
                return NO;
            }
            if (textField.text.length > 11) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 懒加载
-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        
    }
    
    return _DateView;
}

//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
}

- (void)twoCancelResponseEvent {
    
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        
        self.xibView.threeButton.selected = NO;
        self.xibView.fourButton.selected = YES;
        [self.xibView.fourButton setTitle:[NSString stringWithFormat:@"   %@ 一 %@",self.oneDate,self.twoDate] forState:UIControlStateNormal];
        [self.xibView.fourButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
        
    }
    
    
}


@end
