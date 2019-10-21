//
//  AnyPresenter.swift
//  Workflow
//
//  Created by Tyler Thompson on 8/29/19.
//  Copyright © 2019 Tyler Tompson. All rights reserved.
//

import Foundation
public protocol AnyPresenter {
    init()
    
    func launch(view:WorkflowNode?, from root:Any?, withLaunchStyle launchStyle:PresentationType)
    func abandon(_ workflow:Workflow, animated:Bool, onFinish:(() -> Void)?)
}
