//
//  DJNewsEditor.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/7.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsEditor.h"

@interface DJNewsEditor ()<DJNewsContentSaveDelegate>

@end

@implementation DJNewsEditor

-(instancetype)init
{
    if (self = [super init]) {
        _mgr = [[DJNewsContentMgr alloc]init];
        self.delegate = _mgr;
        _mgr.contentKeeper = self;
    }
    return self;
}


@end
