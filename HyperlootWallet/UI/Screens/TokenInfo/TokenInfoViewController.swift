//
//  TokenInfoViewController.swift
//  HyperlootWallet
//
//  Copyright © 2018 Hyperloot DAO. All rights reserved.
//

import UIKit

/*
 TODO: Traits are not supported yet.
 */
class TokenInfoViewController: UIViewController {
    
    struct Input {
        let token: HyperlootToken
        let attributes: HyperlootToken.Attributes?
    }
    
    var input: Input!

    lazy var viewModel = TokenInfoViewModel(token: self.input.token, attributes: self.input.attributes)
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemShortDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        updateUI()
    }
    
    func configureNavigationItem() {
        self.title = "Item Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send item", style: .plain, target: self, action: #selector(sendButtonPressed))
        
        configureBackButtonWithNoText()
    }

    func updateUI() {
        let presentation = viewModel.presentation
        
        itemImageView.setImage(withURL: presentation.itemImageURL, tag: view.tag)
        itemNameLabel.text = presentation.itemName
        itemShortDescriptionLabel.text = presentation.itemShortDescription
        itemPriceLabel.attributedText = presentation.itemPrice
        itemDescriptionLabel.text = presentation.itemDescription
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isEqualTo(route: .sendToken) {
            guard let viewController = segue.destination as? SendViewController else {
                return
            }
            viewController.input = SendViewController.Input(token: viewModel.token)
        }
    }
    @IBAction func sendButtonPressed() {
        performSegue(route: .sendToken)
    }
}
