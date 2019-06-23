//
//  MainVC.swift
//  ZarinPal
//
//  Created by Mahdi Mahjoobi on 6/21/19.
//  Copyright © 2019 Mahdi Mahjoobi. All rights reserved.
//

import UIKit
import ZarinPalSDKPayment

class MainVC: UIViewController {
    
    let productArray = [
        Product(name: "MacBook", imageName: "mac", price: 1500),
        Product(name: "iPhone Xs", imageName: "iphone", price: 1500),
        Product(name: "iWatch", imageName: "watch", price: 1500),
        Product(name: "iPad", imageName: "ipad", price: 1500),
        Product(name: "iPhone X", imageName: "iphone", price: 1500)
    ]
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
    }
    
    func showPayVC(price: Int) {
        let zarinPal = ZarinPal.Builder(vc: self, merchantID: "71c705f8-bd37-11e6-aa0c-000c295eb8fc", amount: price, description: "test")
        zarinPal.indicatorColor = .darkGray
        zarinPal.pageBackgroundColor = .lightGray
        zarinPal.title = "Payment"
        zarinPal.email = "test@gmail.com"
        zarinPal.mobile = "09121789809"
        zarinPal.build().start(delegate: self)
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? ProductTableViewCell {
            cell.item = productArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "پیام", message: "ایا مایل به خرید این کالا هستید؟", preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "تایید", style: .default) { acceptAction in
            self.showPayVC(price: self.productArray[indexPath.row].price)
        }
        let cancel = UIAlertAction(title: "بازگشت", style: .cancel, handler: nil)
        
        alert.addAction(accept)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension MainVC: ZarinPalPaymentDelegate {
    
    func didSuccess(refID: String, authority: String, builder: ZarinPal.Builder) {
        DispatchQueue.main.async {
            self.statusLbl.text = "status: \(refID)"
        }
    }
    
    func didFailure(code: Int, authority: String?) {
        DispatchQueue.main.async {
            self.statusLbl.text = "error: \(code)"
        }
    }
    
}
