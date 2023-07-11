//
//  LPPageDomManager.h
//  LPPoint
//
//  Created by 方焘 on 2023/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPDomNodeModel;
@interface LPPageDomManager : NSObject

/// 开始初始化服务端类树以及埋点列表
/// - Parameter nodeCode: 根节点code
- (void)startInitiateClassModelAndPointWithRootNodeCode:(NSString *)nodeCode;
- (void)addPageNode:(LPDomNodeModel *)nodeModel;
@end

NS_ASSUME_NONNULL_END
