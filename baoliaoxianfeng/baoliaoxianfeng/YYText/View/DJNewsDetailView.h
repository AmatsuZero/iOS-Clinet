//
//  DJNewsDetailView.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <YYText/YYText.h>
#import "DJNewsContentMgr.h"

@interface DJNewsDetailView : YYTextView
//内容管理者
@property(nonatomic,strong)DJNewsContentMgr* mgr;

@end
