//
//  Iterator.swift
//  iOSCSS
//
//  Created by Tyler Thompson on 11/11/18.
//  Copyright © 2021 WWT and Tyler Thompson. All rights reserved.
//

import Foundation
extension LinkedList {
    public struct LinkedListIterator<N: Element>: IteratorProtocol {
        public typealias Element = N
        var element:N?
        
        init(_ node:N?) {
            element = node
        }
        
        mutating public func next() -> N? {
            let e = element
            element = element?.next as? N
            return e
        }
    }
}
