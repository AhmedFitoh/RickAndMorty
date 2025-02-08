//
//  SwiftUITableViewCell.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

class SwiftUITableViewCell<Content: View>: UITableViewCell {
    private var hostingController: UIHostingController<Content>?
    
    func configure(with view: Content) {
        if hostingController == nil {
            let controller = UIHostingController(rootView: view)
            hostingController = controller
            
            contentView.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            hostingController?.rootView = view
        }
        
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
