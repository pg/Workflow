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
public class WorkflowModel: ObservableObject {
    @Published var view:AnyView = AnyView(EmptyView())
    @Published var previousView:AnyView = AnyView(EmptyView())
    @Published var launchStyle:PresentationType = .default {
        willSet(this) {
            shouldPresentModally = this == .modally
            shouldPresentWithNavigationStack = this == .navigationStack
        }
    }
    @Published var shouldPresentModally = false
    @Published var shouldPresentWithNavigationStack = false
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct WorkflowView: View, Presenter {
    @ObservedObject var currentView:WorkflowModel = WorkflowModel()

    public init() { }
    
    public func abandon(_ workflow: Workflow, animated: Bool, onFinish: (() -> Void)?) {
        currentView.launchStyle = .default
        currentView.view = AnyView(EmptyView())
    }

    public func launch(view:AnyView, from root:AnyView, withLaunchStyle launchStyle: PresentationType) {
        currentView.previousView = AnyView(root)
        currentView.view = view
        currentView.launchStyle = launchStyle
    }

    public init(workflow:Workflow, with args:Any?, withLaunchStyle launchStyle:PresentationType = .default, onFinish:((Any?) -> Void)? = nil) {
        workflow.applyPresenter(self)
        _ = workflow.launch(from: body, with: args, withLaunchStyle: launchStyle, onFinish: onFinish)
    }

    public var body: AnyView {
        switch currentView.launchStyle {
            case .modally: return AnyView(currentView.previousView.popover(isPresented: $currentView.shouldPresentModally, content: { self.currentView.view }))
            case .navigationStack: return AnyView(
                NavigationView {
                    VStack {
                        NavigationLink(destination: currentView.view, isActive: $currentView.shouldPresentWithNavigationStack) { currentView.previousView }
                    }
                }
            )
            case .default: return currentView.view
        }
    }
}
