//
//  InviteList.swift
//  Learning Swift Command Line
//
//  Created by Bart Chrzaszcz on 2017-12-21.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import Foundation

struct InviteList {
    var invited: [Invitee] = []
    var pendingInvitees: [Invitee]
    
    init(invitees: [Invitee]) {
        self.pendingInvitees = invitees
    }
    
    // Move invitee from pendingInvitees to invited
    //
    // Must be mutating because we are changing the contents of
    // our array properties
    mutating func invitedPendingInviteAtIndex(index: Int) {
        // Removing an item from an array returns that item
        let invitee = self.pendingInvitees.remove(at: index)
        self.invited.append(invitee)
    }
    
    // Must be mutating because it calls another mutating method
    mutating func askRandomInviteeToBringGenre(genre: ShowGenre) {
        if self.pendingInvitees.count > 0 {
            let randomIndex = Int(arc4random()) % self.pendingInvitees.count
            let invitee = self.pendingInvitees[randomIndex]
            invitee.askToBringShowFromGere(genre: genre)
            self.invitedPendingInviteAtIndex(index: 0)
        }
    }
    
    // Must be mutating because it calls another mutating method
    mutating func inviteeRemainingInvitees() {
        while self.pendingInvitees.count > 0 {
            let invitee = self.pendingInvitees[0]
            invitee.askToBringThemselves()
            self.invitedPendingInviteAtIndex(index: 0)
        }
    }
}
