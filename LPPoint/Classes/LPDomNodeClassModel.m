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

- (LPDomNodeClassModel *)findNodeWithSPM:(NSString *)spm {
    // 将SPM字符串分割成一个数组
    NSArray *spmArray = [spm componentsSeparatedByString:@"-"];
    
    // 开始在子节点中查找
    return [self findNodeWithSPMArray:spmArray];
}

- (LPDomNodeClassModel *)findNodeWithSPMArray:(NSArray *)spmArray {
    // 如果SPM数组为空，返回当前节点
    if (spmArray.count == 0) {
        return self;
    }
    
    // 取出第一个ID，并将其从SPM数组中移除
    NSString *firstId = spmArray[0];
    spmArray = [spmArray subarrayWithRange:NSMakeRange(1, spmArray.count - 1)];
    
    // 在子节点中查找具有指定ID的节点
    for (LPDomNodeClassModel *child in self.children) {
        if ([child.nodeId isEqualToString:firstId]) {
            // 如果找到了，递归地在该子节点的子节点中查找剩余的ID
            return [child findNodeWithSPMArray:spmArray];
        }
    }
    
    // 如果在所有子节点中都没有找到，返回nil
    return nil;
}
@end
