//
//  DJCTFrameParser.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCTFrameParserConfig.h"
#import "DJCoreTextData.h"
/*
 *排版解析类
 @abstract 用于实现文字内容的排版
 @discussion 用于生成最后绘制界面需要的CTFrameRef实例
 */
@interface DJCTFrameParser : NSObject
/**
 *  直接解析字符串，并显示
 *
 *  @param content 要显示的字符串，一般使用NSAttributedString
 *  @param config  文本配置
 *
 *  @return 文本数据
 */
+ (DJCoreTextData *)parseContent:(NSString *)content config:(DJCTFrameParserConfig*)config;
/**
 *  解析JSON，生成文本数据
 *
 *  @param path   JSON文件所在路径
 *  @param config 配置
 *
 *  @return 文本数据
 */
+ (DJCoreTextData *)parseTemplateFile:(NSString *)path config:(DJCTFrameParserConfig*)config;

@end
