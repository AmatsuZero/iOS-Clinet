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

@interface DJNewsDetailView ()<DJNewsContentMgrDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)DJNewsContentMgr* mgr;

@end

@implementation DJNewsDetailView

-(instancetype)init
{
    if (self = [super init]) {
        _mgr = [DJNewsContentMgr new];
        _mgr.delegate = self;
        _mgr.textContent.yy_lineSpacing = 18;//设置行间距
        _mgr.textContent.yy_firstLineHeadIndent = 20;//设置缩进
        self.attributedText = _mgr.textContent;
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

-(void)longPress:(UILongPressGestureRecognizer*)gz
{

}

-(BOOL)canBecomeFirstResponder
{
    return NO;//禁用掉UIMenuController，自己添加长按手势，实现UIMenuController的弹出
}

#pragma mark -- 图片/超链点击事件代理
-(void)contentMgr:(DJNewsContentMgr *)mgr openLink:(NSURL *)link
{
    NSLog(@"点击了超链！ %@",link.absoluteString);
}

-(void)contentMgr:(DJNewsContentMgr *)mgr ViewImg:(UIImage*)img{
    NSLog(@"点击了超链！ %@",img);
}

@end
