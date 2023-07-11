//
//  LPErrorReportor.h
//  LPPoint
//
//  Created by 方焘 on 2023/6/29.
//

#import <Foundation/Foundation.h>

@interface LPErrorReportor : NSObject
+ (void)reportErrorWithType:(NSInteger)type rootNodeCode:(NSString *)rootNodeCode msg:(NSString *)msg;
@end

