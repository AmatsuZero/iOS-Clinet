//
//  SHNewsContentMgr.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DJNewsDetailModel;
@class DJTextImg;

@interface DJNewsContentMgr : NSObject

+(instancetype)getStandardContentMgr;

@property(nonatomic, copy) NSAttributedString* textContent;

@end
