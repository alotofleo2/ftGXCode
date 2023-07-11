//
//  LPPointEventModel.h
//  LPPoint
//
//  Created by 方焘 on 2023/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPointEventModel : NSObject
/**
 "eventName" : "【必选】事件名",
 "eventId" : "【必选】事件ID 服务端的id,当事件出现问题被上报时可以用于快速查找事件",
  "nodeId" : "【必选】服务端 节点id 在一个code下会创建多个node实例 这个id 表达实例唯一id",
  "eventType" : "【必选】事件类型 click/exposure/browse",
  //【可选】参数映射 用于需要上传参数的订阅
  "paramMaps" : [
      {
          "path" : "【必选】el表达式,定位参数keyPath,"
          "alias" : "【必选】三方上传时的别名 当为空或者缺失时按原名上传"
          "type" : "【必选】参数类型 number/string"
      },{xxx},...
  ],
  "privateParams" : "【可选】私有参数,k-v结构  与 映射参数一起上传" ,
  "useActionRefersCount" : "【可选】上传点击事件归因参数个数 默认0不上传",
  "usePgRefersCount" : "【可选】上传页面事件归因参数个数  默认0不上传"
 */

/**【必选】事件名*/
@property (nonatomic, copy) NSString *eventName;
@end

NS_ASSUME_NONNULL_END
