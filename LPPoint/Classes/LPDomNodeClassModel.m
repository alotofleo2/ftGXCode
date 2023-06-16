//
//  LPDomNodeClassModel.m
//  LPPoint
//
//  Created by 方焘 on 2023/5/12.
//

#import "LPDomNodeClassModel.h"

@implementation LPDomNodeClassModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
        _nodeModels = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

/// 添加子节点
/// - Parameter node: 子节点
- (void)addSubNode:(LPDomNodeClassModel *)node {
    [self.children addObject:node];
}

/// 添加节点对象
/// - Parameter node: 节点对象
- (void)addNodeObject:(LPDomNodeModel *)nodeObject {
    [self.nodeModels addObject:nodeObject];
}
@end
