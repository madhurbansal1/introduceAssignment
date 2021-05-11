//
//  UIExtensions.swift
//  introduceAssignment
//
//  Created by madhur bansal on 5/11/21.
//

import Foundation
import UIKit

// MARK:  UITextfield

extension UITextField
{
    func setIndendation(left:CGFloat,right:CGFloat)
    {
        let lPadding = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
        let rPadding = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.height))
        leftView = lPadding
        rightView = rPadding
        leftViewMode = UITextField.ViewMode.always
        rightViewMode = UITextField.ViewMode.always
    }
}

// MARK:  UIViewController
extension UIViewController
{
    private static let association = ObjectAssociation<UIActivityIndicatorView>()

    var indicator: UIActivityIndicatorView {
        
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(at: self.view.center)
                return UIViewController.association[self]!
            }
        }
    }

    public func startAtcivityIndicator()
    {
        DispatchQueue.main.async
        {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }

    public func stopActivityIndicator()
    {
        DispatchQueue.main.async
            {
                self.indicator.stopAnimating()
            }
    }
    
    public func presentAlertController(_ heading:String,_ message:String)
    {
        let alert = UIAlertController(title: heading, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension Date
{
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}

public final class ObjectAssociation<T: AnyObject>
{
    private let policy: objc_AssociationPolicy
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    {
        self.policy = policy
    }
    public subscript(index: AnyObject) -> T?
    {
        get
        {
            return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T?
        }
        set
        {
            objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy)
        }
    }
}

extension UIActivityIndicatorView
{
    public static func customIndicator(at center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        indicator.layer.cornerRadius = 10
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5)
        return indicator
    }
}

// MARK:  UIImageView

extension UIImageView
{
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

// MARK:  UIView

extension UIView
{
    func bindFrameToSuperviewBounds()
    {
        guard let superview = self.superview else
        {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}

