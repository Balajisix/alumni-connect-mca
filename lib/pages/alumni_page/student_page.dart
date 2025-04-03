import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/pages/alumni_page/student_details.dart';
import 'package:alumniconnectmca/providers/alumni_provider/student_provider.dart';
import 'package:alumniconnectmca/models/profile_model.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  // Define theme colors for consistency with details page
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color lightBlue = Color(0xFFBBDEFB);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color white = Colors.white;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Recent', 'IT', 'Management', 'Engineering'];

  @override
  void initState() {
    super.initState();
    // Fetch student data when the page is built
    Future.microtask(() {
      final studentProvider = context.read<StudentProvider>();
      studentProvider.fetchStudent();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              backgroundColor: primaryBlue,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Alumni Connect',
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [darkBlue, primaryBlue],
                        ),
                      ),
                    ),
                    // Decorative pattern
                    Opacity(
                      opacity: 0.1,
                      child: Image.network(
                        'https://www.transparenttextures.com/patterns/cubes.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Bottom text
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Text(
                        'Connect with MCA Student',
                        style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search student by name',
                          prefixIcon: const Icon(Icons.search, color: primaryBlue),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, color: primaryBlue),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),

                    // Filter chips
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = filter == _selectedFilter;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              backgroundColor: white,
                              selectedColor: lightBlue,
                              checkmarkColor: darkBlue,
                              labelStyle: TextStyle(
                                color: isSelected ? darkBlue : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              side: BorderSide(
                                color: isSelected ? primaryBlue : Colors.grey.shade300,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    // Selected filter indicator
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Showing $_selectedFilter Student',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_filteredAlumni(studentProvider).length} Results',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: studentProvider.isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
          ),
        )
            : _buildStudentList(studentProvider),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        child: const Icon(Icons.filter_alt),
        onPressed: _showFilterDialog,
      ),
    );
  }

  // Apply filters to alumni list
  List<Profile> _filteredAlumni(StudentProvider provider) {
    if (_searchQuery.isEmpty && _selectedFilter == 'All') {
      return provider.studentList;
    }

    return provider.studentList.where((student) {
      // Apply search query filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = student.fullName.toLowerCase();
        final hasCompanyMatch = student.experience != null &&
            student.experience!.isNotEmpty &&
            student.experience!.any((exp) =>
            exp.company != null &&
                exp.company!.toLowerCase().contains(query));

        matchesSearch = name.contains(query) || hasCompanyMatch;
      }

      // Apply category filter
      bool matchesFilter = true;
      if (_selectedFilter != 'All') {
        switch (_selectedFilter) {
          case 'IT':
            matchesFilter = student.skills != null &&
                student.skills!.any((skill) =>
                    ['programming', 'software', 'web', 'mobile', 'cloud']
                        .any((tech) => skill.toLowerCase().contains(tech)));
            break;
          case 'Recent':
            if (student.education != null && student.education!.isNotEmpty) {
              final lastEdu = student.education!.last;
              matchesFilter = lastEdu.endYear != null &&
                  int.tryParse(lastEdu.endYear) != null &&
                  int.parse(lastEdu.endYear) >= 2020;
            } else {
              matchesFilter = false;
            }
            break;
        // Additional filters can be added here
          default:
            matchesFilter = true;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildStudentList(StudentProvider provider) {
    final filteredList = _filteredAlumni(provider);

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No student match your search',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final student = filteredList[index];
        return _buildStudentCard(student, context);
      },
    );
  }

  Widget _buildStudentCard(Profile student, BuildContext context) {
    // Get the latest experience if available
    String subtitle = 'No experience information available';
    if (student.experience != null && student.experience!.isNotEmpty) {
      final firstExperience = student.experience!.first;
      final role = firstExperience.role ?? '';
      final company = firstExperience.company ?? '';
      subtitle = '$role at $company';
    }

    // Get skills if available (limited to first 3)
    List<String> skills = [];
    if (student.skills != null && student.skills!.isNotEmpty) {
      skills = student.skills!.take(3).toList();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailPage(
                student: {
                  'rollNo': student.rollNo,
                  'fullName': student.fullName,
                  'about': student.about ?? '',
                  'profilePicUrl': student.profilePicUrl ?? '',
                  'email': student.email ?? '',
                  'phone': student.phone ?? '',
                  'linkedin': student.linkedIn ?? '',
                  'skills': student.skills ?? [],
                  'education': student.education ?? [],
                  'experience': student.experience ?? [],
                  'projects': student.projects ?? [],
                  'achievements': student.achievements ?? [],
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image with Hero animation using rollNo as tag
              Hero(
                tag: 'student-${student.fullName}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: lightBlue,
                  backgroundImage: (student.profilePicUrl?.isNotEmpty ?? false)
                      ? NetworkImage(student.profilePicUrl!)
                      : null,
                  child: (student.profilePicUrl?.isEmpty ?? true)
                      ? Text(
                    student.fullName.isNotEmpty
                        ? student.fullName[0]
                        : '',
                    style: TextStyle(fontSize: 24, color: primaryBlue),
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Alumni info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (skills.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lightBlue.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(fontSize: 12, color: darkBlue),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Navigation (Connect) button
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18, color: primaryBlue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailPage(
                            student: {
                              'rollNo': student.rollNo,
                              'fullName': student.fullName,
                              'about': student.about ?? '',
                              'profilePicUrl': student.profilePicUrl ?? '',
                              'email': student.email ?? '',
                              'phone': student.phone ?? '',
                              'linkedin': student.linkedIn ?? '',
                              'skills': student.skills ?? [],
                              'education': student.education ?? [],
                              'experience': student.experience ?? [],
                              'projects': student.projects ?? [],
                              'achievements': student.achievements ?? [],
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Students',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'By Industry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All',
                  'IT',
                  'Management',
                  'Engineering',
                  'Finance',
                  'Healthcare',
                  'Education',
                  'Research'
                ].map((filter) {
                  return ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                          Navigator.pop(context);
                        });
                      }
                    },
                    backgroundColor: white,
                    selectedColor: lightBlue,
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter ? darkBlue : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'By Graduation Year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All Years',
                  'Recent',
                  '2020-2023',
                  '2015-2019',
                  '2010-2014',
                  'Before 2010'
                ].map((year) {
                  return ChoiceChip(
                    label: Text(year),
                    selected: _selectedFilter == year,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = year;
                          Navigator.pop(context);
                        });
                      }
                    },
                    backgroundColor: white,
                    selectedColor: lightBlue,
                    labelStyle: TextStyle(
                      color: _selectedFilter == year ? darkBlue : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: white,
                    minimumSize: const Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
