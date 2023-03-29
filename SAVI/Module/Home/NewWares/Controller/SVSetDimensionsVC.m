//
//  SVSetDimensionsVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/21.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVSetDimensionsVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVAttrilistModel.h"
#import "SVDetailAttrilistModel.h"
#import "SVAddMoreColorVC.h"
#import "UIViewController+YCPopover.h"
#import "SVDetailAttrilistModel.h"
#import "SVediteAndColorView.h"
#import "ZYInputAlertView.h"
#import "SVColorOneModel.h"
#import "SVSizeTwoModel.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
#define num ScreenH /6 *5
@interface SVSetDimensionsVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeTypeHeight;
@property (weak, nonatomic) IBOutlet UIView *sizeTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *generalSizeHeight;
@property (weak, nonatomic) IBOutlet UIView *generalSizeView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//@property (weak, nonatomic) IBOutlet UIView *sizeTypeView;
//@property (weak, nonatomic) IBOutlet UIView *generalSizeView;
//@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong) NSMutableArray *sizeTypeArray;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) NSMutableArray *generalSizeArray;

@property (nonatomic,strong) NSMutableArray *listArray;
//@property (nonatomic,strong) UIScrollView *scrollView;
//// 尺码类型
@property (nonatomic,strong) NSString *groupname;
@property (nonatomic,strong) SVAttrilistModel *attrilistModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneHeight;
@property (weak, nonatomic) IBOutlet UIView *generalViewTwo;

@property (nonatomic,strong) SVediteAndColorView *editeAndColorView;
@property (nonatomic,strong) SVDetailAttrilistModel *detaiModel;
@property (nonatomic,assign) NSInteger indexSelect;
@property (nonatomic,strong) SVColorOneModel *oneModel;
@property (nonatomic,strong) SVSizeTwoModel *twoModel;
@property (nonatomic,strong) NSString *spec_name;
@property (nonatomic,assign) NSInteger chimaIndex;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@end

@implementation SVSetDimensionsVC

- (void)viewDidLoad {
    [super viewDidLoad];


     [self loadData];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"设置尺码";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"设置尺码";
   self.view.backgroundColor = BackgroundColor;

    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    //  generalSizeArray
    NSLog(@"self.selecIndex = %ld",self.selectIndex);
    [self crategeneralSize];
}

