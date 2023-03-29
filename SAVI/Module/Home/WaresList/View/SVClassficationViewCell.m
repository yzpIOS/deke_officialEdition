//
//  SVClassficationViewCell.m
//  SAVI
//
//  Created by houming Wang on 2021/1/22.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVClassficationViewCell.h"
#import "SVClassficationModel.h"

@interface SVClassficationViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SVClassficationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    
}

- (void)setOneModel:(SVClassficationModel *)oneModel{
    _oneModel = oneModel;
    if ([oneModel.isSelect isEqualToString:@"1"]) {
        self.icon.hidden = NO;
    }else{
        self.icon.hidden = YES;
    }
    self.titleLabel.text = oneModel.sv_pc_name;
}

- (void)setTwoModel:(SVClassficationModel *)twoModel{
    _twoModel = twoModel;
    if ([twoModel.isSelect isEqualToString:@"1"]) {
        self.icon.hidden = NO;
    }else{
        self.icon.hidden = YES;
    }
    self.titleLabel.text = twoModel.sv_psc_name;
}

//- (void)setOneDict:(NSDictionary *)oneDict
//{
//    _oneDict = oneDict;
//    self.titleLabel.text = oneDict[@"sv_psc_name"];
//}
//
//- (void)setTwoDict:(NSDictionary *)twoDict
//{
//    _twoDict = twoDict;
//    self.titleLabel.text = twoDict[@"sv_psc_name"];
//}



@end
