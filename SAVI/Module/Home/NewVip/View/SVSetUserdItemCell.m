//
//  SVSetUserdItemCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/13.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSetUserdItemCell.h"

@interface SVSetUserdItemCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (nonatomic,strong) NSMutableArray *selectArray;


@end
@implementation SVSetUserdItemCell
- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectBtn.layer.cornerRadius = 10;
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.layer.borderColor = GreyFontColor.CGColor;
    self.selectBtn.layer.borderWidth = 1;
    
//    [self.selectBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//     [self.selectBtn setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
}

//- (void)setName:(NSString *)name
//{
//    _name = name;
//    [self.selectBtn setTitle:name forState:UIControlStateNormal];
//}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [self.selectBtn setTitle:dict[@"sv_field_name"] forState:UIControlStateNormal];
}

- (IBAction)selectClick:(UIButton *)button {
    
//    [self.selectBtn setBackgroundImage:[self imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    button.selected = !button.selected;
    if (button.selected) {

        
        if (self.selectCountBlock) {
            self.selectCountBlock(button.titleLabel.text, self.indexPath);
        }
        
        self.removeBtn.hidden = YES;
        
    }else{
//         NSLog(@"普通状态:index = %ld",self.indexPath.row);
//        NSLog(@"普通状态：%@",button.titleLabel.text);
////        for (NSString *str in self.selectArray) {
////            if ([str isEqualToString: button.titleLabel.text]) {
////                [self.selectArray removeObject:str];
////                break;
////            }
////        }
        
//        if (self.selectCountBlock) {
//            self.selectCountBlock(button.titleLabel.text, self.indexPath);
//        }
        if (self.removeCountBlock) {
            self.removeCountBlock(button.titleLabel.text, self.indexPath);
        }
        
        self.removeBtn.hidden = NO;
    }
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 点击删除按钮
- (IBAction)removeClick:(id)sender {
    if (self.countBlock) {
        self.countBlock(self.indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
