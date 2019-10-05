//
//  MockPresenter.swift
//  WorkflowExampleTests
//
//  Created by Tyler Thompson on 10/5/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import Foundation
@testable import DynamicWorkflow

class MockPresenter: Presenter {
    var abandonCalled = 0
    var lastWorkflow:Workflow?
    var lastAnimated:Bool?
    func abandon(_ workflow: Workflow, animated: Bool, onFinish: (() -> Void)?) {
        abandonCalled += 1
        lastWorkflow = workflow
        lastAnimated = animated
        onFinish?()
    }
    required init() { }
}