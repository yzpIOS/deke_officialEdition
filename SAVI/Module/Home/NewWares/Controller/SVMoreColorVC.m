//
//  SVMoreColorVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/19.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVMoreColorVC.h"
//#import "JFTagListView.h"
#import "UIViewController+YCPopover.h"
#import "SVAddMoreColorVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "ZYInputAlertView.h"

//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width)

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
@interface SVMoreColorVC ()
//@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSMutableArray   *tagArray;    //Tag数组
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic,assign) NSInteger indexTag;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic,strong) NSMutableArray *selectColorArray;
//@property (assign, nonatomic) TagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）
@end

@implementation SVMoreColorVC

- (NSMutableArray *)selectColorArray{
    if (_selectColorArray == nil) {
        _selectColorArray = [NSMutableArray array];
    }
    
    return _selectColorArray;
}

- (NSMutableArray *)tagArray{
    if (_tagArray == nil) {
        _tagArray = [NSMutableArray array];
    }
    
    return _tagArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    NSMutableArray *array = [NSMutableArray array];
    array = [NSMutableArray arrayWithObjects:@"白色",@"灰色",@"黑色",@"红色",@"黄色",@"蓝色",@"绿色",@"紫色",@"棕色",@"花色",@"橙色",@"金色",@"银色",@"肤色",@"透明色",@"青绿色",@"草绿色",@"墨绿色",@"藏青色",@"大红色",@"桃红色",@"粉红色",@"豆沙粉",@"香芋紫",@"玫红色",@"淡黄色",@"柠檬黄", nil];
    for (NSString *str in self.colorArray) {

        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([str containsString:obj]) {
                     
                
            }else{
                *stop = YES;
                
                if (*stop == YES) {
                
                [array addObject:str];
                
            }
 
            }
        }];
        
        }
    
   
    for (NSString *str in array) {
        if (![self.tagArray containsObject:str]) {
            [self.tagArray addObject:str];
        }
    }
    

    [self.tagArray addObject:@"新增颜色"];
        [self createUI];
    
    
}

