import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igclone/utils/colors.dart';
import 'package:igclone/utils/dimension.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletalCard extends StatefulWidget {
  const SkeletalCard({super.key});

  @override
  State<SkeletalCard> createState() => _SkeletalCardState();
}

class _SkeletalCardState extends State<SkeletalCard> {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(
              color: MediaQuery.of(context).size.width > webScreenSize
                  ? Colors.grey
                  : Colors.white),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  const Skeleton.leaf(
                    enabled: true,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Test Test Test",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "Textt etxte",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Textt etxte",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: Image.network(
                          'https://images.unsplash.com/photo-1683009427500-71296178737f?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
            //
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.comment),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(FontAwesomeIcons.bookmark),
                      onPressed: () {},
                    ),
                  ))
                ],
              ),
            ),
            //
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                          text: const TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                            TextSpan(
                                text: 'shhshshshs ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: 'shshshshhshshs',
                            ),
                          ])),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
