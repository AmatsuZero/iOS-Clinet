//
//  CoreTextImageData.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJCoreTextImageData.h"
#import "NSString+DJMD5String.h"

@interface DJCoreTextImageData ()

@property(nonatomic,strong)NSMutableDictionary* downLoadTask;
@property(nonatomic,copy)NSString* path;
@property(nonatomic,strong)NSFileManager* FileMgr;

@end

@implementation DJCoreTextImageData

-(instancetype)init
{
    if (self = [super init]) {
        _FileMgr = [NSFileManager defaultManager];
        _downLoadTask = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString *)path{
    if (!_path) {
        _path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"NewsDetails"];
        NSError* error;
        if (![self.FileMgr fileExistsAtPath:_path]) {
            if (![self.FileMgr createDirectoryAtPath:_path withIntermediateDirectories:NO attributes:nil error:&error]) {
                debugLog(@"创建文件夹失败！错误是：%@",error.localizedDescription);
            }
        }
    }
    return _path;
}

-(void)setPicURL:(NSString *)picURL
{
    if ([picURL hasPrefix:@"http"]) {
        _picURL = [[NSBundle mainBundle]pathForResource:@"NoImage" ofType:@"png"];
    } else {
        _picURL = picURL;
        return;
    }
    
    NSString* fileName = [picURL MD5Hash];
    //1.判断沙盒下该图片文件是否已经存在
    if ([self.FileMgr fileExistsAtPath:[self.path stringByAppendingPathComponent:fileName]]) {
        _picURL = [self.path stringByAppendingPathComponent:fileName];
        [self.delegate coretextImgData:self replceWithNewImg:_picURL];
    //2. 如果不存在，说明需要下载
    } else {
    //3. 检查一下下载任务是否已经存在
        if (!self.downLoadTask[picURL]) {
            NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask* downLoadTask = [session dataTaskWithURL:[NSURL URLWithString:picURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data.length<=0||error) {
                    debugLog(@"下载图片出错！错误是：%@",error.localizedDescription);
                    _picURL = [[NSBundle mainBundle]pathForResource:@"NoImage" ofType:@"png"];
                    [self.delegate coretextImgData:self replceWithNewImg:_picURL];
                } else {
                    NSString* sandBoxPath = [self.path stringByAppendingPathComponent:fileName];
                    if (![data writeToFile:sandBoxPath options:NSDataWritingAtomic error:&error]) {
                        NSLog(@"图片写入失败！%@",error.localizedDescription);
                        _picURL = [[NSBundle mainBundle]pathForResource:@"NoImage" ofType:@"png"];
                        [self.delegate coretextImgData:self replceWithNewImg:_picURL];
                    } else {
                        _picURL = sandBoxPath;
                        [self.delegate coretextImgData:self replceWithNewImg:_picURL];
                    }
                }
            } ];
            [downLoadTask resume];
            self.downLoadTask[picURL] = downLoadTask;
        }
    }
}

@end
