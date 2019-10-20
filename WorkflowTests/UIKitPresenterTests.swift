//
//  UIKitPresenterTests.swift
//  WorkflowTests
//
//  Created by Tyler Thompson on 8/26/19.
//  Copyright © 2019 Tyler Tompson. All rights reserved.
//

import Foundation
import XCTest

@testable import Workflow

class UIKitPresenterTests: XCTestCase {
    func testWorkflowCanLaunchViewController() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?
            
            typealias IntakeType = Void?
            
            typealias OutputType = IntakeType
            
            static func instance() -> AnyFlowRepresentable {
                return FR1()
            }
            
            func shouldLoad(with args: Void?) -> Bool {
                return true
            }
        }
        let flow:Workflow = [FR1.self]
        
        let root = UIViewController()
        loadView(controller: root)
        
        root.launchInto(flow)
        
        XCTAssert(UIApplication.topViewController() is FR1)
    }
    
    func testWorkflowCanSkipTheFirstView() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?

            typealias IntakeType = String?

            typealias OutputType = IntakeType

            static func instance() -> AnyFlowRepresentable {
                return FR1()
            }

            func shouldLoad(with args: String?) -> Bool {
                return false
            }
        }
        class FR2:UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?

            typealias IntakeType = Int?

            typealias OutputType = Array<Int>

            static func instance() -> AnyFlowRepresentable {
                return FR2()
            }

            func shouldLoad(with args: Int?) -> Bool {
                return true
            }
        }
        let flow:Workflow = [FR1.self, FR2.self]

        let root = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = root

        root.launchInto(flow)

        XCTAssert(UIApplication.topViewController() is FR2)
    }
    
    func testWorkflowCanPushOntoExistingNavController() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?
            
            typealias IntakeType = Void?
            
            typealias OutputType = IntakeType
            
            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }
            
            func shouldLoad(with args: Void?) -> Bool {
                return true
            }
        }
        let root = UIViewController()
        root.view.backgroundColor = .blue
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)

        root.launchInto([FR1.self])
        
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssert(nav.visibleViewController is FR1)
        XCTAssert(nav.viewControllers.last is FR1)
    }
    
    func testAbandonWorkflowWithoutNavigationController() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?

            typealias IntakeType = Void?

            typealias OutputType = IntakeType

            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }

            func shouldLoad(with args: Void?) -> Bool {
                return true
            }
        }
        
        let root = UIViewController()
        root.view.backgroundColor = .blue
        loadView(controller: root)
        
        let wf:Workflow = [FR1.self]
        
        root.launchInto(wf)
        
        waitUntil(UIApplication.topViewController() is FR1)
        
        (UIApplication.topViewController() as? FR1)?.abandonWorkflow()
        
        waitUntil(!(UIApplication.topViewController() is FR1))
        
        XCTAssert(UIApplication.topViewController() === root)
    }
    
    func testAbandonWorkflowWithNavigationController() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?

            var callback: ((Any?) -> Void)?

            typealias IntakeType = Void?

            typealias OutputType = IntakeType

            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }
            
            func shouldLoad(with args: Void?) -> Bool {
                return true
            }
        }
        
        let root = UIViewController()
        root.view.backgroundColor = .blue
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        let wf:Workflow = [FR1.self]
        
        root.launchInto(wf)
        
        waitUntil(UIApplication.topViewController() is FR1)
        
        (UIApplication.topViewController() as? FR1)?.abandonWorkflow()
        
        waitUntil(!(UIApplication.topViewController() is FR1))
        
        XCTAssert(UIApplication.topViewController() === root)
    }
    
    func testAbandonWorkflowWithNavigationControllerWhichHasSomeViewControllersAlready() {
        class FR1: UIViewController, FlowRepresentable {
            var preferredLaunchStyle: PresentationType = .default

            var presenter: AnyPresenter?
            
            var workflow: Workflow?
            
            var callback: ((Any?) -> Void)?
            
            typealias IntakeType = Void?
            
            typealias OutputType = IntakeType
            
            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }
            
            func shouldLoad(with args: Void?) -> Bool {
                return true
            }
        }
        
        let root = UIViewController()
        root.view.backgroundColor = .blue
        let second = UIViewController()
        root.view.backgroundColor = .red
        let nav = UINavigationController(rootViewController: root)
        nav.pushViewController(second, animated: false)
        loadView(controller: nav)
        
        let wf:Workflow = [FR1.self]
        
        root.launchInto(wf)
        
        waitUntil(UIApplication.topViewController() is FR1)
        
        (UIApplication.topViewController() as? FR1)?.abandonWorkflow()
        
        waitUntil(!(UIApplication.topViewController() is FR1))
        
        XCTAssert(UIApplication.topViewController() === second)
    }
    
    func testLaunchWorkflowWithArguments() {
        class FR1: UIWorkflowItem<Int>, FlowRepresentable {
            static var shouldLoadCalled = false
            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }
            
            func shouldLoad(with args: Int) -> Bool {
                FR1.shouldLoadCalled = true
                return true
            }
        }
        
        let root = UIViewController()
        root.view.backgroundColor = .blue
        loadView(controller: root)
        
        let wf:Workflow = [FR1.self]
        
        root.launchInto(wf, args: 1)
        
        waitUntil(UIApplication.topViewController() is FR1)
        
        XCTAssert(FR1.shouldLoadCalled)
    }
    
    func testCreateViewControllerWithBaseClassForEase() {
        class FR1: UIWorkflowItem<Int>, FlowRepresentable {
            static var shouldLoadCalled = false
            static func instance() -> AnyFlowRepresentable {
                let vc = FR1()
                vc.view.backgroundColor = .green
                return vc
            }
            
            func shouldLoad(with args: Int) -> Bool {
                FR1.shouldLoadCalled = true
                return true
            }
        }
        
        let root = UIViewController()
        root.view.backgroundColor = .blue
        loadView(controller: root)
        
        let wf:Workflow = [FR1.self]
        
        root.launchInto(wf, args: 20000)
        
        waitUntil(UIApplication.topViewController() is FR1)
        
        XCTAssert(FR1.shouldLoadCalled)
    }
    
    private func loadView(controller: UIViewController) {
        let window = UIApplication.shared.keyWindow
        window?.removeViewsFromRootViewController()
        
        window?.rootViewController = controller
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
        
        controller.viewWillAppear(false)
        controller.viewDidAppear(false)
        
        CATransaction.flush()
    }

    static var testCallbackCalled = false
    let testCallback = {
        UIKitPresenterTests.testCallbackCalled = true
    }
    override func setUp() {
        UIKitPresenterTests.testCallbackCalled = false
        UIKitPresenterTests.viewDidLoadOnMockCalled = 0
        UIViewController.initializeTestable()
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        UIViewController.flushPendingTestArtifacts()
    }

    func testFlowCanBeFullyFollowed() {
        class FR1: TestViewController { }
        class FR2: TestViewController { }
        class FR3: TestViewController { }
        class FR4: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self])
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
    }
    
    func testFlowPresentsOnNavStackWhenNavHasNoRoot() {
        class FR1: TestViewController { }
        
        let nav = UINavigationController()
        loadView(controller: nav)
        
        nav.launchInto([FR1.self])
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssertNil(nav.mostRecentlyPresentedViewController)
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
        XCTAssertEqual(UIApplication.topViewController()?.navigationController?.viewControllers.count, 1)
        XCTAssert(UIApplication.topViewController()?.navigationController?.visibleViewController is FR1)
    }

    func testFlowPresentsOnNavStackWhenNavHasNoRootAndNavigationStackLaunchStyle() {
        class FR1: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .navigationStack
            }
        }
        
        let nav = UINavigationController()
        loadView(controller: nav)
        
        nav.launchInto([FR1.self], withLaunchStyle: .navigationStack)
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssertNil(nav.mostRecentlyPresentedViewController)
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
        XCTAssert(UIApplication.topViewController()?.navigationController === nav)
        XCTAssertEqual(UIApplication.topViewController()?.navigationController?.viewControllers.count, 1)
        XCTAssert(UIApplication.topViewController()?.navigationController?.visibleViewController is FR1)
    }

    func testFlowThatSkipsScreen() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                return false
            }
        }
        class FR3: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self])
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
    }

    func testFlowThatSkipsScreenIfThatScreenIsFirst() {
        class FR1: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                return false
            }
        }
        class FR2: TestViewController { }
        class FR3: TestViewController { }
        class FR4: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self])
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
    }

    func testFlowThatSkipsScreenButStillPassesData() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                proceedInWorkflow(args)
                return false
            }
        }
        class FR3: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self])
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow("worked")
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        XCTAssertEqual((UIApplication.topViewController() as? FR3)?.data as? String, "worked")
    }
    
    func testWorkflowLaunchingWorkflow() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            func launchSecondary() {
                let wf:Workflow = [FR_1.self]
                launchInto(wf) { args in
                    self.data = args
                    wf.abandon(animated: false)
                }
            }
        }
        class FR3: TestViewController { }
        class FR_1: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self])
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        (UIApplication.topViewController() as? FR2)?.launchSecondary()
        waitUntil(UIApplication.topViewController() is FR_1)
        class Obj { }
        let obj = Obj()
        (UIApplication.topViewController() as? FR_1)?.proceedInWorkflow(obj)
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert((UIApplication.topViewController() as? FR2)?.data as? Obj === obj)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
    }
    
    func testCallingThroughMultipleSkippedWorkflowItems() {
        class FR1: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                proceedInWorkflow(args)
                return false
            }
        }
        class FR2: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                proceedInWorkflow(args)
                return false
            }
        }
        class FR3: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                proceedInWorkflow(args)
                return false
            }
        }
        class FR4: TestViewController { }
        class Obj { }
        let obj = Obj()
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], args: obj)
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
        XCTAssert((UIApplication.topViewController() as? FR4)?.data as? Obj === obj)
    }

    func testFinishingWorkflowCallsBack() {
        class FR1: TestViewController { }
        class FR2: TestViewController { }
        class FR3: TestViewController { }
        class FR4: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        class Obj { }
        let obj = Obj()
        
        var callbackCalled = false
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], args: obj) { args in
            callbackCalled = true
            XCTAssert(args as? Obj === obj)
        }
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.next()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        (UIApplication.topViewController() as? FR2)?.next()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.next()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
        (UIApplication.topViewController() as? FR4)?.next()
        XCTAssert(callbackCalled)
    }

    func testFinishingWorkflowCallsBackEvenIfLastViewIsSkipped() {
        class FR1: TestViewController { }
        class FR2: TestViewController { }
        class FR3: TestViewController { }
        class FR4: TestViewController {
            override func shouldLoad(with args: Any?) -> Bool {
                self.data = args
                return false
            }
        }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        class Obj { }
        let obj = Obj()
        
        var callbackCalled = false
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], args: obj) { args in
            callbackCalled = true
            XCTAssert(args as? Obj === obj)
        }
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        (UIApplication.topViewController() as? FR1)?.next()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        (UIApplication.topViewController() as? FR2)?.next()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.next()
        XCTAssert(callbackCalled)
    }

    static var viewDidLoadOnMockCalled = 0
    func testViewDidLoadGetsCalledWhereAppropriate() {
        UIKitPresenterTests.viewDidLoadOnMockCalled = 0
        
        class FR1: TestViewController { }
        class FR2: TestViewController { }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, MockFlowRepresentable.self, FR2.self])

        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        
        //Go forward to mock
        (UIApplication.topViewController() as? FR1)?.next()
        waitUntil(UIApplication.topViewController() is MockFlowRepresentable)
        XCTAssertEqual(UIKitPresenterTests.viewDidLoadOnMockCalled, 1)

        // Go to Final
        (UIApplication.topViewController() as? MockFlowRepresentable)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: false)

        // Go back to Mock
        waitUntil(UIApplication.topViewController() is MockFlowRepresentable)
        XCTAssertEqual(UIKitPresenterTests.viewDidLoadOnMockCalled, 1)

        // Go back to First
        UIApplication.topViewController()?.navigationController?.popViewController(animated: false)
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)

        // Go forward to Mock
        (UIApplication.topViewController() as? FR1)?.next()

        waitUntil(UIApplication.topViewController() is MockFlowRepresentable)
        XCTAssertEqual(UIKitPresenterTests.viewDidLoadOnMockCalled, 2)
    }

    func testWorkflowLaunchModally() {
        class ExpectedModal: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .green
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
        }

        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)

        rootController.launchInto(Workflow([ExpectedModal.self]), withLaunchStyle: .modally)
        RunLoop.current.singlePass()

        XCTAssertEqual(controller.viewControllers.count, 1)
        XCTAssert(rootController.mostRecentlyPresentedViewController is ExpectedModal, "mostRecentlyPresentedViewController should be ExpectedModal: \(String(describing: controller.mostRecentlyPresentedViewController))")
    }

    func testWorkflowLaunchModallyButSecondViewPreferrsANavController() {
        class ExpectedModal: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .green
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }

            override func viewDidAppear(_ animated: Bool) {
                proceedInWorkflow()
            }
        }

        class ExpectedModalPreferNav: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModalPreferNav()
                modal.view.backgroundColor = .blue
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
            override var preferredLaunchStyle: PresentationType {
                return .navigationStack
            }
        }

        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)

        rootController.launchInto(Workflow([ExpectedModal.self, ExpectedModalPreferNav.self]), withLaunchStyle: .modally)
        RunLoop.current.singlePass()

        XCTAssertEqual(controller.viewControllers.count, 1)
        XCTAssert(rootController.mostRecentlyPresentedViewController is ExpectedModal, "mostRecentlyPresentedViewController should be ExpectedModal: \(String(describing: controller.mostRecentlyPresentedViewController))")
        waitUntil(UIApplication.topViewController() is ExpectedModalPreferNav)
        XCTAssert(UIApplication.topViewController() is ExpectedModalPreferNav, "Top view controller should be ExpectedModalPresetNav:\(String(describing: UIApplication.topViewController()))")
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
    }

    func testWorkflowLaunchModallyButFirstViewHasANavController() {
        class ExpectedModal: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .green
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
            override var preferredLaunchStyle: PresentationType {
                return .navigationStack
            }
        }

        let firstView = UIViewController()
        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: firstView)
        firstView.present(controller, animated: false)

        let workflow = Workflow([ExpectedModal.self])
        rootController.launchInto(workflow, withLaunchStyle: .modally)
        RunLoop.current.singlePass()

        XCTAssertEqual(controller.viewControllers.count, 1)
        XCTAssert(rootController.mostRecentlyPresentedViewController is UINavigationController, "mostRecentlyPresentedViewController should be UINavigationController: \(String(describing: rootController.mostRecentlyPresentedViewController))")
        XCTAssertEqual((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.count, 1)
        XCTAssert((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.first is ExpectedModal, "rootViewController should be ExpectedModal: \(String(describing: (rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.first))")
    }

    func testWorkflowAbandonWhenNavControllerOnlyHasOneViewController() {
        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)

        let workflow = Workflow([TestViewController.self])
        rootController.launchInto(workflow)

        waitUntil(UIApplication.topViewController() is TestViewController)

        workflow.abandon(animated: false, onFinish: testCallback)

        waitUntil(UIApplication.topViewController() === rootController)
        XCTAssert(UIApplication.topViewController() === rootController, "Expected top view to be 'rootController' but got: \(String(describing: UIApplication.topViewController()))")
        XCTAssertTrue(UIKitPresenterTests.testCallbackCalled)
    }

    func testWorkflowAbandonWhenNoNavigationControllerExists() {
        let rootController = UIViewController()
        loadView(controller: rootController)

        let workflow = Workflow([TestViewController.self])
        rootController.launchInto(workflow)

        waitUntil(UIApplication.topViewController() is TestViewController)

        workflow.abandon(animated: false, onFinish: testCallback)

        waitUntil(UIApplication.topViewController() === rootController)
        XCTAssert(UIApplication.topViewController() === rootController, "Expected top view to be 'rootController' but got: \(String(describing: UIApplication.topViewController()))")
        XCTAssertTrue(UIKitPresenterTests.testCallbackCalled)
    }

    func testWorkflowAbandonWhenLaunchStyleIsNavigationStack() {
        let rootController = UIViewController()
        loadView(controller: rootController)

        let workflow = Workflow([TestViewController.self])
        rootController.launchInto(workflow, withLaunchStyle: .navigationStack)

        waitUntil(UIApplication.topViewController() is TestViewController)

        workflow.abandon(animated: false, onFinish: testCallback)

        waitUntil(UIApplication.topViewController() === rootController)
        XCTAssert(UIApplication.topViewController() === rootController, "Expected top view to be 'rootController' but got: \(String(describing: UIApplication.topViewController()))")
        XCTAssertTrue(UIKitPresenterTests.testCallbackCalled)
    }
    
    func testAbandonWhenWorkflowHasNavPresentingSubsequentViewsModally() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        class FR3: TestViewController { }
        class FR4: TestViewController { }
        
        let root = UIViewController()
        loadView(controller: root)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], withLaunchStyle: .navigationStack)
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        XCTAssertNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
        (UIApplication.topViewController() as? FR4)?.abandonWorkflow()
        waitUntil(UIApplication.topViewController() === root)
        XCTAssert(UIApplication.topViewController() === root)
    }
    
    func testAbandonWhenWorkflowHasNavPresentingSubsequentViewsModallyAndWithMoreNavigation() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        class FR3: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .navigationStack
            }
        }
        class FR4: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        
        let root = UIViewController()
        loadView(controller: root)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], withLaunchStyle: .navigationStack)
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        XCTAssertNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
        (UIApplication.topViewController() as? FR4)?.abandonWorkflow()
        waitUntil(UIApplication.topViewController() === root)
        XCTAssert(UIApplication.topViewController() === root)
    }
    
    func testAbandonWhenWorkflowHasNavWithStartingViewPresentingSubsequentViewsModallyAndWithMoreNavigation() {
        class FR1: TestViewController { }
        class FR2: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        class FR3: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .navigationStack
            }
        }
        class FR4: TestViewController {
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        
        let root = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        loadView(controller: nav)
        
        root.launchInto([FR1.self, FR2.self, FR3.self, FR4.self], withLaunchStyle: .navigationStack)
        waitUntil(UIApplication.topViewController() is FR1)
        XCTAssert(UIApplication.topViewController() is FR1)
        XCTAssertNotNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR1)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR2)
        XCTAssert(UIApplication.topViewController() is FR2)
        XCTAssertNil(UIApplication.topViewController()?.navigationController)
        (UIApplication.topViewController() as? FR2)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR3)
        XCTAssert(UIApplication.topViewController() is FR3)
        (UIApplication.topViewController() as? FR3)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is FR4)
        XCTAssert(UIApplication.topViewController() is FR4)
        (UIApplication.topViewController() as? FR4)?.abandonWorkflow()
        waitUntil(UIApplication.topViewController() === root)
        XCTAssert(UIApplication.topViewController() === root)
    }
    
    func testWorkflowLaunchModallyButFirstViewHasANavControllerAndThenDismiss() {
        class ExpectedModal: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .green
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
        }
        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)
        
        let workflow = Workflow([TestViewController.self, ExpectedModal.self])
        rootController.launchInto(workflow)
        
        waitUntil(UIApplication.topViewController() is TestViewController)
        (UIApplication.topViewController() as? TestViewController)?.proceedInWorkflow()
        waitUntil(UIApplication.topViewController() is ExpectedModal)
        
        workflow.abandon(animated: false, onFinish: testCallback)
        
        waitUntil(UIApplication.topViewController() === rootController)
        XCTAssert(UIApplication.topViewController() === rootController, "Expected top view to be 'rootController' but got: \(String(describing: UIApplication.topViewController()))")
        XCTAssertTrue(UIKitPresenterTests.testCallbackCalled)
    }
    
    func testWorkflowLaunchWithNavigationStack() {
        class ExpectedController: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let controller = ExpectedController()
                controller.view.backgroundColor = .green
                return controller
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
        }

        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)

        rootController.launchInto(Workflow([ExpectedController.self]), withLaunchStyle: .navigationStack)
        RunLoop.current.singlePass()

        XCTAssertEqual(controller.viewControllers.count, 2)
        XCTAssertFalse(rootController.mostRecentlyPresentedViewController is ExpectedController, "mostRecentlyPresentedViewController should not be ExpectedModal: \(String(describing: controller.mostRecentlyPresentedViewController))")
    }

    func testWorkflowLaunchWithNavigationStackWhenLauncherDoesNotHavNavController() {
        class ExpectedController: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let controller = ExpectedController()
                controller.view.backgroundColor = .green
                return controller
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
        }

        let rootController = UIViewController()
        loadView(controller: rootController)

        rootController.launchInto(Workflow([ExpectedController.self]), withLaunchStyle: .navigationStack)
        RunLoop.current.singlePass()

        XCTAssert(rootController.mostRecentlyPresentedViewController is UINavigationController, "mostRecentlyPresentedViewController should be nav controller: \(String(describing: rootController.mostRecentlyPresentedViewController))")
        XCTAssertEqual((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.count, 1)
        XCTAssert((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.first is ExpectedController)
    }

    func testWorkflowLaunchesWithNavButHasAViewThatPreferrsModalBecauseItCan() {
        class ExpectedModal: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .green
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }
            override var preferredLaunchStyle: PresentationType {
                return .modally
            }
            override func viewDidAppear(_ animated: Bool) {
                proceedInWorkflow()
            }
        }
        class ExpectedNav: UIWorkflowItem<Any?>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let modal = ExpectedModal()
                modal.view.backgroundColor = .blue
                return modal
            }
            func shouldLoad(with args: Any?) -> Bool { return true }

            override func viewDidAppear(_ animated: Bool) {
                proceedInWorkflow()
            }
        }
        let rootController = UIViewController()
        let controller = UINavigationController(rootViewController: rootController)
        loadView(controller: controller)

        rootController.launchInto(Workflow([ExpectedNav.self, ExpectedModal.self]))
        RunLoop.current.singlePass()

        XCTAssertEqual(controller.viewControllers.count, 1)
        (UIApplication.topViewController() as? ExpectedNav)?.proceedInWorkflow()
        XCTAssert(UIApplication.topViewController() is ExpectedModal, "Top View was not a modal")
        XCTAssertNil((UIApplication.topViewController() as? ExpectedModal)?.navigationController, "You didn't present modally")
    }
    
    func testFlowRepresentableThatDoesNotTakeInData() {
        class ExpectedController: UIWorkflowItem<Never>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let controller = ExpectedController()
                controller.view.backgroundColor = .green
                return controller
            }
        }

        let rootController = UIViewController()
        loadView(controller: rootController)

        rootController.launchInto(Workflow([ExpectedController.self]), withLaunchStyle: .navigationStack)
        RunLoop.current.singlePass()

        XCTAssert(rootController.mostRecentlyPresentedViewController is UINavigationController, "mostRecentlyPresentedViewController should be nav controller: \(String(describing: rootController.mostRecentlyPresentedViewController))")
        XCTAssertEqual((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.count, 1)
        XCTAssert((rootController.mostRecentlyPresentedViewController as? UINavigationController)?.viewControllers.first is ExpectedController)
    }

    func testFlowRepresentableThatDoesNotTakeInDataAndOverridesShouldLoad() {
        class ExpectedController: UIWorkflowItem<Never>, FlowRepresentable {
            static func instance() -> AnyFlowRepresentable {
                let controller = ExpectedController()
                controller.view.backgroundColor = .green
                return controller
            }
            func shouldLoad() -> Bool {
                return false
            }
        }

        let rootController = UIViewController()
        loadView(controller: rootController)

        rootController.launchInto(Workflow([ExpectedController.self]))
        RunLoop.current.singlePass()

        XCTAssert(UIApplication.topViewController() === rootController)
    }}

extension UIKitPresenterTests {
    class TestViewController: UIWorkflowItem<Any?>, FlowRepresentable {
        var data:Any?
        static func instance() -> AnyFlowRepresentable {
            let controller = self.init()
            controller.view.backgroundColor = .red
            return controller
        }
        func shouldLoad(with args: Any?) -> Bool {
            self.data = args
            return true
        }
        func next() {
            proceedInWorkflow(data)
        }
    }
}

class MockFlowRepresentable: UIWorkflowItem<Any?>, FlowRepresentable {
    static func instance() -> AnyFlowRepresentable {
        return MockFlowRepresentable()
    }
    
    func shouldLoad(with args: Any?) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        UIKitPresenterTests.viewDidLoadOnMockCalled += 1
    }
}
