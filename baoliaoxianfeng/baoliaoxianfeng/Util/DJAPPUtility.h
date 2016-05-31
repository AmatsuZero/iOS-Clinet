//
//  DJAPPUtility.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCoreTextData.h"

@interface DJAPPUtility : NSObject

+ (DJCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(DJCoreTextData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(DJCoreTextData *)data;

@end
