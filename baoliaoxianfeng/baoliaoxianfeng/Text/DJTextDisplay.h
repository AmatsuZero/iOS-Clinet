//
//  DJTextDisplay.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCoreTextData.h"
/**
 *  图片点击通知
 */
extern NSString *const DJCTDisplayViewImagePressedNotification;
/**
 *  超链点击通知
 */
extern NSString *const DJCTDisplayViewLinkPressedNotification;
/*
 @abstract 仅负责显示内容，不负责排版
 @discussion 持有CoreTextData类的实例，负责将CTFrameRef绘制到界面上
 */
@interface DJTextDisplay : UIView

@property (strong, nonatomic) DJCoreTextData * data;

@end
