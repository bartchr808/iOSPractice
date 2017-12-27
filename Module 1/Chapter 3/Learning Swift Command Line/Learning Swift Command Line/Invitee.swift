//
//  Invitee.swift
//  Learning Swift Command Line
//
//  Created by Bart Chrzaszcz on 2017-12-21.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

struct Invitee {
    let name: String
    
    func askToBringShowFromGere(genre: ShowGenre) {
        print("\(self.name), bring a \(genre.name) show")
        print("\(genre.example) is a great \(genre.name)")
    }
    
    func askToBringThemselves() {
        print("\(self.name), just bring yourself")
    }
}
