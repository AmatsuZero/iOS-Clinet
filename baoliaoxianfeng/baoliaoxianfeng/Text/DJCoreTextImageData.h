//
//  CoreTextImageData.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJCoreTextImageData;

@protocol DJCoreTextImageDataDelegate <NSObject>

-(void)coretextImgData:(DJCoreTextImageData*)imgdata replceWithNewImg:(NSString*)newURL;

@end

/**
 *  文本图片类绘
 */
@interface DJCoreTextImageData : NSObject
/**
 *  名称
 */
@property (strong, nonatomic) NSString * picURL;
/**
 *  插入的位置
 */
@property (nonatomic) NSInteger position;
/**
 *  此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
 */
@property (nonatomic) CGRect imagePosition;

@property (nonatomic,weak)id<DJCoreTextImageDataDelegate>delegate;

@end
