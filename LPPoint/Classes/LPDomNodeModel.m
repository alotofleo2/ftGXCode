//
//  LPDomNodeModel.m
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import "LPDomNodeModel.h"

@implementation LPDomNodeModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _childNodes = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)addSubNode:(LPDomNodeModel *)node {
    [self.childNodes addObject:node];
}

- (LPDomNodeModel *)findNodeBySPMPath:(NSArray<NSString *> *)spmPath {
    if (spmPath.count == 0) {
        return nil;
    }
    
    NSString *currentSPM = spmPath[0];
    if (![self.nodeId isEqualToString:currentSPM]) {
        return nil;
    }
    
    if (spmPath.count == 1) {
        return self;
    }
    
    NSArray *remainingSPMPath = [spmPath subarrayWithRange:NSMakeRange(1, spmPath.count - 1)];
    for (LPDomNodeModel *childNode in self.childNodes) {
        LPDomNodeModel *foundNode = [childNode findNodeBySPMPath:remainingSPMPath];
        if (foundNode) {
            return foundNode;
        }
    }
    
    return nil;
}

@end
