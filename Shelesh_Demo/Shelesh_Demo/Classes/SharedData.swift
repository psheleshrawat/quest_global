//
//  SharedData.swift
//  Shelesh_Demo
//
//  Created by Mac on 3/5/20.
//  Copyright © 2020 SheleshR. All rights reserved.
//

import Foundation

class SharedData{
    static var shared:SharedData = SharedData()
    public var isReachable:Bool = false
    private init(){
        
    }
}
