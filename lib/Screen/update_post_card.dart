import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/models/user_model.dart';
import 'package:igclone/providers/user_provider.dart';
import 'package:igclone/resources/firestore_methods.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/utils.dart';
import 'package:provider/provider.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({
    super.key,
    required this.file,
    required this.description,
    required this.pid,
  });
  final String pid;
  final String file;
  final String description;

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final TextEditingController _descCon = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _descCon.text = widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: const Text(
          'Edit Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              String res =
                  await FirestoreMethod().updatePost(_descCon.text, widget.pid);
              if (res == "success") {
                showSnackBar('Update Success', context);

                setState(() {
                  _isLoading = false;
                });

                Navigator.pop(context);
              } else {
                showSnackBar(res, context);
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            _isLoading
                ? const LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(205, 72, 107, 1),
                  )
                : const Padding(padding: EdgeInsets.only(top: 0)),
            Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: _descCon,
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(widget.file, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
