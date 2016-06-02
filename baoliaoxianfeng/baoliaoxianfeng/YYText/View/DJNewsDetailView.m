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

@interface DJNewsDetailView ()<DJNewsContentMgrDelegate>

@property(nonatomic,strong)DJNewsContentMgr* mgr;

@end

@implementation DJNewsDetailView

-(instancetype)init
{
    if (self = [super init]) {
        _mgr = [DJNewsContentMgr new];
        _mgr.delegate = self;
        self.attributedText = [_mgr textContent];
    }
    return self;
}

-(void)contentMgr:(DJNewsContentMgr *)mgr refreshWithNewContent:(NSAttributedString *)attrStr
{
    self.attributedText = attrStr;
}

@end
