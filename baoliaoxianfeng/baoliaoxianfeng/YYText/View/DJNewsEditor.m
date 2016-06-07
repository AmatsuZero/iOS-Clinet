//
//  DJNewsEditor.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/7.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsEditor.h"
#import "DJNewsContentMgr.h"

@interface DJNewsEditor ()<YYTextViewDelegate>

@end

@implementation DJNewsEditor

-(instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}


#pragma mark -- YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView
{

}

@end
