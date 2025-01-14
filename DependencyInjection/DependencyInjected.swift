//
//  DependencyInjected.swift
//  Workflow
//
//  Created by Tyler Thompson on 12/17/19.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

import Foundation
import Swinject

@propertyWrapper
public struct DependencyInjected<Value> {
    let name:String?
    let container:Container
    
    public init(wrappedValue value: Value?) {
        name = nil
        container = Workflow.defaultContainer
    }
    public init(wrappedValue value: Value? = nil, name:String) {
        self.name = name
        container = Workflow.defaultContainer
    }

    public init(wrappedValue value: Value? = nil, container containerGetter:@autoclosure () -> Container, name:String? = nil) {
        self.name = name
        container = containerGetter()
    }

    public lazy var wrappedValue: Value? = {
        container.resolve(Value.self, name: name)
    }()
}
