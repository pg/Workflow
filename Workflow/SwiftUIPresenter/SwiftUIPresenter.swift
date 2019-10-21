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
public struct NavWrapper: View {
    @State var presented = true
    var destination:AnyView
    var current:AnyView?
    
    public var body: some View {
        NavigationLink(destination: destination, isActive: $presented) {
            current ?? AnyView(EmptyView())
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class WorkflowModel: ObservableObject {
    @Published var view:AnyView = AnyView(EmptyView())
    @Published var currentNode:WorkflowNode?
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
    @ObservedObject var workflowModel:WorkflowModel = WorkflowModel()

    public init() { }
    
    public func abandon(_ workflow: Workflow, animated: Bool, onFinish: (() -> Void)?) {
        workflowModel.launchStyle = .default
        workflowModel.view = AnyView(EmptyView())
    }

    public func launch(view:WorkflowNode, from root:AnyView, withLaunchStyle launchStyle: PresentationType) {
        workflowModel.previousView = AnyView(root)
        workflowModel.currentNode = view
        if let v = view.value?.erasedBody as? AnyView {
            workflowModel.view = v
        }
        workflowModel.launchStyle = launchStyle
    }

    public init(workflow:Workflow, with args:Any?, withLaunchStyle launchStyle:PresentationType = .default, onFinish:((Any?) -> Void)? = nil) {
        workflow.applyPresenter(self)
        _ = workflow.launch(from: body, with: args, withLaunchStyle: launchStyle, onFinish: onFinish)
    }

    public var body: AnyView {
        switch workflowModel.launchStyle {
            case .modally: return AnyView(workflowModel.previousView.popover(isPresented: $workflowModel.shouldPresentModally, content: { self.workflowModel.view }))
            case .navigationStack: return generateNavView()
            case .default: return workflowModel.view
        }
    }
    
    func generateNavView() -> AnyView {
        let currentNode = workflowModel.currentNode
        let currentPosition = currentNode?.position ?? 0
        func generateViewRecursively(node: WorkflowNode?) -> AnyView {
            guard let node = node else { return AnyView(EmptyView()) }
            guard node.position < currentPosition else {
                let current = (currentPosition > 1) ? node.previous?.value?.erasedBody as? AnyView : nil
                return AnyView(
                    NavWrapper(destination: workflowModel.view, current: current)
                )
            }
            if  node.next?.value?.preferredLaunchStyle == .navigationStack {
                return AnyView(
                    NavWrapper(destination: generateViewRecursively(node: node.next))
                )
            }
            return AnyView(EmptyView())
        }
        let firstNavStack = currentNode?.traverse(direction: .backward) {
            $0.value?.preferredLaunchStyle != .navigationStack
        }
        let v = generateViewRecursively(node: firstNavStack?.next)
        return AnyView(
            NavigationView {
                VStack {
                    firstNavStack?.value?.erasedBody as? AnyView ?? AnyView(EmptyView())
                    v
                }
            }
        )
    }
}
