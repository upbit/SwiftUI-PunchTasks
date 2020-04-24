//
//  LoginView.swift
//  PunchTasks
//
//  Created by deryzhou on 2020/4/24.
//  Copyright © 2020 Zzz(Test). All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: UserInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.name, ascending: true)]
    ) var userInfoItems: FetchedResults<UserInfo>
    
    @State var isGirlSelect: Bool = true
    @State var userName: String = "小雯雯"
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("首先，请告诉我你是谁？")
                .font(.headline)
                .shadow(radius: 8.0, x: 0, y: 0)
                .padding()
                
            HStack {
                Button(action: {
                    self.isGirlSelect = true
                    self.userName = "小雯雯"
                }) {
                    UserImage(src: "Girl")
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    self.isGirlSelect = false
                    self.userName = "小昊昊"
                }) {
                    UserImage(src: "Boy")
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 28)
            
            Spacer()
            
            Button(action: {
                self.setUserInfo()
            }) {
                Text("确认")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 48)
                    .background(self.isGirlSelect ? Color.sakura : Color.water)
                    .cornerRadius(24.0)
                    .shadow(radius: 16.0, x: 0, y: 0)
            }
            .padding()
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors:
                self.isGirlSelect ? [.water, .sakura] : [.sakura, .water]
            ), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }
    
    func setUserInfo() {
        let userInfo = UserInfo(context: managedObjectContext)
        userInfo.name = userName
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct UserImage: View {
    let src: String
    init(src: String) {
        self.src = src
    }

    var body: some View {
        return Image(src)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .shadow(radius: 8.0, x: 0, y: 0)
    }
}

extension Color {
    static var gold: Color {
        return Color(red: 247.0/255.0, green: 217.0/255.0, blue: 76.0/255.0)
    }
    
    static var water: Color {
        return Color(red: 129.0/255.0, green: 199.0/255.0, blue: 212.0/255.0)
    }
    
    static var sakura: Color {
        return Color(red: 248.0/255.0, green: 195.0/255.0, blue: 205.0/255.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
