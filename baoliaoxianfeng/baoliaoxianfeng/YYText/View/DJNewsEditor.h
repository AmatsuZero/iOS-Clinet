//
//  DJNewsEditor.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/7.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <YYText/YYText.h>
#import "DJNewsContentMgr.h"

@interface DJNewsEditor : YYTextView

@property(nonatomic,strong)DJNewsContentMgr* mgr;
 
@end
