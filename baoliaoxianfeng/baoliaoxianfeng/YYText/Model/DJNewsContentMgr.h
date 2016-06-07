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

@class DJNewsContentMgr;

@protocol DJNewsContentMgrDelegate <NSObject>

-(void)contentMgr:(DJNewsContentMgr*)mgr openLink:(NSURL*)link;
-(void)contentMgr:(DJNewsContentMgr *)mgr ViewImg:(UIImage*)img;

@end

@protocol DJNewsContentSaveDelegate <NSObject>



@end

@interface DJNewsContentMgr : NSObject

@property(nonatomic, strong) NSMutableAttributedString* textContent;

@property(nonatomic,weak) id <DJNewsContentMgrDelegate> delegate;

@property(nonatomic,weak) id <DJNewsContentSaveDelegate>contentKeeper;

@end
