// profile_model.dart

class Profile {
  final String fullName;
  final String profilePicUrl;
  final String about;
  final List<Education> education;
  final List<String> skills;
  final List<Experience> experience;
  final List<Project> projects;
  final List<String> achievements;

  Profile({
    required this.fullName,
    required this.profilePicUrl,
    required this.about,
    required this.education,
    required this.skills,
    required this.experience,
    required this.projects,
    required this.achievements,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      fullName: map['fullName'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      about: map['about'] ?? '',
      education: map['education'] != null
          ? List<Education>.from(
          (map['education'] as List).map((e) => Education.fromMap(e)))
          : [],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : [],
      experience: map['experience'] != null
          ? List<Experience>.from(
          (map['experience'] as List).map((e) => Experience.fromMap(e)))
          : [],
      projects: map['projects'] != null
          ? List<Project>.from(
          (map['projects'] as List).map((e) => Project.fromMap(e)))
          : [],
      achievements: map['achievements'] != null
          ? List<String>.from(map['achievements'])
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'profilePicUrl': profilePicUrl,
      'about': about,
      'education': education.map((e) => e.toMap()).toList(),
      'skills': skills,
      'experience': experience.map((e) => e.toMap()).toList(),
      'projects': projects.map((p) => p.toMap()).toList(),
      'achievements': achievements,
    };
  }
}

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String startYear;
  final String endYear;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    required this.endYear,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      fieldOfStudy: map['fieldOfStudy'] ?? '',
      startYear: map['startYear'] ?? '',
      endYear: map['endYear'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startYear': startYear,
      'endYear': endYear,
    };
  }
}

class Experience {
  final String company;
  final String role;
  final String duration;
  final String description;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'duration': duration,
      'description': description,
    };
  }
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String link;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.link,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      technologies: map['technologies'] != null
          ? List<String>.from(map['technologies'])
          : [],
      link: map['link'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'technologies': technologies,
      'link': link,
    };
  }
}
