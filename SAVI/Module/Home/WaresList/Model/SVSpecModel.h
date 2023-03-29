//
//  SVSpecModel.h
//  SAVI
//
//  Created by houming Wang on 2018/11/30.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVAtteilistModel.h"
@interface SVSpecModel : NSObject
@property (nonatomic,assign) NSInteger spec_id;
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,strong) NSString *effective;
@property (nonatomic,strong) NSString *grouplist;
@property (nonatomic,strong) NSString *industrytype_id;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,strong) NSString *spec_name;
@property (nonatomic,strong) NSString *sv_canbe_uploadimages;
@property (nonatomic,strong) NSString *sv_is_activity;
@property (nonatomic,strong) NSString *sv_is_multiplegroup;
@property (nonatomic,strong) NSString *sv_is_publish;
@property (nonatomic,strong) NSString *sv_remark;
@property (nonatomic,strong) NSString *user_id;
@property(nonatomic, strong) NSMutableArray <SVAtteilistModel *>*attrilist;
@end
