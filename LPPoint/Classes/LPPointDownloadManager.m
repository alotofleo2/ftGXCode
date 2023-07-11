//
//  LPPointDownloadManager.m
//  LPPoint
//
//  Created by 方焘 on 2023/6/29.
//

#import "LPPointDownloadManager.h"

@interface LPPointDownloadManager ()

@end

@implementation LPPointDownloadManager
+ (instancetype)sharedInstance {
    static LPPointDownloadManager *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [[LPPointDownloadManager alloc] init];
    });
    return o;
}

- (void)getNodeClassMapWithRootNodeCode:(NSString *)rootNodeCode complete:(void(^)(NSDictionary * map))complete {
    
}
@end
