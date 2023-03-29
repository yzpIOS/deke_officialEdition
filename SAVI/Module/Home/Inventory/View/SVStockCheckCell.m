//
//  SVStockCheckCell.m
//  SAVI
//
//  Created by Sorgle on 2017/10/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVStockCheckCell.h"
#import "JJPhotoManeger.h"
@interface SVStockCheckCell () <UITextFieldDelegate,JJPhotoDelegate>

//图
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//原库存
@property (weak, nonatomic) IBOutlet UILabel *unitprice;
//单位
@property (weak, nonatomic) IBOutlet UILabel *unit;
//现库存
@property (weak, nonatomic) IBOutlet UILabel *existing;

@property (weak, nonatomic) IBOutlet UILabel *existingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;


@property (weak, nonatomic) IBOutlet UITextField *countText;
//-
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
//+
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end

@implementation SVStockCheckCell




-(void)setGoodsModel:(SVCheckGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    [self updateCell];
    
}

//重载layoutSubviews，对cell里面子控件frame进行设置
- (void)layoutSubviews {
    [super layoutSubviews];
    self.countText.delegate = self;
    [self updateCell];
    
}

- (void)updateCell {
    //图片
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    if (![SVTool isBlankString:_goodsModel.sv_p_images2]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:_goodsModel.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconView];
    self.iconView.userInteractionEnabled = YES;
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconView addGestureRecognizer:tap];
    
    //名称
    self.goodsName.text = _goodsModel.sv_p_name;
    //单位
    self.unit.text = _goodsModel.sv_p_unit;
    //规格
    self.sv_p_specs.text = _goodsModel.sv_p_specs;
    
    //库存
    self.unitprice.text = _goodsModel.sv_p_storage;
    
    //设置默认是隐藏的  //以下是滚动变化时数值的赋值
//    if (_goodsModel.product_number == 0 && self.checkCellBool == YES) {
    if (self.checkCellBool == YES) {
        [self hiddenYES];
    } else {
        [self hiddenNO];
    }
    self.countText.text = [NSString stringWithFormat:@"%ld",(long)_goodsModel.product_num];
    //现库存
    self.existing.text = [NSString stringWithFormat:@"%ld",(long)_goodsModel.product_num];
    
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
//    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

//点击减按钮的响应
- (IBAction)countReduce:(UIButton *)sender {
    
    //先赋值，后判断
    self.goodsModel.product_num --;
    
    [self blockMethods];
}

//点击加按钮的响应
- (IBAction)countAdd:(UIButton *)sender {
    
    //先判断，后赋值
    if (self.reduceButton.hidden == YES) {
        [self hiddenNO];
        //选中了，就开始回调。因为盘点是要一个盘点记录数据
        [self blockMethods];
        return;
    }
    
    self.goodsModel.product_num ++;
    
    [self blockMethods];
}

//UITextField的变化
- (IBAction)countTextAdd:(UITextField *)sender {
    
    self.goodsModel.product_num = [sender.text floatValue];
    [self blockMethods];
    
}

/**
 调用block
 */
-(void)blockMethods{
    
    if (self. inventoryChangeBlock) {
        self.inventoryChangeBlock(self.goodsModel,self.indexPatch);
    }
    
    //以下是点击变化时数值的赋值
    self.countText.text = [NSString stringWithFormat:@"%ld", (long)self.goodsModel.product_num];
    //现库存
    self.existing.text = [NSString stringWithFormat:@"%ld",(long)_goodsModel.product_num];
}
/**
 YES隐藏的方法
 */
-(void)hiddenYES{
    self.existingLabel.hidden = YES;
    self.existing.hidden = YES;
    self.reduceButton.hidden = YES;
    self.countText.hidden = YES;
    [self.addButton setImage:[UIImage imageNamed:@"icon_inventory"] forState:UIControlStateNormal];
}

/**
 NO隐藏的方法
 */
-(void)hiddenNO{
    self.existingLabel.hidden = NO;
    self.existing.hidden = NO;
    self.reduceButton.hidden = NO;
    self.countText.hidden = NO;
    [self.addButton setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.countText]) {
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
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 6) {
                    
                    if ([string isEqualToString:@"."] && range.location == 6) {
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
    
    return YES;
}




@end
