//
//  LPDomNodeModel.h
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "LPDomNodeClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDomNodeModel : NSObject
/**节点元素id*/
@property (nonatomic, copy) NSString *nodeId;
/**节点类*/
@property (nonatomic, weak) LPDomNodeClassModel *nodeClassModel;
/**虚拟父view 优先级高于物理父view的节点绑定view*/
@property (nonatomic, weak) UIView *dummyParentView;
/**绑定视图的弱引用*/
@property (nonatomic, weak) UIView *lp_view;


@end

NS_ASSUME_NONNULL_END
