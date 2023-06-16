//
//  LPPointManager.m
//  LPPoint
//
//  Created by 方焘 on 2023/4/27.
//

#import "LPPointManager.h"

@interface LPPointManager  ()
@property (nonatomic, strong) dispatch_queue_t domOperationQueue;
@end

@implementation LPPointManager

+ (instancetype)sharedInstance {
    static LPPointManager *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [[LPPointManager alloc] init];
        o.domOperationQueue = dispatch_queue_create("com.LPPoint.domOperationQueue", DISPATCH_QUEUE_SERIAL);
    });
    return o;
}

- (void)performDOMOperation:(void (^)(void))operation {
    // 定义一个标识符，用于检查是否在 domOperationQueue 中
    static void *domOperationQueueIdentifier = &domOperationQueueIdentifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 将标识符关联到 domOperationQueue 中
        dispatch_queue_set_specific(self.domOperationQueue, domOperationQueueIdentifier, domOperationQueueIdentifier, NULL);
    });

    // 检查当前线程是否已经在 domOperationQueue 中
    if (dispatch_get_specific(domOperationQueueIdentifier)) {
        operation();
    } else {
        dispatch_async(self.domOperationQueue, ^{
            operation();
        });
    }
}
@end