- (IBAction)cancle:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUI
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH /5 *3 -136);
    [self.colorView addSubview:scrollView];
    
    CGFloat tagBtnX = 16;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<self.tagArray.count; i++) {
        
        CGSize tagTextSize = [self.tagArray[i] sizeWithFont:GlobalFont(15) maxSize:CGSizeMake(Width-32-32, 30)];
        if (tagBtnX+tagTextSize.width+30 > Width-32) {
            
            tagBtnX = 16;
            tagBtnY += 30+15;
        }
        
        if (i == self.tagArray.count - 1) {
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
            [tagBtn setTitle:self.tagArray[i] forState:UIControlStateNormal];
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
            //虚线的间隔
            border.lineDashPattern = @[@4, @2];
            
            tagBtn.layer.cornerRadius = 5.f;
            tagBtn.layer.masksToBounds = YES;
            
            [tagBtn.layer addSublayer:border];
       
            
            [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        }else{
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
            [tagBtn setTitle:self.tagArray[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = GlobalFont(15);
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:tagBtn];
         
            if (!kArrayIsEmpty(self.colorArray)) {
                for (NSString *str in self.colorArray) {
                    
                    if ([str isEqualToString:self.tagArray[i]]) {
                        [self tagBtnClick:tagBtn];
                    }
                }
            }
          
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        }
       scrollView.contentSize = CGSizeMake(self.colorView.frame.size.width,tagBtnY + 30);
    }
}

- (void)tagBtnClick:(UIButton *)btn
{
    if (self.editInterface == 1) {
        self.indexTag = btn.tag;
        if (self.indexTag == self.tagArray.count - 1) {
            [self showAddTagView];
        }else{
            btn.selected = !btn.selected;
            for (NSString *str in self.colorArray) {
                
                for (NSString *firstStr in self.firstColorArray) {
                    if ([str isEqualToString:firstStr]) {
                        if ([firstStr isEqualToString:self.tagArray[self.indexTag]]) {
                            btn.userInteractionEnabled = NO;
                            [btn setBackgroundColor:[UIColor orangeColor]];
                            btn.layer.borderColor = [UIColor clearColor].CGColor;
                            [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                        }else{
                            
                            if (btn.selected){
                                [btn setBackgroundColor:[UIColor orangeColor]];
                                btn.layer.borderColor = [UIColor clearColor].CGColor;
                                [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                            }
                            
                            if (!btn.selected){
                                btn.layer.borderColor = [UIColor grayColor].CGColor;
                                [btn setBackgroundColor:[UIColor clearColor]];
                                [self.selectColorArray removeObject:self.tagArray[self.indexTag]];
                            }
                            
                        }
                    }else{
                        if (btn.selected){
                            [btn setBackgroundColor:[UIColor orangeColor]];
                            btn.layer.borderColor = [UIColor clearColor].CGColor;
                            [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                        }
                        
                        if (!btn.selected){
                            btn.layer.borderColor = [UIColor grayColor].CGColor;
                            [btn setBackgroundColor:[UIColor clearColor]];
                            [self.selectColorArray removeObject:self.tagArray[self.indexTag]];
                        }
                    }
                    
                }
                
            }
            
        }
    }else{
        self.indexTag = btn.tag;
        if (self.indexTag == self.tagArray.count - 1) {
            [self showAddTagView];
        }else{
            btn.selected = !btn.selected;
            
            if (kArrayIsEmpty(self.colorArray)) {
                if (btn.selected){
                    [btn setBackgroundColor:[UIColor orangeColor]];
                    btn.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                }
                if (!btn.selected){
                    btn.layer.borderColor = [UIColor grayColor].CGColor;
                    [btn setBackgroundColor:[UIColor clearColor]];
                    [self.selectColorArray removeObject:self.tagArray[self.indexTag]];
                }
            }else{
                for (NSString *str in self.colorArray) {
                    for (NSString *tagStr in self.tagArray) {
                        if ([str isEqualToString:tagStr]) {
                            [btn setBackgroundColor:[UIColor orangeColor]];
                            btn.layer.borderColor = [UIColor clearColor].CGColor;
                            [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                        }else{
                            if (btn.selected){
                                [btn setBackgroundColor:[UIColor orangeColor]];
                                btn.layer.borderColor = [UIColor clearColor].CGColor;
                                
                                [self.selectColorArray addObject:self.tagArray[self.indexTag]];
                            }
                            if (!btn.selected){
                                btn.layer.borderColor = [UIColor grayColor].CGColor;
                                [btn setBackgroundColor:[UIColor clearColor]];
                                [self.selectColorArray removeObject:self.tagArray[self.indexTag]];
                            }
                        }
                    }

                }

            }

        }
    }
  
    NSLog(@"_selectColorArray = %@",_selectColorArray);
    
}

//进入添加标签界面
-(void)showAddTagView{

    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = navigationBackgroundColor;
    // alertView.inputTextView.text = @"输入开心的事儿···";
    alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
    alertView.colorLabel.text = @"新增颜色";
    alertView.placeholder = @"输入颜色";
    alertView.textfieldStrBlock = ^(NSString *str) {
       
        NSString *result;
        if ([str containsString:@"，"]) {
          
            return [SVTool TextButtonAction:self.view withSing:@"不能输入逗号"];
         
           
        }else if ([str containsString:@","]){
         
            return [SVTool TextButtonAction:self.view withSing:@"不能输入逗号"];
           
        
        }else{
            result = str;
            [weakSelf.selectColorArray removeAllObjects];
            [weakSelf.tagArray removeObjectAtIndex:weakSelf.tagArray.count - 1];
            [weakSelf.tagArray addObject:result];
            
            [weakSelf.tagArray addObject:@"新增颜色"];
            [[weakSelf.colorView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf createUI];
        }
        
       
    };
    
    [alertView show];
}

- (IBAction)sureClick:(id)sender {
//    if (self.colorArrayBlock) {
//        NSMutableArray *dataArray = [NSMutableArray array];
//        for (NSString *str in self.selectColorArray) {
//            if (![dataArray containsObject:str]) {
//                [dataArray addObject:str];
//            }
//        }
//        self.colorArrayBlock(dataArray);
//    }
//
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(colorArrayClick:)]) {
        NSMutableArray *dataArray = [NSMutableArray array];
            for (NSString *str in self.selectColorArray) {
                    if (![dataArray containsObject:str]) {
                        [dataArray addObject:str];
                    }
            }
        
        NSLog(@"dataArray9999999 = %@",dataArray);
        
        [self.delegate colorArrayClick:dataArray];
        
        }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
