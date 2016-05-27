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
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif
//Masonry省略mas_开头
#define MAS_SHORTHAND

#endif /* CommonMacro_h */
