//
//  ViewController.swift
//  arc-example
//
//  Created by danny.santoso on 07/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    var reference1: Person?
    var reference2: Person?
    var reference3: Person?
    
    let queue = DispatchQueue(label: "...")
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strongReferences()
    }
    
    private func strongReferences() {
        reference1 = Person(name: "Danny")
        
        reference2 = reference1
        reference3 = reference1
        
        reference1 = nil
        reference2 = nil
    }
    
    private func weakReferences() {
        var memberDicoding: Person?
        var dicodingSpace: Apartment?
        
        memberDicoding = Person(name: "Danny")
        dicodingSpace = Apartment(unit: "Dicoding Academy")
        
        memberDicoding!.apartment = dicodingSpace
        dicodingSpace!.tenant = memberDicoding
        
        memberDicoding = nil
        dicodingSpace = nil
    }
    
    private func unownedReferences() {
        var memberDicoding: Person?
        memberDicoding = Person(name: "Danny")
        memberDicoding!.number = PhoneNumber(number: 62810_8108_1081, owner: memberDicoding!)
        
        memberDicoding = nil
    }
    
    private func autoreleasepoolloadImages() {
        let url = URL(string: "https://picsum.photos/200")!
        
        for _ in 0...500 {
            queue.async { [unowned self] in
                autoreleasepool {
                    guard let data = try? Data(contentsOf: url),
                          let image = UIImage(data: data) else {
                              return
                          }
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
}

class Person {
    let name: String
    var apartment: Apartment?
    var number: PhoneNumber?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    weak var tenant: Person?
    
    init(unit: String) {
        self.unit = unit
    }
    
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

class PhoneNumber {
    let number: UInt64
    unowned let owner: Person
    
    init(number: UInt64, owner: Person) {
        self.number = number
        self.owner = owner
    }
    
    deinit {
        print("Phone number +\(number) is being deinitialized")
    }
}
