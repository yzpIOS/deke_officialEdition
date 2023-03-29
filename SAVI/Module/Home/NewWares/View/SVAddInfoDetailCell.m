//
//  SVAddInfoDetailCell.m
//  SAVI
//
//  Created by houming Wang on 2021/2/21.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVAddInfoDetailCell.h"

@interface SVAddInfoDetailCell()


@end

@implementation SVAddInfoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    NSString *sv_brand_name = dict[@"sv_brand_name"];
    
    NSString *sv_foundation_name = dict[@"sv_foundation_name"];
    if (kStringIsEmpty(sv_brand_name)) {
        self.sv_foundation_name.text = sv_foundation_name;
    }else{
        self.sv_foundation_name.text = sv_brand_name;
    }
    
    self.sv_foundation_name.textColor = GlobalFontColor;
  
}



@end
