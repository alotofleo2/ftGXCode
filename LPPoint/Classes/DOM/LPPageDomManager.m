//
//  LPPageDomManager.m
//  LPPoint
//
//  Created by 方焘 on 2023/6/28.
//

#import "LPPageDomManager.h"
#import "LPDomNodeModel.h"
#import <objc/runtime.h>
#import "LPPointDownloadManager.h"
#import "LPErrorReportor.h"

@interface LPDomNodeModel (domManager)
- (BOOL)lp_isBind;
- (void)lp_setIsBind:(BOOL)isBind;
@end

@implementation LPDomNodeModel (domManager)

/// 是否已绑定节点类
- (BOOL)lp_isBind {
    NSNumber *lp_isBind = objc_getAssociatedObject(self, @"lp_isBind");
    return lp_isBind && lp_isBind.boolValue;
}

- (void)lp_setIsBind:(BOOL)isBind {
    objc_setAssociatedObject(self, @"lp_isBind", @(isBind), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface LPPageDomManager ()
@property (nonatomic, strong) NSHashTable *nodeTable;
@end

@implementation LPPageDomManager
- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - public
- (void)startInitiateClassModelAndPointWithRootNodeCode:(NSString *)nodeCode {
    [[LPPointDownloadManager sharedInstance] getNodeClassMapWithRootNodeCode:nodeCode complete:^(NSDictionary *map) {
        if (!map) {
            [LPErrorReportor reportErrorWithType:10000 rootNodeCode:nodeCode msg:@"downloadError"];
            return;
        };
    }];
}

- (void)addPageNode:(LPDomNodeModel *)nodeModel {
    [self.nodeTable addObject:nodeModel];
}

#pragma mark - private

@end
