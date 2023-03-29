//
//  SVSizeTwoModel.h
//  SAVI
//
//  Created by houming Wang on 2019/4/1.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSizeTwoModel : NSObject
//"industrytype_id" = 18;
//sort = 13;
//"spec_id" = 13;
//"spec_name" = "尺码";
//"sv_canbe_uploadimages" = 0;
//"sv_is_activity" = 0;
//"sv_is_multiplegroup" = 1;
//"sv_is_publish" = 1;
//"sv_remark" = "";
//"user_id" = 0;
@property (nonatomic,strong) NSString *industrytype_id;
//@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,assign) NSInteger spec_id;
@property (nonatomic,assign) NSString *spec_name;
@property (nonatomic,assign) NSInteger sv_canbe_uploadimages;
@property (nonatomic,assign) NSInteger sv_is_activity;
@property (nonatomic,assign) NSInteger sv_is_multiplegroup;
@property (nonatomic,assign) NSInteger sv_is_publish;
@property (nonatomic,assign) NSString *sv_remark;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,assign) NSInteger effective;
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,strong) NSString *grouplist;
@end

NS_ASSUME_NONNULL_END
