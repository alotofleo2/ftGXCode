//
//  LPDomNodeModel.h
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "LPDomNodeClassModel.h"

NS_ASSUME_NONNULL_BEGIN
@class LPDomNodeModel;
@interface LPDomNodeModel : NSObject

/**节点元素Code*/
@property (nonatomic, copy) NSString *nodeCode;
/**节点类*/
@property (nonatomic, weak) LPDomNodeClassModel *nodeClassModel;
/**虚拟父view 优先级高于物理父view的节点绑定view*/
@property (nonatomic, weak) UIView *dummyParentView;
/**绑定视图的弱引用*/
@property (nonatomic, weak) UIView *lp_view;

#pragma mark - root 相关
/**是否是根节点*/
@property (nonatomic, assign) BOOL isRoot;

/// 开始Dom树初始化,包含类树加载和埋点列表下载
- (void)startDomInitiate;
@end

@interface LPDomNodeModel (LPDomClass)

@end

NS_ASSUME_NONNULL_END
