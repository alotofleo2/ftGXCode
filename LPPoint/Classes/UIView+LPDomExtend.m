//
//  UIView+LPDomExtend.m
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import "UIView+LPDomExtend.h"
#import <objc/runtime.h>
#import "LPPointManager.h"

@interface NSObject (LPPointSwizzle)

@end

@implementation NSObject (LPPointSwizzle)
+ (BOOL)lk_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)lk_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_
{
    return [object_getClass((id)self) lk_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}
@end

@interface UIView (LPDomExtend)

/// 检查更新节点链接是否正确
- (void)lp_checkAndFixChildNodes;
@end

@implementation UIView (LPDomExtend)
+ (void)load {
    [self lk_swizzleMethod:@selector(addSubview:) withMethod:@selector(lp_point_addSubview:) error:nil];
}


- (void)lp_point_addSubview:(UIView *)view {
    [self lp_point_addSubview:view];
    if (![view lp_isKeyNode]) return;
//    [view lp_linkNode];
}

////桥接节点关系
//- (void)lp_linkNode {
//
//    if (self.lp_domNodeModel.isRoot) return;
//    if (!self.superview && !self.lp_domNodeModel.dummyParentView)return;
//
//    //如果原来就有桥接先清除
//    if (self.lp_domNodeModel.parentNode) {
//        [self.lp_domNodeModel.parentNode removeSubNode:self.lp_domNodeModel];
//        self.lp_domNodeModel.parentNode = nil;
//    }
//
//    //如何存在虚拟父视图,把虚拟父视图当做superView去判断
//    if (self.lp_domNodeModel.dummyParentView) {
//        [self lp_linkNodeWithSuperview:self.lp_domNodeModel.dummyParentView];
//    } else {
//        [self lp_linkNodeWithSuperview:self.superview];
//    }
//
//}
//桥接节点关系
//- (void)lp_linkNodeWithSuperview:(UIView *)superview {
//    UIView *sView = superview;
//    while (sView) {
//        if ([sView lp_isKeyNode]) {
//            self.lp_domNodeModel.parentNode = sView.lp_domNodeModel;
//            [sView.lp_domNodeModel addSubNode:self.lp_domNodeModel];
//            // 检查并修复子节点关联
//            [sView lp_checkAndFixChildNodes];
//            break;
//        }
//        sView = sView.superview;
//    }
//}

/// 判断是否为元素节点 通过是否已启用node模型判断
- (BOOL)lp_isKeyNode {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    return lp_domNodeModel.nodeId.length > 0;
}

- (LPDomNodeModel *)lp_domNodeModel {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    if (!lp_domNodeModel) {
        lp_domNodeModel = [[LPDomNodeModel alloc] init];
        [self lk_setDomNodeModel:lp_domNodeModel];
    }
    return lp_domNodeModel;
}

- (void)lk_setDomNodeModel:(LPDomNodeModel *)lp_domNodeModel {
    objc_setAssociatedObject(self, @"lp_domNodeModel", lp_domNodeModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    lp_domNodeModel.lp_view = self;
}

- (UIView *)lp_findViewBySPM:(NSString *)spm {
    NSArray<NSString *> *spmPath = [spm componentsSeparatedByString:@"-"];
    LPDomNodeModel *foundNode = [self.lp_domNodeModel findNodeBySPMPath:spmPath];
    return foundNode ? foundNode.lp_view : nil;
}

- (NSString *)lp_currentNodeSPM {
    NSMutableString *spm = [NSMutableString string];
    LPDomNodeModel *currentNode = self.lp_domNodeModel;
    
    while (currentNode) {
        if (spm.length > 0) {
            [spm insertString:@"-" atIndex:0];
        }
        [spm insertString:currentNode.nodeId atIndex:0];
        currentNode = currentNode.parentNode;
    }
    
    return spm;
}

- (void)lp_bindEventsWithSPM:(NSString *)spm eventType:(NSInteger)eventType reportParameters:(NSDictionary *)reportParameters {
    UIView *targetView = [self lp_findViewBySPM:spm];
    if (!targetView) {
        return;
    }
    
    // 请在此处补充绑定事件逻辑
    // eventType: 事件类型 (点击事件, 曝光事件)
    // reportParameters: 上报参数
}

#pragma mark - private

//- (void)lp_checkAndFixChildNodes {
//    LPDomNodeModel *parentNode = self.lp_domNodeModel;
//
//    for (UIView *subview in self.subviews) {
//        LPDomNodeModel *childNode = subview.lp_domNodeModel;
//
//        // 如果当前子视图不是 keyNode，则继续递归检查其子视图
//        if (![subview lp_isKeyNode]) {
//            [subview lp_checkAndFixChildNodes];
//            continue;
//        }
//        //子视图若还没有链接,就跳过
//        if (!childNode.parentNode) {
//            continue;
//        }
//
//        // 检查子节点的父节点是否正确
//        if (childNode.parentNode != parentNode) {
//            // 如果存在虚拟父视图
//            if (childNode.dummyParentView) {
//                // 使用虚拟父视图作为父节点
//                UIView *keyDummyView = nil;
//                // 查找关键节点
//                UIView *keyNodeSuperview = childNode.dummyParentView;
//                while (keyNodeSuperview) {
//                    if ([keyNodeSuperview lp_isKeyNode]) {
//                        keyDummyView = keyNodeSuperview;
//                        break;
//                    }
//                    keyNodeSuperview = keyNodeSuperview.superview;
//                }
//                if (keyDummyView) {
//                    [childNode.parentNode removeSubNode:childNode];
//                    childNode.parentNode = keyDummyView.lp_domNodeModel;
//                    [keyDummyView.lp_domNodeModel addSubNode:childNode];
//                }
//
//            } else {
//                // 修正子节点的父节点关联
//                [childNode.parentNode removeSubNode:childNode];
//                childNode.parentNode = parentNode;
//                [parentNode addSubNode:childNode];
//            }
//            if (childNode.parentNode != parentNode) {
//
//                // 修正子节点的父节点关联
//                [childNode.parentNode removeSubNode:childNode];
//                childNode.parentNode = parentNode;
//                [parentNode addSubNode:childNode];
//            }
//
//            // 递归检查子视图的子节点
//            [subview lp_checkAndFixChildNodes];
//        }
//    }
//}

@end
