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
            TestView.self
        ])
    }
}

struct TestView: View, FlowRepresentable {
    func shouldLoad(with args: Never?) -> Bool { return true }
    
    var preferredLaunchStyle: PresentationType
    
    weak var workflow: Workflow?
    
    var callback: ((Any?) -> Void)?
    
    static func instance() -> AnyFlowRepresentable {
        return TestView(preferredLaunchStyle: .default)
    }
    
    var body:AnyView {
        AnyView(
           Text("First!")
        )
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
