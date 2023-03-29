//
//  SVmembershipLevelListCell.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/23.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVmembershipLevelListCell.h"

@interface SVmembershipLevelListCell()
@property (nonatomic,strong) NSArray *imageArray;
@end
@implementation SVmembershipLevelListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageArray = [NSArray arrayWithObjects:@"membershipLevel_bg_one",@"membershipLevel_bg_two",
                       @"membershipLevel_bg_three",@"membershipLevel_bg_four",nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
      //  self.backgroundColor = ColorUtil(@"F0EFF0");
        
        
        _baseView = [[UIView alloc]init];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        _img = [[UIImageView alloc]init];
        [_baseView addSubview:_img];
        
        _nameLbl =[[UILabel alloc]init];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        _nameLbl.textColor = [UIColor whiteColor];
        [_baseView addSubview:_nameLbl];
        
        _peopleNumLbl =[[UILabel alloc]init];
        _peopleNumLbl.textAlignment = NSTextAlignmentLeft;
        _peopleNumLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        _peopleNumLbl.textColor = [UIColor whiteColor];
        [_baseView addSubview:_peopleNumLbl];
        
        _menberDicountLbl =[[UILabel alloc]init];
        _menberDicountLbl.textAlignment = NSTextAlignmentLeft;
        _menberDicountLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        _menberDicountLbl.textColor = [UIColor whiteColor];
        [_baseView addSubview:_menberDicountLbl];
        
        _integralRangeLbl =[[UILabel alloc]init];
        _integralRangeLbl.textAlignment = NSTextAlignmentLeft;
        _integralRangeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        _integralRangeLbl.textColor = [UIColor whiteColor];
        _integralRangeLbl.numberOfLines = 0;
        [_baseView addSubview:_integralRangeLbl];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    _baseView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    _img.sd_layout
    .leftSpaceToView(_baseView, 0)
    .topSpaceToView(_baseView, 0)
    .rightSpaceToView(_baseView, 0)
    .bottomSpaceToView(_baseView, 0);
    
    _nameLbl.sd_layout
    .topSpaceToView(_baseView, 10)
    .leftSpaceToView(_baseView, 10)
    .rightSpaceToView(_baseView, 10)
    .autoHeightRatio(0);
    //.minHeightIs(H(19));
    
    _peopleNumLbl.sd_layout
    .topSpaceToView(_nameLbl,10)
    .leftSpaceToView(_baseView, 10)
    .rightSpaceToView(_baseView, 10)
    .autoHeightRatio(0);
   // .minHeightIs(H(17));
    
    _menberDicountLbl.sd_layout
    .topSpaceToView(_peopleNumLbl, 10)
    .leftSpaceToView(_baseView, 10)
    //.widthIs(100)
    .autoHeightRatio(0);
   // .minHeightIs(H(17));
    
    _integralRangeLbl.sd_layout
    .topSpaceToView(_peopleNumLbl, 10)
    .rightSpaceToView(_baseView, 10)
    .autoHeightRatio(0);
//    .minHeightIs(H(17))
//    .widthIs(120);
    
//    _fourLbl.sd_layout
//    .topSpaceToView(_secondLbl, H(4))
//    .leftSpaceToView(_threeLbl, W(3))
//    .rightSpaceToView(_baseView, W(20))
//    .autoHeightRatio(0)
//    .minHeightIs(H(17));
    
    [_baseView setupAutoHeightWithBottomView:_menberDicountLbl bottomMargin:10];
    [self setupAutoHeightWithBottomView:_baseView bottomMargin:0];
}

- (void)setData:(SVMembershipLevelList *)data
{
    _data = data;

    _img.image = [UIImage imageNamed:self.imageArray[data.indexNum]];
//    if (data.indexNum == 0) {
//        _img.image = [UIImage imageNamed:@"membershipLevel_bg_one"];
//    }else if (data.indexNum == 1){
//        _img.image = [UIImage imageNamed:@"membershipLevel_bg_two"];
//    }else if (data.indexNum == 2){
//        _img.image = [UIImage imageNamed:@"membershipLevel_bg_three"];
//    }else if (data.indexNum == 4){
//        _img.image = [UIImage imageNamed:@"membershipLevel_bg_four"];
//    }else{
//        _img.image = [self imageWithColor: [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
//    }

    _nameLbl.text = data.sv_ml_name;
    [_nameLbl sizeToFit];
    _peopleNumLbl.text = [NSString stringWithFormat:@"%ld人",(long)data.count];
    [_peopleNumLbl sizeToFit];
    _menberDicountLbl.text = [NSString stringWithFormat:@"会员折扣：%ld",(long)data.sv_ml_commondiscount];
    [_menberDicountLbl sizeToFit];
    _integralRangeLbl.text = [NSString stringWithFormat:@"积分范围  %ld-%ld",(long)data.sv_ml_initpoint,(long)data.sv_ml_endpoint];
    [_integralRangeLbl sizeToFit];
    [self layoutSubviews];
}


-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
