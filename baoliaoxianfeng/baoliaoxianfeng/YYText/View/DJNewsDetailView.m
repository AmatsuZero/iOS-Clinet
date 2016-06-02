//
//  DJNewsDetailView.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsDetailView.h"
#import "DJNewsContentMgr.h"
#import "UIImageView+WebCache.h"

@interface DJNewsDetailView ()


@end

@implementation DJNewsDetailView

-(instancetype)init
{
    if (self = [super init]) {
        self.attributedText = [DJNewsContentMgr getStandardContentMgr].textContent;
    }
    return self;
}

@end
