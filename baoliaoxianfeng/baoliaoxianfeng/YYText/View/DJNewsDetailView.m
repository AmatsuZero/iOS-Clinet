//
//  DJNewsDetailView.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsDetailView.h"
#import "UIImageView+WebCache.h"

@interface DJNewsDetailView ()<UIGestureRecognizerDelegate>

@end

@implementation DJNewsDetailView

-(instancetype)init
{
    if (self = [super init]) {
        _mgr = [DJNewsContentMgr new];
        _mgr.textContent.yy_lineSpacing = 18;//设置行间距
        _mgr.textContent.yy_firstLineHeadIndent = 20;//设置缩进
        self.attributedText = _mgr.textContent;
        self.editable = NO;
    }
    return self;
}

#pragma mark -- UIMenuController相关
-(BOOL)canBecomeFirstResponder
{
    return NO;//禁用掉编辑模式
}



@end
