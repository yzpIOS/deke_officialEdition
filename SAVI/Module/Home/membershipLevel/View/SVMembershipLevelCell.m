//
//  SVMembershipLevelCell.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/23.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVMembershipLevelCell.h"


@interface SVMembershipLevelCell()
//@property(nonatomic,strong)UIView* baseView;
//@property(nonatomic,strong)UIImageView* img;
//@property(nonatomic,strong)UILabel* nameLbl;
//@property(nonatomic,strong)UILabel* peopleNumLbl;


@property (weak, nonatomic) IBOutlet UIImageView *img;


@property (nonatomic,strong) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *peopleNumLbl;

@property (weak, nonatomic) IBOutlet UILabel *menberDicountLbl;
@property (weak, nonatomic) IBOutlet UILabel *integralRangeLbl;


@end
@implementation SVMembershipLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _img.layer.cornerRadius = 10.0f;
    _img.layer.masksToBounds = YES;
    self.imageArray = [NSArray arrayWithObjects:@"membershipLevel_bg_one",@"membershipLevel_bg_two",
                       @"membershipLevel_bg_three",@"membershipLevel_bg_four",nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setData:(SVMembershipLevelList *)data
{
    _data = data;

    _img.image = [JWXUtils imageCompressForSize:[UIImage imageNamed:self.imageArray[data.indexNum]] targetSize:CGSizeMake(ScreenW - 20, 130)];
//    _img.layer.cornerRadius = 20.0f;
//    _img.layer.masksToBounds = YES;
  //  _img.image = [UIImage imageNamed:self.imageArray[data.indexNum]];

    _nameLbl.text = data.sv_ml_name;
    [_nameLbl sizeToFit];
    _peopleNumLbl.text = [NSString stringWithFormat:@"%ld人",(long)data.count];
    [_peopleNumLbl sizeToFit];
    _menberDicountLbl.text = [NSString stringWithFormat:@"会员折扣：%.2f",data.sv_ml_commondiscount];
    [_menberDicountLbl sizeToFit];
    _integralRangeLbl.text = [NSString stringWithFormat:@"积分范围  %ld-%ld",(long)data.sv_ml_initpoint,(long)data.sv_ml_endpoint];
    [_integralRangeLbl sizeToFit];
    
    
  //  [self layoutSubviews];
}

- (void)setFrame:(CGRect)frame{
  //  frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
  //  frame.size.width -= 20;
    [super setFrame:frame];
}


//-(UIImage *)imageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
//}

@end
