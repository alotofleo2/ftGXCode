//
//  LPPointDownloadManager.h
//  LPPoint
//
//  Created by 方焘 on 2023/6/29.
//

#import <Foundation/Foundation.h>

@interface LPPointDownloadManager : NSObject
+ (instancetype)sharedInstance;

- (void)getNodeClassMapWithRootNodeCode:(NSString *)rootNodeCode  complete:(void(^)(NSDictionary * map))complete;
@end