- (void)loadBtn{
    NSMutableArray *array = self.selectColorArray;
    //   [self.generalSizeArray addObjectsFromArray:self.selectColorArray];
    if (!kArrayIsEmpty(array)) {
        CGFloat tagBtnX = 20;
        CGFloat tagBtnY = 0;
        
        for (NSInteger i = 0; i < array.count; i++) {
            
            SVDetailAttrilistModel *model = array[i];
            CGSize tagTextSize = [model.attri_name sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(Width-32-32, 35)];
            if (tagBtnX+tagTextSize.width+30 > Width-32) {
                
                tagBtnX = 20;
                tagBtnY += 35+15;
            }
            
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            tagBtn.tag = model.indexTag;
            
            //            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 35);
            [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = GlobalFont(15);
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [tagBtn addTarget:self action:@selector(generalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self generalBtnClick:tagBtn];
            
            [self.generalViewTwo addSubview:tagBtn];
        }
        
    }
}

- (void)loadData{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetSpecification?industrytype=%@&key=%@",[SVUserManager shareInstance].sv_uit_cache_id,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict8888 = %@",dict);
        SVColorOneModel *oneModel = [SVColorOneModel mj_objectWithKeyValues:dict[@"values"][0]];
        self.oneModel = oneModel;
        NSMutableDictionary *dict2 = dict[@"values"][1];
        NSLog(@"spec_name = %@",dict2[@"spec_name"]);
        
        SVSizeTwoModel *twoModel = [SVSizeTwoModel mj_objectWithKeyValues:dict[@"values"][1]];
        
        self.twoModel = twoModel;
        NSLog(@"spec_name = %@",self.twoModel.spec_name);
        self.spec_name = dict2[@"spec_name"];
        //   self.twoModel.spec_name = dict2[@"spec_name"];
        //   NSArray *dicArray = [SVAttrilistModel mj_objectArrayWithKeyValuesArray:dict2[@"grouplist"]];
        // NSMutableArray *listArray = [NSMutableArray array];
        self.listArray =  [NSMutableArray array];
        NSArray*dicArray = dict2[@"grouplist"];
        if (self.editInterface == 1) {
            //            for (NSDictionary *dic in dicArray) {
            //                SVAttrilistModel *model = [SVAttrilistModel mj_objectWithKeyValues:dic];
            //                [self.listArray addObject:model];
            //                if ([self.attri_group isEqualToString:model.groupname]) {
            //                    [self.sizeTypeArray addObject:model.groupname];
            //                }
            //
            //            }
            
            for (NSInteger i = 0; i < dicArray.count; i++) {
                NSDictionary *dic = dicArray[i];
                SVAttrilistModel *model = [SVAttrilistModel mj_objectWithKeyValues:dic];
                [self.listArray addObject:model];
                if ([self.attri_group isEqualToString:model.groupname]) {
                    self.chimaIndex = i;
                    [self.sizeTypeArray addObject:model.groupname];
                }
            }
            
            
        }else{
            for (NSDictionary *dic in dicArray) {
                SVAttrilistModel *model = [SVAttrilistModel mj_objectWithKeyValues:dic];
                [self.listArray addObject:model];
                [self.sizeTypeArray addObject:model.groupname];
            }
        }
        
        
        
        
        NSLog(@"listArray = %@",self.listArray);
        [self createSizeType];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 加载尺码类型的按钮
- (void)createSizeType{
    
    if (self.editInterface == 1) {
        CGFloat tagBtnX = 20;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.sizeTypeArray.count; i++) {
            
            CGSize tagTextSize = [self.sizeTypeArray[i] sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(Width-32-32, 35)];
            if (tagBtnX+tagTextSize.width+30 > Width-32) {
                
                tagBtnX = 20;
                tagBtnY += 35+15;
            }
            
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            // self.tagBtn = tagBtn;
            tagBtn.tag = self.chimaIndex;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 35);
            [tagBtn setTitle:self.sizeTypeArray[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = GlobalFont(15);
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [tagBtn addTarget:self action:@selector(sizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.sizeTypeView addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;

            [self sizeBtnClick:tagBtn];

            self.oneHeight.constant = tagBtnY + 35;
            self.sizeTypeHeight.constant = tagBtnY + 35 + 41 + 15;
        }
    }else{
        CGFloat tagBtnX = 20;
        CGFloat tagBtnY = 0;
        for (int i= 0; i<self.sizeTypeArray.count; i++) {
            
            CGSize tagTextSize = [self.sizeTypeArray[i] sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(Width-32-32, 35)];
            if (tagBtnX+tagTextSize.width+30 > Width-32) {
                
                tagBtnX = 20;
                tagBtnY += 35+15;
            }
            
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            // self.tagBtn = tagBtn;
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 35);
            [tagBtn setTitle:self.sizeTypeArray[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = GlobalFont(15);
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [tagBtn addTarget:self action:@selector(sizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.sizeTypeView addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            
            if (kStringIsEmpty(self.attri_group)) {
                if (i == 0) {
                    [self sizeBtnClick:tagBtn];
                }
            }else{
                if ([self.attri_group isEqualToString:self.sizeTypeArray[i]]) {
                    [self sizeBtnClick:tagBtn];
                }
            }
            
            
            self.oneHeight.constant = tagBtnY + 35;
            self.sizeTypeHeight.constant = tagBtnY + 35 + 41 + 15;
        }
    }
    
}
#pragma mark - 尺寸
- (void)crategeneralSize{
    CGFloat tagBtnX = 20;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<self.generalSizeArray.count; i++) {
        SVDetailAttrilistModel *model = self.generalSizeArray[i];
        model.indexTag = i;
        CGSize tagTextSize = [model.attri_name sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(Width-32-32, 35)];
        if (tagBtnX+tagTextSize.width+30 > Width-32) {
            
            tagBtnX = 20;
            tagBtnY += 35+15;
        }
        
        if (i == self.generalSizeArray.count - 1) {
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 35);
            [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
            [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            CAShapeLayer *border = [CAShapeLayer layer];
            
            //虚线的颜色
            border.strokeColor = [UIColor orangeColor].CGColor;
            //填充的颜色
            border.fillColor = [UIColor clearColor].CGColor;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
            
            //设置路径
            border.path = path.CGPath;
            
            border.frame = tagBtn.bounds;
            //虚线的宽度
            border.lineWidth = 1.f;
            
            //设置线条的样式
            //    border.lineCap = @"square";
            //虚线的间隔
            border.lineDashPattern = @[@4, @2];
            
            tagBtn.layer.cornerRadius = 5.f;
            tagBtn.layer.masksToBounds = YES;
            
            [tagBtn.layer addSublayer:border];
            
            
            [tagBtn addTarget:self action:@selector(generalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.generalViewTwo addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        }else{
            
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 35);
            [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = GlobalFont(15);
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [tagBtn addTarget:self action:@selector(generalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            for (SVDetailAttrilistModel *model in self.sizeTwoArray) {
                SVDetailAttrilistModel *model2 = self.generalSizeArray[i];
                if ([model.attri_name isEqualToString:model2.attri_name]) {
                    [self generalBtnClick:tagBtn];
                }
                //                if ([str isEqualToString:self.generalSizeArray[i]]) {
                //                    [self tagBtnClick:tagBtn];
                //                }
            }
            
            [SVUserManager loadUserInfo];
            SVDetailAttrilistModel *detaiModel = self.generalSizeArray[i];
            if (![SVTool isBlankString:[NSString stringWithFormat:@"%ld",detaiModel.attri_user_id]] &&  [SVUserManager shareInstance].user_id.integerValue == detaiModel.attri_user_id) {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
                longPress.minimumPressDuration = 0.5; //定义按的时间
                [tagBtn addGestureRecognizer:longPress];
                
            }else{
                
            }
            
            [self.generalViewTwo addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
        }
        //  self.twoHeight.constant = tagBtnY + 35;
        self.generalSizeHeight.constant = tagBtnY + 35 + 56;
        
        
    }
    
}

#pragma mark - 编辑删除
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.indexSelect = [gestureRecognizer view].tag;
        self.detaiModel = self.generalSizeArray[self.indexSelect];
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.editeAndColorView];
        //实现弹出方法
        [UIView animateWithDuration:.2 animations:^{
            self.editeAndColorView.frame = CGRectMake(0, num, ScreenW, ScreenH-num);
        }];
        
    }
}

#pragma mark - 点击尺码
- (void)sizeBtnClick:(UIButton *)btn{
    [self.generalViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.generalSizeArray removeAllObjects];
    [self.selectColorArray removeAllObjects];
    
    self.selectIndex = btn.tag;
    //  self.selectBtn = btn;
    // self.groupnameStr = self.sizeTypeArray[btn.tag];
    self.tagBtn.selected = NO;
    self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
    self.tagBtn.backgroundColor = [UIColor whiteColor];
    btn.selected = YES;
    btn.layer.borderColor = [[UIColor clearColor] CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setBackgroundColor:[UIColor orangeColor]];
    self.tagBtn = btn;
    SVAttrilistModel *attrilistModel = self.listArray[btn.tag];
    self.groupname = attrilistModel.groupname;
    self.attrilistModel = attrilistModel;
    self.generalSizeArray = [SVDetailAttrilistModel mj_objectArrayWithKeyValuesArray:attrilistModel.attrilist];
    SVDetailAttrilistModel *model = [[SVDetailAttrilistModel alloc] init];
    model.attri_name = @"新增尺码";
    //  groupname[NSMutableString stringWithString:str1];
    [self.generalSizeArray addObject:model];
    
    [self crategeneralSize];
}

#pragma mark - 点击尺寸
- (void)generalBtnClick:(UIButton *)btn{
    // self.indexTag = btn.tag;
    if (self.editInterface == 1) {
        if (btn.tag == self.generalSizeArray.count - 1) {
            [self showAddTagView];
        }else{
            btn.selected = !btn.selected;
            
            for (SVDetailAttrilistModel *model2 in self.sizeTwoArray) {
                
                for (NSString *firstStr in self.firstSizeArray) {
                    if ([model2.attri_name isEqualToString:firstStr]) {
                        SVDetailAttrilistModel *model = self.generalSizeArray[btn.tag];
                        if ([firstStr isEqualToString:model.attri_name]) {
                            [btn setBackgroundColor:[UIColor orangeColor]];
                            btn.layer.borderColor = [UIColor clearColor].CGColor;
                            [self.selectColorArray addObject:self.generalSizeArray[btn.tag]];
                            btn.userInteractionEnabled = NO;
                        }else{
                            
                            if (btn.selected){
                                [btn setBackgroundColor:[UIColor orangeColor]];
                                btn.layer.borderColor = [UIColor clearColor].CGColor;
                                [self.selectColorArray addObject:self.generalSizeArray[btn.tag]];
                            }
                            
                            if (!btn.selected){
                                btn.layer.borderColor = [UIColor grayColor].CGColor;
                                [btn setBackgroundColor:[UIColor clearColor]];
                                [self.selectColorArray removeObject:self.generalSizeArray[btn.tag]];
                            }
                            
                        }
                    }else{
                        if (btn.selected){
                            [btn setBackgroundColor:[UIColor orangeColor]];
                            btn.layer.borderColor = [UIColor clearColor].CGColor;
                            [self.selectColorArray addObject:self.generalSizeArray[btn.tag]];
                        }
                        
                        if (!btn.selected){
                            btn.layer.borderColor = [UIColor grayColor].CGColor;
                            [btn setBackgroundColor:[UIColor clearColor]];
                            [self.selectColorArray removeObject:self.generalSizeArray[btn.tag]];
                        }
                    }
                    
                }
                
            }
            
            
        }
    }else{
        if (btn.tag == self.generalSizeArray.count - 1) {
            [self showAddTagView];
        }else{
            btn.selected = !btn.selected;
            if (btn.selected){
                [btn setBackgroundColor:[UIColor orangeColor]];
                btn.layer.borderColor = [UIColor clearColor].CGColor;
                // [self.selectBtnArray addObject:btn];
                [self.selectColorArray addObject:self.generalSizeArray[btn.tag]];
            }
            if (!btn.selected){
                btn.layer.borderColor = [UIColor grayColor].CGColor;
                [btn setBackgroundColor:[UIColor clearColor]];
                // [self.selectBtnArray removeObject:btn];
                [self.selectColorArray removeObject:self.generalSizeArray[btn.tag]];
            }
        }
    }
}

#pragma mark - 确认按钮的点击
- (IBAction)sureClick:(id)sender {
    if (self.editInterface == 1) {
        if (self.selectArrayBlock) {
            NSLog(@"spec_name = %@",self.spec_name);
            //        self.selectArrayBlock(self.selectColorArray);
            NSMutableArray *dataArray = [NSMutableArray array];
            for (SVDetailAttrilistModel *model in self.selectColorArray) {
                if (![dataArray containsObject:model]) {
                    [dataArray addObject:model];
                }//self.groupname
            } self.selectArrayBlock(dataArray,self.selectIndex,self.oneModel,self.twoModel,self.spec_name);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (self.selectArrayBlock) {
            NSLog(@"spec_name = %@",self.spec_name);
            //        self.selectArrayBlock(self.selectColorArray);
            NSMutableArray *dataArray = [NSMutableArray array];
            for (SVDetailAttrilistModel *model in self.selectColorArray) {
                if (![dataArray containsObject:model]) {
                    [dataArray addObject:model];
                    NSLog(@"model.spec_id=%ld,model.attri_id=%ld,model.attri_name=%@,model.attri_group=%@",model.spec_id,model.attri_id,model.attri_name,model.attri_group);
                    
                }//
            } self.selectArrayBlock(dataArray,self.selectIndex,self.oneModel,self.twoModel,self.groupname);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - 新增尺码
-(void)showAddTagView{
    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = navigationBackgroundColor;
    // alertView.inputTextView.text = @"输入开心的事儿···";
    alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
    alertView.colorLabel.text = @"新增尺码";
    alertView.placeholder = @"输入尺码";
    alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
    [alertView confirmBtnClickBlock:^(SVDetailAttrilistModel *model) {
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/SaveSpecification?key=%@",[SVUserManager shareInstance].access_token];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"attri_id"] = @"0";
        parameter[@"attri_group"] = weakSelf.groupname;
        NSMutableArray *attArrayM = [SVDetailAttrilistModel mj_objectArrayWithKeyValuesArray:weakSelf.attrilistModel.attrilist];
        SVDetailAttrilistModel *model2 = attArrayM[0];
        parameter[@"spec_id"] = [NSString stringWithFormat:@"%ld",model2.spec_id];
        parameter[@"attri_name"] = model.attri_name;
        parameter[@"sv_remark"] = @"";
        parameter[@"is_custom"] = @"true";
        NSLog(@"parameter = %@",parameter);
        
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict新增 = %@",dict);
            if ([dict[@"succeed"] integerValue] == 1) {
                [weakSelf.selectColorArray removeAllObjects];
                [weakSelf.generalSizeArray removeObjectAtIndex:weakSelf.generalSizeArray.count - 1];
                model.attri_id = [dict[@"values"] integerValue];
                model.attri_user_id = [dict[@"user_id"] integerValue];
                model.spec_id = model2.spec_id;
                model.attri_group = weakSelf.groupname;
                model.sort = model2.sort;
                [weakSelf.generalSizeArray addObject:model];
                SVDetailAttrilistModel *modelTwo = [[SVDetailAttrilistModel alloc] init];
                modelTwo.attri_name = @"新增尺码";
                [[weakSelf.generalViewTwo subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [weakSelf.generalSizeArray addObject:modelTwo];
                [weakSelf crategeneralSize];
            }else{
                [SVTool TextButtonAction:weakSelf.view withSing:@"新增尺码失败"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:weakSelf.view withSing:@"网络开小差了"];
        }];
    }];
    [alertView show];
    
}

#pragma mark - 删除尺码
- (void)deleteGesClick{
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/DeleteAttr_new?attri_id=%ld&key=%@",self.detaiModel.attri_id,[SVUserManager shareInstance].access_token];
    
    NSLog(@"urlStr删除 = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict删除 = %@",dict);
        if ([dict[@"succeed"] integerValue] == 1) {
            [self.generalViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            // [self loadData];
            [self.generalSizeArray removeObjectAtIndex:self.indexSelect];
            [self crategeneralSize];
            [self handlePan];
        }else{
            [self handlePan];
            [SVTool TextButtonAction:self.view withSing:@"删除失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 编辑尺码
- (void)editGesClick{
    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = navigationBackgroundColor;
    // alertView.inputTextView.text = @"输入开心的事儿···";
    alertView.colorLabel.text = @"编辑尺码";
    //    alertView.placeholder = @"输入尺码";
    alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
    SVDetailAttrilistModel *modelTwo = self.generalSizeArray[self.indexSelect];
    alertView.inputTextView.text = modelTwo.attri_name;
    [alertView show];
    [self handlePan];
    
    [alertView confirmBtnClickBlock:^(SVDetailAttrilistModel *model) {
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/SaveSpecification?key=%@",[SVUserManager shareInstance].access_token];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"attri_id"] = [NSString stringWithFormat:@"%ld",modelTwo.attri_id];
        parameter[@"attri_group"] = weakSelf.groupname;
        NSMutableArray *attArrayM = [SVDetailAttrilistModel mj_objectArrayWithKeyValuesArray:weakSelf.attrilistModel.attrilist];
        SVDetailAttrilistModel *model2 = attArrayM[0];
        parameter[@"spec_id"] = [NSString stringWithFormat:@"%ld",model2.spec_id];
        parameter[@"attri_name"] = model.attri_name;
        parameter[@"sv_remark"] = @"";
        parameter[@"is_custom"] = @"true";
        NSLog(@"parameter = %@",parameter);
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict编辑 = %@",dict);
            
            if ([dict[@"succeed"] integerValue] == 1) {
                modelTwo.attri_name = alertView.inputTextView.text;
                modelTwo.attri_id = [dict[@"values"] integerValue];
                modelTwo.attri_user_id = [dict[@"user_id"] integerValue];
                [self.generalViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                // [self loadData];
                //  [self.generalSizeArray removeObjectAtIndex:self.indexSelect];
                [self.generalSizeArray replaceObjectAtIndex:self.indexSelect withObject:modelTwo];
                // [self.generalSizeArray insertObject:<#(nonnull id)#> atIndex:<#(NSUInteger)#>]
                [self crategeneralSize];
                
                [self handlePan];
            }else{
                [self handlePan];
                [SVTool TextButtonAction:self.view withSing:@"删除失败"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:weakSelf.view withSing:@"网络开小差了"];
        }];
        // self.inputTextView.text
        
    }];
    
}

- (SVediteAndColorView *)editeAndColorView
{
    if (!_editeAndColorView) {
        _editeAndColorView = [[NSBundle mainBundle] loadNibNamed:@"SVediteAndColorView" owner:nil options:nil].lastObject;
        _editeAndColorView.frame = CGRectMake(0, ScreenH, ScreenW, num);
        
        UITapGestureRecognizer *editGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGesClick)];
        [self.editeAndColorView.editView addGestureRecognizer:editGes];
        
        UITapGestureRecognizer *edeleteGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteGesClick)];
        [self.editeAndColorView.deleteView addGestureRecognizer:edeleteGes];
        
        
    }
    
    
    
    return _editeAndColorView;
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}

#pragma mark - 移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.2 animations:^{
        self.editeAndColorView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
    }];
    
}


- (NSMutableArray *)sizeTypeArray
{
    if (_sizeTypeArray == nil) {
        _sizeTypeArray = [NSMutableArray array];
    }
    
    return _sizeTypeArray;
}

- (NSMutableArray *)generalSizeArray
{
    if (_generalSizeArray == nil) {
        _generalSizeArray = [NSMutableArray array];
    }
    
    return _generalSizeArray;
}



- (NSMutableArray *)selectBtnArray{
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    
    return _selectBtnArray;
}

- (NSMutableArray *)selectColorArray{
    if (_selectColorArray == nil) {
        _selectColorArray = [NSMutableArray array];
    }
    
    return _selectColorArray;
}

@end
