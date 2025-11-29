import 'package:flutter/material.dart';



class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: const Text('Help & Support',style: TextStyle(
            color: Colors.white,fontWeight: FontWeight.w600),),
        backgroundColor: Colors.orange,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. FAQ Section
            HelpSectionTitle(title: 'Frequently Asked Questions (FAQ)'),
            FaqSection(),
            SizedBox(height: 20.0),

            // 2. Contact and Other Resources
            HelpSectionTitle(title: 'Need More Help?'),
            ContactSection(),
            SizedBox(height: 20.0),

            // 3. Documentation/Tutorials
            HelpSectionTitle(title: 'Resources'),
            ResourcesSection(),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets for Structure ---

class HelpSectionTitle extends StatelessWidget {
  final String title;
  const HelpSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// --- Specific Content Sections ---

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual FAQ data
    return const Column(
      children: [
        FaqItem(
          question: 'How do I reset my password?',
          answer: 'Go to the Login screen, tap "Forgot Password," and follow the instructions to receive a password reset link via email.',
        ),
        FaqItem(
          question: 'Where can I find my order history?',
          answer: 'Your order history is available in the "Profile" section under "My Orders".',
        ),
        // Add more FaqItem widgets
      ],
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
          child: Text(answer),
        ),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  // Action for a ListTile press (e.g., navigate to a contact form screen)
  void _handleTap(BuildContext context, String title) {
    // In a real app, you would use Navigator to push a new screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title tapped (Navigation goes here)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Contact Support'),
          subtitle: const Text('Send us a detailed message'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _handleTap(context, 'Contact Support'),
        ),
        const Divider(height: 0),
        ListTile(
          leading: const Icon(Icons.forum),
          title: const Text('Community Forum'),
          subtitle: const Text('Get help from other users'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _handleTap(context, 'Community Forum'),
        ),
      ],
    );
  }
}

class ResourcesSection extends StatelessWidget {
  const ResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Official Documentation'),
          subtitle: const Text('Full user guides and tutorials'),
          trailing: const Icon(Icons.open_in_new, size: 16),
          onTap: () {
            // In a real app, you would launch a URL
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Launching URL for documentation')),
            );
          },
        ),
      ],
    );
  }
}

