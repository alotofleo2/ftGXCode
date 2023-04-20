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


@implementation UIView (LPDomExtend)
+ (void)load {
    [self lk_swizzleMethod:@selector(addSubview:) withMethod:@selector(lp_point_addSubview:) error:nil];
}


- (void)lp_point_addSubview:(UIView *)view {
    [self lp_point_addSubview:view];
    if (![view lp_isKeyNode]) return;
    [view lp_linkNode];
}

//桥接节点关系
- (void)lp_linkNode {
    if (self.lp_domNodeModel.isRoot) return;
    if (self.lp_domNodeModel.dummyParentView) {
        [self lp_linkNodeWithSuperview:self.lp_domNodeModel.dummyParentView];
    } else {
        [self lp_linkNodeWithSuperview:self.superview];
    }
}
//桥接节点关系
- (void)lp_linkNodeWithSuperview:(UIView *)superview {
    UIView *sView = superview;
    while (sView) {
        if ([sView lp_isKeyNode]) {
            self.lp_domNodeModel.parentNode = sView.lp_domNodeModel;
            [sView.lp_domNodeModel addSubNode:self.lp_domNodeModel];
            break;
        }
        sView = sView.superview;
    }
}

/// 判断是否为元素节点 通过是否已启用node模型判断
- (BOOL)lp_isKeyNode {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    return lp_domNodeModel != nil;
}

- (LPDomNodeModel *)lp_domNodeModel {
    LPDomNodeModel *lp_domNodeModel = objc_getAssociatedObject(self, @"lp_domNodeModel");
    if (!lp_domNodeModel) {
        lp_domNodeModel = [[LPDomNodeModel alloc] init];
        [self lk_setDemoNodeModel:lp_domNodeModel];
    }
    return lp_domNodeModel;
}

- (void)lk_setDemoNodeModel:(LPDomNodeModel *)lp_domNodeModel {
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
@end
