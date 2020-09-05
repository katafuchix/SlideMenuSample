//
//  ViewController.swift
//  SlideMenuSample
//
//  Created by cano on 2020/09/05.
//  Copyright © 2020 cano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var rightMenuView: UIView!
    @IBOutlet weak var rightMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    let MENU_WIDTH: CGFloat = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpViews()
        self.bind()
    }

    func setUpViews() {
        self.rightMenuConstraint.constant = self.view.frame.width
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    func bind() {
        self.menuButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
            if self.rightMenuConstraint.constant == self.view.frame.width {
                self.showMenu()
            } else {
                self.hideMenu()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func showMenu(){
        self.view.bringSubviewToFront(self.rightMenuView)
        UIView.animate(withDuration: 0.2, animations: {
            self.rightMenuConstraint.constant = self.view.frame.size.width - self.MENU_WIDTH
            self.view.layoutIfNeeded()
            },completion: nil
        )
    }
    
    func hideMenu(){
        UIView.animate(withDuration: 0.2, animations: {
            self.rightMenuConstraint.constant = self.view.frame.size.width
            self.view.layoutIfNeeded()
            }, completion: nil
        )
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.menuCell, for: indexPath)!
        cell.menuLabel.text = "menu \(indexPath.row)"
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.label.text = "selected menu\(indexPath.row)"
        self.hideMenu()
    }
}
