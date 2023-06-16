//
//  LPPointManager.h
//  LPPoint
//
//  Created by 方焘 on 2023/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPointManager : NSObject
+ (instancetype)sharedInstance;

/// dom相关任务队列
/// - Parameter operation: 队列内容
- (void)performDOMOperation:(void (^)(void))operation;
@end

NS_ASSUME_NONNULL_END
