//
//  PetModel.swift
//  practice-MVVM
//
//  Created by 장혜령 on 2021/04/18.
//
//import PlaygroundSupport
//조금 더 확장하자면 아예 animal -> 상위 protocol을 만들고 이를 채택하여 사용하도록?

import UIKit

public class Pet {
    public enum Rarity{
        case common
        case uncommon
        case rare
        case veryrare
    }
    
    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage
    
    public init(name: String, birthday: Date, rarity: Rarity, image: UIImage){
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
    
}


