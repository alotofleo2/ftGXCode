//
//  LPPointTests.m
//  LPPointTests
//
//  Created by 方焘 on 04/10/2023.
//  Copyright (c) 2023 方焘. All rights reserved.
//

@import XCTest;
#import "UIView+LPDomExtend.h"


@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testLPDomFunctionality {
    UIView *rootView = [[UIView alloc] init];
    rootView.lp_domNodeModel.nodeId = @"0";
    rootView.lp_domNodeModel.isRoot = YES;
    
    UIView *childView1 = [[UIView alloc] init];
    childView1.lp_domNodeModel.nodeId = @"1";
    
    UIView *childView2 = [[UIView alloc] init];
    childView2.lp_domNodeModel.nodeId = @"2";
    
    [rootView addSubview:childView1];
    [childView1 addSubview:childView2];
    
    XCTAssert([rootView lp_isKeyNode]);
    XCTAssert([childView1 lp_isKeyNode]);
    XCTAssert([childView2 lp_isKeyNode]);
    
    XCTAssert([rootView lp_currentNodeSPM] && [[rootView lp_currentNodeSPM] isEqualToString:@"0"]);
    XCTAssert([childView1 lp_currentNodeSPM] && [[childView1 lp_currentNodeSPM] isEqualToString:@"0-1"]);
    XCTAssert([childView2 lp_currentNodeSPM] && [[childView2 lp_currentNodeSPM] isEqualToString:@"0-1-2"]);
    
    UIView *foundView1 = [rootView lp_findViewBySPM:@"0-1"];
    XCTAssert(foundView1 == childView1);
    
    UIView *foundView2 = [rootView lp_findViewBySPM:@"0-1-2"];
    XCTAssert(foundView2 == childView2);
    
    UIView *notFoundView = [rootView lp_findViewBySPM:@"0-3"];
    XCTAssert(notFoundView == nil);
    
    NSDictionary *reportParameters = @{@"key": @"value"};
    // 这里 eventType 的值应该根据您具体使用的事件类型常量来设置
    NSInteger eventType = 1;
    
    [rootView lp_bindEventsWithSPM:@"0-1-2" eventType:eventType reportParameters:reportParameters];
    
    // 确保事件已成功绑定，需要根据您实际使用的埋点事件库进行检查
    // 例如：检查是否有正确的观察者、手势识别器等
}
@end

