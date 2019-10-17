//
//  SwiftUIPresenter.swift
//  Workflow
//
//  Created by Tyler Thompson on 10/17/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension FlowRepresentable where Self: View {
    typealias Body = AnyView
    var erasedBody:Any {
        return body
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct WorkflowView: View, Presenter {
    public init() { }

    public func abandon(_ workflow: Workflow, animated: Bool, onFinish: (() -> Void)?) {
        currentView = AnyView(EmptyView())
    }

    public func launch(view:AnyView, from root:AnyView, withLaunchStyle launchStyle: PresentationType) {
        currentView = view
    }

    public init(workflow:Workflow) {
        workflow.applyPresenter(self)
        _ = workflow.launch(from: body, with: nil)
    }

    @State var currentView:AnyView = AnyView(Text("WRONG"))

    public var body: AnyView {
        currentView
    }
}
