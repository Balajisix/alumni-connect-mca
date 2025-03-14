import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildViewMode(ProfileProvider provider, BuildContext context) {
    final theme = Theme.of(context);

    Widget _buildSection(String title, Widget content) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
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
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(provider.aboutController.text),
                        ),
                      ),

                    // Education section
                    _buildSection(
                      "Education",
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.institutionController.text,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                                label: Text(skill.trim()),
                                backgroundColor: theme.primaryColor.withOpacity(0.1),
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
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(exp.roleController.text,
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                        ),
                                        if (proj.linkController.text.isNotEmpty)
                                          Icon(Icons.link, color: theme.primaryColor),
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
                                              color: theme.primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(tech.trim(), style: TextStyle(fontSize: 12)),
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
                                    Icon(Icons.emoji_events, color: theme.primaryColor, size: 20),
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
    final theme = Theme.of(context);

    Widget _buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(child: Divider()),
          ],
        ),
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
                  onTap: () => provider.pickProfileImage(),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.primaryColor.withOpacity(0.2),
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
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("Tap to change", style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Basic Information section
          _buildSectionTitle("Basic Information"),
          TextField(
            controller: provider.fullNameController,
            decoration: InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: provider.aboutController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "About",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Icon(Icons.info),
              ),
            ),
          ),

          // Education section
          _buildSectionTitle("Education"),
          TextField(
            controller: provider.institutionController,
            decoration: InputDecoration(
              labelText: "Institution",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.school),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.degreeController,
                  decoration: InputDecoration(
                    labelText: "Degree",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: provider.fieldOfStudyController,
                  decoration: InputDecoration(
                    labelText: "Field of Study",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
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
                  decoration: InputDecoration(
                    labelText: "Start Year",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: provider.endYearController,
                  decoration: InputDecoration(
                    labelText: "End Year",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),

          // Skills section
          _buildSectionTitle("Skills"),
          TextField(
            controller: provider.skillsController,
            decoration: InputDecoration(
              labelText: "Skills (comma separated)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.stars),
            ),
          ),

          // Achievements section
          _buildSectionTitle("Achievements"),
          TextField(
            controller: provider.achievementsController,
            decoration: InputDecoration(
              labelText: "Achievements (comma separated)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.emoji_events),
            ),
          ),

          // Experience section
          _buildSectionTitle("Experience"),
          ...List.generate(provider.experienceFields.length, (index) {
            final exp = provider.experienceFields[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Experience ${index + 1}", style: theme.textTheme.titleMedium),
                        const Spacer(),
                        if (provider.experienceFields.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.removeExperience(index),
                          ),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: exp.companyController,
                      decoration: const InputDecoration(
                        labelText: "Company",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.roleController,
                      decoration: const InputDecoration(
                        labelText: "Role",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.durationController,
                      decoration: const InputDecoration(
                        labelText: "Duration",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exp.descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
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
              icon: const Icon(Icons.add),
              label: const Text("Add Experience"),
              style: ElevatedButton.styleFrom(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Project ${index + 1}", style: theme.textTheme.titleMedium),
                        const Spacer(),
                        if (provider.projectFields.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.removeProject(index),
                          ),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: proj.titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.technologiesController,
                      decoration: const InputDecoration(
                        labelText: "Technologies (comma separated)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.code),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: proj.linkController,
                      decoration: const InputDecoration(
                        labelText: "Link",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
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
              icon: const Icon(Icons.add),
              label: const Text("Add Project"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          ElevatedButton(
            onPressed: () => provider.saveProfile(),
            child: const Text("Save Profile"),
            style: ElevatedButton.styleFrom(
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
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: Icon(provider.isEditing ? Icons.check : Icons.edit),
                onPressed: () => provider.toggleEditing(),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.isEditing
              ? _buildEditMode(provider, context)
              : _buildViewMode(provider, context),
        );
      },
    );
  }
}