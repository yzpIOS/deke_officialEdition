//
//  SVAtteilistModel.h
//  SAVI
//
//  Created by houming Wang on 2018/11/30.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAtteilistModel : NSObject
@property (nonatomic,strong) NSString *attri_name;
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,strong) NSString *attri_code;
@property (nonatomic,strong) NSString *attri_id;
@property (nonatomic,strong) NSString *attri_user_id;
@property (nonatomic,strong) NSString *effective;
@property (nonatomic,strong) NSString *images_info;
@property (nonatomic,strong) NSString *is_custom;
@property (nonatomic,strong) NSString *is_default;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,assign) NSInteger spec_id;
@property (nonatomic,strong) NSString *sv_remark;
@end
