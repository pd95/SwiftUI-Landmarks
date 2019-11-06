//
//  UserData.swift
//  Landmarks
//
//  Created by Philipp on 06.11.19.
//  Copyright © 2019 Philipp. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
}
