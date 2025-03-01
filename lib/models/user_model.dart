class UserModel {
  final String? uid;
  final String firstName;
  final String lastName;
  final String rollNo;
  final String email;
  final String phone;
  final String linkedIn;
  final String userType;
  final String password;

  UserModel({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.rollNo,
    required this.email,
    required this.phone,
    required this.linkedIn,
    required this.userType,
    required this.password
  });

  Map<String, dynamic> toMap(){
    return{
      'uid' : uid,
      'firstName': firstName,
      'lastName': lastName,
      'rollNo': rollNo,
      'email': email,
      'phone': phone,
      'linkedIn': linkedIn,
      'userType': userType,
      'password' : password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      rollNo: map['rollNo'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      linkedIn: map['linkedIn'] ?? '',
      userType: map['userType'] ?? '',
      password: map['password'] ?? '',
    );
  }
}

