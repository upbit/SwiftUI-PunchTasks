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
            
            Text("请告诉我你是谁？")
                .font(.title)
                .foregroundColor(.SAKURA)
                .shadow(radius: 4.0, x: 4.0, y: 4.0)
                .padding()
                
            HStack {
                Button(action: {
                    self.isGirlSelect = true
                    self.userName = "小雯雯"
                }) {
                    VStack {
                        UserImage(src: "Girl")
                        Text("小雯雯")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.NANOHANA)
                            .padding(.top, 8)
                            .shadow(radius: 4.0, x: 4.0, y: 4.0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    self.isGirlSelect = false
                    self.userName = "小昊昊"
                }) {
                    VStack {
                        UserImage(src: "Boy")
                        Text("小昊昊")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.NANOHANA)
                            .padding(.top, 8)
                            .shadow(radius: 4.0, x: 4.0, y: 4.0)
                    }
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
                    .background(self.isGirlSelect ? Color.MOMO : Color.MIZU)
                    .cornerRadius(24.0)
                    .shadow(radius: 16.0)
            }
            .padding()
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors:
                self.isGirlSelect ? [.MIZU, .MOMO] : [.MOMO, .MIZU]
            ), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all))
    }

    func setUserInfo() {
        let userInfo = UserInfo(context: managedObjectContext)
        userInfo.name = userName
        userInfo.isGirl = isGirlSelect
        
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
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.NANOHANA, lineWidth: 4))
            .shadow(radius: 8.0)
    }
}

extension Color {
    // 鬱金
    static var UKON: Color {
        return Color(red: 239.0/256, green: 187.0/256, blue: 36.0/256)
    }

    // 菜の花
    static var NANOHANA: Color {
        return Color(red: 247.0/256, green: 217.0/256, blue: 76.0/256)
    }
    
    // 琥珀
    static var KOHAKU: Color {
        return Color(red: 202.0/256, green: 122.0/256, blue: 44.0/256)
    }

    // 水
    static var MIZU: Color {
        return Color(red: 129.0/256, green: 199.0/256, blue: 212.0/256)
    }
    
    // 桃
    static var MOMO: Color {
        return Color(red: 245.0/256, green: 150.0/256, blue: 170.0/256)
    }

    // 桜
    static var SAKURA: Color {
        return Color(red: 254.0/256, green: 223.0/256, blue: 225.0/256)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
