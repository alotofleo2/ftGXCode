//
//  LPDomNodeClassModel.m
//  LPPoint
//
//  Created by 方焘 on 2023/5/12.
//

#import "LPDomNodeClassModel.h"
#import "LPErrorReportor.h"

@implementation LPDomNodeClassModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _childs = [NSMutableArray array];
        _nodeModels = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
#pragma mark publick
+ (instancetype)domNodeClassTreeWithData:(NSDictionary *)data {
    return [self createClassNodeWithNodeData:data isRoot:YES parentNode:nil rootNode:nil];
}

/// 添加子节点
/// - Parameter node: 子节点
- (void)addSubNode:(LPDomNodeClassModel *)node {
    [self.childs addObject:node];
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

    // 在子节点中查找具有指定Code的节点
    for (LPDomNodeClassModel *child in self.childs) {
        if ([child.nodeCode isEqualToString:firstId]) {
            // 如果找到了，递归地在该子节点的子节点中查找剩余的ID
            return [child findNodeWithSPMArray:spmArray];
        }
    }

    // 如果在所有子节点中都没有找到，返回nil
    return nil;
}

#pragma mark private
//创建类节点的方法
+ (instancetype)createClassNodeWithNodeData:(NSDictionary *)data isRoot:(BOOL)isRoot parentNode:(LPDomNodeClassModel *)parentNode rootNode:(LPDomNodeClassModel *)rootNode {
    LPDomNodeClassModel *classNode = [[LPDomNodeClassModel alloc] init];
    classNode.isRoot = isRoot;
    classNode.parent = parentNode;
    classNode.rootNode = isRoot ? classNode : rootNode;
    classNode.nodeId = [classNode getValueWithData:data forKey:@"nodeId"];
    classNode.nodeCode = [classNode getValueWithData:data forKey:@"nodeCode"];
    NSArray *childs = [data valueForKey:@"childs"];
    //递归创建子节点
    for (NSDictionary *childData in childs) {
        [classNode.childs addObject:[self createClassNodeWithNodeData:childData isRoot:NO parentNode:classNode rootNode:rootNode]];
    }
    return classNode;
}

- (NSString *)getValueWithData:(NSDictionary *)data forKey:(NSString *)key {
    NSString *value = [data valueForKey:key];
    if (!value) {
        [LPErrorReportor reportErrorWithType:10000 rootNodeCode:self.rootNode.nodeCode msg:[NSString stringWithFormat:@"%@ value 不存在", key]];
    }
    return value;
}

@end
