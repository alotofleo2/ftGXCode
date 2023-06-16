//
//  UIView+LPDomExtend.h
//  LPPoint
//
//  Created by 方焘 on 2023/4/10.
//

#import <UIKit/UIKit.h>
#import "LPDomNodeModel.h"

@interface UIView (LPDomExtend)
@property (nonatomic, strong, setter=lk_setDomNodeModel:) LPDomNodeModel *lp_domNodeModel;

/// 判断是否为元素节点 通过是否已启用node模型判断
- (BOOL)lp_isKeyNode;


/// 根据SPM查找对应View
/// - Parameter spm: spm
- (UIView *)lp_findViewBySPM:(NSString *)spm;

/// 当前view的SPM
- (NSString *)lp_currentNodeSPM;

- (void)lp_bindEventsWithSPM:(NSString *)spm eventType:(NSInteger)eventType reportParameters:(NSDictionary *)reportParameters;
@end
