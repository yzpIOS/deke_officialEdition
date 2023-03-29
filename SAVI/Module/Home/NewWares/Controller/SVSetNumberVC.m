//
//  SVSetNumberVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/22.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVSetNumberVC.h"
#import "SVSetNumberCell.h"
#import "SVDetailAttrilistModel.h"
#import "SGQRCodeScanningVC.h"
#import "SVduoguigeModel.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
//static NSString *const ID = @"SVSetNumberCell";
@interface SVSetNumberVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIView *colorAndSizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorAndSizeHeight;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UIView *colorView;
@property (weak, nonatomic) IBOutlet UISwitch *oneSwi;
@property (weak, nonatomic) IBOutlet UISwitch *twoSwi;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic,assign) BOOL ischineseStr;
@property (nonatomic,strong) UITextField *textField;
@end

@implementation SVSetNumberVC

- (NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    
    return _viewArray;
}
- (NSMutableArray *)arraydataResult2{
    if (!_arraydataResult2) {
        _arraydataResult2 = [NSMutableArray array];
    }
    
    return _arraydataResult2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置条码";
    self.view.backgroundColor = BackgroundColor;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;

    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
 
    
    [self.oneSwi addTarget:self action:@selector(oneSwiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.twoSwi addTarget:self action:@selector(twoSwiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadcolorAndSizeView];
}

- (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            self.ischineseStr = YES;
            return YES;
        }
    }
     self.ischineseStr = NO;
    return NO;
}

- (void)oneSwiClick:(UISwitch *)swi{
    if (swi.isOn) {// 开着
        [self.colorAndSizeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSLog(@"开着");
        self.twoView.hidden = NO;
         [self loadcolorAndSizeView];
    }else{// 关着
        NSLog(@"关着");
        self.twoView.hidden = YES;
         [self.colorAndSizeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.colorAndSizeHeight.constant = 50;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.colorAndSizeView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorAndSizeView.mas_left);
            make.right.mas_equalTo(self.colorAndSizeView.mas_right);
            make.top.mas_equalTo(self.colorAndSizeView.mas_top);
            make.height.mas_equalTo(50);
        }];
        
        UILabel *barCodeL = [[UILabel alloc] init];
        [view addSubview:barCodeL];
        [barCodeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.centerY.mas_equalTo(view.mas_centerY);
            make.width.mas_equalTo(50);
        }];

        
        barCodeL.textColor = [UIColor colorWithHexString:@"555555"];
        barCodeL.font = [UIFont systemFontOfSize:15];
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            barCodeL.text = @"款号";
        }else{
            barCodeL.text = @"条码";
        }
       
        barCodeL.textAlignment = NSTextAlignmentLeft;
       // colorView.backgroundColor = [UIColor whiteColor];
        
        // 扫描按钮
        UIButton *saoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:saoBtn];
        [saoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).offset(-10);
            make.centerY.mas_equalTo(view.mas_centerY);
        }];
//        btn.tag = i;
        [saoBtn setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
        [saoBtn addTarget:self action:@selector(twoSaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITextField *textField = [[UITextField alloc] init];
        self.textField = textField;
        textField.placeholder = @"输入或扫描";
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(barCodeL.mas_right).offset(10);
            make.top.mas_equalTo(view.mas_top);
            make.right.mas_equalTo(saoBtn.mas_left).offset(-10);
            make.height.mas_equalTo(50);
        }];
    }
}

- (void)twoSwiClick:(UISwitch *)swi{
    if (swi.isOn) {//开着
        [self.viewArray removeAllObjects];
        [self.colorAndSizeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self loadcolorAndSizeView];
        
    }else{
        for (NSInteger i = 0; i < self.viewArray.count; i++) {
            UITextField *textFilrd = self.viewArray[i];
            textFilrd.placeholder = @"输入扫描条码";
            textFilrd.text = nil;
            // textFilrd.text rem
        }
    }
  
}

