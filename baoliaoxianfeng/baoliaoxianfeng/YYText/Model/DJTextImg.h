//
//  DJTextImg.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJTextImg;

@protocol DJTextImgDelegate <NSObject>

-(void)textImgModel:(DJTextImg*)imgModel replaceImg:(UIImage*)img imgPath:(NSString*)path;

@end

@interface DJTextImg : NSObject

@property (nonatomic, copy)NSString* placeHolder;
@property (nonatomic, copy)NSString* loadFailPic;
@property (nonatomic, weak)id<DJTextImgDelegate> delegate;
@property (nonatomic, copy)NSString* url;

-(UIImage*)getWebPicFrom:(NSString*)url withPlaceHolder:(NSString*)placeHolder andFailPic:(NSString*)failPic;

@end
