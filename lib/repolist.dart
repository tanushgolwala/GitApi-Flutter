import 'package:flutter/material.dart';
import 'package:gitapi/commit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Repolist extends StatefulWidget {
  final String owner;
  const Repolist({super.key, required this.owner});

  @override
  State<Repolist> createState() => _RepolistState();
}

class _RepolistState extends State<Repolist> {
  List<dynamic> repositories = [];

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/${widget.owner}/repos'),
    );
    if (response.statusCode == 200) {
      setState(() {
        repositories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub Repositories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: repositories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          repositories[index]['owner']['avatar_url']),
                    ),
                    title: Text(
                      repositories[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        repositories[index]['description'] ?? 'No description'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommitHistoryPage(
                              owner: widget.owner,
                              repositoryName: repositories[index]['name']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
