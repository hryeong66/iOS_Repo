//
//  PetViewModel.swift
//  practice-MVVM
//
//  Created by 장혜령 on 2021/04/18.
//

import UIKit

public class PetViewModel{
    // 1) Pet 객체 생성
    private let pet : Pet
    private let calendar : Calendar
    
    public init(pet: Pet){
        self.pet = pet
        calendar = Calendar(identifier: .gregorian)
    }
    
    // 2) getting
    
    public var name: String{
        return pet.name
    }
    
    public var image: UIImage{
        return pet.image
    }
    
    public var ageText: String{
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        let age = components.year!
        return "\(age) years old"
    }
    
    public var adoptionFeeText: String{
        switch pet.rarity {
        case .common:
            return "500won"
        case .uncommon:
            return "1000won"
        case .rare:
            return "1500won"
        case .veryrare:
            return "5000won"
        }
    }
}