- (void)twoSaoBtnClick:(UIButton *)btn{
//    self.hidesBottomBarWhenPushed = YES;
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//        weakSelf.textField.text = name;
//
//        for (NSInteger i = 0; i < self.viewArray.count; i++) {
//            UITextField *textFilrd = self.viewArray[i];
//            //textFilrd.placeholder = @"输入扫描条码";
//            textFilrd.text = name;
//            // textFilrd.text rem
//        }
//    };
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        weakSelf.textField.text = resultStr;
        
        for (NSInteger i = 0; i < self.viewArray.count; i++) {
            UITextField *textFilrd = self.viewArray[i];
            //textFilrd.placeholder = @"输入扫描条码";
            textFilrd.text = resultStr;
            // textFilrd.text rem
        }
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
     //  [self.navigationController pushViewController:vc animated:YES];
    
    //设置点击时的背影色
    //  [self.oneCell.scanButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //  [self.oneCell.scanButton setBackgroundColor:[UIColor clearColor]];
        
        [self.navigationController pushViewController:vc animated:YES];
    });
}
#pragma mark -  确认按钮的点击
- (IBAction)sureClick:(id)sender {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (UITextField *textF in self.viewArray) {
       
            if (!kStringIsEmpty(textF.text)) {
                [arrayM addObject:textF.text];
            }else{
             //   [arrayM addObject:@"0"];
                return [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
            }

    }
    
    NSLog(@"arrayM = %@",arrayM);
    
    if (self.textArrayBlock) {
        self.textArrayBlock(arrayM);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//获取当前的时间

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYYMMdd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    
    return currentTimeString;
    
}

- (void)loadcolorAndSizeView{
    
    if (self.editInterface == 1) {

         CGFloat maxY = 0;
        // 新写的逻辑
        for (int i = 0; i < self.arraydataResult2.count; i++) {
            
            if ([self.arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                NSLog(@"来了");
              //  [self.viewArray removeAllObjects];
               NSDictionary *dict = self.arraydataResult2[i];
                NSString *color = dict[@"color"];
                NSString *sizeStr = dict[@"sizeStr"];
                
                  UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                self.colorView = colorView;
                [self.colorAndSizeView addSubview:colorView];
                
                
                // 扫描按钮
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [colorView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(colorView.mas_right).offset(-10);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                btn.tag = i;
                [btn setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(saoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                // 条码
                //        UILabel *sizeL = [[UILabel alloc] init];
                UITextField *textField = [[UITextField alloc] init];
                textField.tag = i;
                textField.delegate = self;
                [colorView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(btn.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                [self.viewArray addObject:textField];
                textField.textColor = [UIColor colorWithHexString:@"555555"];
                textField.font = [UIFont systemFontOfSize:15];
                
                if (self.twoSwi.isOn) {
                    if (!kArrayIsEmpty(self.arraydataResult2)) {
                        //                textField.text = @"hah";
                        [self checkIsChinese:self.borcodeStr];
                        
                        if (self.ischineseStr == YES) {// 有中文
                            
                            NSLog(@"有中文");
                            NSString *time = [self getCurrentTimes];
                            if (i < 10) {
                                NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                                NSString *size;
                                [self checkIsChinese:sizeStr];
                                if (self.ischineseStr == YES) {// 有中文
                                    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                                    textField.text = str;
                                    NSLog(@"str = %@",str);
                                }else{
                                    if ([sizeStr containsString:@"/"]) {
                                        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",sizeStr];
                                        size = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                    }else{
                                        size = sizeStr;
                                    }
                                    
                                    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@%@",time,numStr,size];
                                    textField.text = str;
                                    NSLog(@"str = %@",str);
                                    
                                }
                                
                            }else{
                                NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                                NSString *size;
                                [self checkIsChinese:sizeStr];
                                if (self.ischineseStr == YES) {// 有中文
                                    NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                                    textField.text = str;
                                    NSLog(@"str = %@",str);
                                }else{
                                    if ([sizeStr containsString:@"/"]) {
                                        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",sizeStr];
                                        size = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                    }else{
                                        size = sizeStr;
                                    }
                                    
                                    NSString *str = [NSString stringWithFormat:@"%@%@%@",time,numStr,size];
                                    textField.text = str;
                                    NSLog(@"str = %@",str);
                                }
                                
                            }
                        }else{
                            // 没有中文
                            if (i < 10) {
                                NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                                NSString *size;
                                [self checkIsChinese:sizeStr];
                                if (self.ischineseStr == YES) {// 有中文
                                    NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                                    textField.text = str22;
                                }else{
                                    if ([sizeStr containsString:@"/"]) {
                                        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",sizeStr];
                                        size = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                    }else{
                                        size = sizeStr;
                                    }
                                    
                                    NSString *str22 = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,size];
                                    textField.text = str22;
                                }
                                
                            }else{
                                NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                                NSString *size;
                                [self checkIsChinese:sizeStr];
                                if (self.ischineseStr == YES) {// 有中文
                                    NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                                    textField.text = str22;
                                }else{
                                    if ([sizeStr containsString:@"/"]) {
                                        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",sizeStr];
                                        size = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                    }else{
                                        size = sizeStr;
                                    }
                                    NSString *str = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,size];
                                    textField.text = str;
                                    NSLog(@"str = %@",str);
                                }
                                
                            }
                            
                            NSLog(@"没有中文");
                        }
                        
                    }
                    else{
                        // textField.text = self.sizeArray[i];
                    }
                    
                }else{
                    textField.placeholder = @"输入扫描条码";
                }
               

               
                
                
                
                // 尺寸
                UILabel *sizeL = [[UILabel alloc] init];
                [colorView addSubview:sizeL];
                [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(textField.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                sizeL.numberOfLines = 0;
                
                sizeL.textColor = [UIColor colorWithHexString:@"555555"];
                sizeL.font = [UIFont systemFontOfSize:15];
                sizeL.text = sizeStr;
                sizeL.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];
                //颜色
                UILabel *colorL = [[UILabel alloc] init];
                [colorView addSubview:colorL];
                [colorL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(colorView.mas_left).offset(20);
                    //                    make.right.mas_equalTo(textField.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                colorL.numberOfLines = 0;
                
                colorL.textColor = [UIColor colorWithHexString:@"555555"];
                colorL.font = [UIFont systemFontOfSize:15];
                colorL.text = color;
                colorL.textAlignment = NSTextAlignmentCenter;
                
                //  colorView.backgroundColor = [UIColor whiteColor];
                
                maxY = CGRectGetMaxY(colorView.frame)+1;
                               //  [self.colorAndSizeView addSubview:oneColorView];
            }else{
               // [self.viewArray removeAllObjects];
                SVduoguigeModel *duoguigeModel = self.arraydataResult2[i];
                SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                // self.spec_name_two = specModel2.spec_name;
                // 颜色的
                SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                
                    // SVDetailAttrilistModel *model = self.sizeArray[i];
                UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                self.colorView = colorView;
                [self.colorAndSizeView addSubview:colorView];
                
                
                // 扫描按钮
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [colorView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(colorView.mas_right).offset(-10);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                btn.tag = i;
                [btn setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(saoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                // 条码
                //        UILabel *sizeL = [[UILabel alloc] init];
                UITextField *textField = [[UITextField alloc] init];
                textField.tag = i;
                textField.delegate = self;
                [colorView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(btn.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
               
                textField.textColor = [UIColor colorWithHexString:@"555555"];
                textField.font = [UIFont systemFontOfSize:15];
                [self.viewArray addObject:textField];
                
                textField.text = duoguigeModel.sv_p_artno;
 
                if (self.twoSwi.isOn) {
                    if (duoguigeModel.sv_p_artno.doubleValue == 0) {
                        [self checkIsChinese:self.borcodeStr];
                      
                      if (!kArrayIsEmpty(self.arraydataResult2)) {
            
                          [self checkIsChinese:self.borcodeStr];

                          if (self.ischineseStr == YES) {// 有中文

                              NSLog(@"有中文");
                              NSString *time = [self getCurrentTimes];
                              if (i < 10) {
                                  NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                                  NSString *sizeStr;
                                  [self checkIsChinese:atteilistModel2.attri_name];
                                  if (self.ischineseStr == YES) {// 有中文
                                      NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                                      textField.text = str;
                                      NSLog(@"str = %@",str);
                                  }else{
                                      if ([atteilistModel2.attri_name containsString:@"/"]) {
                                          NSMutableString *string = [NSMutableString stringWithFormat:@"%@",atteilistModel2.attri_name];
                                          sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      }else{
                                          sizeStr = atteilistModel2.attri_name;
                                      }

                                      NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@%@",time,numStr,sizeStr];
                                      textField.text = str;
                                      NSLog(@"str = %@",str);

                                  }

                              }else{
                                  NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                                  NSString *sizeStr;
                                  [self checkIsChinese:atteilistModel2.attri_name];
                                  if (self.ischineseStr == YES) {// 有中文
                                      NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                                      textField.text = str;
                                      NSLog(@"str = %@",str);
                                  }else{
                                      if ([atteilistModel2.attri_name containsString:@"/"]) {
                                          NSMutableString *string = [NSMutableString stringWithFormat:@"%@",atteilistModel2.attri_name];
                                          sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      }else{
                                          sizeStr = atteilistModel2.attri_name;
                                      }

                                      NSString *str = [NSString stringWithFormat:@"%@%@%@",time,numStr,sizeStr];
                                      textField.text = str;
                                      NSLog(@"str = %@",str);
                                  }

                              }
                          }else{
                              // 没有中文
                              if (i < 10) {
                                  NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                                  NSString *sizeStr;
                                  [self checkIsChinese:atteilistModel2.attri_name];
                                  if (self.ischineseStr == YES) {// 有中文
                                      NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                                      textField.text = str22;
                                  }else{
                                      if ([atteilistModel2.attri_name containsString:@"/"]) {
                                          NSMutableString *string = [NSMutableString stringWithFormat:@"%@",atteilistModel2.attri_name];
                                          sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      }else{
                                          sizeStr = atteilistModel2.attri_name;
                                      }

                                      NSString *str22 = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,sizeStr];
                                      textField.text = str22;
                                  }

                              }else{
                                  NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                                  NSString *sizeStr;
                                  [self checkIsChinese:atteilistModel2.attri_name];
                                  if (self.ischineseStr == YES) {// 有中文
                                      NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                                      textField.text = str22;
                                  }else{
                                      if ([atteilistModel2.attri_name containsString:@"/"]) {
                                          NSMutableString *string = [NSMutableString stringWithFormat:@"%@",atteilistModel2.attri_name];
                                          sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      }else{
                                          sizeStr = atteilistModel2.attri_name;
                                      }
                                      NSString *str = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,sizeStr];
                                      textField.text = str;
                                      NSLog(@"str = %@",str);
                                  }

                              }

                              NSLog(@"没有中文");
                          }

                      }
                      else{
                          // textField.text = self.sizeArray[i];
                      }
                                 
                    }else{
                        textField.text = duoguigeModel.sv_p_artno;
                        
                    }
                     
                }else{
                    textField.placeholder = @"输入扫描条码";
                }

                // 尺寸
                UILabel *sizeL = [[UILabel alloc] init];
                [colorView addSubview:sizeL];
                [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(textField.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                sizeL.numberOfLines = 0;
                
                sizeL.textColor = [UIColor colorWithHexString:@"555555"];
                sizeL.font = [UIFont systemFontOfSize:15];
                sizeL.text = atteilistModel2.attri_name;
                sizeL.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];

                 
                //颜色
                            UILabel *colorL = [[UILabel alloc] init];
                [colorView addSubview:colorL];
                [colorL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(colorView.mas_left).offset(20);
//                    make.right.mas_equalTo(textField.mas_left).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                colorL.numberOfLines = 0;
                
                colorL.textColor = [UIColor colorWithHexString:@"555555"];
                colorL.font = [UIFont systemFontOfSize:15];
                colorL.text = attriModel.attri_name;
                colorL.textAlignment = NSTextAlignmentCenter;
                
              //  colorView.backgroundColor = [UIColor whiteColor];
                            
                maxY = CGRectGetMaxY(colorView.frame)+1;
               //  [self.colorAndSizeView addSubview:oneColorView];
                
            }
        }
        
        self.colorAndSizeHeight.constant = self.arraydataResult2.count *50 +(self.arraydataResult2.count - 1) * 1;
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (UITextField *textF in self.viewArray) {
           
                if (!kStringIsEmpty(textF.text)) {
                    [arrayM addObject:textF.text];
                }else{
                    return [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                  //  [arrayM addObject:@"0"];
                }

        }
        
        NSLog(@"arrayM = %@",arrayM);
        
        if (self.textArrayBlock) {
            self.textArrayBlock(arrayM);
        }
        
    }else{
        CGFloat maxY = 0;
        for (NSInteger i = 0; i < self.sizeArray.count; i++) {
            SVDetailAttrilistModel *model = self.sizeArray[i];
           
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
            self.colorView = colorView;
            [self.colorAndSizeView addSubview:colorView];
            
            
            // 扫描按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [colorView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(colorView.mas_right).offset(-10);
                make.centerY.mas_equalTo(colorView.mas_centerY);
            }];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(saoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 条码
            //        UILabel *sizeL = [[UILabel alloc] init];
            UITextField *textField = [[UITextField alloc] init];
            textField.tag = i;
            textField.delegate = self;
            [colorView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(btn.mas_left).offset(-20);
                make.centerY.mas_equalTo(colorView.mas_centerY);
            }];
            textField.placeholder = @"输入扫描条码";
            textField.textColor = [UIColor colorWithHexString:@"555555"];
            textField.font = [UIFont systemFontOfSize:15];
            [self.viewArray addObject:textField];
            
            
            [self checkIsChinese:self.borcodeStr];
            if (kArrayIsEmpty(self.ItemNumberArray)) {
                if (self.ischineseStr == YES) {// 有中文
                    
                    NSLog(@"有中文");
                    NSString *time = [self getCurrentTimes];
                    if (i < 10) {
                        NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                        NSString *sizeStr;
                        [self checkIsChinese:model.attri_name];
                        if (self.ischineseStr == YES) {// 有中文
                            NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                            textField.text = str;
                            NSLog(@"str = %@",str);
                        }else{
                            if ([model.attri_name containsString:@"/"]) {
                                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",model.attri_name];
                                sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                            }else{
                                sizeStr = model.attri_name;
                            }
                            
                            NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@%@",time,numStr,sizeStr];
                            textField.text = str;
                            NSLog(@"str = %@",str);
                            
                        }
                        
                    }else{
                        NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                        NSString *sizeStr;
                        [self checkIsChinese:model.attri_name];
                        if (self.ischineseStr == YES) {// 有中文
                            NSMutableString *str = [NSMutableString stringWithFormat:@"%@%@",time,numStr];
                            textField.text = str;
                            NSLog(@"str = %@",str);
                        }else{
                            if ([model.attri_name containsString:@"/"]) {
                                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",model.attri_name];
                                sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                            }else{
                                sizeStr = model.attri_name;
                            }
                            
                            NSString *str = [NSString stringWithFormat:@"%@%@%@",time,numStr,sizeStr];
                            textField.text = str;
                            NSLog(@"str = %@",str);
                        }
                        
                    }
                }else{
                    // 没有中文
                    if (i < 10) {
                        NSString *numStr = [NSString stringWithFormat:@"%02d",i];
                        NSString *sizeStr;
                        [self checkIsChinese:model.attri_name];
                        if (self.ischineseStr == YES) {// 有中文
                            NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                            textField.text = str22;
                        }else{
                            if ([model.attri_name containsString:@"/"]) {
                                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",model.attri_name];
                                sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                            }else{
                                sizeStr = model.attri_name;
                            }
                            
                            NSString *str22 = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,sizeStr];
                            textField.text = str22;
                        }
                        
                    }else{
                        NSString *numStr = [NSString stringWithFormat:@"%ld",i];
                        NSString *sizeStr;
                        [self checkIsChinese:model.attri_name];
                        if (self.ischineseStr == YES) {// 有中文
                            NSString *str22 = [NSString stringWithFormat:@"%@%@",self.borcodeStr,numStr];
                            textField.text = str22;
                        }else{
                            if ([model.attri_name containsString:@"/"]) {
                                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",model.attri_name];
                                 sizeStr = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
                            }else{
                                sizeStr = model.attri_name;
                            }
                            NSString *str = [NSString stringWithFormat:@"%@%@%@",self.borcodeStr,numStr,sizeStr];
                            textField.text = str;
                            NSLog(@"str = %@",str);
                        }
                        
                    }
                    
                    NSLog(@"没有中文");
                }
            }else{
                textField.text = self.ItemNumberArray[i];
            }
           
            
            
            // 尺寸
            UILabel *sizeL = [[UILabel alloc] init];
            [colorView addSubview:sizeL];
            [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(textField.mas_left).offset(-20);
                make.centerY.mas_equalTo(colorView.mas_centerY);
            }];
            
            sizeL.numberOfLines = 0;
            
            sizeL.textColor = [UIColor colorWithHexString:@"555555"];
            sizeL.font = [UIFont systemFontOfSize:15];
            sizeL.text = model.attri_name;
            sizeL.textAlignment = NSTextAlignmentCenter;
            colorView.backgroundColor = [UIColor whiteColor];
            
            maxY = CGRectGetMaxY(colorView.frame)+1;
        }
        
        CGFloat maxColorY = 0;
        for (NSInteger i = 0; i < self.colorArray.count; i++) {
            
            UIView *oneColorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxColorY, 100, self.numberArray.count * 50 + self.numberArray.count -1)];
            oneColorView.backgroundColor = [UIColor yellowColor];
            maxColorY = CGRectGetMaxY(oneColorView.frame)+1;
            
            // 尺寸
            UILabel *sizeL = [[UILabel alloc] init];
            [oneColorView addSubview:sizeL];
            [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(oneColorView.mas_top).offset(16);
                make.centerX.mas_equalTo(oneColorView.mas_centerX);
            }];
            
            sizeL.numberOfLines = 0;
            
            sizeL.textColor = [UIColor colorWithHexString:@"555555"];
            sizeL.font = [UIFont systemFontOfSize:15];
            sizeL.text = self.colorArray[i];
            sizeL.textAlignment = NSTextAlignmentCenter;
            oneColorView.backgroundColor = [UIColor clearColor];
            
            
            [self.colorAndSizeView addSubview:oneColorView];
        }
        
        
        self.colorAndSizeHeight.constant = self.sizeArray.count *50 +(self.sizeArray.count - 1) * 1;
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (UITextField *textF in self.viewArray) {
           
                if (!kStringIsEmpty(textF.text)) {
                    [arrayM addObject:textF.text];
                }else{
                    return [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                  //  [arrayM addObject:@"0"];
                }

        }
        
        NSLog(@"arrayM = %@",arrayM);
        
        if (self.textArrayBlock) {
            self.textArrayBlock(arrayM);
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
   // if (self.textField == textField) {
        for (NSInteger i = 0; i < self.viewArray.count; i++) {
            if (textField.tag != i) {
                UITextField *textFilrdView = self.viewArray[i];
                if ([textField.text isEqualToString:textFilrdView.text]) {
                    textField.text = nil;
                    textField.placeholder = @"输入扫描条码";
                return [SVTool TextButtonAction:self.view withSing:@"条码重复或已存在，请重新编辑"];
                }
            }


    }
    
    
}


- (void)saoBtnClick:(UIButton *)btn{
    UITextField *textFilrd = self.viewArray[btn.tag];
    
    
//    self.hidesBottomBarWhenPushed = YES;
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//        textFilrd.text = name;
//
//    };
    
   // __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        textFilrd.text = resultStr;
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
    //   [self.navigationController pushViewController:vc animated:YES];
    
    //设置点击时的背影色
  //  [self.oneCell.scanButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  [self.oneCell.scanButton setBackgroundColor:[UIColor clearColor]];
        
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
