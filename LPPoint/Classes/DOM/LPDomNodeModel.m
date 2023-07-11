//
//  LPDomNodeModel.m
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import "LPDomNodeModel.h"
#import "LPPageDomManager.h"

@interface LPDomNodeModel ()
@property (nonatomic, strong) LPPageDomManager *pageDomManager;
@end

@implementation LPDomNodeModel
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

/// 开始Dom树初始化,包含类树加载和埋点列表下载
- (void)startDomInitiate {
    if (self.isRoot) {
        [self.pageDomManager startInitiateClassModelAndPointWithRootNodeCode:self.nodeCode];
    }
}

- (LPPageDomManager *)pageDomManager {
    if (!_pageDomManager) {
        _pageDomManager = [[LPPageDomManager alloc] init];
    }
    return _pageDomManager;
}
@end

@implementation LPDomNodeModel (LPDomClass)

@end
