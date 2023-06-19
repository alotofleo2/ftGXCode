//
//  LPDomNodeClassModel.h
//  LPPoint
//
//  Created by 方焘 on 2023/5/12.
//

#import <Foundation/Foundation.h>
#import "LPDomNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDomNodeClassModel : NSObject
/**是否是根节点*/
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, copy) NSString *nodeId; // 节点的唯一标识符
@property (nonatomic, copy) NSString *spm; // 此节点的序列化路径匹配器（SPM）字符串
@property (nonatomic, weak) LPDomNodeClassModel *parent; // 此节点的父节点
@property (nonatomic, strong) NSHashTable<LPDomNodeModel *>*nodeModels; // 与此节点对应的视图的节点模型
@property (nonatomic, strong) NSMutableArray<LPDomNodeClassModel *> *children; // 此节点的子节点

/// 添加子节点
/// - Parameter node: 子节点
- (void)addSubNode:(LPDomNodeClassModel *)node;

/// 添加节点对象
/// - Parameter node: 节点对象
- (void)addNodeObject:(LPDomNodeModel *)nodeObject;


/// 根据SPM查找节点
/// - Parameter spm: spm
- (LPDomNodeClassModel *)findNodeWithSPM:(NSString *)spm;
@end

NS_ASSUME_NONNULL_END
