import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/chatUsersModel.dart';
import '../models/postModel.dart';
import 'package:http/http.dart' as http;

class CommentaryPost extends StatefulWidget {
  int? account;

  CommentaryPost({required this.account});

  @override
  _CommentaryPost createState() {
    return _CommentaryPost();
  }
}

class _CommentaryPost extends State<CommentaryPost> {
  final List<Post> comments = [];
  final Map<int, ChatUsers> accounts = {};

  Future<void> fetchComments(List<Post> comments) async {
    final responsePost = await http
        .get(Uri.parse('https://mindshare-ai.alwaysdata.net/api/post/comments/${widget.account}'));

    if (responsePost.statusCode == 200) {
      final body = jsonDecode(responsePost.body);
      for(var i = 0; i < body.length; i++) {
        comments.add(Post.fromJson(body[i] as Map<String, dynamic>));
      }

      // If the server did return a 200 OK response,
      setState(() {

      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Post');
    }
  }

  Future<void> fetchAccount(Map<int ,ChatUsers> accounts) async {
    final responseUser = await http
        .get(Uri.parse('https://mindshare-ai.alwaysdata.net/api/account'));

    if (responseUser.statusCode == 200) {
      final body = jsonDecode(responseUser.body);

      for(var i = 0; i < body.length; i++) {
        final ChatUsers currentUser = ChatUsers.fromJson(body[i] as Map<String, dynamic>);
        accounts[currentUser.id] = currentUser;
      }

      // If the server did return a 200 OK response,
      setState(() {

      });

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAccount(accounts);
    fetchComments(comments);
  }

  @override
  Widget build(BuildContext context) {
    if (accounts.isNotEmpty && comments.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 15, 30),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 15, 34),
          toolbarHeight: 40,
          title: const Text("Réponses"),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: comments.length, // Nombre de posts à afficher
          itemBuilder: (context, index) {
            final int idAcc = comments[index].account;

            return Card(
              color: const Color.fromARGB(255, 15, 15, 34),
              elevation: 4,
              margin: const EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/${accounts[idAcc]
                                        ?.lastName}${accounts[idAcc]
                                        ?.firstName}.jpg'),
                                maxRadius: 30,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        accounts[idAcc]!.firstName + " " +
                                            accounts[idAcc]!.lastName,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade400),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      comments[index].content,
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      comments[index].date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 15, 30),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 15, 30),
        toolbarHeight: 70,
        title: Image.asset('images/logoMindshare.png',
          height: 60,),
        centerTitle: true,
      ),
    );
  }
}
