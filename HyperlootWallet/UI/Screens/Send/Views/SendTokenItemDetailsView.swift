//
//  SendTokenItemDetailsView.swift
//  HyperlootWallet
//
//  Copyright © 2018 Hyperloot DAO. All rights reserved.
//

import UIKit
import AlamofireImage

typealias SendTokenItemDetailsPresentation = SendTokenItemDetailsView.Presentation

class SendTokenItemDetailsView: UIView {
    
    struct Presentation {
        let imageURL: String?
        let name: String
        let description: String?
    }

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!

    func update(presentation: SendTokenItemDetailsPresentation) {
        itemImageView.setImage(withURL: presentation.imageURL, tag: tag)
        itemNameLabel.text = presentation.name
        itemDescriptionLabel.text = presentation.description
    }
}
