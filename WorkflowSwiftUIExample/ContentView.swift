//
//  ContentView.swift
//  WorkflowSwiftUIExample
//
//  Created by Tyler Thompson on 10/16/19.
//  Copyright © 2019 Tyler Thompson. All rights reserved.
//

import SwiftUI
import Workflow
struct ContentView: View {
    var body: some View {
        WorkflowView(workflow: [
            TestView.self,
            TestView2.self,
            TestView3.self
        ], with: "test")
    }
}

struct TestView: View, FlowRepresentable {
    typealias IntakeType = Never
    
    var preferredLaunchStyle: PresentationType
    weak var workflow: Workflow?
    var callback: ((Any?) -> Void)?
    
    static func instance() -> AnyFlowRepresentable {
        return TestView(preferredLaunchStyle: .default)
    }
    
    var body:AnyView {
        AnyView(
            Button(action: {
                self.proceedInWorkflow("")
            }) {
                Text("Next")
            }
        )
    }
}

struct TestView2: View, FlowRepresentable {
    typealias IntakeType = Never
    
    var preferredLaunchStyle: PresentationType
    weak var workflow: Workflow?
    var callback: ((Any?) -> Void)?
    
    static func instance() -> AnyFlowRepresentable {
        return TestView2(preferredLaunchStyle: .navigationStack)
    }
    
    var body:AnyView {
        AnyView(
            Button(action: {
                self.proceedInWorkflow()
            }) {
                Text("Almost!!")
            }
        )
    }
}

struct TestView3: View, FlowRepresentable {
    typealias IntakeType = Never

    var preferredLaunchStyle: PresentationType
    weak var workflow: Workflow?
    var callback: ((Any?) -> Void)?
    
    static func instance() -> AnyFlowRepresentable {
        return TestView3(preferredLaunchStyle: .navigationStack)
    }
    
    var body:AnyView {
        AnyView(
            Button(action: {
                self.workflow?.abandon()
            }) {
                Text("Fin.")
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
