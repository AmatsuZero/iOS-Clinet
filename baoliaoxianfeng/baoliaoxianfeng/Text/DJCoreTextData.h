//
//  CoreTextData.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
/**
 *  
 *  @abstract 用于承载显示所需要的所有数据
 *  @discussion 用于保存由DJCTFrameParser类生成的DJCTFrameRef实例以及DJCTFrameRef实际绘制需要的高度
 */
@interface DJCoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;

@end
