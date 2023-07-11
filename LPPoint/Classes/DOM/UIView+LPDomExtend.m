//
//  UIView+LPDomExtend.m
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import "UIView+LPDomExtend.h"
#import <objc/runtime.h>

@interface NSObject (LPPointSwizzle)

@end

@implementation NSObject (LPPointSwizzle)
+ (BOOL)lk_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_ {
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

+ (BOOL)lk_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_ {
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
    if (![view lp_isKeyNode])
        return;
    //    [view lp_linkNode];
}

/// 判断是否为元素节点 通过是否已启用node模型判断
- (BOOL)lp_isKeyNode {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    return lp_domNodeModel.nodeCode.length > 0;
}

- (LPDomNodeModel *)lp_domNodeModel {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    if (!lp_domNodeModel) {
        lp_domNodeModel = [[LPDomNodeModel alloc] init];
        lp_domNodeModel.lp_view = self;
        [self lk_setDomNodeModel:lp_domNodeModel];
    }
    return lp_domNodeModel;
}

- (void)lk_setDomNodeModel:(LPDomNodeModel *)lp_domNodeModel {
    objc_setAssociatedObject(self, @"lp_domNodeModel", lp_domNodeModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    lp_domNodeModel.lp_view = self;
}

- (NSString *)lp_currentViewNodeSPM {
    // 获取当前view的节点
    LPDomNodeModel *node = [self lp_domNodeModel]; // 假设你有一个方法来获取当前view的节点

    // 如果当前view的节点是根节点，返回其nodeId
    if (node.nodeClassModel.isRoot) {
        return node.nodeCode;
    }

    // 否则，递归地获取父view的SPM，然后将当前view的nodeId添加到其后面
    UIView *parentView = self.superview;
    while (parentView && ![parentView lp_isKeyNode]) {
        parentView = parentView.superview;
    }
    if (!parentView) {
        // 如果没有找到具有lp_node的父视图，返回当前节点的nodeId
        return node.nodeCode;
    }
    NSString *parentSPM = [parentView lp_currentViewNodeSPM];
    return [NSString stringWithFormat:@"%@-%@", parentSPM, node.nodeCode];
}

- (void)lp_bindEventsWithSPM:(NSString *)spm eventType:(NSInteger)eventType reportParameters:(NSDictionary *)reportParameters {
    //    UIView *targetView = [self lp_findViewBySPM:spm];
    //    if (!targetView) {
    //        return;
    //    }

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
