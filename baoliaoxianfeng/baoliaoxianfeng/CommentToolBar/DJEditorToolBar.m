//
//  DJEditorToolBar.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/3.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJEditorToolBar.h"

@implementation DJEditorToolBar

-(instancetype)init
{
    if (self = [super init]) {
        UIBarButtonItem* itme1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(testAction1:)];
        UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testAction2:)];
        UIBarButtonItem* item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(testAction3:)];
        UIBarButtonItem* item4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(testAction4:)];
    }
    return self;
}

#pragma mark -- 测试事件


@end
