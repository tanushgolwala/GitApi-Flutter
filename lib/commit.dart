import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CommitHistoryPage extends StatefulWidget {
  final String owner;
  final String repositoryName;

  const CommitHistoryPage({
    super.key,
    required this.owner,
    required this.repositoryName,
  });

  @override
  State<CommitHistoryPage> createState() => _CommitHistoryPageState();
}

class _CommitHistoryPageState extends State<CommitHistoryPage> {
  List<dynamic> commits = [];

  @override
  void initState() {
    super.initState();
    fetchCommits();
  }

  Future<void> fetchCommits() async {
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/${widget.owner}/${widget.repositoryName}/commits'),
    );
    if (response.statusCode == 200) {
      setState(() {
        commits = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load commits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commit History of ${widget.repositoryName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: commits.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: commits.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        commits[index]['commit']['message'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Committed by: ${commits[index]['commit']['committer']['name']}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Commit Date: ${DateTime.parse(commits[index]['commit']['committer']['date']).toString()}',
                          ),
                        ],
                      ),
                      onTap: () {
                        String commitUrl = commits[index]['html_url'];
                        if (commitUrl.isNotEmpty) {
                          launchURL(commitUrl);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void launchURL(String url) async {
    var convurl = Uri.parse(url);
    if (await canLaunchUrl(convurl)) {
      await launchUrl(convurl);
    } else {
      throw 'Could not launch $url';
    }
  }
}
