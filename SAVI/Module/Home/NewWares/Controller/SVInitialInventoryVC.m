//
//  SVInitialInventoryVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/29.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInitialInventoryVC.h"
#import "SVDetailAttrilistModel.h"
#import "ZYInputAlertView.h"
#import "SVduoguigeModel.h"

@interface SVInitialInventoryVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inventoryViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *inventoryView;
@property (nonatomic,strong) NSMutableArray *viewArray;

////遮盖view
//@property (nonatomic,strong) UIView * maskTheView;

@end

@implementation SVInitialInventoryVC
- (NSMutableArray *)arraydataResult2{
    if (!_arraydataResult2) {
        _arraydataResult2 = [NSMutableArray array];
    }
    
    return _arraydataResult2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"初始库存";
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
   self.view.backgroundColor = BackgroundColor;
    //右上角按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"批量输入" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self loadInvitalInventory];
}

- (IBAction)sureClick:(id)sender {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (UITextField *textF in self.viewArray) {
        if (!kStringIsEmpty(textF.text)) {
            [arrayM addObject:textF.text];
        }else{
            [arrayM addObject:@"0"];
        }
      
    }
    
    NSLog(@"arrayM = %@",arrayM);
    
    if (self.stockBlock) {
        self.stockBlock(arrayM);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)selectbuttonResponseEvent{
    if (self.editInterface == 1) {
        ZYInputAlertView *alertView = [ZYInputAlertView alertView];
        alertView.confirmBgColor = navigationBackgroundColor;
        // alertView.inputTextView.text = @"输入开心的事儿···";
        alertView.colorLabel.text = @"批量输入";
        alertView.placeholder = @"输入库存数";
        // SVDetailAttrilistModel *modelTwo = self.generalSizeArray[self.indexSelect];
        //  alertView.inputTextView.text = modelTwo.attri_name;
        [alertView show];
        
        alertView.textfieldStrBlock = ^(NSString *str) {
//            for (NSInteger i = 0; i < self.viewArray.count; i++) {
//
//                if (kStringIsEmpty(self.sizeArray[i])) {
//
//                    UITextField *textField = self.viewArray[i];
//                    textField.textAlignment = NSTextAlignmentCenter;
//                    textField.text = str;
//                }
//
//            }
            for (NSInteger i = 0; i < self.arraydataResult2.count; i++) {
                     // SVDetailAttrilistModel *model = self.sizeArray[i];
                if ([self.arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                    UITextField *textField = self.viewArray[i];
                    textField.textAlignment = NSTextAlignmentCenter;
                    textField.text = str;
                }
            }
        };
    }else{
        ZYInputAlertView *alertView = [ZYInputAlertView alertView];
        alertView.confirmBgColor = navigationBackgroundColor;
        // alertView.inputTextView.text = @"输入开心的事儿···";
        alertView.colorLabel.text = @"批量输入";
        alertView.placeholder = @"输入库存数";
        // SVDetailAttrilistModel *modelTwo = self.generalSizeArray[self.indexSelect];
        //  alertView.inputTextView.text = modelTwo.attri_name;
        [alertView show];
        
        alertView.textfieldStrBlock = ^(NSString *str) {
            for (NSInteger i = 0; i < self.viewArray.count; i++) {
                UITextField *textField = self.viewArray[i];
                textField.text = str;
            }
        };
    }
}

- (void)loadInvitalInventory{
    if (self.editInterface == 1) {
        CGFloat maxY = 0;
        for (NSInteger i = 0; i < self.arraydataResult2.count; i++) {
           // SVDetailAttrilistModel *model = self.sizeArray[i];
            if ([self.arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = self.arraydataResult2[i];
                UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                                          // self.colorView = colorView;
                [self.inventoryView addSubview:colorView];
                
                // 库存数
                //        UILabel *sizeL = [[UILabel alloc] init];
                UITextField *textField = [[UITextField alloc] init];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.tag = i;
                textField.delegate = self;
                [colorView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(colorView.mas_right).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                // textField.placeholder = @"输入库存数";
                //                if (kStringIsEmpty(self.sizeArray[i])) {
                //                    textField.userInteractionEnabled = YES;
                //                    textField.placeholder = @"请输入库存";
                //
                //                }else{
//                textField.userInteractionEnabled = NO;
//                textField.text = duoguigeModel.sv_p_storage;
                // }
                textField.userInteractionEnabled = YES;
                textField.placeholder = @"请输入库存";
                textField.textAlignment = NSTextAlignmentCenter;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.textColor = [UIColor colorWithHexString:@"555555"];
                textField.font = [UIFont systemFontOfSize:15];
                [self.viewArray addObject:textField];
                
                // 尺寸
                UILabel *sizeL = [[UILabel alloc] init];
                [colorView addSubview:sizeL];
                [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                    // make.right.mas_equalTo(textField.mas_left).offset(-30);
                    make.centerX.mas_equalTo(colorView.mas_centerX);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                sizeL.numberOfLines = 0;
                
                sizeL.textColor = [UIColor colorWithHexString:@"555555"];
                sizeL.font = [UIFont systemFontOfSize:15];
                sizeL.text = dict[@"sizeStr"];
                sizeL.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];
                
                // 颜色
                UILabel *color = [[UILabel alloc] init];
                [colorView addSubview:color];
                [color mas_makeConstraints:^(MASConstraintMaker *make) {
                    //  make.top.mas_equalTo(colorView.mas_top).offset(16);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                    make.left.mas_offset(20);
                }];
                
                color.numberOfLines = 0;
                
                color.textColor = [UIColor colorWithHexString:@"555555"];
                color.font = [UIFont systemFontOfSize:15];
                color.text = dict[@"color"];
                color.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];
                
                
                maxY = CGRectGetMaxY(colorView.frame)+1;
            }else{
                
                SVduoguigeModel *duoguigeModel = self.arraydataResult2[i];
                SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                // self.spec_name_two = specModel2.spec_name;
                // 颜色的
                SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                
                UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                          // self.colorView = colorView;
                [self.inventoryView addSubview:colorView];
                
                // 库存数
                //        UILabel *sizeL = [[UILabel alloc] init];
                UITextField *textField = [[UITextField alloc] init];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.tag = i;
                textField.delegate = self;
                [colorView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(colorView.mas_right).offset(-20);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                // textField.placeholder = @"输入库存数";
//                if (kStringIsEmpty(self.sizeArray[i])) {
//                    textField.userInteractionEnabled = YES;
//                    textField.placeholder = @"请输入库存";
//
//                }else{
                    textField.userInteractionEnabled = NO;
                textField.text = duoguigeModel.sv_p_storage;
               // }
                
                textField.textAlignment = NSTextAlignmentCenter;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.textColor = [UIColor colorWithHexString:@"555555"];
                textField.font = [UIFont systemFontOfSize:15];
                [self.viewArray addObject:textField];
                
                // 尺寸
                UILabel *sizeL = [[UILabel alloc] init];
                [colorView addSubview:sizeL];
                [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
                    // make.right.mas_equalTo(textField.mas_left).offset(-30);
                    make.centerX.mas_equalTo(colorView.mas_centerX);
                    make.centerY.mas_equalTo(colorView.mas_centerY);
                }];
                
                sizeL.numberOfLines = 0;
                
                sizeL.textColor = [UIColor colorWithHexString:@"555555"];
                sizeL.font = [UIFont systemFontOfSize:15];
                sizeL.text = atteilistModel2.attri_name;
                sizeL.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];
                
                // 颜色
                UILabel *color = [[UILabel alloc] init];
                [colorView addSubview:color];
                [color mas_makeConstraints:^(MASConstraintMaker *make) {
                   //  make.top.mas_equalTo(colorView.mas_top).offset(16);
                     make.centerY.mas_equalTo(colorView.mas_centerY);
                    make.left.mas_offset(20);
                }];
                
                color.numberOfLines = 0;
                
                color.textColor = [UIColor colorWithHexString:@"555555"];
                color.font = [UIFont systemFontOfSize:15];
                color.text = attriModel.attri_name;
                color.textAlignment = NSTextAlignmentCenter;
                colorView.backgroundColor = [UIColor whiteColor];
                
                
                maxY = CGRectGetMaxY(colorView.frame)+1;
            }

        }
        
//        CGFloat maxColorY = 0;
//        for (NSInteger i = 0; i < self.colorArray.count; i++) {
//
//            UIView *oneColorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxColorY, 100, 50)];
//            oneColorView.backgroundColor = [UIColor yellowColor];
//            maxColorY = CGRectGetMaxY(oneColorView.frame)+1;
//
//            // 尺寸
//            UILabel *sizeL = [[UILabel alloc] init];
//            [oneColorView addSubview:sizeL];
//            [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(oneColorView.mas_top).offset(16);
//                make.centerX.mas_equalTo(oneColorView.mas_centerX);
//            }];
//
//            sizeL.numberOfLines = 0;
//
//            sizeL.textColor = [UIColor colorWithHexString:@"555555"];
//            sizeL.font = [UIFont systemFontOfSize:15];
//            sizeL.text = self.colorArray[i];
//            sizeL.textAlignment = NSTextAlignmentCenter;
//            oneColorView.backgroundColor = [UIColor clearColor];
//
//            maxColorY = CGRectGetMaxY(oneColorView.frame)+1;
//            [self.inventoryView addSubview:oneColorView];
//        }
//
        
//        self.colorAndSizeHeight.constant = self.sizeArray.count *50 +(self.sizeArray.count - 1) * 1;
        
        
        self.inventoryViewHeight.constant = self.arraydataResult2.count *50 +(self.arraydataResult2.count - 1) * 1;
        
//        for (int i = 0; i < self.arraydataResult2.count; i++) {
//            if ([self.arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
//
//            }else{
//
//            }
//        }
        
    }else{
        CGFloat maxY = 0;
        for (NSInteger i = 0; i < self.sizeArray.count; i++) {
            SVDetailAttrilistModel *model = self.sizeArray[i];
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
            // self.colorView = colorView;
            [self.inventoryView addSubview:colorView];
            
            // 库存数
            //        UILabel *sizeL = [[UILabel alloc] init];
            UITextField *textField = [[UITextField alloc] init];
            textField.tag = i;
            textField.delegate = self;
            [colorView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(colorView.mas_right).offset(-20);
                make.centerY.mas_equalTo(colorView.mas_centerY);
            }];
            textField.placeholder = @"输入库存数";
            textField.textAlignment = NSTextAlignmentCenter;
            textField.textColor = [UIColor colorWithHexString:@"555555"];
            textField.font = [UIFont systemFontOfSize:15];
            [self.viewArray addObject:textField];
            
            // 尺寸
            UILabel *sizeL = [[UILabel alloc] init];
            [colorView addSubview:sizeL];
            [sizeL mas_makeConstraints:^(MASConstraintMaker *make) {
             //  make.right.mas_equalTo(textField.mas_left).offset(-30);
              //  make.centerX.mas_equalTo(colorView.mas_centerX);
                make.centerX.mas_equalTo(colorView.mas_centerX);
                make.centerY.mas_equalTo(colorView.mas_centerY);
            //    make.center.mas_equalTo(colorView.center);
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
            
            
            [self.inventoryView addSubview:oneColorView];
        }
        
        
        self.inventoryViewHeight.constant = self.sizeArray.count *50 +(self.sizeArray.count - 1) * 1;
    }
}


- (NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    
    return _viewArray;
}
@end
