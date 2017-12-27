//
//  main.swift
//  Learning Swift Command Line
//
//  Created by Bart Chrzaszcz on 2017-12-21.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

var inviteeList = InviteList(invitees: [
    Invitee(name: "Sarah"),
    Invitee(name: "Jamison"),
    Invitee(name: "Marcos"),
    Invitee(name: "Roana"),
    Invitee(name: "Neena"),
    ])
let genres = [
    ShowGenre(name: "Comedy", example: "Modern Family"),
    ShowGenre(name: "Drama", example: "Breaking Bad"),
    ShowGenre(name: "Variety", example: "The Colbert Report"),
]
for genre in genres {
    inviteeList.askRandomInviteeToBringGenre(genre: genre)
}
inviteeList.inviteeRemainingInvitees()
