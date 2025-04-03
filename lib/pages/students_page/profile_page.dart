import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/students_provider/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildViewMode(ProfileProvider provider, BuildContext context) {
    // Custom blue theme colors
    final Color primaryBlue = Color(0xFF1E88E5);
    final Color lightBlue = Color(0xFFBBDEFB);
    final Color darkBlue = Color(0xFF1565C0);
    final theme = Theme.of(context);

    Widget _buildSection(String title, Widget content) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: darkBlue,
              )
          ),
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 24),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with material card and image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [darkBlue, primaryBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'profile-image',
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              radius: 58,
                              backgroundImage: provider.profilePicController.text.isNotEmpty
                                  ? NetworkImage(provider.profilePicController.text)
                                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.fullNameController.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About section
                    if (provider.aboutController.text.isNotEmpty)
                      _buildSection(
                        "About",
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: lightBlue, width: 1),
                          ),
                          child: Text(provider.aboutController.text),
                        ),
                      ),

                    // Education section
                    _buildSection(
                      "Education",
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: lightBlue, width: 1),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.institutionController.text,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  )),
                              const SizedBox(height: 4),
                              Text("${provider.degreeController.text} in ${provider.fieldOfStudyController.text}"),
                              const SizedBox(height: 4),
                              Text("${provider.startYearController.text} - ${provider.endYearController.text}",
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Skills section
                    if (provider.skillsController.text.isNotEmpty)
                      _buildSection(
                        "Skills",
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: provider.skillsController.text.split(',').map((skill) =>
                              Chip(
                                label: Text(skill.trim(), style: TextStyle(color: darkBlue)),
                                backgroundColor: lightBlue.withOpacity(0.5),
                              )
                          ).toList(),
                        ),
                      ),

                    // Experience section
                    if (provider.experienceFields.isNotEmpty)
                      _buildSection(
                        "Experience",
                        Column(
                          children: provider.experienceFields.map((exp) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: lightBlue, width: 1),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(exp.roleController.text,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: primaryBlue,
                                        )),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(exp.companyController.text, style: theme.textTheme.bodyLarge),
                                        const Spacer(),
                                        Text(exp.durationController.text, style: theme.textTheme.bodySmall),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(exp.descriptionController.text),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Projects section
                    if (provider.projectFields.isNotEmpty)
                      _buildSection(
                        "Projects",
                        Column(
                          children: provider.projectFields.map((proj) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: lightBlue, width: 1),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(proj.titleController.text,
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: primaryBlue,
                                              )),
                                        ),
                                        if (proj.linkController.text.isNotEmpty)
                                          Icon(Icons.link, color: primaryBlue),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(proj.descriptionController.text),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: proj.technologiesController.text.split(',').map((tech) =>
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: lightBlue.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(tech.trim(), style: TextStyle(fontSize: 12, color: darkBlue)),
                                          )
                                      ).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Achievements section
                    if (provider.achievementsController.text.isNotEmpty)
                      _buildSection(
                        "Achievements",
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: provider.achievementsController.text.split(',').map((achievement) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.emoji_events, color: primaryBlue, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(achievement.trim())),
                                  ],
                                ),
                              )
                          ).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditMode(ProfileProvider provider, BuildContext context) {
    // Custom blue theme colors
    final Color primaryBlue = Color(0xFF1E88E5);
    final Color lightBlue = Color(0xFFBBDEFB);
    final Color darkBlue = Color(0xFF1565C0);
    final theme = Theme.of(context);

    Widget _buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(title, style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkBlue,
            )),
            const SizedBox(width: 8),
            Expanded(child: Divider(color: lightBlue)),
          ],
        ),
      );
    }

    InputDecoration _buildInputDecoration(String label, {Icon? prefixIcon}) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBlue),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon.icon, color: primaryBlue) : null,
        filled: true,
        fillColor: Colors.white,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => provider.pickProfileImage(context),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: primaryBlue.withOpacity(0.2),
                        child: CircleAvatar(
                          radius: 58,
                          backgroundImage: provider.profileImage != null
                              ? FileImage(provider.profileImage!)
                              : (provider.profilePicController.text.isNotEmpty
                              ? NetworkImage(provider.profilePicController.text)
                              : const AssetImage('assets/default_avatar.png')) as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("Tap to change", style: TextStyle(color: primaryBlue, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Basic Information section
          _buildSectionTitle("Basic Information"),
          TextField(
            controller: provider.fullNameController,
            decoration: _buildInputDecoration("Full Name", prefixIcon: const Icon(Icons.person)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: provider.aboutController,
            maxLines: 3,
            decoration: _buildInputDecoration("About", prefixIcon: const Icon(Icons.info)),
          ),

          // Education section
          _buildSectionTitle("Education"),
          TextField(
            controller: provider.institutionController,
            decoration: _buildInputDecoration("Institution", prefixIcon: const Icon(Icons.school)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.degreeController,
                  decoration: _buildInputDecoration("Degree"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: provider.fieldOfStudyController,
                  decoration: _buildInputDecoration("Field of Study"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.startYearController,
                  decoration: _buildInputDecoration("Start Year"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: provider.endYearController,
                  decoration: _buildInputDecoration("End Year"),
                ),
              ),
            ],
          ),

          // Skills section
          _buildSectionTitle("Skills"),
          TextField(
            controller: provider.skillsController,
            decoration: _buildInputDecoration("Skills (comma separated)", prefixIcon: const Icon(Icons.stars)),
          ),

          // Achievements section
          _buildSectionTitle("Achievements"),
          TextField(
            controller: provider.achievementsController,
            decoration: _buildInputDecoration("Achievements (comma separated)", prefixIcon: const Icon(Icons.emoji_events)),
          ),

          // Experience section
          _buildSectionTitle("Experience"),
          ...List.generate(provider.experienceFields.length, (index) {
            final exp = provider.experienceFields[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: lightBlue),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Experience ${index + 1}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: darkBlue,
                              fontWeight: FontWeight.bold,
                            )),
                        const Spacer(),
                        if (provider.experienceFields.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.removeExperience(index),
                          ),
                      ],
                    ),
                    Divider(color: lightBlue),
                    TextField(
                      controller: exp.companyController,
                      decoration: _buildInputDecoration("Company", prefixIcon: const Icon(Icons.business)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.roleController,
                      decoration: _buildInputDecoration("Role", prefixIcon: const Icon(Icons.work)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.durationController,
                      decoration: _buildInputDecoration("Duration", prefixIcon: const Icon(Icons.date_range)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.descriptionController,
                      maxLines: 2,
                      decoration: _buildInputDecoration("Description"),
                    ),
                  ],
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => provider.addExperience(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Experience", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          // Projects section
          _buildSectionTitle("Projects"),
          ...List.generate(provider.projectFields.length, (index) {
            final proj = provider.projectFields[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: lightBlue),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Project ${index + 1}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: darkBlue,
                              fontWeight: FontWeight.bold,
                            )),
                        const Spacer(),
                        if (provider.projectFields.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.removeProject(index),
                          ),
                      ],
                    ),
                    Divider(color: lightBlue),
                    TextField(
                      controller: proj.titleController,
                      decoration: _buildInputDecoration("Title", prefixIcon: const Icon(Icons.title)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.descriptionController,
                      maxLines: 2,
                      decoration: _buildInputDecoration("Description"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.technologiesController,
                      decoration: _buildInputDecoration("Technologies (comma separated)", prefixIcon: const Icon(Icons.code)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.linkController,
                      decoration: _buildInputDecoration("Link", prefixIcon: const Icon(Icons.link)),
                    ),
                  ],
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => provider.addProject(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Project", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          ElevatedButton(
            onPressed: () => provider.saveProfile(),
            child: const Text("Save Profile", style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlue,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF1565C0),
            actions: [
              IconButton(
                icon: Icon(provider.isEditing ? Icons.check : Icons.edit, color: Colors.white),
                onPressed: () => provider.toggleEditing(),
              ),
            ],
          ),
          body: provider.isLoading
              ? Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
              : provider.isEditing
              ? _buildEditMode(provider, context)
              : _buildViewMode(provider, context),
        );
      },
    );
  }
}