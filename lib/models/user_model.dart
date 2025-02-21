class UserModel {
  String firstName;
  String lastName;
  String rollNo;
  String email;
  String phone;
  String linkedIn;
  String password;
  String userType;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.rollNo,
    required this.email,
    required this.phone,
    required this.linkedIn,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toMap(){
    return{
      'firstName': firstName,
      'lastName': lastName,
      'rollNo': rollNo,
      'email': email,
      'phone': phone,
      'linkedIn': linkedIn,
      'password': password,
      'userType': userType
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
        firstName: map['firstName'],
        lastName: map['lastName'],
        rollNo: map['rollNo'],
        email: map['email'],
        phone: map['phone'],
        linkedIn: map['linkedIn'],
        password: map['password'],
        userType: map['userType'],
    );
  }
}

