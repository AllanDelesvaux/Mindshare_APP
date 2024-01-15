import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mindshare_ai/screens/profilePage.dart';
import '../models/chatUsersModel.dart';
import '../models/postModel.dart';
import 'commentaryPostPage.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PostPageApp());



class PostPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Post> posts = [];
  final Map<int, int> commentsCount = {};
  final Map<int ,ChatUsers> accounts = {};

  Future<void> fetchPost(List<Post> posts) async {
    final responsePost = await http
        .get(Uri.parse('https://mindshare-ai.alwaysdata.net/api/post'));

    if (responsePost.statusCode == 200) {
      final body = jsonDecode(responsePost.body);
      for(var i = 0; i < body.length; i++) {
        final Post currentPost = Post.fromJson(body[i] as Map<String, dynamic>);

        if (currentPost.post_commented != null) {
          commentsCount.update(currentPost.post_commented!, (value) => value + 1);
        } else {
          posts.add(currentPost);
          commentsCount[currentPost.id_post] = 0;
        }
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
    fetchPost(posts);
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isNotEmpty && accounts.isNotEmpty) {
      return Scaffold(
          backgroundColor: Color.fromARGB(255, 15, 15, 30),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 15, 15, 30),
            toolbarHeight: 70,
            title: Image.asset('images/logoMindshare.png',
              height: 60,),
            centerTitle: true,
          ),
          body:
          ListView.builder(
            itemCount: posts.length, // Nombre de posts à afficher
            itemBuilder: (context, index) {
              final int idAcc = posts[index].account;
              return Card(
                color: Color.fromARGB(255, 15, 15, 34),
                elevation: 20,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap : (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ProfilePage(account: posts[index].account);
                                    }));
                                  },
                                  child : CircleAvatar(
                                    backgroundImage: AssetImage('images/${accounts[idAcc]?.lastName}${accounts[idAcc]?.firstName}.jpg'),
                                    maxRadius: 30,
                                  ),
                                ),
                                SizedBox(width: 16,),
                                Expanded(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text( accounts[idAcc]!.firstName + " " + accounts[idAcc]!.lastName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                                        SizedBox(height: 6,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(posts[index].content,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        posts[index].date,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.6)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Text(
                            (commentsCount[idAcc].toString() == null ? commentsCount[idAcc].toString() : 0.toString() ) + " Réponses", //Nombre de commentaires aux posts
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.white70,),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return CommentaryPost(account: posts[index].id_post);
                              }));
                            },
                          )

/*IconButton(
                        icon: Icon(Icons.share, color: Colors.white70,),
                        onPressed: () {
                          // Action à effectuer lorsque l'utilisateur appuie sur le bouton de partage.
                        },
                      ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
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
