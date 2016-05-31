//
//  CoreTextData.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "DJCoreTextImageData.h"
#import "DJCoreTextLinkData.h"
/**
 *  
 *  @abstract 用于承载显示所需要的所有数据
 *  @discussion 用于保存由DJCTFrameParser类生成的DJCTFrameRef实例以及DJCTFrameRef实际绘制需要的高度
 */
@interface DJCoreTextData : NSObject
/**
 *  绘制文本的FrameRef
 */
@property (assign, nonatomic) CTFrameRef ctFrame;
/**
 *  绘制区域的高度
 */
@property (assign, nonatomic) CGFloat height;
/**
 *  文本图片
 */
@property (strong,nonatomic) NSArray<DJCoreTextImageData*>* imageArray;
/**
 *  文本超链
 */
@property (strong, nonatomic) NSArray<DJCoreTextLinkData*>* linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
