//
//  CommonMacro.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h
//自定义打印
#ifdef DEBUG 
#define debugLog(...) NSLog(__VA_ARGS__) 
#define debugMethod() NSLog(@"%s", __func__) 
#else 
#define debugLog(...) 
#define debugMethod() 
#endif 
//自定义颜色
#define RGB(A, B, C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
//Masonry省略mas_开头
#define MAS_SHORTHAND

#endif /* CommonMacro_h */
