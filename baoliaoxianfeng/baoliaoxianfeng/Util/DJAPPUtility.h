//
//  DJAPPUtility.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJAPPUtility : NSObject
/**
 *  将字符串转换成对应的UIColor
 *
 *  @param color 颜色描述字符串，字符串可以是一般性描述，比如yellow、blue、red等等，也可是16进制颜色描述符（带不带Alpha均可）
 *
 *  @return 对应UIColor
 */
+(UIColor*)convertToColorType:(NSString*)color;
/**
 *  将UIDeviceRGBColorSpace描述符转换成颜色描述符，比如“UIDeviceRGBColorSpace 0 0 1 1”对应的描述就是“blue”
 *
 *  @param rgbColorSapce 颜色UIDeviceRGBColorSpace描述符，在NSAttributedString中，颜色是以NSColor或者CTForegroundColor存储的，需要转换成我们认识的颜色
 *
 *  @return 颜色描述符，能转换成认识的就转换成认识的，不在默认颜色之列的就转换成16进制颜色描述符
 */
+(NSString*)convertToDescriptionStr:(NSString*)rgbColorSapce;

@end
