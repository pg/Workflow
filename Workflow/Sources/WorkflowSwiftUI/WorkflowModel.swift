//
//  WorkflowModel.swift
//  
//
//  Created by Tyler Thompson on 12/5/20.
//

import Foundation
import SwiftUI
import Workflow

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class WorkflowModel: ObservableObject, AnyOrchestrationResponder {
    @Published var view = AnyView(EmptyView())
    var stack = LinkedList<ViewHolder>()

    var launchStyle: LaunchStyle.PresentationType = .default

    public func launch(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData)) {
        guard let next = to.instance.value?.underlyingInstance as? AnyView else { return }
        stack.append(ViewHolder(view: next, metadata: to.metadata))

        handleLaunch(next, to)
    }

    private func handleLaunch(_ next: AnyView, _ to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData)) {
        var v = next

        switch LaunchStyle.PresentationType(rawValue: to.metadata.launchStyle) ?? .default {
            case .modal(let style): v = AnyView(ModalWrapper(next: v, current: AnyView(EmptyView()), style: style).environmentObject(self).environmentObject(stack.first!.value))
            case .navigationStack: v = AnyView(NavigationView { v })
            default: break
        }

        switch launchStyle {
            case .modal(let style): v = AnyView(ModalWrapper(next: v, current: AnyView(EmptyView()), style: style).environmentObject(self).environmentObject(stack.first!.value))
            case .navigationStack: v = AnyView(NavigationView { v })
            case .default: break
        }
        self.view = v
    }

    public func proceed(to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData),
                        from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData)) {
        guard let next = to.instance.value?.underlyingInstance as? AnyView else { return }
        stack.append(ViewHolder(view: next, metadata: to.metadata))
        present(view: next)
    }

    private func present(view next: AnyView) {
        var v = next
        _ = stack.last?.traverse(direction: .backward) { node in
            guard let nextNode = node.next else { return false } // NOTE: Barring some threading crazy, this should never be nil

            switch LaunchStyle.PresentationType(rawValue: nextNode.value.metadata.launchStyle) ?? .default {
                case .modal(let style): v = AnyView(ModalWrapper(next: v, current: node.value.view, style: style).environmentObject(self).environmentObject(node.value))
                case .navigationStack:
                    let navWrapper = AnyView(NavWrapper(next: v, current: node.value.view).environmentObject(self).environmentObject(node.value))
                    guard self.launchStyle != .navigationStack else {
                        v = navWrapper
                        break
                    }
                    guard node.previous != nil else {
                        v = AnyView(NavigationView { navWrapper })
                        break
                    }

                    if let style = LaunchStyle.PresentationType(rawValue: node.value.metadata.launchStyle),
                       style != .navigationStack {
                        v = AnyView(NavigationView { navWrapper })
                        break
                    }
                    v = navWrapper
                default: return false
            }

            if node === stack.first {
                if case .modal(let style) = LaunchStyle.PresentationType(rawValue: node.value.metadata.launchStyle) {
                    v = AnyView(ModalWrapper(next: v, current: AnyView(EmptyView()), style: style).environmentObject(self).environmentObject(node.value))
                }
                switch self.launchStyle {
                    case .modal(let style):
                        v = AnyView(ModalWrapper(next: v, current: AnyView(EmptyView()), style: style).environmentObject(self).environmentObject(node.value))
                    case .navigationStack:
                        v = AnyView(NavigationView { v })
                    default: break
                }
            }

            return false
        }
        view = v
    }

    #warning("TEST THIS")
    public func proceedBackward(from: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData),
                                to: (instance: AnyWorkflow.InstanceNode, metadata: FlowRepresentableMetaData)) {
        stack.removeLast()
        guard let prev = to.instance.value?.underlyingInstance as? AnyView,
              !stack.isEmpty else { return }

        if let last = stack.last {
            last.value = last.value.copy
        }

        if stack.count == 1 {
            handleLaunch(prev, to)
        } else {
            present(view: prev)
        }
    }

    public func abandon(_ workflow: AnyWorkflow, animated: Bool, onFinish: (() -> Void)?) {
        view = AnyView(EmptyView())
    }
}
