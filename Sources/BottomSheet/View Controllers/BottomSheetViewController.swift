//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Adam Foot on 16/06/2021.
//

import UIKit
import SwiftUI
import Combine

@available(iOS 15, *)
class BottomSheetViewController<Content: View>: UIViewController, UISheetPresentationControllerDelegate {
    @Binding private var isPresented: Bool
    @Binding private var currentDetent: UISheetPresentationController.Detent.Identifier?
    
    private let detents: [UISheetPresentationController.Detent]
    private let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let prefersGrabberVisible: Bool
    private let prefersScrollingExpandsWhenScrolledToEdge: Bool
    private let prefersEdgeAttachedInCompactHeight: Bool
    private let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    
    private let contentView: UIHostingController<Content>
    
    init(
        isPresented: Binding<Bool>,
        currentDetent: Binding<UISheetPresentationController.Detent.Identifier?> = .constant(nil),
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier:  UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        content: Content
    ) {
        _isPresented = isPresented
        _currentDetent = currentDetent
        
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        
        self.contentView = UIHostingController(rootView: content)
        
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = isModalInPresentation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = detents
            presentationController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
            presentationController.prefersGrabberVisible = prefersGrabberVisible
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            presentationController.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            presentationController.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
            presentationController.delegate = self
            
            if let currentDetent = currentDetent {
                presentationController.selectedDetentIdentifier = currentDetent
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isPresented = false
    }
    
    func updateCurrentDetent(to identifier: UISheetPresentationController.Detent.Identifier?) {
        self.sheetPresentationController?.animateChanges {
            self.sheetPresentationController?.selectedDetentIdentifier = currentDetent
        }
    }
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        self.currentDetent = sheetPresentationController.selectedDetentIdentifier
    }
    
}
