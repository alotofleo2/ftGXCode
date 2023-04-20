//
//  LPDomNodeModel.h
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDomNodeModel : NSObject
/**是否是根节点*/
@property (nonatomic, assign) BOOL isRoot;
/**根节点对象*/
@property (nonatomic, weak) LPDomNodeModel *rootNode;


/**节点元素id*/
@property (nonatomic, copy) NSString *nodeId;
/**父节点*/
@property (nonatomic, weak) LPDomNodeModel *parentNode;
/**子节点列表 弱引用 不影响子节点 生命周期*/
@property (nonatomic, strong) NSHashTable <LPDomNodeModel *> *childNodes;
/**虚拟父view 优先级高于物理父view的节点绑定view*/
@property (nonatomic, weak) UIView *dummyParentView;
/**绑定视图的弱引用*/
@property (nonatomic, weak) UIView *lp_view;
/// 添加子节点
/// - Parameter node: 子节点
- (void)addSubNode:(LPDomNodeModel *)node;

/// 根据spm列表查找节点
/// - Parameter spmPath: 将spm切割成列表入参
- (LPDomNodeModel *)findNodeBySPMPath:(NSArray<NSString *> *)spmPath;

@end

NS_ASSUME_NONNULL_END
