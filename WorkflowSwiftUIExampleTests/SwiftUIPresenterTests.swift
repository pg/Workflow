//
//  SwiftUIPresenterTests.swift
//  WorkflowTests
//
//  Created by Tyler Thompson on 10/19/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import Foundation
import XCTest
import SwiftUI

@testable import Workflow

class SwiftUIPresenterTests: XCTestCase {
//    func testWorkflowCanLaunchView() {
//    }
//
//    func testWorkflowCanSkipTheFirstView() {
//    }

    func testWorkflowCanPushOntoExistingNavController() {

    }

//    func testAbandonWorkflowWithoutNavigationController() {
//
//    }

    func testAbandonWorkflowWithNavigationController() {

    }

    func testAbandonWorkflowWithNavigationControllerWhichHasSomeViewControllersAlready() {

    }

//    func testLaunchWorkflowWithArguments() {
//
//    }

//    func testFlowCanBeFullyFollowed() {
//    }

    func testFlowPresentsOnNavStackWhenNavHasNoRoot() {
    }

    func testFlowPresentsOnNavStackWhenNavHasNoRootAndNavigationStackLaunchStyle() {
    }

//    func testFlowThatSkipsScreen() {
//    }

//    func testFlowThatSkipsScreenIfThatScreenIsFirst() {
//    }

//    func testFlowThatSkipsScreenButStillPassesData() {
//    }

    func testWorkflowLaunchingWorkflow() {
    }

    func testCallingThroughMultipleSkippedWorkflowItems() {
    }

//    func testFinishingWorkflowCallsBack() {
//    }

    func testFinishingWorkflowCallsBackEvenIfLastViewIsSkipped() {
    }

    func testWorkflowLaunchModally() {
    }

    func testWorkflowLaunchModallyButSecondViewPreferrsANavController() {
    }

    func testWorkflowLaunchModallyButFirstViewHasANavController() {
    }

    func testWorkflowAbandonWhenNavControllerOnlyHasOneViewController() {
    }

    func testWorkflowAbandonWhenNoNavigationControllerExists() {
    }

    func testWorkflowAbandonWhenLaunchStyleIsNavigationStack() {
    }

    func testAbandonWhenWorkflowHasNavPresentingSubsequentViewsModally() {
    }

    func testAbandonWhenWorkflowHasNavPresentingSubsequentViewsModallyAndWithMoreNavigation() {
    }

    func testAbandonWhenWorkflowHasNavWithStartingViewPresentingSubsequentViewsModallyAndWithMoreNavigation() {
    }

    func testWorkflowLaunchModallyButFirstViewHasANavControllerAndThenDismiss() {
    }

    func testWorkflowLaunchWithNavigationStack() {
    }

    func testWorkflowLaunchWithNavigationStackWhenLauncherDoesNotHavNavController() {
    }

    func testWorkflowLaunchesWithNavButHasAViewThatPreferrsModalBecauseItCan() {
    }
}

fileprivate struct MockFlowRepresentable: View, FlowRepresentable {
    var data:Any?
    
    var preferredLaunchStyle: PresentationType = .default
    weak var workflow: Workflow?
    var callback: ((Any?) -> Void)?

    static func instance() -> AnyFlowRepresentable {
        return MockFlowRepresentable()
    }
    
    mutating func shouldLoad(with args: Any?) -> Bool {
        self.data = args
        return true
    }
    
    func next() {
        proceedInWorkflow(data)
    }

    var body:AnyView {
        AnyView(
            VStack {
                Button(action: next) {
                    Text("Next")
                }
            }
        )
    }
}
