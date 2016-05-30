//
//  DJCTFrameParserConfig.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @abstract 用于实现一些排版时的可配置项
 *  @discussion 用于配置绘制的参数，例如：文字颜色，大小，行间距等
 */
@interface DJCTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
/**
 *  字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 *  行间距
 */
@property (nonatomic, assign) CGFloat lineSpace;
/**
 *  字体颜色
 */
@property (nonatomic, strong) UIColor *textColor;

@end
