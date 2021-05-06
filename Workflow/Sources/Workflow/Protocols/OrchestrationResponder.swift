//
//  OrchestrationResponder.swift
//  
//
//  Created by Tyler Thompson on 11/24/20.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

import Foundation
/// A type capable of responding to `Workflow` actions.
public protocol OrchestrationResponder {
    /**
     Respond to the `Workflow` launching.
     - Parameter to: Passes the `AnyWorkflow.InstanceNode` and `FlowRepresentableMetadata` so the responder can decide how to launch the first loaded instance.
     */
    func launch(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata))
    /**
     Respond to the `Workflow` proceeding.
     - Parameter to: Passes the `AnyWorkflow.InstanceNode` and `FlowRepresentableMetadata` so the responder can decide how to proceed.
     - Parameter from: Passes the `AnyWorkflow.InstanceNode` and `FlowRepresentableMetadata` so the responder has context on where to proceed from.
     */
    func proceed(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata),
                 from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata))
    /**
     Respond to the `Workflow` backing up.
     - Parameter to: Passes the `AnyWorkflow.InstanceNode` and `FlowRepresentableMetadata` so the responder can decide how to back up.
     - Parameter from: Passes the `AnyWorkflow.InstanceNode` and `FlowRepresentableMetadata` so the responder has context on where to back up from.
     */
    func backUp(from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata),
                to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata))
    func abandon(_ workflow: AnyWorkflow, animated: Bool, onFinish: (() -> Void)?)
}

extension OrchestrationResponder {
    func launchOrProceed(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata),
                         from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetadata)?) {
        if let root = from {
            proceed(to: to, from: root)
        } else {
            launch(to: to)
        }
    }
}