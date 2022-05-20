//@dart=2.9
import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/widgets/book_details_dialog.dart';
import 'package:book_tracker/widgets/book_search_page.dart';
import 'package:book_tracker/widgets/create_profile.dart';
import 'package:book_tracker/widgets/reading_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference userCollectionReference =
        FirebaseFirestore.instance.collection('users');
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    List<Book> userBooksReadList = [];

    var authUser = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        toolbarHeight: 77,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/Icon-76.png',
              scale: 2,
            ),
            Text(
              'A.Reader',
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: userCollectionReference.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final userListStream = snapshot.data.docs.map((user) {
                return MUser.fromDocument(user);
              }).where((user) {
                return (user.uid == authUser.uid);
              }).toList(); //[user]

              MUser curUser = userListStream[0];

              return Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            curUser.avatarUrl ?? 'https://i.pravatar.cc/300'),
                        backgroundColor: Colors.white,
                        child: const Text(''),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return createProfileDialog(
                              context,
                              curUser,
                              userBooksReadList,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    curUser.displayName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                (value) {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text(''),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookSearchPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Reading List',
                          style: TextStyle(
                            color: kBlackColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              var readingListListBook = snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).where((book) {
                return (book.userId == authUser.uid) &&
                    (book.finishedReading == null) &&
                    (book.startedReading == null);
              }).toList();

              return Expanded(
                flex: 1,
                child: (readingListListBook.isNotEmpty)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: readingListListBook.length,
                        itemBuilder: (context, index) {
                          Book book = readingListListBook[index];

                          return ReadingListCard(
                              buttonText: 'Not Started',
                              rating: book.rating != null ? (book.rating) : 4.0,
                              author: book.author,
                              image: book.photoUrl,
                              title: book.title);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No books found. Add a book :)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
          )
        ],
      ),
    );
  }
}
