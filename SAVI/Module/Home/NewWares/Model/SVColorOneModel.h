//
//  SVColorOneModel.h
//  SAVI
//
//  Created by houming Wang on 2019/3/30.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVColorOneModel : NSObject
//"attri_group" = "";
//attrilist =             (
//);
//effective = 0;
//grouplist = "<null>";
//"industrytype_id" = 18;
//sort = 12;
//"spec_id" = 12;
//"spec_name" = "颜色";
//"sv_canbe_uploadimages" = 1;
//"sv_is_activity" = 0;
//"sv_is_multiplegroup" = 0;
//"sv_is_publish" = 1;
//"sv_remark" = "";
//"user_id" = 0;

@property (nonatomic,strong) NSString *spec_name;
@property (nonatomic,strong) NSString *spec_id;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *industrytype_id;
@property (nonatomic,assign) NSInteger sv_is_multiplegroup;
@property (nonatomic,strong) NSString *grouplist;
@property (nonatomic,assign) NSInteger sv_is_publish;
@property (nonatomic,assign) NSInteger sv_canbe_uploadimages;
@property (nonatomic,assign) NSInteger sv_is_activity;
@property (nonatomic,assign) NSInteger effective;
@property (nonatomic,strong) NSString *sv_remark;
@property (nonatomic,strong) NSString *attri_group;
@property (nonatomic,assign) NSInteger sort;

@end

NS_ASSUME_NONNULL_END
