//
//  SVMemberNumberCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/9.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVMemberNumberCell.h"
#import "SVStoreLineView.h"

@interface SVMemberNumberCell()
@property (weak, nonatomic) IBOutlet UIView *fatherView;

@end
@implementation SVMemberNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMemberCountArray:(NSMutableArray *)memberCountArray
{
    _memberCountArray = memberCountArray;
   // self.textName.text = @"各门店会员数";
    
    CGFloat maxY = 0;
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.memberCountArray.count ; i++) {
        
        NSDictionary *dict = self.memberCountArray[i];
        
        if ([dict[@"count"] floatValue] == 0) {//数据为0时
            
        }else{
            
            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
            rankingsV.namelabel.text = dict[@"storename"];
            rankingsV.moneylabel.text = dict[@"ratiostring"];
            if (self.memberOrder_receivable != 0) {
                float twoWide = 180 * [dict[@"count"] floatValue] / self.memberOrder_receivable;
                NSLog(@"3333twoWide = %f",twoWide);
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.width = twoWide;
                }];
                rankingsV.colorView.height = 15;
                
                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                //  maxY = maxY;
                maxY = CGRectGetMaxY(rankingsV.frame);
                
                //  maxY = maxY;
                [self.fatherView addSubview:rankingsV];
            }
        }
        
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
