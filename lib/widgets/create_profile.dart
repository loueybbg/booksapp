//@art=2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:book_tracker/models/book.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/utils/util.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:flutter/material.dart';

Widget createProfileDialog(
    BuildContext context, MUser curUser, List<Book> bookList) {
  final TextEditingController _displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _profesionTextController =
      TextEditingController(text: curUser.profession);

  final TextEditingController _quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController _avatarTextController =
      TextEditingController(text: curUser.avatarUrl);

  return AlertDialog(
    // ignore: avoid_unnecessary_containers
    content: Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  curUser.avatarUrl ?? 'https://i.pravatar.cc/300'),
              radius: 50,
            )
          ],
        ),
        Text(
          'Books Read (${bookList.length})',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.redAccent),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                curUser.displayName.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return UpdateUserProfile(
                        user: curUser,
                        displayNameTextController: _displayNameTextController,
                        profesionTextController: _profesionTextController,
                        quoteTextController: _quoteTextController,
                        avatarTextController: _avatarTextController);
                  },
                );
              },
              icon: const Icon(
                Icons.mode_edit,
                color: Colors.black12,
              ),
              label: const Text(''),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${curUser.profession}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        SizedBox(
          width: 100,
          height: 2,
          child: Container(
            color: Colors.red,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blueGrey.shade100),
              color: const Color(0xfff1f3f6),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const Text('Favorite Quote:',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                SizedBox(
                  width: 100,
                  height: 2,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      curUser.quote == null
                          ? 'Favorite book quote: Life is great...'
                          : " \" ${curUser.quote} \"",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                Book book = bookList[index];
                return Card(
                  elevation: 2.0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('${book.title}'),
                        leading: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(book.photoUrl),
                        ),
                        subtitle: Text('${book.author}'),
                      ),
                      Text('Finished on: ${formatDate(book.finishedReading)}')
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    )),
  );
}
